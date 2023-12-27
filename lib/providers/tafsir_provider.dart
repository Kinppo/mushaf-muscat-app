import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/helper_functions.dart';

class TafsirLines {
  String? text;
  String? ayaNumber;
  String? pageNumber;
  String? tafsir;

  TafsirLines({
    this.text,
    this.ayaNumber,
    this.pageNumber,
    this.tafsir,
  });
}

class TafsirProvider with ChangeNotifier {
  List<String?> surahs = [];
  List<String?> ayats = [];
  List<String?> tafsirs = [];
  List<String?> carouselJSON = [];
  List<TafsirLines> tafsirLines = [];
  int pageNumber = 0;

  Future<List<TafsirLines>> getLines(pageNum) async {
    final List<TafsirLines> lines = [];
    String data = await rootBundle.loadString(
        'lib/data/json_files/tafsir_files/surahs_tafsir_$pageNum.json');

    var jsonResult = jsonDecode(data);
    for (int index = 0; index < jsonResult.length; index++) {
      lines.add(TafsirLines(
        text: jsonResult[index]['text'],
        ayaNumber: jsonResult[index]['aya'],
        pageNumber: jsonResult[index]['page'],
        tafsir: jsonResult[index]['tafsir'],
      ));
    }

    tafsirLines = lines;
    notifyListeners();
    return tafsirLines;
  }

  void fetchSurahsforCarousel() async {
    var data =
        await rootBundle.loadString('lib/data/json_files/surahs_pages.json');
    var jsonResult = jsonDecode(data);
    for (int index = 0; index < jsonResult.length; index++) {
      carouselJSON.add(HelperFunctions.normalise(jsonResult[index]['surah']));
    }
  }

  List<String?> loadSurahs() {
    fetchSurahsforCarousel();
    return carouselJSON;
  }
}
