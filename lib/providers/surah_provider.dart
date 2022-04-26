import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';

class SurahProvider with ChangeNotifier  {


List<Surah> _surahs = [];



 Future<void> fetchSurahs() async {
 String data = await rootBundle.loadString('lib/data/json_files/surah.json');
 //String convertedData = convertToArabicNumbers(data);

String convertedData = HelperFunctions.convertToArabicNumbers(data);
 var jsonResult = jsonDecode(convertedData);


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
           surahTitle: data['name'],
          surahType: data['revelationType'],
          numOfAyas: data['numberOfAyahs'],
         ))
      // );

      );

      _surahs = loadedSurahs;
     
     
      notifyListeners();
 }
      



List<Surah> get surahs {
    
    return [..._surahs];
  }

}