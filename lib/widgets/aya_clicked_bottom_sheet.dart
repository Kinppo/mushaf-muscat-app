import 'dart:math' as math; // import this


import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/localization/app_localizations.dart';

import '../resources/colors.dart';

class AyaClickedBottomSheet extends StatefulWidget {
  const AyaClickedBottomSheet({Key? key}) : super(key: key);

  @override
  State<AyaClickedBottomSheet> createState() => _AyaClickedBottomSheetState();
}

class _AyaClickedBottomSheetState extends State<AyaClickedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    // return grid item container
    Widget returnGridItem(BorderRadius rad, Color bkColor, String bkText) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: rad,
        ),
        child: Row(
          children: [
            IconButton(
                padding: EdgeInsets.all(20),
                iconSize: 32,
                alignment: Alignment.topRight,
                onPressed: () {
                  //todo: change text next to iconbutton
                  //todo: fill icon button
                },
                icon: Icon(Icons.bookmark_border_outlined),
                color: bkColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "الفاصل $bkText",
                  style: TextStyle(fontSize: 16, color: CustomColors.black200),
                  textAlign: TextAlign.right,
                ),

                //todo: only show this when button is pressed
                Text(
                  "الآية: ١٣٦",
                  style: TextStyle(fontSize: 14, color: CustomColors.grey200),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      );
    }

    // return grid list item container
    Widget returnListItem(IconData listIcon, String listText, bool transform) {
      return ListTile(
        leading:(transform== true) ? Transform(
          alignment: Alignment.center,
           transform: Matrix4.rotationY(math.pi),
          child: Icon(listIcon)) : Icon(listIcon),
        title: Text(listText),
      );
    }

    return Container(
      height: 1000,
      color: CustomColors.yellow100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColors.yellow100,
                  ),
                  child: GridView(
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        crossAxisCount: 2,
                        childAspectRatio: 79 / 30,
                      ),
                      children: <Widget>[
                        returnGridItem(
                          BorderRadius.only(topRight: Radius.circular(20)),
                          CustomColors.yellow400,
                          AppLocalizations.of(context)!
                              .translate('onclick_aya_modalsheet_bk1')
                              .toString(),
                        ),
                        returnGridItem(
                          BorderRadius.only(topLeft: Radius.circular(20)),
                          CustomColors.pink100,
                          AppLocalizations.of(context)!
                              .translate('onclick_aya_modalsheet_bk2')
                              .toString(),
                        ),
                        returnGridItem(
                          BorderRadius.only(bottomRight: Radius.circular(20)),
                          CustomColors.green200,
                          AppLocalizations.of(context)!
                              .translate('onclick_aya_modalsheet_bk3')
                              .toString(),
                        ),
                        returnGridItem(
                          BorderRadius.only(bottomLeft: Radius.circular(20)),
                          CustomColors.blue100,
                          AppLocalizations.of(context)!
                              .translate('onclick_aya_modalsheet_bk4')
                              .toString(),
                        ),
                      ]),
                ),
              ),
            ),

            ListTile(    

              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  returnListItem(
                      Icons.play_arrow,
                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list1')
                          .toString(), false),
                  Divider(
                    color: CustomColors.yellow200,
                    indent: 58,
                    thickness: 1.3,
                  ),
                  returnListItem(
                      Icons.play_arrow,
                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list2')
                          .toString(), false),
                ]),
              ),
             
            ),
             ListTile(    

              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  returnListItem(
                      MdiIcons.share,

                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list3')
                          .toString(), false),
                  Divider(
                    color: CustomColors.yellow200,
                    indent: 58,
                    thickness: 1.3,
                  ),
                  returnListItem(
                      Icons.copy,
                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list4')
                          .toString(), true),
                ]),
              ),
              
            ),

            // ElevatedButton(
            //   child: const Text('Close BottomSheet'),
            //   onPressed: () => Navigator.pop(context),
            // )
          ],
        ),
      ),
    );
  }
}
