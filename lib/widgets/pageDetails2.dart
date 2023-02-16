import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/models/book_mark.dart';
import 'package:mushafmuscat/providers/bookMarks_provider.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';
import 'package:provider/provider.dart';

import 'package:mushafmuscat/models/pageText.dart';
import '../widgets/finalCarousel2.dart';
import '../models/AyatLines.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/ayatLines_provider.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';

class pageDetails2 extends StatefulWidget {
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
  // bool pageDetails_loadAudios;

// Function togg;

  pageDetails2({
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
  State<pageDetails2> createState() => _pageDetails2State();
}

class _pageDetails2State extends State<pageDetails2> {
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
//new vars
  List<String> audioPaths = [];
  List<Audio> audioList = [];
  final assetsAudioPlayer = AssetsAudioPlayer();
  var bookmarks;

  // int clickedHighlightNum = 0;
  bool firstFlag = false;
  bool clickHighlightWhilePlaying = false;
  int indexhighlighted = 0;
  int storeCurrentPage = 0;

  List<int> pagesThatNeedExtraPadding = [
    600,
    599,
    596,
    595,
    594,
    593,
    592,
    589,
    583,
    582,
    580,
        577,

  ];

  List<int> pagesThatNeedLessSpacing = [
    596,
    595,
    594,
    592,
    591,
    589,
    587,
    585,
    583,
    582,
    580,

  
  ];

 final surahPageswithHeaders = [
    77,
    604,
    599,
    572,
    566,
    598,
    177,
    377,
    411,
    570,
    564,
    558,
    404,
    602,
    428,
    560,
    574,
    549,
    575,
    367,
    415,
    603,
    601,
    359,
    577,
    562,
    589,
    600,
    511,
    262,
    458,
    128,
    499,
    507,
    249,
    467,
    477,
    305,
    502,
    489,
    106,
    312,
    528,
    267,
    515,
    322,
    518,
    531,
    453,
    282,
    255,
    526,
    446,
    293,
    537,
    523,
    496,
    520,
    534,
    332,
    440,
    483,
    396,
    590,
    235,
    553,
    221,
    208,
    585,
    591,
    418,
    342,
    587,
    593,
    578,
    551,
    545,
    592,
    586,
    50,
    151,
    582,
    596,
    568,
    554,
    597,
    583,
    434,
    385,
    187,
    350,
    595,
    556,
    542,
    580,
    594
  ];

  //bookmark variables
  bool bkSamePage = false;
  late Color bkColor;
  late int bkIndex;

  @override
  initState() {
    if (isLoaded == false) {
      print("rebuildingggggg");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await loadTextandBookmarks(widget.currentpage);

        // setState(() {
        //    loadTextandBookmarks(widget.currentpage);
        // });
      });

      // print("audio list for page $widget.id is $audioList");
      // print(audioList.toString());

      //todo:fix this
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
    textlist = await Provider.of<ayatLines_provider>(context, listen: false)
        .getLines(page);
    surahNameList = [];

    surahNameList = await Provider.of<SurahProvider>(context, listen: false)
        .getSurahName(page);

// textlist.forEach((element){
// surahNameList.add(element.surahName);
// });

// print(surahNameList);

    final List<BookMark> bk =
        await Provider.of<BookMarks>(context, listen: false).bookmarks;
    print("bookmarks are: $bk");
    bk.forEach((element) {
      setState(() {
        if (element.pageNum == widget.currentpage) {
          bkSamePage = true;
          bkColor = pickColor(element.type);
          bkIndex = element.highlightNum;
          print("we are in the same page");
          print("BOOKMARK HIGHLIGHT NUM IS $bkIndex");
        }
      });
    });
  }

  didChangeDependencies() {
    final List<BookMark> bk2 =
        Provider.of<BookMarks>(context, listen: true).bookmarks;

    bk2.forEach((element) {
      setState(() {
        if (element.pageNum == widget.currentpage) {
          bkSamePage = true;
          bkColor = pickColor(element.type);
          bkIndex = element.highlightNum;
          print("we are in the same page DIDDDD");
          print("BOOKMARK HIGHLIGHT NUM IS $bkIndex");
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
    //=======
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
// print(surahNameList.toString());

    textlist = Provider.of<ayatLines_provider>(context, listen: false)
        .getLines(widget.id);
    List<String> textl = [];
    textlist.then((value) {
      for (int i = 0; i < value.length; i++) {
        if (i == 0 &&
            value[i].endOfSurah == '1' &&
            value[i + 1].startOfSurah == '1') {
          print("&&&&&&&&&&&&&&&&&");
          textl.add(value[i].text! + '\n\n');
        } else if (value[i].startOfSurah == '1') {
          print("$i  >>>>>>> " +
              value[i].toString() +
              " with height " +
              value[i].height.toString());

          String sPortrait = '';
          String sLandscape = '';

          for (int j = 0; j < value[i].height; j++) {
            sPortrait = sPortrait + '\n';
            if (i < value[i].height - 2) {
              sLandscape = sLandscape + '\n';
            }
          }
          print(sPortrait);

          (isLandscape == false)
              ? textl.add(sPortrait + value[i].text!)
              : textl.add(sLandscape + value[i].text!);
        } else {
          textl.add(value[i].text!);
        }
      }

      fulltext = textl.join('\n\n');
    });

    // print(fulltext);
    if (fulltext == null) {
      return [TextSpan(text: '')];
    }
    fulltext = fulltext!.replaceAll(')', ').');

    splittedList = fulltext!.split(".");

    // splittedList = fulltext!.replaceAll('.', ')');

    // splittedList = (HelperFunctions.splitLinesintoList(fulltext!));
    //=======
    List<String> arrayStrings = splittedList;
    List<TextSpan> arrayOfTextSpan = [];

    // final string = """Text seems like it should be so simple, but it really isn't.""";
    // final arrayStrings = string.split(" ");
    bool tapped = false;

    // arrayOfTextSpan= await AddAyas(arrayStrings);
    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index] + "";
      var intValue = text.replaceAll(RegExp('[^0-9]'), '');
      // print(surahNameList.toString());

      // String singleSurahName =  (SingleSurahList.isNotEmpty) ? SingleSurahList[index].toString(): "unknoen";

      // SingleSurahList[index].toString();
// print(textlist[index]);
      // print("TEXT LENGTH: "+ text.length.toString());
      final span = TextSpan(
          text: text,
          style: TextStyle(
              // wordSpacing:text.length/90,
              background: Paint()..color = Colors.transparent),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                // widget.highlightedAyaText= text;
                // print("The word touched is " + widget.highlightedAyaText.toString());

                highlightFlag = true;
                // print(arrayOfTextSpan);
                int counter = 0;
                arrayOfTextSpan.forEach((element) {
                  if (element.text != null &&
                      element.text != "" &&
                      element.text != '\n') {
                    // String dummy = element.text!;
                    // print("counter=$counter and element is $dummy");
                    if (element.text == text) {
                      idx = counter;
                      // counter = counter + 1;
                    }
                    counter = counter + 1;
                  }
                });

                // idx = arrayStrings
                //     .indexWhere((element) => text ==  element );
                print("highlighted line number  $idx");
                //  intValue = int.parse(text.replaceAll(RegExp('[^0-9]'), ''));
                print("highlighted TEXT IS  " + intValue.toString());
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
      print("HIGHLIGHT FLAG IS CURRENTLY $highlightFlag");
      print("HIGHLIGHT ERRORRRRR $idx and length is :" +
          arrayOfTextSpan.length.toString());

      if (highlightFlag == true &&
          arrayOfTextSpan.length == arrayStrings.length) {
        arrayOfTextSpan[idx].style?.background!.color =
            Colors.brown.withOpacity(0.25);
        // arrayOfTextSpan[idx].style?.background!.
        arrayOfTextSpan[idx].style?.background!.style = PaintingStyle.stroke;
        // arrayOfTextSpan[idx].style?.background!.strokeJoin=StrokeJoin.round;
        // arrayOfTextSpan[idx].style?.background!.strokeCap= StrokeCap.square;

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
        ///====temp and may be disposed later based on the use case
        if (widget.closedBottomSheet == true) {
          // highlightFlag = false;
          widget.closedBottomSheet = false;

          arrayOfTextSpan[idx].style?.background!.color = Colors.transparent;
        }

        ///====
        arrayOfTextSpan[widget.indexhighlight].style?.background!.color =
            Color.fromARGB(255, 223, 223, 66).withOpacity(0.15);

        arrayOfTextSpan[widget.indexhighlight].style?.background!.style =
            PaintingStyle.stroke;

        arrayOfTextSpan[widget.indexhighlight].style?.background!.strokeWidth =
            17.2;
      }
    });

    return arrayOfTextSpan as List<TextSpan>;
  }

  Container? Page1_and2Container() {
    return Container(
      margin: EdgeInsets.fromLTRB(65, 0, 65, 0),
      padding: EdgeInsets.fromLTRB(0, 126, 0, 0),
      child: RichText(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        text: new TextSpan(
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 8,
            color: Colors.red,
            wordSpacing: 1,
            letterSpacing: 0.6,
            height: 1.6,
          ),
          children: createTextSpans(),
        ),
      ),
    );
  }

  Container? AllOtherPagesContainer() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
        margin: (isLandscape == false)
            ? EdgeInsets.fromLTRB(0, 0, 0, 0)
            : EdgeInsets.fromLTRB(0, 110, 0, 0),
        padding:  (isLandscape == false &&(  widget.id==575 || widget.id == 574 || widget.id == 572  || widget.id==568 || widget.id==566 || widget.id==563  || widget.id==564  || widget.id==558  || widget.id==554  ) ) ? EdgeInsets.only(top: 25) :
        pagesThatNeedExtraPadding.contains(widget.id)
            ? EdgeInsets.only(top: 25)
            : (surahPageswithHeaders.contains(widget.id))
                ? EdgeInsets.only(top: 15)
                : EdgeInsets.only(top: 36),
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          textWidthBasis: TextWidthBasis.longestLine,
          text: new TextSpan(
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              fontSize: (isLandscape == false &&
                      (widget.id == 591 || widget.id == 585 || widget.id == 585 || widget.id==568 || widget.id == 566 ))
                  ? 6.0
                  : (isLandscape == false)
                      ? 8
                      : 22,
              color: Colors.red,
              wordSpacing: 2.9,
              letterSpacing: (isLandscape == false &&( widget.id==568  )) ? 1.5 :(isLandscape == false &&( widget.id==577 || widget.id== 575 || widget.id == 562   || widget.id == 560|| widget.id == 558) ) ?1.3 :  (isLandscape == false &&
                      pagesThatNeedLessSpacing.contains(widget.id))
                  ? 1.30
                  : (isLandscape == false)
                      ? 1.7
                      : 2.5,
              height: (isLandscape == false &&
                      (widget.id == 591 || widget.id == 585 ||widget.id == 568 || widget.id == 566 || widget.id == 566 ))
                  ? 3.0
                  : (isLandscape == false)
                      ? 2.3
                      : 1.8,

              // height: 1.68,
            ),
            children: createTextSpans(),
          ),
        ));
  }

  // Container? AllOtherPagesContainer() {
  //   return Container(
  //       padding: EdgeInsets.fromLTRB(12, 53, 6, 0),
  //       child: Expanded(
  //           child: RichText(
  //         textDirection: TextDirection.rtl,
  //         textAlign: TextAlign.justify,
  //         text: new TextSpan(
  //           style: const TextStyle(
  //               fontFamily: 'Amiri',
  //               fontWeight: FontWeight.bold,
  //               fontSize: 13,
  //               color: Colors.brown,
  //               wordSpacing: 2.6,
  //               letterSpacing: 1,
  //               height: 1.25),
  //           children: createTextSpans(),
  //         ),
  //       )));
  // }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start, // <=== try this maybe

            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: (widget.id == 1 || widget.id == 2)
                      ? Page1_and2Container()
                      : AllOtherPagesContainer(),
                ),
              ])
        : CircularProgressIndicator();
  }
}
