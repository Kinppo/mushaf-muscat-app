import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/models/book_mark.dart';
import 'package:mushafmuscat/providers/bookmarks_provider.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';
import 'package:provider/provider.dart';
import '../providers/ayat_lines_provider.dart';
import '../resources/colors.dart';
import '../utils/manual_lists.dart';

class PageDetails2 extends StatefulWidget {
  int id;
  int indexhighlight;
  int currentpage;
  bool ayaFlag;
  Function toggleClickedHighlight;
  int clickedHighlightNum;
  bool firstFlag;
  int prev;
  bool closedBottomSheet;
  List<String> ayaNumsforThePage;

  PageDetails2({
    Key? key,
    required this.id,
    required this.indexhighlight,
    required this.currentpage,
    required this.ayaFlag,
    required this.toggleClickedHighlight,
    required this.clickedHighlightNum,
    required this.firstFlag,
    required this.prev,
    required this.closedBottomSheet,
    required this.ayaNumsforThePage,
  }) : super(key: key);

  @override
  State<PageDetails2> createState() => _PageDetails2State();
}

class _PageDetails2State extends State<PageDetails2> {
  String? fulltext;
  bool flag = false;
  List<String> splittedList = [''];
  late bool isLoaded = false;
  var textlist;
  String tempText = '';
  bool highlightFlag = false;
  int idx = 0;
  bool clickedListen = false;
  int textsize = 0;
  List<String> surahNameList = [];
  List<String> audioPaths = [];
  List<Audio> audioList = [];
  final assetsAudioPlayer = AssetsAudioPlayer();
  var bookmarks;
  bool firstFlag = false;
  bool clickHighlightWhilePlaying = false;
  int indexhighlighted = 0;
  int storeCurrentPage = 0;
  final surahPageswithHeaders = ManualLists().surahPageswithHeaders;
  final pagesThatNeedExtraPadding = ManualLists().pagesThatNeedExtraPadding;
  final pagesThatNeedSpacing_small = ManualLists().pagesThatNeedSpacingSmall;
  final pagesThatNeedSpacing_medium = ManualLists().pagesThatNeedSpacingMedium;
  final pagesThatNeedSmallerFont = ManualLists().pagesThatNeedSmallerFont;
  final pagesThatNeedLessHeight = ManualLists().pagesThatNeedLessHeight;

  //bookmark variables
  bool bkSamePage = false;
  late Color bkColor;
  late int bkIndex;

  @override
  initState() {
    if (isLoaded == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await loadTextandBookmarks(widget.currentpage);
      });
      isLoaded = true;
    }
    super.initState();
  }

  Color pickColor(String type) {
    switch (type) {
      case '1':
        return CustomColors.yellow400;
      case '2':
        return CustomColors.pink100;
      case '3':
        return CustomColors.green200;
      case '4':
        return CustomColors.blue100;
      default:
        return Colors.transparent;
    }
  }

  Future<void> loadTextandBookmarks(int page) async {
    textlist = await Provider.of<AyatLinesProvider>(context, listen: false)
        .getLines(page);
    surahNameList = [];

    surahNameList = await Provider.of<SurahProvider>(context, listen: false)
        .getSurahName(page);

    final List<BookMark> bk =
        Provider.of<BookMarks>(context, listen: false).bookmarks;
    bk.forEach((element) {
      setState(() {
        if (element.pageNum == widget.currentpage) {
          bkSamePage = true;
          bkColor = pickColor(element.type);
          bkIndex = element.highlightNum;
        }
      });
    });
  }

  @override
  didChangeDependencies() {
    final List<BookMark> bk2 =
        Provider.of<BookMarks>(context, listen: true).bookmarks;

    bk2.forEach((element) {
      setState(() {
        if (element.pageNum == widget.currentpage) {
          bkSamePage = true;
          bkColor = pickColor(element.type);
          bkIndex = element.highlightNum;
        }
      });
    });

    super.didChangeDependencies();
  }

  List<TextSpan> createTextSpans() {
    if (widget.currentpage != widget.id) {
      setState(() {
        widget.indexhighlight = -1;
      });
    }
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    textlist = Provider.of<AyatLinesProvider>(context, listen: false)
        .getLines(widget.id);
    List<String> textl = [];
    textlist.then((value) {
      for (int i = 0; i < value.length; i++) {
        if (i == 0 &&
            value[i].endOfSurah == '1' &&
            value[i + 1].startOfSurah == '1') {
          textl.add(value[i].text! + '\n\n');
        } else if (value[i].startOfSurah == '1') {
          String sPortrait = '';
          String sLandscape = '';

          for (int j = 0; j < value[i].height; j++) {
            sPortrait = '$sPortrait\n';
            if (i < value[i].height - 2) {
              sLandscape = '$sLandscape\n';
            }
          }

          (isLandscape == false)
              ? textl.add(sPortrait + value[i].text!)
              : textl.add(sLandscape + value[i].text!);
        } else {
          textl.add(value[i].text!);
        }
      }

      fulltext = textl.join('\n\n');
    });

    if (fulltext == null) {
      return [const TextSpan(text: '')];
    }
    fulltext = fulltext!.replaceAll(')', ').');
    splittedList = fulltext!.split(".");

    List<String> arrayStrings = splittedList;
    List<TextSpan> arrayOfTextSpan = [];

    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index];
      var intValue = text.replaceAll(RegExp('[^0-9]'), '');

      final span = TextSpan(
          text: text,
          style: TextStyle(background: Paint()..color = Colors.transparent),
          recognizer: DoubleTapGestureRecognizer()
            ..onDoubleTap = () {
              setState(() {
                highlightFlag = true;
                int counter = 0;
                arrayOfTextSpan.forEach((element) {
                  if (element.text != null &&
                      element.text != "" &&
                      element.text != '\n') {
                    if (element.text == text) {
                      idx = counter;
                    }
                    counter = counter + 1;
                  }
                });
                widget.clickedHighlightNum = idx + 1;
                widget.toggleClickedHighlight(
                    idx + 1, intValue.toString(), text, surahNameList[idx]);
              });
            });

      if (index == 0) {
        widget.ayaNumsforThePage.clear();
      }
      widget.ayaNumsforThePage.add(intValue);
      arrayOfTextSpan.add(span);
    }

    setState(() {
      if (highlightFlag == true &&
          arrayOfTextSpan.length == arrayStrings.length) {
        arrayOfTextSpan[idx].style?.background!.color =
            Colors.brown.withOpacity(0.25);
        arrayOfTextSpan[idx].style?.background!.style = PaintingStyle.stroke;
        arrayOfTextSpan[idx].style?.background!.strokeWidth = 17.2;
        highlightFlag = false;
      }
    });

    if (bkSamePage == true) {
      arrayOfTextSpan[bkIndex].style?.background!.color =
          bkColor.withOpacity(0.25);
      arrayOfTextSpan[bkIndex].style?.background!.style = PaintingStyle.stroke;
      arrayOfTextSpan[bkIndex].style?.background!.strokeWidth = 17.2;
    }

    setState(() {
      if (widget.currentpage == widget.prev &&
          widget.ayaFlag != false &&
          arrayStrings[0] != "") {
        if (widget.closedBottomSheet == true) {
          widget.closedBottomSheet = false;
          arrayOfTextSpan[idx].style?.background!.color = Colors.transparent;
        }
        arrayOfTextSpan[widget.indexhighlight].style?.background!.color =
            const Color.fromARGB(255, 223, 223, 66).withOpacity(0.15);
        arrayOfTextSpan[widget.indexhighlight].style?.background!.style =
            PaintingStyle.stroke;
        arrayOfTextSpan[widget.indexhighlight].style?.background!.strokeWidth =
            17.2;
      }
    });
    setState(() {});
    return arrayOfTextSpan;
  }

  Container? page1And2Container() {
    return Container(
      margin: (widget.id == 1)
          ? const EdgeInsets.fromLTRB(0, 105, 0, 0)
          : const EdgeInsets.fromLTRB(0, 145, 0, 0),
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: RichText(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 8,
            color: Colors.transparent,
            wordSpacing: 2.9,
            letterSpacing: (widget.id == 1) ? 2.2 : 1.5,
            height: 2.2,
          ),
          children: createTextSpans(),
        ),
      ),
    );
  }

  Container? allOtherPagesContainer() {
    final screenheight = MediaQuery.of(context).size.height;

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
        margin: (isLandscape == false)
            ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
            : const EdgeInsets.fromLTRB(0, 110, 0, 0),
        padding: (isLandscape == false &&
                (widget.id == 597 ||
                    widget.id == 586 ||
                    widget.id == 578 ||
                    widget.id == 578 ||
                    widget.id == 458 ||
                    widget.id == 453 ||
                    widget.id == 404 ||
                    widget.id == 350 ||
                    widget.id == 585 ||
                    widget.id == 587 ||
                    widget.id == 590 ||
                    widget.id == 518 ||
                    widget.id == 322 ||
                    widget.id == 570 ||
                    widget.id == 377))
            ? const EdgeInsets.only(top: 25)
            : pagesThatNeedExtraPadding.contains(widget.id)
                ? const EdgeInsets.only(top: 25)
                : (surahPageswithHeaders.contains(widget.id))
                    ? const EdgeInsets.only(top: 15)
                    : const EdgeInsets.only(top: 36),
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          textWidthBasis: TextWidthBasis.longestLine,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              fontSize: (isLandscape == false &&
                      (widget.id == 507 || widget.id == 499))
                  ? 6
                  : (isLandscape == false && (widget.id == 597))
                      ? 6.8
                      : (isLandscape == false &&
                              pagesThatNeedSmallerFont.contains(widget.id))
                          ? 6.0
                          : (isLandscape == false)
                              ? 8
                              : 22,
              color: Colors.transparent,
              wordSpacing: 2.9,
              letterSpacing: (isLandscape == false &&
                      (widget.id == 499 ||
                          widget.id == 404 ||
                          widget.id == 415))
                  ? 1.5
                  : (isLandscape == false &&
                          (widget.id == 597 ||
                              widget.id == 578 ||
                              widget.id == 526 ||
                              widget.id == 507 ||
                              widget.id == 453 ||
                              widget.id == 418 ||
                              widget.id == 570 ||
                              widget.id == 377))
                      ? 1.3
                      : (isLandscape == false &&
                              pagesThatNeedSpacing_medium.contains(widget.id))
                          ? 1.5
                          : (isLandscape == false &&
                                  pagesThatNeedSpacing_small
                                      .contains(widget.id))
                              ? 1.30
                              : (isLandscape == false)
                                  ? 1.7
                                  : 2.5,
              height: (isLandscape == false &&
                      (widget.id == 507 || widget.id == 499))
                  ? 3.0
                  : (isLandscape == false && (widget.id == 597))
                      ? 2.6
                      : (isLandscape == false &&
                              pagesThatNeedLessHeight.contains(widget.id))
                          ? 3.0
                          : (isLandscape == false)
                              // ? 2.3
                              ? screenheight > 800
                                  ? screenheight * 0.0027
                                  : screenheight > 700
                                      ? screenheight * 0.0033
                                      : screenheight * 0.0033
                              : 1.7,
            ),
            children: createTextSpans(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
              alignment: Alignment.centerRight,
              child: (widget.id == 1 || widget.id == 2)
                  ? page1And2Container()
                  : allOtherPagesContainer(),
            ),
          ])
        : const CircularProgressIndicator();
  }
}
