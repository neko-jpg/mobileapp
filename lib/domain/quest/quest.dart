import 'package:isar/isar.dart';

part 'quest.g.dart';

@Collection()
class Quest {
  Quest(); // Empty constructor for Isar

  Id id = Isar.autoIncrement;

  late String owner;
  late String title;
  late String category;

  int estimatedMinutes = 5;

  String? iconKey;

  late DateTime createdAt;
}
