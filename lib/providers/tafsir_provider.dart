import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';

class TafsirProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<Surah> _undiacritizedSurahList = [];
  List <String?> carouselJSON =[];
 List<List<int>>  flagsForEndofSurah =[];
  List<List<String?>>AyaNum=[];
  String user_query;
  late int num_param;

  TafsirProvider({required this.user_query});

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

    // _undiacritizedSurahList.forEach((surah) {
    //   surah.surahTitle == HelperFunctions.removeAllDiacritics(surah.surahTitle);
    // });

    //   print("UNDIAC");
    
    //  print(_undiacritizedSurahList);

    notifyListeners();
  }

  List<Surah> get surahs {
    return [..._surahs];
  }


//todo: fix function based on new database that will be provided
  List<Surah> getSurahName(num_param) {
    List<Surah> nameMatch = [];
    nameMatch.addAll(_undiacritizedSurahList);

    nameMatch.retainWhere((surah) =>
    //THIS LINE SHOULD BE FIXED
        // (int.parse(surah.surahNum!)==num_param) 
        (num_param-1 < int.parse(surah.surahNum!))
            );

            //print(matches);
            return nameMatch;
  }


  List<Surah> getSeachResults(user_query) {
    List<Surah> matches = [];
    String ? query= HelperFunctions.removeAllDiacritics(user_query);
    matches.addAll(_undiacritizedSurahList);

    matches.retainWhere((surah) =>
        (HelperFunctions.removeAllDiacritics((surah.surahTitle))!.contains(query!)) 
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


List<String?>loadSurahs()  {
  fetchSurahsforCarousel();
 
return carouselJSON;
   
 }

  List<List<int>> loadFlags()  {
          // print(flagsForEndofSurah[4]);

return flagsForEndofSurah;
   
 }

List<List<String?>> loadAyaNum()  {
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
tempList2.add(HelperFunctions.convertToArabicNumbers(jsonResult2[index]['aya']));

      }
      
      flagsForEndofSurah.add(tempList);
      AyaNum.add(tempList2);
      tempList = [];
      tempList2 = [];

    }
    // print(flagsForEndofSurah[603]);
 }
 }