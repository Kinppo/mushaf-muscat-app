import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../data/boxes.dart';
import '../models/book_mark.dart';

class BookMarkItem {
  final String page;
  final String aya;
  final String type;
  final String id;

  BookMarkItem(
      {required this.page,
      required this.aya,
      required this.type,
      required this.id});
}

class BookMarks extends ChangeNotifier {
  final String _boxName = 'bookMarks';

  List<BookMark> _bookmarks = [];

  List<BookMark> get bookmarks {
    return [..._bookmarks];
  }

  Future<List<BookMark>> getFullAccount() async {
    final box = Boxes.getBookMarks();
    final List<BookMark> bookMarks = box.values.toList().cast<BookMark>();

    return bookMarks;
  }

  Future<void> fetchAndSetBookMarks() async {
    List<BookMark> loadedBookMar = [];

    loadedBookMar = await getFullAccount();
    _bookmarks = loadedBookMar;

    notifyListeners();
  }

  Future<void> addBookMark() async {
    final newItem = BookMark(id: '2', aya: '٢٣٥', page: 'test', type: '2');
    final box = Boxes.getBookMarks();
    box.add(newItem);
  }

  Future<void> deleteBookMark(String id) async {}
}
