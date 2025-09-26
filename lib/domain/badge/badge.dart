import 'package:isar/isar.dart';

part 'badge.g.dart';

@Collection()
class Badge {
  Id id = Isar.autoIncrement;

  late String uid;
  late String code;
  late DateTime earnedAt;

  Badge(); // Empty constructor for Isar
}
