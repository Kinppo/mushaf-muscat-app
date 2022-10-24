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

    String data = await rootBundle
        .loadString('lib/data/json_files/quran_lines/surahs_word_$pageNum.json');

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

    notifyListeners();

    return ayat_lines;
  }

  List<AyatLines> get text {
    return [...ayat_lines];
  }

   List<AyatLines> get numbers {
    return [...ayat_lines];
  }
}
