import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';
import '../utils/helper_functions.dart';

GeneralAya welcomeFromJson(String str) => GeneralAya.fromJson(json.decode(str));

class GeneralAya {
  String surah;
  String aya;
  String page;
  String text;
  int index;

  GeneralAya(
      {required this.surah,
      required this.aya,
      required this.page,
      required this.text,
      required this.index});

  factory GeneralAya.fromJsonUndiac(Map<String, dynamic> json) => GeneralAya(
      surah: HelperFunctions.removeAllDiacritics(json["surah"])!,
      aya: json["aya"],
      page: json["page"],
      text: HelperFunctions.removeAllDiacritics(json["text"])!,
      index: json['index']);

  factory GeneralAya.fromJson(Map<String, dynamic> json) => GeneralAya(
      surah: json["surah"]!,
      aya: json["aya"],
      page: json["page"],
      text: json["text"]!,
      index: json['index']);
}

class SurahProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<GeneralAya> _generalAyasList = [];
  List<GeneralAya> _generalAyasListUndiac = [];
  List<String?> carouselJSON = [];
  List<List<int>> flagsForEndofSurah = [];
  List<List<String?>> ayaNum = [];
  String userQuery;
  late int numParam;

  SurahProvider({required this.userQuery});

  Future<void> fetchSurahs() async {
    String data = await rootBundle.loadString('lib/data/json_files/surah.json');
    var jsonResult = jsonDecode(data);
    if (jsonResult == null) {
      return;
    }

    final List<Surah> loadedSurahs = [];
    jsonResult['data'].forEach((data) => loadedSurahs.add(Surah(
          surahNum: data['number'],
          surahPageNum: data['first_page_num'],
          surahTitle: HelperFunctions.normalise(data['name']),
          surahType: data['revelationType'],
          numOfAyas: data['numberOfAyahs'],
        )));
    loadAllAyasJson();
    _surahs = loadedSurahs;
    notifyListeners();
  }

  List<Surah> get surahs {
    return [..._surahs];
  }

  List<GeneralAya> get ayaas {
    return [..._generalAyasList];
  }

  List<GeneralAya> get undiacAyaas {
    return [..._generalAyasListUndiac];
  }

  List<Surah> getSeachResults(userQuery) {
    List<Surah> matches = [];
    String? query = HelperFunctions.removeAllDiacritics(userQuery);
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
    List<GeneralAya> foundSurahs = [];
    foundSurahs.addAll(_generalAyasList);
    foundSurahs
        .retainWhere((element) => element.page.toString() == page.toString());
    List<String> surahString = [];

    for (var item in foundSurahs) {
      surahString.add(item.surah);
    }
    return surahString;
  }

  Future<void> loadAllAyasJson() async {
    var data2 =
        await rootBundle.loadString('lib/data/json_files/allayapages.json');
    final parsed = jsonDecode(data2).cast<Map<String, dynamic>>();

    final welcome =
        parsed.map<GeneralAya>((json) => GeneralAya.fromJson(json)).toList();

    var data3 = await rootBundle
        .loadString('lib/data/json_files/undiac_allayapages.json');
    final parsed3 = jsonDecode(data3).cast<Map<String, dynamic>>();

    final welcomeUndiac = parsed3
        .map<GeneralAya>((json) => GeneralAya.fromJsonUndiac(json))
        .toList();

    _generalAyasList = welcome;
    _generalAyasListUndiac = welcomeUndiac;

    notifyListeners();
  }

  List<Surah> getSeachResultsAppbar(userQuery) {
    List<Surah> matches = [];
    String? query = HelperFunctions.removeAllDiacritics(userQuery);
    matches.addAll(_surahs);
    matches.retainWhere((surah) =>
        (HelperFunctions.removeAllDiacritics(surah.surahTitle))!
            .contains(query!) ||
        ((HelperFunctions.removeAllDiacritics(surah.surahTitle!)))!
            .endsWith(query));
    return matches;
  }

  List<GeneralAya> getAyaSeachResultsAppbar(userQuery) {
    List<GeneralAya> matches = [];
    String? query = HelperFunctions.removeAllDiacritics(userQuery);
    matches.addAll(_generalAyasListUndiac);

    matches.retainWhere((aya) =>
        (aya.text).contains(query!) ||
        (aya.text).startsWith(query) ||
        (aya.text).endsWith(query));

    List<GeneralAya> matchesDiac = [];
    List<int> indices = [];

    for (var mtch in matches) {
      matchesDiac.add(_generalAyasList[mtch.index]);
      indices.add(mtch.index);
    }

    return matchesDiac;
  }

  List<String?> loadSurahs() {
    fetchSurahsforCarousel();

    return carouselJSON;
  }

  List<List<int>> loadFlags() {
    return flagsForEndofSurah;
  }

  List<List<String?>> loadAyaNum() {
    return ayaNum;
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
      ayaNum.add(tempList2);
      tempList = [];
      tempList2 = [];
    }
  }
}
