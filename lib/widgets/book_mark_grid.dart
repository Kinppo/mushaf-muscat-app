import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../widgets/book_mark_item.dart' as bmi;
import '../localization/app_localizations.dart';
import '../providers/bookMarks_provider.dart';

class BookMarksGrid extends StatelessWidget {
  const BookMarksGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bookMarksData = Provider.of<BookMarks>(context).bookmarks;
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!
              .translate('book_marks_title')
              .toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        bookMarksData.isEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    if (_isLandscape)
                      const SizedBox(
                        width: double.infinity,
                        height: 20,
                      )
                    else
                      const SizedBox(
                        width: double.infinity,
                        height: 60,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/mark3.svg"),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 4),
                            child: SvgPicture.asset("assets/images/mark1.svg")),
                        SvgPicture.asset("assets/images/mark2.svg")
                      ],
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('book_marks_description')
                            .toString(),
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              )
            : Expanded(
                child: ListView.builder(
                itemCount: bookMarksData.length,
                itemBuilder: (ctx, i) => bmi.BookMarkItem(
                  id: bookMarksData[i].id,
                  page: bookMarksData[i].page,
                  aya: bookMarksData[i].aya,
                  type: bookMarksData[i].type,
                ),
              )),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
