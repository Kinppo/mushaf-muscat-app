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

  generalAya(
      {required this.surah,
      required this.aya,
      required this.page,
      required this.text});

  factory generalAya.fromJson(Map<String, dynamic> json) => generalAya(
        surah: json["surah"],
        aya: json["aya"],
        page: json["page"],
        text: json["text"],
      );
}

class SurahProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<Surah> _undiacritizedSurahList = [];
  List<generalAya> _generalAyasList = [];

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
      print("result is null");
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

    _surahs = loadedSurahs;
    // _undiacritizedSurahList = loadedSurahs;

   loadedSurahs.forEach((element) {
      _undiacritizedSurahList.add(Surah(
              surahNum: element.surahNum,
              surahPageNum: element.surahPageNum,
              surahTitle: HelperFunctions.removeAllDiacritics(element.surahTitle),
              surahType: element.surahType,
              numOfAyas: element.numOfAyas,
            ));

            // print(_undiacritizedSurahList);

   });

    notifyListeners();
  }

  List<Surah> get surahs {
    return [..._surahs];
  }

  List<Surah> get undiac_Surahs {
    return [..._undiacritizedSurahList];
  }

  List<generalAya> get ayaas {
    return [..._generalAyasList];
  }

  List<Surah> getSeachResults(user_query) {
    List<Surah> matches = [];
    // print("USER QUERY: $user_query");
    String? query = HelperFunctions.removeAllDiacritics(user_query);
    matches.addAll(_undiacritizedSurahList);

    matches.retainWhere((surah) =>
        (HelperFunctions.removeAllDiacritics((surah.surahTitle))!
            .contains(query!)) ||
        ((surah.surahTitle!.substring(2)).startsWith(query)) ||
        (HelperFunctions.removeAllDiacritics(surah.surahTitle!)!
            .endsWith(query)));

    // print(matches);
    return matches;
  }

  Future<void> loadAllAyasJson() async {
// if (_undiacritizedSurahList.isEmpty) {
//   loadSurahs();
// }

// var data= await generalAya.fromJson();
    Stopwatch stopwatch = new Stopwatch()..start();

    print("*********LOADED AYASSSSS*************");
    // var pdfText= await json.decode('lib/data/json_files/allayapages.json');
    var data2 =
        await rootBundle.loadString('lib/data/json_files/allayapages.json');
    final parsed = jsonDecode(data2).cast<Map<String, dynamic>>();

// Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(data2));
// print(data2);

    final welcome =
        parsed.map<generalAya>((json) => generalAya.fromJson(json)).toList();
// print(welcome[1].surah);
// print(welcome);
    print('doSomething() executed in ${stopwatch.elapsed}');

// var insertEventInstance = InsertEvent();

// print("*************** LENGTH IS: " + welcome.aya.length.toString());
//       final List<generalAya> loadedAyas = [];

//     String data2 = await rootBundle.loadString('lib/data/json_files/allayapages.json');
//         var jsonResult2 = jsonDecode(data2);
//         if (jsonResult2 == null) {
//       print("result is null");
//       return;
//     }

//      jsonResult2.forEach((data) =>
//             //convert data to product objects

//             //  print(data['name'])
//             loadedAyas.add(generalAya(
//               aya: data['aya'],
//               text: data['text'],
//               page:data['page'],
//               surah: data['surah'],
//             ))
//         // );

//         );
    _generalAyasList = welcome;

    notifyListeners();
  }

  List<Surah> getSeachResults_appbar(user_query) {
    if (_undiacritizedSurahList.isEmpty) {
      fetchSurahs();
      // print(_undiacritizedSurahList.toString());


    }
    print(undiac_Surahs.toList().toString());
List <Surah> m= [];
undiac_Surahs.forEach((element) {
  print(element.surahTitle);
});

// print(_undiacritizedSurahList.length);
    List<Surah> matches = [];
    // print("USER QUERY: $user_query");
    String? query = HelperFunctions.removeAllDiacritics(user_query);
    // matches.addAll(_undiacritizedSurahList);

    // for (var item in _undiacritizedSurahList) {
    //   if (HelperFunctions.removeAllDiacritics((item.surahTitle))!.contains(query!)) {
    //     matches.add(item);
    //   }
    // }
    matches.retainWhere((surah) =>
        (HelperFunctions.removeAllDiacritics((surah.surahTitle))!
            .contains(query!)) 
        ||
        (surah.surahTitle!.startsWith(query)) 
        ||
        (HelperFunctions.removeAllDiacritics(surah.surahTitle!)!
            .endsWith(query)));

    // print(matches);
    return matches;
  }

  List<generalAya> getAyaSeachResults_appbar(user_query) {
    if (_generalAyasList.isEmpty) {
      loadAllAyasJson();
    }
// print(_generalAyasList);

    List<generalAya> matches = [];
    String? query = HelperFunctions.removeAllDiacritics(user_query);
    matches.addAll(_generalAyasList);

    print("guery $query");
// print("aya " + _generalAyasList[1].text);

// if (query == _generalAyasList[1].text[0]) {
//   print("SURAH FATIHA");
// }
    matches.retainWhere((aya) =>
        (HelperFunctions.removeAllDiacritics((aya.text))!.contains(query!)) 
        ||

        ((HelperFunctions.removeAllDiacritics((aya.text))!)
            .startsWith(query)) 
            ||

        (HelperFunctions.removeAllDiacritics(aya.text!)!.endsWith(query)));

    // print(matches);
  
    return matches;
  }

  List<String?> loadSurahs() {
    fetchSurahsforCarousel();

    return carouselJSON;
  }

  List<List<int>> loadFlags() {
    // print(flagsForEndofSurah[4]);

    return flagsForEndofSurah;
  }

  List<List<String?>> loadAyaNum() {
    // print(flagsForEndofSurah[2]);
    return AyaNum;
  }

  void fetchSurahsforCarousel() async {
    var data =
        await rootBundle.loadString('lib/data/json_files/surahs_pages.json');
    var jsonResult = jsonDecode(data);
    // print(jsonResult);

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
    // print(flagsForEndofSurah[603]);
  }
}
