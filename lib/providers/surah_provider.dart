import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';

generalAya welcomeFromJson(String str) => generalAya.fromJson(json.decode(str));

class generalAya {
  String surah;
  String aya;
  String page;
  String text;
  int index;

  generalAya(
      {required this.surah,
      required this.aya,
      required this.page,
      required this.text,
      required this.index});

  factory generalAya.fromJsonUndiac(Map<String, dynamic> json) => generalAya(
      surah: HelperFunctions.removeAllDiacritics(json["surah"])!,
      aya: json["aya"],
      page: json["page"],
      text: HelperFunctions.removeAllDiacritics(json["text"])!,
      index: json['index']);

  factory generalAya.fromJson(Map<String, dynamic> json) => generalAya(
      surah: json["surah"]!,
      aya: json["aya"],
      page: json["page"],
      text: json["text"]!,
      index: json['index']);
}

class SurahProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<generalAya> _generalAyasList = [];
  List<generalAya> _generalAyasList_undiac = [];
  List<String?> carouselJSON = [];
  List<List<int>> flagsForEndofSurah = [];
  List<List<String?>> AyaNum = [];
  String user_query;
  late int num_param;

  SurahProvider({required this.user_query});

  Future<void> fetchSurahs() async {
    String data = await rootBundle.loadString('lib/data/json_files/surah.json');

    var jsonResult = jsonDecode(data);

    if (jsonResult == null) {
      return;
    }

    final List<Surah> loadedSurahs = [];

    jsonResult['data'].forEach((data) =>
            //convert data to product objects
            loadedSurahs.add(Surah(
              surahNum: data['number'],
              surahPageNum: data['first_page_num'],
              surahTitle: HelperFunctions.normalise(data['name']),
              surahType: data['revelationType'],
              numOfAyas: data['numberOfAyahs'],
            ))
        // );

        );
    loadAllAyasJson();
    _surahs = loadedSurahs;

    notifyListeners();
  }

  List<Surah> get surahs {
    return [..._surahs];
  }

  List<generalAya> get ayaas {
    return [..._generalAyasList];
  }

  List<generalAya> get UndiacAyaas {
    return [..._generalAyasList_undiac];
  }

  List<Surah> getSeachResults(user_query) {
    List<Surah> matches = [];
    String? query = HelperFunctions.removeAllDiacritics(user_query);
    matches.addAll(_surahs);

    matches.retainWhere((surah) =>
        (HelperFunctions.removeAllDiacritics((surah.surahTitle))!
            .contains(query!)) ||
        ((surah.surahTitle!.substring(2)).startsWith(query)) ||
        (HelperFunctions.removeAllDiacritics(surah.surahTitle!)!
            .endsWith(query)));

    return matches;
  }

  Future<List<String>> getSurahName(page) async {
    List<generalAya> FoundSurahs = [];
    FoundSurahs.addAll(_generalAyasList);
    FoundSurahs.retainWhere(
        (element) => element.page.toString() == page.toString());
    List<String> SurahString = [];
    FoundSurahs.forEach((element) {
      SurahString.add(element.surah);
    });

    return SurahString;
  }

  Future<void> loadAllAyasJson() async {
    Stopwatch stopwatch = new Stopwatch()..start();

    var data2 =
        await rootBundle.loadString('lib/data/json_files/allayapages.json');
    final parsed = jsonDecode(data2).cast<Map<String, dynamic>>();

    final welcome =
        parsed.map<generalAya>((json) => generalAya.fromJson(json)).toList();

    var data3 = await rootBundle
        .loadString('lib/data/json_files/undiac_allayapages.json');
    final parsed3 = jsonDecode(data3).cast<Map<String, dynamic>>();

    final welcome_undiac = parsed3
        .map<generalAya>((json) => generalAya.fromJsonUndiac(json))
        .toList();

    _generalAyasList = welcome;
    _generalAyasList_undiac = welcome_undiac;

    notifyListeners();
  }

  List<Surah> getSeachResults_appbar(user_query) {
    // if (_surahs.isEmpty) {
    //   fetchSurahs();
    // }

    List<Surah> matches = [];

    String? query = HelperFunctions.removeAllDiacritics(user_query);

    matches.addAll(_surahs);

    matches.retainWhere((surah) =>
        (HelperFunctions.removeAllDiacritics(surah.surahTitle))!
            .contains(query!) ||
        // ((HelperFunctions.removeAllDiacritics(surah.surahTitle))!.substring(2).startsWith(query)) ||

        ((HelperFunctions.removeAllDiacritics(surah.surahTitle!)))!
            .endsWith(query));

    return matches;
  }

  List<generalAya> getAyaSeachResults_appbar(user_query) {
    // if (_generalAyasList.isEmpty) {
    //   loadAllAyasJson();
    // }

    List<generalAya> matches = [];
    String? query = HelperFunctions.removeAllDiacritics(user_query);
    matches.addAll(_generalAyasList_undiac);

    matches.retainWhere((aya) =>
        (aya.text)!.contains(query!) ||
        (aya.text)!.startsWith(query) ||
        (aya.text)!.endsWith(query));

    List<generalAya> matches_diac = [];
    List<int> indices = [];

    for (var mtch in matches) {
      matches_diac.add(_generalAyasList[mtch.index]);
      indices.add(mtch.index);
    }

    return matches_diac;
  }

  List<String?> loadSurahs() {
    fetchSurahsforCarousel();

    return carouselJSON;
  }

  List<List<int>> loadFlags() {
    return flagsForEndofSurah;
  }

  List<List<String?>> loadAyaNum() {
    return AyaNum;
  }

  void fetchSurahsforCarousel() async {
    var data =
        await rootBundle.loadString('lib/data/json_files/surahs_pages.json');
    var jsonResult = jsonDecode(data);

    for (int index = 0; index < jsonResult.length; index++) {
      carouselJSON.add(HelperFunctions.normalise(jsonResult[index]['surah']));
    }
    for (int i = 1; i <= jsonResult.length; i++) {
      List<int> tempList = [];
      List<String?> tempList2 = [];
      String flgs = await rootBundle
          .loadString('lib/data/json_files/quran_lines/surahs_word_$i.json');

      var jsonResult2 = jsonDecode(flgs);

      for (int index = 0; index < jsonResult2.length; index++) {
        tempList.add(int.parse(jsonResult2[index]['EndOfSurah']));
        tempList2.add(
            HelperFunctions.convertToArabicNumbers(jsonResult2[index]['aya']));
      }

      flagsForEndofSurah.add(tempList);
      AyaNum.add(tempList2);
      tempList = [];
      tempList2 = [];
    }
  }
}
