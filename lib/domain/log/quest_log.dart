import 'package:isar/isar.dart';

part 'quest_log.g.dart';

enum ProofType { photo, check }

@Collection()
class QuestLog {
  Id id = Isar.autoIncrement;

  late String uid;
  late int questId;
  late DateTime ts;

  @Enumerated(EnumType.name)
  late ProofType proofType;

  String? proofValue;
  late bool synced;

  QuestLog(); // Empty constructor for Isar
}
