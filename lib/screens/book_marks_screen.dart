import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mushafmuscat/widgets/book_mark_grid.dart';
import 'package:provider/provider.dart';

import '../widgets/bottom_navigation_bar.dart';
import '../providers/bookmarks_provider.dart';

class BookMarksScreen extends StatefulWidget {
  static const routeName = '/book_marks';

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    //Hive.box('bookMarks').close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<BookMarks>(context)
          .fetchAndSetBookMarks()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BNavigationBar(
        pageIndex: 1,
        toggleBars:
            () {}, //do nothing and only allow bottom nav bar to disappear in quran screen
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : BookMarksGrid()),
    );
  }
}
