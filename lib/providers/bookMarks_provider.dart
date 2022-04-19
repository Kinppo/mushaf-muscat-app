import 'package:flutter/foundation.dart';

class BookMarkItem {
  final String page;
  final String aya;
  final int type;
  final String id;

  BookMarkItem(
      {required this.page,
      required this.aya,
      required this.type,
      required this.id});
}

class BookMarks extends ChangeNotifier {
  List<BookMarkItem> _bookmarks = [];

  List<BookMarkItem> get bookmarks {
    return [..._bookmarks];
  }

  Future<void> fetchAndSetBookMarks() async {
    final List<BookMarkItem> loadedBookMarks = [];
    await Future.delayed(Duration(seconds: 1));

    loadedBookMarks
        .add(BookMarkItem(page: "الفاتحة", aya: "٢٣٥", type: 1, id: "1"));
    loadedBookMarks
        .add(BookMarkItem(page: "يوسف", aya: "٢٣٥", type: 2, id: "2"));
    loadedBookMarks
        .add(BookMarkItem(page: "العمران", aya: "٢٣٥", type: 3, id: "3"));

    _bookmarks = loadedBookMarks;

    notifyListeners();
  }

  void addBookMark() async {}

  void deleteBookMark(String id) async {}
}
