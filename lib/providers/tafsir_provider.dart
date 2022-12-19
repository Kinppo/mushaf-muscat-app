import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';

class TafsirProvider with ChangeNotifier {
    List <String?> surahs =[];

  List <String?> ayats =[];
    List <String?> tafsirs =[];
  List <String?> carouselJSON =[];



  Future<void> fetchSurahs(int page) async {
 ayats =[];
     tafsirs =[];
    String data = await rootBundle.loadString('lib/data/json_files/tafsir_files/surahs_tafsir_$page.json');

    var jsonResult = jsonDecode(data);

    //print (jsonResult['data']);

    if (jsonResult == null) {
      print("result is null");
      return;
    }

    final List<Surah> loadedSurahs = [];
    // print("reached here");

    jsonResult.forEach((data) {
            //convert data to product objects
            // print(data)
          ayats.add(data['text']);
           tafsirs.add(data['tafsir']);

    }
        );

    
    notifyListeners();
  }

  void fetchSurahsforCarousel() async {
    
 var data =
        await rootBundle.loadString('lib/data/json_files/surahs_pages.json');
    var jsonResult = jsonDecode(data);
    // print(jsonResult);

    for (int index = 0; index < jsonResult.length; index++) {
      carouselJSON.add(HelperFunctions.normalise(jsonResult[index]['surah']));
    }
//   for (int i = 1; i <= jsonResult.length; i++) {
//       List<int> tempList = [];
//        List<String?> tempList2 = [];
//       String flgs = await rootBundle
//           .loadString('lib/data/json_files/quran_lines/surahs_word_$i.json');

//       var jsonResult2 = jsonDecode(flgs);

//       for (int index = 0; index < jsonResult2.length; index++) {
// tempList2.add(HelperFunctions.convertToArabicNumbers(jsonResult2[index]['aya']));

//       }
      
//       tempList2 = [];

    // }
 }

 List<String?>loadSurahs()  {
  fetchSurahsforCarousel();
 
return carouselJSON;
   
 }
 }









 
 