import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';



class generalAya {
  String surah;
  String aya;
  String page;
  String text;

generalAya({
    required this.surah,
    required this.aya,
    required this.page,
    required this.text
  });
}


class SurahProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<Surah> _undiacritizedSurahList = [];
    List<generalAya> _generalAyasList = [];

  List <String?> carouselJSON =[];
 List<List<int>>  flagsForEndofSurah =[];
  List<List<String?>>AyaNum=[];
  String user_query;
  late int num_param;

  SurahProvider({required this.user_query});

  Future<void> fetchSurahs() async {
    String data = await rootBundle.loadString('lib/data/json_files/surah.json');
    
    //for aya search
    String data2 = await rootBundle.loadString('lib/data/json_files/allayapages.json');

    //String convertedData = convertToArabicNumbers(data);
// String convertedData = HelperFunctions.convertToArabicNumbers(data);
//  var jsonResult = jsonDecode(convertedData);

    var jsonResult = jsonDecode(data);
        var jsonResult2 = jsonDecode(data2);


    //print (jsonResult['data']);

    if (jsonResult == null) {
      print("result is null");
      return;
    }
    

    if (jsonResult2 == null) {
      print("result is null");
      return;
    }

    final List<Surah> loadedSurahs = [];

    final List<generalAya> loadedAyas = [];

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
        
 jsonResult2.forEach((data) =>
            //convert data to product objects

            //  print(data['name'])
            loadedAyas.add(generalAya(
              aya: data['aya'],
              text: data['text'],
              page:data['page'],
              surah: data['surah'],
            ))
        // );

        );
    _surahs = loadedSurahs;
    _undiacritizedSurahList = loadedSurahs;
    _generalAyasList= loadedAyas;

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




  List<Surah> getSeachResults(user_query) {

    List<Surah> matches = [];
    print("USER QUERY: $user_query");
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

            print(matches);
            return matches;
  }

  List<Surah> getSeachResults_appbar(user_query) {
if (_undiacritizedSurahList.isEmpty) {
      fetchSurahs();
}
print(_undiacritizedSurahList.length);
    List<Surah> matches = [];
    print("USER QUERY: $user_query");
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

            print(matches);
            return matches;
  }



  List<generalAya> getAyaSeachResults_appbar(user_query) {
if (_generalAyasList.isEmpty) {
      fetchSurahs();
}
    List<generalAya> matches = [];
    String ? query= HelperFunctions.removeAllDiacritics(user_query);
    matches.addAll(_generalAyasList);

    matches.retainWhere((aya) =>
        (HelperFunctions.removeAllDiacritics((aya.text))!.contains(query!)) 
        ||

        ((HelperFunctions.removeAllDiacritics((aya.text))!.substring(2))
            .startsWith(query)) 
            ||
        (HelperFunctions.removeAllDiacritics(aya.text!)!
            .endsWith(query))
            );

            print(matches);
            matches.forEach((element) {print(element.text);});
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