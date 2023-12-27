import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/aya_lines.dart';
import '../utils/helperFunctions.dart';

class AyatLinesProvider with ChangeNotifier {
  bool firstlist = true;
  List<AyatLines> ayatLines = [];
  List<String> surahnames = [];
  List<int> listofnum = [];

  int pageNumber = 0;

  Future<List<AyatLines>> getLines(pageNum) async {
    listofnum.add(pageNum);
    pageNumber = pageNum;
    final List<AyatLines> lines = [];

    String data = await rootBundle.loadString(
        'lib/data/json_files/quran_lines/surahs_word_$pageNum.json');

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
    ayatLines = lines;
    notifyListeners();
    return ayatLines;
  }

  List<AyatLines> get text {
    return [...ayatLines];
  }

  List<AyatLines> get numbers {
    return [...ayatLines];
  }

  Future<int?> getSplit(int chosenAya, List<AyatLines> ayats, String surahFrom,
      List<String> surahList) async {
    int idx = 0;
    List<String> textl = [];
    String fulltext;
    List<String> splittedList = [];
    for (var item in ayats) {
      textl.add(item.text!);
    }
    fulltext = textl.join('\n\n');
    fulltext = fulltext.replaceAll(')', ').');
    splittedList = fulltext.split(".");

    for (int index = 0; index < splittedList.length; index++) {
      String t = splittedList[index];
      var intValue = t.replaceAll(RegExp('[^0-9]'), '');
      if (HelperFunctions.removeAllDiacritics(surahList[index]) ==
              HelperFunctions.removeAllDiacritics(surahFrom) &&
          intValue == chosenAya.toString()) {
        idx = index;
        return index;
      }
    }
    return idx;
  }

  Future<int?> getAya(int page, int chosenAya, String surahFrom) async {
    String data2 = await rootBundle
        .loadString('lib/data/json_files/quran_lines/surahs_word_$page.json');
    List<AyatLines> ayats = [];

    var jsonResult2 = jsonDecode(data2);
    for (int index = 0; index < jsonResult2.length; index++) {
      ayats.add(
        AyatLines(
          text: jsonResult2[index]['text'],
          surahName: jsonResult2[index]['SurahName'],
        ),
      );
    }

    final surahlistt =
        await rootBundle.loadString('lib/data/json_files/allayapages.json');
    var jsonResultallaya = jsonDecode(surahlistt);
    List<String> surahList = [];
    for (var x in jsonResultallaya) {
      if (x['page'] == page.toString()) {
        surahList.add(x['surah']);
      }
    }

    int? ind = await getSplit(chosenAya, ayats, surahFrom, surahList);
    return ind ?? 0;
  }
}
