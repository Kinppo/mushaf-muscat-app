import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import '../resources/colors.dart';
import '../providers/bookmarks_provider.dart';
import '../screens/quran_screen.dart';

class BookMarkItem extends StatelessWidget {
  final String page;
  final String aya;
  final String type;
  final String id;
  final int pageNum;
  final int highlightNum;

  BookMarkItem({
    super.key,
    required this.page,
    required this.aya,
    required this.type,
    required this.id,
    required this.pageNum,
    required this.highlightNum,
  });

  Future<bool?> _showSnackBar(context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!
          .translate('book_marks_delete_msg')
          .toString()),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.translate('undo').toString(),
        onPressed: () {},
      ),
    ));
    return null;
  }

  late final BookMarks bookMarkProvider;

  @override
  Widget build(BuildContext context) {
    bookMarkProvider = Provider.of<BookMarks>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).errorColor),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.fromLTRB(0, 5, 5, 13),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        bookMarkProvider.deleteBookMark(int.parse(id));
        return _showSnackBar(context);
      },
      onDismissed: (direction) {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
          child: ListTile(
            onTap: () {
              Navigator.of(context).popAndPushNamed(
                QuranScreen.routeName,
                arguments: {
                  'v1': pageNum,
                  'v2': 0,
                },
              );
            },
            leading: Icon(
              MdiIcons.bookmark,
              color: type == "1"
                  ? CustomColors.yellow400
                  : type == "2"
                      ? CustomColors.pink100
                      : type == "3"
                          ? CustomColors.green200
                          : CustomColors.blue100,
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
