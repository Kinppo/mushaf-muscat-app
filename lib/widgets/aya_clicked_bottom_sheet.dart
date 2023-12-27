import 'dart:math' as math; // import this

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/bookmarks_provider.dart';

import 'package:mushafmuscat/localization/app_localizations.dart';

import '../resources/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class AyaClickedBottomSheet extends StatefulWidget {
  Function ShowAudioPlayer;
  int clickedHighlightNum;
  int currentPage;
  String surahName;
  String ayaNum;
  String highlightedAyaText;
  Function playMoreOptions;
  AyaClickedBottomSheet({
    Key? key,
    required this.ShowAudioPlayer,
    required this.clickedHighlightNum,
    required this.currentPage,
    required this.surahName,
    required this.ayaNum,
    required this.highlightedAyaText,
    required this.playMoreOptions,
  }) : super(key: key);

  @override
  State<AyaClickedBottomSheet> createState() => _AyaClickedBottomSheetState();
}

class _AyaClickedBottomSheetState extends State<AyaClickedBottomSheet> {
// Icon bookmarkIcon =Icon(Icons.bookmark_border_outlined);
  List<IconData> bkIconsList = [
    Icons.bookmark_border_outlined,
    Icons.bookmark_border_outlined,
    Icons.bookmark_border_outlined,
    Icons.bookmark_border_outlined
  ];

  void viewAudioPlayerController() {
    setState(() {
      widget.ShowAudioPlayer();
    });
  }

  void shareController() async {
    String sharedAya = widget.highlightedAyaText.replaceAll("\n", " ");

    await Share.share(sharedAya);
  }

  void copyClipboard() async {
    String copiedAya = widget.highlightedAyaText.replaceAll("\n", " ");

    await Clipboard.setData(ClipboardData(text: copiedAya)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("تم نسخ الآية!")));
    });
  }

//bookmark vars

  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    final Screenwidth = MediaQuery.of(context).size.width;
    final box = context.findRenderObject() as RenderBox?;

    final bookMarkProvider = Provider.of<BookMarks>(context, listen: false);
    // return grid item container
    void getIcon(int type) {
      setState(() {
        if (bookMarkProvider.checkBookmark(type.toString()) == true) {
          bkIconsList[type - 1] = Icons.bookmark;
        } else {
          bkIconsList[type - 1] = Icons.bookmark_border_outlined;
        }
      });
    }

    String? bkAya(String type) {
      String? l = bookMarkProvider.bkAyaText(type);

      return l;
    }

    Widget returnGridItem(BorderRadius rad, Color bkColor, String bkText,
        int type, String bkAya, double Screenheight) {
      return Container(
        // color: Colors.red,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: rad,
        ),
        child: Row(
          children: [
            IconButton(
                // padding: const EdgeInsets.all(10),
                iconSize: 32,
                alignment: Alignment.topRight,
                onPressed: () {
                  bookMarkProvider.addBookMark(
                      id: type.toString(),
                      aya: widget.ayaNum,
                      page: widget.surahName,
                      type: type.toString(),
                      pageNum: widget.currentPage,
                      highlightNum: widget.clickedHighlightNum);
                  //todo: change text next to iconbutton
                  //todo: fill icon
                  // setState(() {
                  //   var bk=getIcon(type);
                  // });
                  // getIcon(type);
                  setState(() {
                    getIcon(type);
                  });
                },
                icon: (bookMarkProvider.checkBookmark(type.toString()) == true)
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border_outlined),
                // icon: Icon(bkIconsList[type-1]),
                color: bkColor),
            Padding(
              padding: EdgeInsets.only(top: Screenheight * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الفاصل $bkText",
                    style:
                        TextStyle(fontSize: 16, color: CustomColors.black200),
                    textAlign: TextAlign.right,
                  ),

                  //todo: only show this when button is pressed
                  Text(
                    (bkAya != '' && bkAya != null) ? "الآية: $bkAya" : "",
                    style: TextStyle(fontSize: 14, color: CustomColors.grey200),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget returnListItem(
        String listText, bool transform, String path, Function handler) {
      return Material(
        child: ListTile(
          enableFeedback: true,
          onTap: () {
            handler();
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
          title: Text(listText,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Screenheight * 0.01),
        // height: Screenheight*0.65,
        // color: Colors.blue,
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
                          childAspectRatio: 74 / 30,
                        ),
                        children: <Widget>[
                          returnGridItem(
                              const BorderRadius.only(
                                  topRight: Radius.circular(20)),
                              CustomColors.yellow400,
                              AppLocalizations.of(context)!
                                  .translate('onclick_aya_modalsheet_bk1')
                                  .toString(),
                              1,
                              bkAya("1")!,
                              Screenheight),
                          returnGridItem(
                              const BorderRadius.only(
                                  topLeft: Radius.circular(20)),
                              CustomColors.pink100,
                              AppLocalizations.of(context)!
                                  .translate('onclick_aya_modalsheet_bk2')
                                  .toString(),
                              2,
                              bkAya("2")!,
                              Screenheight),
                          returnGridItem(
                              const BorderRadius.only(
                                  bottomRight: Radius.circular(20)),
                              CustomColors.green200,
                              AppLocalizations.of(context)!
                                  .translate('onclick_aya_modalsheet_bk3')
                                  .toString(),
                              3,
                              bkAya("3")!,
                              Screenheight),
                          returnGridItem(
                              const BorderRadius.only(
                                  bottomLeft: Radius.circular(20)),
                              CustomColors.blue100,
                              AppLocalizations.of(context)!
                                  .translate('onclick_aya_modalsheet_bk4')
                                  .toString(),
                              4,
                              bkAya("4")!,
                              Screenheight),
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
                        'listPlay',
                        viewAudioPlayerController),
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
                        'listPlay',
                        widget.playMoreOptions),
                  ]),
                ),
              ),
              SizedBox(height: 6),
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
                        'listShare',
                        shareController),
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
                        'listCopy',
                        copyClipboard),
                  ]),
                ),
              ),
              // SizedBox(height: 8),

              // ElevatedButton(
              //   child: const Text('Close BottomSheet'),
              //   onPressed: () => Navigator.pop(context),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
