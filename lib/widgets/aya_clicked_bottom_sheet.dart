import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bookmarks_provider.dart';
import 'package:mushafmuscat/localization/app_localizations.dart';
import '../resources/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class AyaClickedBottomSheet extends StatefulWidget {
  final Function showAudioPlayer;
  final int clickedHighlightNum;
  final int currentPage;
  final String surahName;
  final String ayaNum;
  final String highlightedAyaText;
  final Function playMoreOptions;

  const AyaClickedBottomSheet({
    super.key,
    required this.showAudioPlayer,
    required this.clickedHighlightNum,
    required this.currentPage,
    required this.surahName,
    required this.ayaNum,
    required this.highlightedAyaText,
    required this.playMoreOptions,
  });

  @override
  State<AyaClickedBottomSheet> createState() => _AyaClickedBottomSheetState();
}

class _AyaClickedBottomSheetState extends State<AyaClickedBottomSheet> {
  List<IconData> bkIconsList = [
    Icons.bookmark_border_outlined,
    Icons.bookmark_border_outlined,
    Icons.bookmark_border_outlined,
    Icons.bookmark_border_outlined
  ];

  void viewAudioPlayerController() {
    setState(() {
      widget.showAudioPlayer();
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
          .showSnackBar(const SnackBar(content: Text("تم نسخ الآية!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final bookMarkProvider = Provider.of<BookMarks>(context, listen: false);

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
        int type, String bkAya, double screenheight2) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: rad,
        ),
        child: Row(
          children: [
            IconButton(
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
                  setState(() {
                    getIcon(type);
                  });
                },
                icon: (bookMarkProvider.checkBookmark(type.toString()) == true)
                    ? const Icon(Icons.bookmark)
                    : const Icon(Icons.bookmark_border_outlined),
                color: bkColor),
            Padding(
              padding: EdgeInsets.only(top: screenheight2 * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الفاصل $bkText",
                    style:
                        TextStyle(fontSize: 16, color: CustomColors.black200),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    (bkAya != '') ? "الآية: $bkAya" : "",
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
              : SvgPicture.asset("assets/images/$path.svg",
                  width: 30, height: 30, fit: BoxFit.fitWidth),
          title: Text(listText,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenheight * 0.01),
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
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        physics: const NeverScrollableScrollPhysics(),
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
                              screenheight),
                          returnGridItem(
                              const BorderRadius.only(
                                  topLeft: Radius.circular(20)),
                              CustomColors.pink100,
                              AppLocalizations.of(context)!
                                  .translate('onclick_aya_modalsheet_bk2')
                                  .toString(),
                              2,
                              bkAya("2")!,
                              screenheight),
                          returnGridItem(
                              const BorderRadius.only(
                                  bottomRight: Radius.circular(20)),
                              CustomColors.green200,
                              AppLocalizations.of(context)!
                                  .translate('onclick_aya_modalsheet_bk3')
                                  .toString(),
                              3,
                              bkAya("3")!,
                              screenheight),
                          returnGridItem(
                              const BorderRadius.only(
                                  bottomLeft: Radius.circular(20)),
                              CustomColors.blue100,
                              AppLocalizations.of(context)!
                                  .translate('onclick_aya_modalsheet_bk4')
                                  .toString(),
                              4,
                              bkAya("4")!,
                              screenheight),
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
              const SizedBox(height: 6),
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
            ],
          ),
        ),
      ),
    );
  }
}
