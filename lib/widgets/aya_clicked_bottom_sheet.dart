import 'dart:math' as math; // import this

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/localization/app_localizations.dart';

import '../resources/colors.dart';

class AyaClickedBottomSheet extends StatefulWidget {
   Function ShowAudioPlayer;
   
AyaClickedBottomSheet({
    Key? key,
    required this.ShowAudioPlayer,
   
  }) : super(key: key);

  @override
  State<AyaClickedBottomSheet> createState() => _AyaClickedBottomSheetState();
}

class _AyaClickedBottomSheetState extends State<AyaClickedBottomSheet> {

  void viewAudioPlayerController() {
    setState(() {
      widget.ShowAudioPlayer();
    });
  }

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
                padding: const EdgeInsets.all(20),
                iconSize: 32,
                alignment: Alignment.topRight,
                onPressed: () {
                  //todo: change text next to iconbutton
                  //todo: fill icon           
                },

                icon: const Icon(Icons.bookmark_border_outlined),
                color: bkColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
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


    Widget returnListItem(String listText, bool transform, String path, Function handler) {
      return Material(
        child: ListTile(      
          enableFeedback: true,
          onTap: (){
viewAudioPlayerController();
          Navigator.pop(context);
          },
          leading: (transform == true)
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: SvgPicture.asset("assets/images/$path.svg",
                      width: 30, height: 30, fit: BoxFit.fitWidth))
              // child: Icon(listIcon))
              : SvgPicture.asset("assets/images/$path.svg",
                  width: 30, height: 30, fit: BoxFit.fitWidth),
          title: Text(listText, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        ),
      );
    }

    return Container(
      height: 600,
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
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              physics: NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        crossAxisCount: 2,
                        childAspectRatio: 79 / 30,
                      ),
                      children: <Widget>[
                        returnGridItem(
                          const BorderRadius.only(
                              topRight: Radius.circular(20)),
                          CustomColors.yellow400,
                          AppLocalizations.of(context)!
                              .translate('onclick_aya_modalsheet_bk1')
                              .toString(),
                        ),
                        returnGridItem(
                          const BorderRadius.only(topLeft: Radius.circular(20)),
                          CustomColors.pink100,
                          AppLocalizations.of(context)!
                              .translate('onclick_aya_modalsheet_bk2')
                              .toString(),
                        ),
                        
                        returnGridItem(
                          const BorderRadius.only(
                              bottomRight: Radius.circular(20)),
                          CustomColors.green200,
                          AppLocalizations.of(context)!
                              .translate('onclick_aya_modalsheet_bk3')
                              .toString(),
                        ),
                        returnGridItem(
                          const BorderRadius.only(
                              bottomLeft: Radius.circular(20)),
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
                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list1')
                          .toString(),
                      false,
                      'listPlay',viewAudioPlayerController),
                  Divider(
                    color: CustomColors.yellow200,
                    indent: 58,
                    thickness: 1.3,
                  ),
                  returnListItem(
                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list2')
                          .toString(),
                      false,
                      'listPlay', (){}),
                ]),
              ),
            ),
            SizedBox(height:6),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  returnListItem(
                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list3')
                          .toString(),
                      true,
                      'listShare',(){} ),
                  Divider(
                    color: CustomColors.yellow200,
                    indent: 58,
                    thickness: 1.3,
                  ),
                  returnListItem(
                      AppLocalizations.of(context)!
                          .translate('onclick_aya_modalsheet_list4')
                          .toString(),
                      true,
                      'listCopy', (){}),
                ]),
              ),
            ),            SizedBox(height:8),


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
