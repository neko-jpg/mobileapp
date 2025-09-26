import 'package:isar/isar.dart';

part 'pair.g.dart';

@Collection()
class Pair {
  Id id = Isar.autoIncrement;

  late List<String> members;
  late String category;
  late DateTime createdAt;
  DateTime? lastHighfiveAt;

  Pair(); // Empty constructor for Isar
}
