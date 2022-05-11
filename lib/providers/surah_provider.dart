import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';

class SurahProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<Surah> _undiacritizedSurahList = [];

  String user_query;

  SurahProvider({required this.user_query});

  Future<void> fetchSurahs() async {
    String data = await rootBundle.loadString('lib/data/json_files/surah.json');

    //String convertedData = convertToArabicNumbers(data);
// String convertedData = HelperFunctions.convertToArabicNumbers(data);
//  var jsonResult = jsonDecode(convertedData);

    var jsonResult = jsonDecode(data);

    //print (jsonResult['data']);

    if (jsonResult == null) {
      print("result is null");
      return;
    }

    final List<Surah> loadedSurahs = [];
    // print("reached here");

    jsonResult['data'].forEach((data) =>
            //convert data to product objects

            //  print(data['name'])
            loadedSurahs.add(Surah(
              surahNum: data['number'],
              surahPageNum: data['first_page_num'],
              surahTitle: HelperFunctions.normalise(data['name']),
              surahType: data['revelationType'],
              numOfAyas: data['numberOfAyahs'],
            ))
        // );

        );

    _surahs = loadedSurahs;
    _undiacritizedSurahList = loadedSurahs;

    _undiacritizedSurahList.forEach((surah) {
      surah.surahTitle == HelperFunctions.removeAllDiacritics(surah.surahTitle);
    });

    //   print("UNDIAC");
    
    //  print(_undiacritizedSurahList);

    notifyListeners();
  }

  List<Surah> get surahs {
    return [..._surahs];
  }



  List<Surah> getSeachResults(user_query) {
    List<Surah> matches = [];
    String ? query= HelperFunctions.removeAllDiacritics(user_query);
    matches.addAll(_undiacritizedSurahList);

    matches.retainWhere((surah) =>
        ((surah.surahTitle)!.contains(query!)) 
        ||

        ((surah.surahTitle!.substring(2))
            .startsWith(query)) 
            ||
        (HelperFunctions.removeAllDiacritics(surah.surahTitle!)!
            .endsWith(query))
            );

            //print(matches);
            return matches;
  }
}
