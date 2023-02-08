import 'dart:convert';
import 'dart:core';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/AyatLines.dart';

import '../utils/helperFunctions.dart';

class ayatLines_provider with ChangeNotifier {
  bool firstlist = true;
  List<AyatLines> ayat_lines = [];
  List<String> surahnames = [];
  List<int> listofnum = [];

  int pageNumber = 0;

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
        startOfSurah: jsonResult[index]['StartOfSurah'],
        height: jsonResult[index]['height'],


      ));
    }

    ayat_lines = lines;

    notifyListeners();

    return ayat_lines;
  }

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