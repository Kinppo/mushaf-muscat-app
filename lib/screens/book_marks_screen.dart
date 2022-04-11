import 'package:flutter/material.dart';
import 'package:mushafmuscat/widgets/bottom_navigation_bar.dart';

import '../localization/app_localizations.dart';

class BookMarksScreen extends StatelessWidget {
  static const routeName = '/book_marks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BNavigationBar(
        pageIndex: 1,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        child: Column(
          children: [Text("test"), Text("test"), Text("test")],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
