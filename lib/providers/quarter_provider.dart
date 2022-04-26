import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/quarter.dart';

import '../utils/helperFunctions.dart';

class QuarterProvider with ChangeNotifier {


  List<Quarter> _quarters = [];


  Future<void> fetchQuarters() async {
    String data =
        await rootBundle.loadString('lib/data/json_files/quarter.json');
    //String convertedData = convertToArabicNumbers(data);

    // String convertedData = HelperFunctions.convertToArabicNumbers(data);
     var jsonResult = jsonDecode(data);

    
//print(jsonResult);
    //print (jsonResult['data']);

    if (jsonResult == null) {
      print("result is null");
      return;
    }

    final List<Quarter> loadedQuarters = [];
    // print("reached here");

    jsonResult['data'].forEach((data) =>
            //convert data to product objects

            //  print(data['name'])
            loadedQuarters.add(Quarter(
              startingJuzzIndex: data['startingJuzzIndex'],
              startingHizbIndex: data['startingHizbIndex'],
              quarter: data['quarter'],
              hizbNum: data['hizbNum'],
              surahTitle: data['surahTitle'],
              startingAya: data['startingAya'],
              juzz: data['juzz'],
              quarterAyaNum: data['quarterAyaNum'],
              quarterPageNum: data['quarterPageNum'],
            ))
        // );

        );

    _quarters = loadedQuarters;
    notifyListeners();
  }

  List<Quarter> get quarters {

    return [..._quarters];
  }
}
