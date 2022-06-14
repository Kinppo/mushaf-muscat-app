import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/pageText.dart';

import '../utils/helperFunctions.dart';

class PageText_provider with ChangeNotifier {
  List<PageText> page_texts = [];

  // int pageid;


  Future<void> fetchPageText() async {


    

    final List<PageText> loadedTexts = [];
    // print("reached here");

    for(  int i = 1 ; i <= 5; i++ ) { 
          String data = await rootBundle.loadString('lib/data/json_files/json_pages/quran_page_$i.json');

var jsonResult = jsonDecode(data);

    //print (jsonResult['data']);

    if (jsonResult == null) {
      print("result is null");
      return;
    }

    print("ENTERED");
    print(jsonResult);

    jsonResult['data'].forEach((data) =>
            //convert data to product objects

            //  print(data['name'])
            loadedTexts.add(PageText(
              id: int.parse(data['id']),
              page: int.parse(data['page']),
              line: int.parse(data['line']),
              position: int.parse(data['position']),
              text: data['text'],
            ))
        // );

        );
     


   }  
    
 

    page_texts = loadedTexts;
   

    

    notifyListeners();
  }

  List<PageText> get text {
    return [...page_texts];
  }



}