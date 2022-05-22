import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/AyatLines.dart';

import '../utils/helperFunctions.dart';

class ayatLines_provider with ChangeNotifier {
  List<AyatLines> ayat_lines = [];
   int page_num ;

  // int pageid;

  ayatLines_provider( this.page_num);

//   Future<void> fetchPageText(page_num) async {

//     final List<AyatLines> loadedTexts = [];
//     // print("reached here");

   
//     String data = await rootBundle.loadString('lib/data/json_files/Ayat_pages/$page_num.json');

// var jsonResult = jsonDecode(data);

//     //print (jsonResult['data']);

//     if (jsonResult == null) {
//       print("result is null");
//       return;
//     }

//     print("ENTERED");
//     print(jsonResult);

//     jsonResult.forEach((data) =>
//             //convert data to product objects

//             //  print(data['name'])
//             loadedTexts.add(AyatLines(
//               text: data['line'],
             
//             ))
//         // )

//         );

   
  
  

//     ayat_lines = loadedTexts;
//     print("AYAT LINES");
//    print(ayat_lines);


//     notifyListeners();
//   }

  
   Future <List<AyatLines>>  getLines(pageNum) async {

    final List<AyatLines> lines = [];
    // print("reached here");

   
    String data =  await rootBundle.loadString('lib/data/json_files/Ayat_pages/$pageNum.json') ;

var jsonResult = jsonDecode(data);

    //print (jsonResult['data']);

    

    //print("ENTERED");
    //print(jsonResult);

    jsonResult.forEach((data) =>
            //convert data to product objects

            //  print(data['name'])
            lines.add(AyatLines(
              text: data['line'],
             
            ))
        // )

        );

   
  
  

    ayat_lines = lines;
  
    notifyListeners();
    return [...ayat_lines];
  }

  List<AyatLines> get text {
    return [...ayat_lines];
  }




}