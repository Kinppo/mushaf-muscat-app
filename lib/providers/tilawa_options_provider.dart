import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';
import '../utils/helper_functions.dart';

class tilawaOptions with ChangeNotifier {
  List<Surah> _surahs = [];
  List<List<String?>> AyaNum = [];
  List<String> AyasList = [];
  List<String> SurahsList = [];
  var loadedjson2;
  bool loaded = false;
  late int num_param;

  Future<void> fetchSurahs() async {
    if (SurahsList.isEmpty) {
      String data =
          await rootBundle.loadString('lib/data/json_files/surah.json');
      var jsonResult = jsonDecode(data);
      if (jsonResult == null) {
        return;
      }
      loadedjson2 = jsonDecode(
          await rootBundle.loadString('lib/data/json_files/allayapages.json'));

      final List<Surah> loadedSurahs = [];

      jsonResult['data'].forEach((data) => loadedSurahs.add(Surah(
            surahNum: data['number'],
            surahPageNum: data['first_page_num'],
            surahTitle: HelperFunctions.normalise(data['name']),
            surahType: data['revelationType'],
            numOfAyas: data['numberOfAyahs'],
          )));

      _surahs = loadedSurahs;

      _surahs.forEach((element) {
        SurahsList.add(element.surahTitle.toString());
        AyasList.add(element.numOfAyas.toString());
      });
    }
    notifyListeners();
  }

  List<Surah> get surahs {
    return [..._surahs];
  }

  Future<List<String>> fetchSurahList() async {
    List<String> surahList = [];

    _surahs.forEach((element) {
      surahList.add(element.surahTitle.toString());
    });
    return surahList;
  }

  List<String> getAyaList(int index) {
    List<String> listNum = [];
    int num = int.parse(_surahs[index].numOfAyas!);
    listNum = List<String>.generate(num, (i) => (i + 1).toString());

    return listNum;
  }

  Future<int> getPageNumber(String name, String aya) async {
    var val = loadedjson2.firstWhere(
        (item) =>
            HelperFunctions.normalise(item['surah']) ==
                HelperFunctions.normalise(name) &&
            item['aya'] == aya,
        orElse: () => 1);
    return int.parse(val['page']);
  }
}
