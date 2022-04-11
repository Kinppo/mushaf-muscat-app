import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mushafmuscat/models/book_mark.dart';
import 'package:mushafmuscat/widgets/bottom_navigation_bar.dart';

import '../localization/app_localizations.dart';
import '../widgets/book_mark_item.dart' as bmi;

class BookMarksScreen extends StatelessWidget {
  static const routeName = '/book_marks';
  final List<BookMark> _bookMarks = [
    BookMark(page: "الفاتحة", aya: "٢٣٥", type: 1, id: "1"),
    BookMark(page: "يوسف", aya: "٢٣٥", type: 2, id: "2"),
    BookMark(page: "العمران", aya: "٢٣٥", type: 3, id: "3")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BNavigationBar(
        pageIndex: 1,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!
                  .translate('book_marks_title')
                  .toString(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            _bookMarks.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/images/mark3.svg"),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 4),
                              child:
                                  SvgPicture.asset("assets/images/mark1.svg")),
                          SvgPicture.asset("assets/images/mark2.svg")
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('book_marks_description')
                              .toString(),
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                    itemCount: _bookMarks.length,
                    itemBuilder: (ctx, i) => bmi.BookMarkItem(
                      id: _bookMarks[i].id,
                      page: _bookMarks[i].page,
                      aya: _bookMarks[i].aya,
                      type: _bookMarks[i].type,
                    ),
                  )),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
