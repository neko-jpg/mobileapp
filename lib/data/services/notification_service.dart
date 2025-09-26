import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();

  static const List<String> defaultReminderTimes = ['07:30', '18:30', '21:30'];
  static const int _recurringNotificationBaseId = 200;
  static const int _auxiliaryNotificationId = 300;
  static const int _snoozeNotificationId = 400;
  static const String _recordRoutePayload = '/record';

  static const String snoozeActionId_10m = 'snooze_10m';
  static const String snoozeActionId_1h = 'snooze_1h';
  static const String snoozeActionId_1d = 'snooze_1d';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _tapController =
      StreamController<String>.broadcast();

  bool _initialized = false;
  String? _initialPayload;

  bool get _supportsLocalNotifications => !kIsWeb;

  Stream<String> get notificationTapStream => _tapController.stream;

  Future<String?> takeInitialPayload() async {
    final payload = _initialPayload;
    _initialPayload = null;
    return payload;
  }

  Future<bool> init() async {
    if (!_supportsLocalNotifications) {
      return false;
    }

    if (!_initialized) {
      tz.initializeTimeZones();
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      _initialPayload = launchDetails?.notificationResponse?.payload;

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initializationSettings = InitializationSettings(
        android: androidSettings,
      );
      await _plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          if (details.actionId != null &&
              details.actionId!.startsWith('snooze')) {
            _handleSnooze(details.actionId!, details.payload);
          } else {
            final payload = details.payload;
            if (payload != null && payload.isNotEmpty) {
              _tapController.add(payload);
            }
          }
        },
      );
      _initialized = true;
    }
    final granted = await requestPermission();
    return granted;
  }

  Future<bool> requestPermission() async {
    if (!_supportsLocalNotifications) {
      return false;
    }

    bool granted = true;

    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      final enabled = await androidImplementation.areNotificationsEnabled();
      if (enabled != null) {
        granted = granted && enabled;
      }
    }

    final iosImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosImplementation != null) {
      final iosGranted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (iosGranted != null) {
        granted = granted && iosGranted;
      }
    }

    return granted;
  }

  Future<void> scheduleRecurringReminders(List<String> times) async {
    if (!_supportsLocalNotifications) {
      return;
    }

    await _cancelRecurringReminders();
    for (var index = 0; index < times.length; index++) {
      final parsed = _parseTime(times[index]);
      if (parsed == null) continue;

      await _plugin.zonedSchedule(
        _recurringNotificationBaseId + index,
        _titleForIndex(index),
        _bodyForIndex(index),
        _nextInstance(parsed.$1, parsed.$2),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'minq_daily_channel',
            'MinQ 毎日のリマインダー',
            channelDescription: '続けやすいタイミングでミニクエをお知らせします。',
            importance: Importance.high,
            priority: Priority.high,
            actions: [
              AndroidNotificationAction(snoozeActionId_10m, '+10分'),
              AndroidNotificationAction(snoozeActionId_1h, '+1時間'),
              AndroidNotificationAction(snoozeActionId_1d, '明日'),
            ],
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: _recordRoutePayload,
      );
    }
  }

  Future<void> scheduleAuxiliaryReminder(String time) async {
    if (!_supportsLocalNotifications) {
      return;
    }

    final parsed = _parseTime(time);
    if (parsed == null) return;

    await _plugin.zonedSchedule(
      _auxiliaryNotificationId,
      'あと1つだけやってみよう',
      '今日のミニQuestがまだなら、今こそHigh-fiveをもらいにいこう。',
      _nextInstance(parsed.$1, parsed.$2),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'minq_aux_channel',
          'MinQ 追いリマインダー',
          channelDescription: '未完了のときだけ届く補助リマインダーです。',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: _recordRoutePayload,
    );
  }

  Future<void> _handleSnooze(String actionId, String? payload) async {
    Duration snoozeDuration;
    switch (actionId) {
      case snoozeActionId_10m:
        snoozeDuration = const Duration(minutes: 10);
        break;
      case snoozeActionId_1h:
        snoozeDuration = const Duration(hours: 1);
        break;
      case snoozeActionId_1d:
        snoozeDuration = const Duration(days: 1);
        break;
      default:
        return;
    }

    final snoozedTime = tz.TZDateTime.now(tz.local).add(snoozeDuration);

    await _plugin.zonedSchedule(
      _snoozeNotificationId,
      'Snoozed: MinQからのお知らせ',
      '時間になりました。ミニQuestをRecordしましょう。',
      snoozedTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'minq_snooze_channel',
          'MinQ スヌーズしたリマインダー',
          channelDescription: 'スヌーズしたリマインダーです。',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> cancelAuxiliaryReminder() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    await _plugin.cancel(_auxiliaryNotificationId);
  }

  Future<void> cancelAll() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    await _plugin.cancelAll();
  }

  Future<void> _cancelRecurringReminders() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    for (var index = 0; index < 3; index++) {
      await _plugin.cancel(_recurringNotificationBaseId + index);
    }
  }

  (int, int)? _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    final normalizedHour = hour.clamp(0, 23).toInt();
    final normalizedMinute = minute.clamp(0, 59).toInt();
    return (normalizedHour, normalizedMinute);
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return '朝一番のミニクエ時間';
      case 1:
        return '昼下がりのリセット';
      case 2:
        return 'おやすみ前の振り返り';
      default:
        return 'MinQからのお知らせ';
    }
  }

  String _bodyForIndex(int index) {
    switch (index) {
      case 0:
        return '最初のミニクエで勢いをつけましょう。まずは1分でOK！';
      case 1:
        return '小さなタスクで午後の集中力を取り戻しましょう。';
      case 2:
        return '今日のRecordをまとめて、ストリークを伸ばそう。';
      default:
        return 'ミニQuestを続けて、PairにHigh-fiveを送りましょう。';
    }
  }
}

