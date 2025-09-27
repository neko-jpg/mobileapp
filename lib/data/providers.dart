import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:minq/data/repositories/auth_repository.dart';
import 'package:minq/data/repositories/pair_repository.dart';
import 'package:minq/data/repositories/quest_log_repository.dart';
import 'package:minq/data/repositories/quest_repository.dart';
import 'package:minq/data/repositories/user_repository.dart';
import 'package:minq/data/services/firestore_sync_service.dart';
import 'package:minq/data/services/isar_service.dart';
import 'package:minq/data/services/notification_service.dart';
import 'package:minq/data/services/photo_storage_service.dart';
import 'package:minq/data/services/local_preferences_service.dart';
import 'package:minq/data/services/remote_config_service.dart';
import 'package:minq/data/services/time_consistency_service.dart';
import 'package:minq/data/services/marketing_attribution_service.dart';
import 'package:minq/data/services/app_locale_controller.dart';
import 'package:minq/data/services/image_moderation_service.dart';
import 'package:minq/domain/config/feature_flags.dart';
import 'package:minq/domain/quest/quest.dart';
import 'package:minq/domain/log/quest_log.dart';
import 'package:minq/domain/user/user.dart' as minq_user;

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final notificationPermissionProvider = StateProvider<bool>((ref) => false);
final timeDriftDetectedProvider = StateProvider<bool>((ref) => false);

final notificationTapStreamProvider = StreamProvider<String>((ref) async* {
  final notifications = ref.watch(notificationServiceProvider);
  final initialPayload = await notifications.takeInitialPayload();
  if (initialPayload != null && initialPayload.isNotEmpty) {
    yield initialPayload;
  }
  yield* notifications.notificationTapStream;
});

final timeConsistencyServiceProvider =
    Provider<TimeConsistencyService>((ref) => TimeConsistencyService());

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());
final photoStorageServiceProvider = Provider<PhotoStorageService>((ref) {
  return PhotoStorageService(
    imagePicker: ref.watch(imagePickerProvider),
    moderationService: const ImageModerationService(),
  );
});

final localPreferencesServiceProvider =
    Provider<LocalPreferencesService>((_) => LocalPreferencesService());

final marketingAttributionServiceProvider =
    Provider<MarketingAttributionService>((ref) {
  return MarketingAttributionService(ref.watch(localPreferencesServiceProvider));
});

final appLocaleControllerProvider =
    StateNotifierProvider<AppLocaleController, Locale?>((ref) {
  return AppLocaleController(ref.watch(localPreferencesServiceProvider));
});

final firebaseAvailabilityProvider = Provider<bool>((_) => true);

final firebaseAuthProvider = Provider<FirebaseAuth?>(
  (ref) => ref.watch(firebaseAvailabilityProvider)
      ? FirebaseAuth.instance
      : null,
);
final firestoreProvider = Provider<FirebaseFirestore?>(
  (ref) => ref.watch(firebaseAvailabilityProvider)
      ? FirebaseFirestore.instance
      : null,
);

final remoteConfigProvider = Provider<FirebaseRemoteConfig?>((ref) {
  return ref.watch(firebaseAvailabilityProvider)
      ? FirebaseRemoteConfig.instance
      : null;
});

final featureFlagsProvider =
    StateNotifierProvider<FeatureFlagsNotifier, FeatureFlags>((ref) {
  return FeatureFlagsNotifier(ref.watch(remoteConfigProvider));
});

final isarProvider = FutureProvider<Isar>((ref) async {
  final isarService = IsarService();
  return isarService.init();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

QuestRepository? _buildQuestRepository(Ref ref) {
  final asyncIsar = ref.watch(isarProvider);
  return asyncIsar.when(
    data: QuestRepository.new,
    loading: () => null,
    error: (error, stackTrace) {
      debugPrint('Quest repository unavailable: $error');
      return null;
    },
  );
}

QuestLogRepository? _buildQuestLogRepository(Ref ref) {
  final asyncIsar = ref.watch(isarProvider);
  return asyncIsar.when(
    data: QuestLogRepository.new,
    loading: () => null,
    error: (error, stackTrace) {
      debugPrint('Quest log repository unavailable: $error');
      return null;
    },
  );
}

UserRepository? _buildUserRepository(Ref ref) {
  final asyncIsar = ref.watch(isarProvider);
  return asyncIsar.when(
    data: UserRepository.new,
    loading: () => null,
    error: (error, stackTrace) {
      debugPrint('User repository unavailable: $error');
      return null;
    },
  );
}

final questRepositoryProvider = Provider<QuestRepository?>(
  _buildQuestRepository,
);
final questLogRepositoryProvider = Provider<QuestLogRepository?>(
  _buildQuestLogRepository,
);
final userRepositoryProvider = Provider<UserRepository?>(_buildUserRepository);

final pairRepositoryProvider = Provider<PairRepository?>((ref) {
  final firestore = ref.watch(firestoreProvider);
  if (firestore == null) {
    return null;
  }
  return PairRepository(firestore);
});

final firestoreSyncServiceProvider = Provider<FirestoreSyncService?>((ref) {
  final firestore = ref.watch(firestoreProvider);
  if (firestore == null) {
    return null;
  }
  final isarValue = ref.watch(isarProvider).value;
  final questLogRepository = ref.watch(questLogRepositoryProvider);
  if (isarValue == null || questLogRepository == null) {
    return null;
  }
  return FirestoreSyncService(
    firestore,
    questLogRepository,
    isarValue,
  );
});

final appStartupProvider = FutureProvider<void>((ref) async {
  final notifications = ref.read(notificationServiceProvider);
  final permissionGranted = await notifications.init();
  ref.read(notificationPermissionProvider.notifier).state = permissionGranted;

  await ref.watch(isarProvider.future);
  final questRepository = ref.read(questRepositoryProvider);
  await questRepository?.seedInitialQuests();

  final firebaseAvailable = ref.watch(firebaseAvailabilityProvider);
  if (!firebaseAvailable) {
    return;
  }

  final firebaseUser =
      await ref.read(authRepositoryProvider).signInAnonymously();

  if (firebaseUser == null) {
    return;
  }

  final userRepo = ref.read(userRepositoryProvider);
  if (userRepo == null) {
    debugPrint('User repository unavailable; aborting startup.');
    return;
  }
  var localUser = await userRepo.getLocalUser(firebaseUser.uid);
  if (localUser == null) {
    localUser =
        minq_user.User()
          ..uid = firebaseUser.uid
          ..createdAt = DateTime.now()
          ..notificationTimes = List.of(
            NotificationService.defaultReminderTimes,
          )
          ..privacy = 'private'
          ..longestStreak = 0
          ..currentStreak = 0;
    await userRepo.saveLocalUser(localUser);
  } else if (localUser.notificationTimes.isEmpty) {
    localUser.notificationTimes = List.of(
      NotificationService.defaultReminderTimes,
    );
    await userRepo.saveLocalUser(localUser);
  }

  final pairRepository = ref.read(pairRepositoryProvider);
  if (pairRepository != null) {
    final assignment = await pairRepository.fetchAssignment(firebaseUser.uid);
    final assignedPairId = assignment?['pairId'] as String?;
    if (assignedPairId != null && assignedPairId.isNotEmpty) {
      if (localUser.pairId != assignedPairId) {
        localUser.pairId = assignedPairId;
        await userRepo.saveLocalUser(localUser);
      }
    }
  }

  final logRepo = ref.read(questLogRepositoryProvider);
  if (logRepo == null) {
    debugPrint('Quest log repository unavailable; skipping streak calculations.');
    return;
  }
  final currentStreak = await logRepo.calculateStreak(localUser.uid);
  final longestStreak = await logRepo.calculateLongestStreak(localUser.uid);
  final previousLongest = localUser.longestStreak;
  if (localUser.currentStreak != currentStreak ||
      localUser.longestStreak != longestStreak) {
    await userRepo.updateStreaks(
      localUser.uid,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      longestStreakReachedAt: longestStreak > previousLongest
          ? DateTime.now()
          : localUser.longestStreakReachedAt,
    );
    localUser.currentStreak = currentStreak;
    localUser.longestStreak = longestStreak;
    if (longestStreak > previousLongest) {
      localUser.longestStreakReachedAt = DateTime.now();
    }
  }

  final reminderTimes = List<String>.from(localUser.notificationTimes);
  final recurringTimes = reminderTimes.take(2).toList();
  final auxiliaryTime = reminderTimes.length > 2 ? reminderTimes[2] : null;

  if (permissionGranted) {
    await notifications.ensureTimezoneConsistency(
      fallbackRecurring: recurringTimes,
      fallbackAuxiliary: auxiliaryTime,
    );
    if (recurringTimes.isNotEmpty) {
      await notifications.scheduleRecurringReminders(recurringTimes);
    }

    if (auxiliaryTime != null) {
      final hasCompleted = await logRepo.hasCompletedDailyGoal(localUser.uid);
      if (hasCompleted) {
        await notifications.cancelAuxiliaryReminder();
      } else {
        await notifications.scheduleAuxiliaryReminder(auxiliaryTime);
      }
    } else {
      await notifications.cancelAuxiliaryReminder();
    }
    await notifications.resumeFromTimeDrift();
  }
  if (!permissionGranted) {
    await notifications.ensureTimezoneConsistency(
      fallbackRecurring: const <String>[],
      fallbackAuxiliary: null,
    );
    await notifications.cancelAll();
  }

  try {
    final timeConsistent =
        await ref.read(timeConsistencyServiceProvider).isDeviceTimeConsistent();
    final hasDrift = !timeConsistent;
    ref.read(timeDriftDetectedProvider.notifier).state = hasDrift;
    if (hasDrift) {
      await notifications.suspendForTimeDrift();
    }
  } on SocketException catch (error) {
    debugPrint('Time consistency probe failed: $error');
  }

  final syncService = ref.read(firestoreSyncServiceProvider);
  if (syncService != null) {
    try {
      await syncService.syncQuestLogs(firebaseUser.uid);
    } on FirebaseException catch (error) {
      debugPrint('Quest log sync failed: ${error.code}');
    }
  }

  await ref.read(featureFlagsProvider.notifier).ensureLoaded();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final localUserProvider = FutureProvider<minq_user.User?>((ref) async {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      final repository = ref.watch(userRepositoryProvider);
      if (repository == null) {
        return null;
      }
      return repository.getLocalUser(firebaseUser.uid);
    },
    error: (_, __) => Future.value(null),
    loading: () => Future.value(null),
  );
});

final uidProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.value?.uid;
});

final pairAssignmentStreamProvider =
    StreamProvider<DocumentSnapshot<Map<String, dynamic>>?>((ref) {
      final firestore = ref.watch(firestoreProvider);
      if (firestore == null) {
        return const Stream.empty();
      }
      final authState = ref.watch(authStateChangesProvider);
      final firebaseUser = authState.value;
      if (firebaseUser == null) {
        return const Stream.empty();
      }
      return firestore
          .collection('pair_assignments')
          .doc(firebaseUser.uid)
          .snapshots();
    });
final pairStreamProvider =
    StreamProvider<DocumentSnapshot<Map<String, dynamic>>?>((ref) {
      final pairRepository = ref.watch(pairRepositoryProvider);
      if (pairRepository == null) {
        return const Stream.empty();
      }
      final asyncUser = ref.watch(localUserProvider);
      final localUser = asyncUser.value;
      final pairId = localUser?.pairId;
      if (pairId == null || pairId.isEmpty) {
        return Stream<DocumentSnapshot<Map<String, dynamic>>?>.value(null);
      }
      return pairRepository
          .getPairStream(pairId)
          .map<DocumentSnapshot<Map<String, dynamic>>?>((snapshot) => snapshot);
    });

Future<void> _ensureStartup(Ref ref) async {
  await ref.watch(appStartupProvider.future);
}

final allQuestsProvider = FutureProvider<List<Quest>>((ref) async {
  await _ensureStartup(ref);
  final repository = ref.read(questRepositoryProvider);
  if (repository == null) {
    return const <Quest>[];
  }
  return repository.getAllQuests();
});

final templateQuestsProvider = FutureProvider<List<Quest>>((ref) async {
  await _ensureStartup(ref);
  final repository = ref.read(questRepositoryProvider);
  if (repository == null) {
    return const <Quest>[];
  }
  return repository.getTemplateQuests();
});

final userQuestsProvider = FutureProvider<List<Quest>>((ref) async {
  await _ensureStartup(ref);
  final user = await ref.watch(localUserProvider.future);
  if (user == null) {
    return [];
  }
  final repository = ref.read(questRepositoryProvider);
  if (repository == null) {
    return const <Quest>[];
  }
  return repository.getQuestsForOwner(user.uid);
});
final questByIdProvider = FutureProvider.family<Quest?, int>((ref, id) async {
  await _ensureStartup(ref);
  final repository = ref.read(questRepositoryProvider);
  if (repository == null) {
    return null;
  }
  return repository.getQuestById(id);
});

final streakProvider = FutureProvider<int>((ref) async {
  await _ensureStartup(ref);
  final user = await ref.watch(localUserProvider.future);
  if (user == null) {
    return 0;
  }
  final repository = ref.read(questLogRepositoryProvider);
  if (repository == null) {
    return 0;
  }
  return repository.calculateStreak(user.uid);
});

final longestStreakProvider = FutureProvider<int>((ref) async {
  await _ensureStartup(ref);
  final user = await ref.watch(localUserProvider.future);
  if (user == null) {
    return 0;
  }
  final repository = ref.read(questLogRepositoryProvider);
  if (repository == null) {
    return 0;
  }
  return repository.calculateLongestStreak(user.uid);
});

final todayCompletionCountProvider = FutureProvider<int>((ref) async {
  await _ensureStartup(ref);
  final user = await ref.watch(localUserProvider.future);
  if (user == null) {
    return 0;
  }
  final repository = ref.read(questLogRepositoryProvider);
  if (repository == null) {
    return 0;
  }
  return repository.countLogsForDay(user.uid, DateTime.now());
});

final recentLogsProvider = FutureProvider<List<QuestLog>>((ref) async {
  await _ensureStartup(ref);
  final user = await ref.watch(localUserProvider.future);
  if (user == null) {
    return [];
  }
  final repository = ref.read(questLogRepositoryProvider);
  if (repository == null) {
    return const <QuestLog>[];
  }
  final logs = await repository.getLogsForUser(user.uid);
  return logs.take(30).toList();
});
final heatmapDataProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  await _ensureStartup(ref);
  final user = await ref.watch(localUserProvider.future);
  if (user == null) {
    return {};
  }
  final repository = ref.read(questLogRepositoryProvider);
  if (repository == null) {
    return const <DateTime, int>{};
  }
  return repository.getHeatmapData(user.uid);
});














