import 'dart:convert';
import 'dart:core';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/AyatLines.dart';
import 'package:mushafmuscat/screens/ayah_screen.dart';

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

  Future<int?> getSplit(int chosenAya, List<AyatLines> ayats, String surahFrom, List<String> surahList) async {
  // Future<int?> getSplit(int chosenAya, List<AyatLines> ayats) async {
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
    print(">>>>>>>>>>suraaaah from  <<<<<<<<<<<<<< " +surahFrom.toString());
//  for (int j = 0; j < splittedList.length; j++) {
//       print("ayaaaaaaaaaaaa $j " +splittedList[j]); }
    for (int index = 0; index < splittedList.length; index++) {
      // print("ayaaaaaaaaaaaa $index " +splittedList[index]);
      String t = splittedList[index] + "";
      var intValue = t.replaceAll(RegExp('[^0-9]'), '');
      print("VALUE IS $intValue and chosen is $chosenAya");
      if (HelperFunctions.removeAllDiacritics(surahList[index]) == HelperFunctions.removeAllDiacritics(surahFrom)  && intValue == chosenAya.toString()) {
        print("WE ARE IN $intValue");

        idx = index;
        return index;
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

  Future<int?> getAya(int page, int chosenAya, String surahFrom) async {
    // print("CHOSEN AYA is $chosenAya");
    String data2 = await rootBundle
        .loadString('lib/data/json_files/quran_lines/surahs_word_$page.json');
    List<AyatLines> ayats = [];

//     bool first = false;
    var jsonResult2 = jsonDecode(data2);
    for (int index = 0; index < jsonResult2.length; index++) {
      ayats.add(AyatLines(text: jsonResult2[index]['text'],
surahName: jsonResult2[index]['SurahName'],
      // pageNumber: jsonResult2[index]['page'],
      ),
      );
    }
final surahlistt = await rootBundle
        .loadString('lib/data/json_files/allayapages.json');
    var jsonResultallaya = jsonDecode(surahlistt);
    List<String> surahList=[];
    for (var x in jsonResultallaya) {
if (x['page']==page.toString()){
  // print("mbbbbbbbbbbbbbbbb");
  surahList.add(x['surah']);
      // print(x['surah']);
}
    }

    int? ind = await getSplit(chosenAya, ayats, surahFrom, surahList);
    return ind != null ? ind : 0;
  }
}
