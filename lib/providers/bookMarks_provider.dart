import 'package:flutter/foundation.dart';
import '../data/boxes.dart';
import '../models/book_mark.dart';

class BookMarkItem {
  final String page;
  final String aya;
  final String type;
  final String id;
  final int pageNum;
  final int highlightNum;

  BookMarkItem({
    required this.page,
    required this.aya,
    required this.type,
    required this.id,
    required this.pageNum,
    required this.highlightNum,
  });
}

class BookMarks extends ChangeNotifier {
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

  Future<void> addBookMark({id, aya, page, type, pageNum, highlightNum}) async {
    bool check = checkBookmark(type);
    if (!check) {
      final newItem = BookMark(
          id: id,
          aya: aya,
          page: page,
          type: type,
          pageNum: pageNum,
          highlightNum: highlightNum);

      final box = Boxes.getBookMarks();
      box.add(newItem);
      fetchAndSetBookMarks();
    }
    notifyListeners();
  }

  Future<void> deleteBookMark(int id) async {
    final box = Boxes.getBookMarks();
    var listofbox = box.values.toList();
    int indices =
        listofbox.indexWhere((element) => element.type == id.toString());

    box.deleteAt(indices);
    fetchAndSetBookMarks();
  }

  bool checkBookmark(String type) {
    final box = Boxes.getBookMarks();
    var filteredUsers = box.values.where((box) => box.id == type).toList();

    if (filteredUsers.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String? bkAyaText(String type) {
    final box = Boxes.getBookMarks();
    var bookmarksss = box.values.where((box) => box.id == type).toList();
    String bkTxt = '';

    for (var item in bookmarksss) {
      bkTxt = item.aya.toString();
    }
    return bkTxt;
  }
}
