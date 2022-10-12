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
  late final String type;

    @HiveField(4)
  final int pageNum;

    @HiveField(5)
  final int highlightNum;


  BookMark(
      {required this.id,
      required this.aya,
      required this.page,
      required this.type,
      required this.pageNum,
      required this.highlightNum
  });
}
