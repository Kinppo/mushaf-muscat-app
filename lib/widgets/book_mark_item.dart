import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/localization/app_localizations.dart';

import '../resources/colors.dart';

class BookMarkItem extends StatelessWidget {
  final String page;
  final String aya;
  final int type;
  final String id;

  BookMarkItem(
      {required this.page,
      required this.aya,
      required this.type,
      required this.id});

  @override
  Widget build(BuildContext context) {
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
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure? '),
                  content: const Text('Do you remove the item from cart?'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'))
                  ],
                ));
      },
      onDismissed: (direction) {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
          child: ListTile(
            leading: Icon(
              MdiIcons.bookmark,
              color: type == 1
                  ? CustomColors.yellow400
                  : type == 2
                      ? CustomColors.red400
                      : CustomColors.pink100,
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
