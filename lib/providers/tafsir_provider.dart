import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';

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

  List<TafsirLines> tafsir_lines = [];

  int pageNumber = 0;

  Future<List<TafsirLines>> getLines(pageNum) async {
    final List<TafsirLines> lines = [];

    String data = await rootBundle.loadString(
        'lib/data/json_files/tafsir_files/surahs_tafsir_$pageNum.json');

    // .loadString('lib/data/json_files/Ayat_pages/$pageNum.json');

    var jsonResult = jsonDecode(data);
    for (int index = 0; index < jsonResult.length; index++) {
      lines.add(TafsirLines(
        text: jsonResult[index]['text'],
        ayaNumber: jsonResult[index]['aya'],
        pageNumber: jsonResult[index]['page'],
        tafsir: jsonResult[index]['tafsir'],
      ));
    }

    tafsir_lines = lines;

    notifyListeners();

    return tafsir_lines;
  }

//   Future<void> fetchSurahs(int page) async {
//  ayats.clear();
//      tafsirs.clear();
//     String data = await rootBundle.loadString('lib/data/json_files/tafsir_files/surahs_tafsir_$page.json');

//     var jsonResult = jsonDecode(data);

//     if (jsonResult == null) {
//       return;
//     }

//     final List<Surah> loadedSurahs = [];

//     jsonResult.forEach((data) {
//           ayats.add(data['text']);
//            tafsirs.add(data['tafsir']);

//     }
//         );

//     notifyListeners();
//   }

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
