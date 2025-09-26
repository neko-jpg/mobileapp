import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:minq/domain/badge/badge.dart';
import 'package:minq/domain/log/quest_log.dart';
import 'package:minq/domain/pair/pair.dart';
import 'package:minq/domain/quest/quest.dart';
import 'package:minq/domain/user/user.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late final Isar isar;

  Future<Isar> init() async {
    final existing = Isar.getInstance();
    if (existing != null) {
      isar = existing;
      return isar;
    }

    final directory = kIsWeb ? null : await getApplicationDocumentsDirectory();
    final schemas = [
      QuestSchema,
      UserSchema,
      PairSchema,
      QuestLogSchema,
      BadgeSchema,
    ];

    final directoryPath = directory?.path ?? 'isar_web';
    isar = await Isar.open(
      schemas,
      directory: directoryPath,
    );

    return isar;
  }
}
