import 'package:hive/hive.dart';
import 'package:mushafmuscat/models/book_mark.dart';

class Boxes {
  static Box<BookMark> getBookMarks() => Hive.box<BookMark>('bookMarks');
}
