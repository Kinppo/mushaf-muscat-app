import 'dart:convert';
import 'dart:core';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/AyatLines.dart';

import '../utils/helperFunctions.dart';

class ayatLines_provider with ChangeNotifier {
  ayatLines_provider() : super();

  bool firstlist = false;
  List<AyatLines> ayat_lines = [];
  List<String> surahnames = [];
  List<int> listofnum = [];

  int pageNumber = 0;
  ayatLines_provider.instance();

//new variables
  List<TextSpan> text_spans = [];
  bool highlightFlag = false;
  int idx = -1;

  bool _listenableValue2 = false;
  bool get listenableValue2 => _listenableValue2;
  List<TextSpan> _listenableValue = [];
  List<TextSpan> get listenableValue => _listenableValue;
  String intVAL='';
  String ayaText='';
  List<String> ProvsplittedList = [];
  //  void setValue(){
  //     _listenableValue =  getSpans(1) as List<TextSpan>;
  //     notifyListeners();
  //  }
  void toggHighlight() {
    highlightFlag = false;
  }

  Future<List<AyatLines>> getLines(pageNum) async {
// print(pageNum);

    listofnum.add(pageNum);

    pageNumber = pageNum;
    final List<AyatLines> lines = [];

    String data = await rootBundle.loadString(
        'lib/data/json_files/quran_lines/surahs_word_$pageNum.json');

    // .loadString('lib/data/json_files/Ayat_pages/$pageNum.json');

    var jsonResult = jsonDecode(data);
    for (int index = 0; index < jsonResult.length; index++) {
      lines.add(AyatLines(
        text: jsonResult[index]['text'],
        endOfSurah: jsonResult[index]['EndOfSurah'],
        surahName: jsonResult[index]['SurahName'],
        pageNumber: pageNum,
        aya: jsonResult[index]['aya'],
      ));
    }

    ayat_lines = lines;
    // print(ayat_lines);

    firstlist = true;

    await getSplittedList(pageNum);
    notifyListeners();

    return ayat_lines;
  }

//==============================
  Future<void> getSplittedList(pageNum) async {
    String fulltext = '';
    List<String> splittedList = [];

    if (firstlist == true) {
      List<String> textl = [];

      for (int i = 0; i < ayat_lines.length; i++) {
        if (ayat_lines[i].endOfSurah == '1' && i != ayat_lines.length - 1) {
          textl.add(ayat_lines[i].text! + '\n\n\n\n');
        } else {
          textl.add(ayat_lines[i].text!);
        }
      }

      fulltext = textl.join('\n\n');

      // print(ayat_lines);
    }
// if (fulltext == null) {
//       return [TextSpan(text: '')];
//     }
    fulltext = fulltext!.replaceAll(')', ').');

    splittedList = fulltext!.split(".");

    ProvsplittedList = splittedList;
  }

  // Future<List<TextSpan>> getSpans(pageNum) async {
  Future<void> setValue() async {
// ayat_lines = await getLines(1);

    final arrayStrings = ProvsplittedList;
    final List<TextSpan> arrayOfTextSpan = [];

    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index] + "";
      var intValue = text.replaceAll(RegExp('[^0-9]'), '');
      intVAL=intValue.toString();
      // print("TEXT LENGTH: "+ text.length.toString());
      final span = TextSpan(
          text: text,
          style: TextStyle(
              // wordSpacing:text.length/90,
              background: Paint()..color = Colors.transparent),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print("touched");
              // setState(() {
              // widget.highlightedAyaText= text;
              // print("The word touched is " + widget.highlightedAyaText.toString());

              highlightFlag = true;
              idx =
                  arrayOfTextSpan.indexWhere((element) => element.text == text);
              print("highlighted line number  $idx");
              notifyListeners();
ayaText=text;

              //  intValue = int.parse(text.replaceAll(RegExp('[^0-9]'), ''));
              // print("highlighted TEXT IS  " + intValue.toString());
              // widget.clickedHighlightNum = idx + 1;
              // widget.toggleClickedHighlight(
              // idx + 1, intValue.toString(), text);
              // });
              setValue();
            });

      // if (index==0) {
      //  widget.ayaNumsforThePage.clear();
      // }
      // widget.ayaNumsforThePage.add(intValue);

      arrayOfTextSpan.add(span);
    }

    if (highlightFlag == true) {
      arrayOfTextSpan[idx].style?.background!.color =
          Colors.brown.withOpacity(0.25);
      arrayOfTextSpan[idx].style?.background!.strokeWidth = 8.9;
    }
    print("TRUE TRUE TRUE");
    print(ProvsplittedList);
    _listenableValue = arrayOfTextSpan;
    notifyListeners();

    // return arrayOfTextSpan;
  }

//==============================

  List<AyatLines> get text {
    return [...ayat_lines];
  }

  List<AyatLines> get numbers {
    return [...ayat_lines];
  }

  Future<int?> getSplit(int chosenAya, List<AyatLines> ayats) async {
    int idx = 0;
    List<String> textl = [];
    String fulltext;
    List<String> splittedList = [];

    ayats.forEach((element) {
      textl.add(element.text!);
    });
    fulltext = textl.join('\n\n');
    fulltext = fulltext.replaceAll(')', ').');
    List<int> ayaNums = [];
    splittedList = fulltext.split(".");
    print(splittedList);
    for (int index = 0; index < splittedList.length; index++) {
      String t = splittedList[index] + "";
      var intValue = t.replaceAll(RegExp('[^0-9]'), '');
      print("VALUE IS $intValue and chosen is $chosenAya");
      if (intValue == chosenAya.toString()) {
        print("WE ARE IN $intValue");
        idx = index;
      }
// ayaNums.add(int.parse(intValue));
//     //  int idx = splittedList
//     //                 .indexWhere((element) => element.text == text);
//     //  }
    }
// // int idx= ayaNums.indexWhere((element) => element. == 2);
    print("INTVALUE IS $idx");
    return idx;
// print("INDEXXXXXXXX IS " +ayaNums.toString() );
  }

  Future<int?> getAya(int page, int chosenAya) async {
    // print("CHOSEN AYA is $chosenAya");
    String data2 = await rootBundle
        .loadString('lib/data/json_files/quran_lines/surahs_word_$page.json');
    List<AyatLines> ayats = [];

//     bool first = false;
    var jsonResult2 = jsonDecode(data2);
    for (int index = 0; index < jsonResult2.length; index++) {
      ayats.add(AyatLines(text: jsonResult2[index]['text']));
    }

    int? ind = await getSplit(chosenAya, ayats);
    return ind != null ? ind : 0;

// print("-------CHOSEN AYA----- $chosenAya");
// print("-------CHOSEN PAGE---- $page");

//     for (int index = 0; index < jsonResult2.length; index++) {
//       if (first == false && jsonResult2[index]['aya'] == chosenAya.toString()) {
//         first=true;
//         print("-------CHOSEN INDEX----- $index");

//         return index;
//       }
//     }
//     return 0;
  }
}
