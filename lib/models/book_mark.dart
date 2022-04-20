import 'package:hive/hive.dart';
part 'book_mark.g.dart';

@HiveType(typeId: 0)
class BookMark extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String page;

  @HiveField(2)
  final String aya;

  @HiveField(3)
  final String type;

  BookMark(
      {required this.id,
      required this.aya,
      required this.page,
      required this.type});
}
