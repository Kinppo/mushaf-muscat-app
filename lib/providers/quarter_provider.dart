import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/quarter.dart';

import '../utils/helperFunctions.dart';

//import '../utils/helperFunctions.dart';

class QuarterProvider with ChangeNotifier {
  List<Quarter> _quarters = [];

  int Counter = 0;

  Future<void> fetchQuarters() async {
    String data = await rootBundle
        .loadString('lib/data/json_files/quarters_updated.json');
    //String convertedData = convertToArabicNumbers(data);

    // String convertedData = HelperFunctions.convertToArabicNumbers(data);
    var jsonResult = jsonDecode(data);

    if (jsonResult == null) {
      return;
    }

    final List<Quarter> loadedQuarters = [];
    jsonResult['data'].forEach((data) =>
        //convert data to product objects

        loadedQuarters.add(Quarter(
          startingJuzzIndex: trueorfalse(data['startingJuzzIndex']),
          startingHizbIndex: trueorfalse(data['startingHizbIndex']),
          quarter: updated_quarter(int.parse(data['rub'])),
          hizbNum: HelperFunctions.convertToArabicNumbers(data['hezb']),
          surahTitle: HelperFunctions.normalise(data['surahTitle']),
          startingAya: (data['text']),
          juzz: convertToArabicOrdinal(int.parse(data['juz'])),
          quarterAyaNum:
              HelperFunctions.convertToArabicNumbers(data['quarterAyaNum']),
          quarterPageNum: HelperFunctions.convertToArabicNumbers(data['page']),
        )));

    _quarters = loadedQuarters;
    notifyListeners();
  }

  int updated_quarter(int quarter) {
    Counter = Counter + 1;

    int updatedQ = Counter;

    if (Counter == 4) {
      Counter = 0;
    }

    return updatedQ;
  }

// Convert 0 and 1 values to boolean values
  bool trueorfalse(String value) {
    if (value == "1") {
      return true;
    } else {
      return false;
    }
  }

// Convert Juzz numbers to arabic ordinal literals
  String? convertToArabicOrdinal(int num) {
    Map<int, String> specialNums = {
      1: "الأول",
      10: "العاشر",
    };

    Map<int, String> lastDigits = {
      10: "عشر",
      20: "العشرون",
      30: "الثلاثون",
      40: "الأربعون",
      50: "الخمسون",
      60: "الستون",
      70: "السبعون",
      80: "الثمانون",
      90: "التسعون",
    };

    Map<int, String> firstDigits = {
      1: "الحادي",
      2: "الثاني",
      3: "الثالث",
      4: "الرابع",
      5: "الخامس",
      6: "السادس",
      7: "السابع",
      8: "الثامن",
      9: "التاسع",
    };

    if (specialNums[num] != null) {
      return specialNums[num];
    }

    if (firstDigits[num] != null) {
      return firstDigits[num];
    }
    if (lastDigits[num] != null) {
      return lastDigits[num];
    }

    double firstDigit = num % 10;
    double lastDigit = num - firstDigit;

    if (lastDigit < 20) {
      return firstDigits[firstDigit]! + " " + lastDigits[lastDigit]!;
    }

    String? out = firstDigits[firstDigit]! + " و";

    out = out + lastDigits[lastDigit]!;
    return out;
  }

// return list of quarters
  List<Quarter> get quarters {
    return [..._quarters];
  }
}
