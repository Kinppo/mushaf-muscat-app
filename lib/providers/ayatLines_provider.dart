import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/AyatLines.dart';

import '../utils/helperFunctions.dart';

class ayatLines_provider with ChangeNotifier {
  bool firstlist = true;
  List<AyatLines> ayat_lines = [];

  List<int> listofnum = [];
  List<List<AyatLines>> lis2 = [];

  int pageNumber = 0;

Future<List<AyatLines>> getLines(pageNum) async {
// print(pageNum);

    listofnum.add(pageNum);

    pageNumber = pageNum;
    final List<AyatLines> lines = [];

    String data = await rootBundle
        .loadString('lib/data/json_files/Ayat_pages/$pageNum.json');

    var jsonResult = jsonDecode(data);

    for (int index = 0; index < jsonResult.length; index++) {
      lines.add(AyatLines(
        text: jsonResult[index]['line'],
        pageNumber: pageNum,
      ));
    }

    ayat_lines = lines;

    notifyListeners();

    return ayat_lines;
  }

  List<AyatLines> get text {
    return [...ayat_lines];
  }
}
