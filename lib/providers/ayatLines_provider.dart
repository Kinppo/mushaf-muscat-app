import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/AyatLines.dart';

import '../utils/helperFunctions.dart';

class ayatLines_provider with ChangeNotifier {
  List<AyatLines> ayat_lines = [];

  // int pageid;


  Future<void> fetchPageText() async {

    final List<AyatLines> loadedTexts = [];
    // print("reached here");

    for(  int i = 1 ; i <= 3; i++ ) { 
          String data = await rootBundle.loadString('lib/data/json_files/Ayat_pages/$i.json');

var jsonResult = jsonDecode(data);

    //print (jsonResult['data']);

    if (jsonResult == null) {
      print("result is null");
      return;
    }

    print("ENTERED");
    print(jsonResult);

    jsonResult.forEach((data) =>
            //convert data to product objects

            //  print(data['name'])
            loadedTexts.add(AyatLines(
              text: data['line'],
             
            ))
        // );

        );
     


   }  
    
  

    ayat_lines = loadedTexts;
    print("AYAT LINES");
   print(ayat_lines);


    notifyListeners();
  }

  List<AyatLines> get text {
    return [...ayat_lines];
  }




}