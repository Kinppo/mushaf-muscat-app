import 'dart:convert';
import 'dart:core';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/surah.dart';

import '../utils/helperFunctions.dart';

class tilawaOptions with ChangeNotifier {
  List<Surah> _surahs = [];
  List<List<String?>>AyaNum=[];
   List<String>AyasList=[];
   List<String>SurahsList=[];

  late int num_param;


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

_surahs.forEach((element) {
    SurahsList.add(element.surahTitle.toString());
    AyasList.add(element.numOfAyas.toString());
}
);


    
    notifyListeners();
  }

 
 List<Surah> get surahs {
    return [..._surahs];
  }


  Future<List<String>> fetchSurahList() async { 
List<String> surahList=[];

_surahs.forEach((element) {
  surahList.add(element.surahTitle.toString());
});
return surahList;

 }

 List<String> getAyaList(int index) {
// print("i am in provider");
  List<String> listNum=[];
  int num= int.parse(_surahs[index].numOfAyas!) ;
  listNum = new List<String>.generate(num, (i) => '$i');
  
  return listNum;
 }
  
  
 }