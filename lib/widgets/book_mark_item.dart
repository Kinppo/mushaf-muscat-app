
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/localization/app_localizations.dart';
import 'package:mushafmuscat/models/page.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../providers/bookMarks_provider.dart';
import '../screens/quran_screen.dart';

class BookMarkItem extends StatelessWidget {
  final String page;
  final String aya;
  final String type;
  final String id;
  final int pageNum;
  final int highlightNum;

  BookMarkItem(
      {required this.page,
      required this.aya,
      required this.type,
      required this.id, 
      required this.pageNum, 
      required this.highlightNum});

  Future<bool?> _showSnackBar(context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!
          .translate('book_marks_delete_msg')
          .toString()),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.translate('undo').toString(),
        onPressed: () {

        },
      ),
    ));
    return null;
  }
late final bookMarkProvider;

  @override
  Widget build(BuildContext context) {
        bookMarkProvider = Provider.of<BookMarks>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).errorColor),
        //color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.fromLTRB(0, 5, 5, 13),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        bookMarkProvider.deleteBookMark(int.parse(id));
          print("test");
        return _showSnackBar(context);
        // return showDialog(
        //     context: context,
        //     builder: (ctx) => AlertDialog(
        //           title: const Text('Are you sure? '),
        //           content: const Text('Do you remove the item from cart?'),
        //           actions: [
        //             FlatButton(
        //                 onPressed: () {
        //                   Navigator.of(context).pop(false);
        //                 },
        //                 child: const Text('No')),
        //             FlatButton(
        //                 onPressed: () {
        //                   Navigator.of(context).pop(true);
        //                 },
        //                 child: const Text('Yes'))
        //           ],
        //         ));
      },
      onDismissed: (direction) {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
          child: ListTile(
            onTap: () {
                   print("bookmak item: $page");
              print("bookmak item2: $aya");
              print("bookmak item: $highlightNum");
              print("bookmak item2: $pageNum");
                   Navigator.of(context).popAndPushNamed(QuranScreen.routeName,arguments:pageNum);

            },
            leading: Icon(
              MdiIcons.bookmark,
              color: type == "1"
                  ? CustomColors.yellow400
                  : type == "2"
                      ? CustomColors.pink100 :
                      type == "3"
                     ? CustomColors.green200
                     : 
                     CustomColors.blue100,
              size: 31,
            ),
            title: Text(page),
            subtitle: Text(
                '${AppLocalizations.of(context)!.translate('book_marks_aya').toString()}${aya}'),
          ),
        ),
      ),
    );
  }
}
