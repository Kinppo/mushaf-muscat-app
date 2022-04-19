import 'package:flutter/material.dart';
import 'package:mushafmuscat/widgets/book_mark_grid.dart';
import 'package:provider/provider.dart';

import '../widgets/bottom_navigation_bar.dart';
import '../providers/bookMarks_provider.dart';

class BookMarksScreen extends StatefulWidget {
  static const routeName = '/book_marks';

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  var _isInit = true;
  var _isLoading = false;

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
      bottomNavigationBar: const BNavigationBar(
        pageIndex: 1,
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
