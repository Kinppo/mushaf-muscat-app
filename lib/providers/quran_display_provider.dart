import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quarter.dart';
import '../models/page.dart' as pg;


//import '../utils/helperFunctions.dart';

class QuranDisplay with ChangeNotifier {


  List<pg.Page> loadedpages = [];

 List<pg.Page> pages = [
    pg.Page(
      pageNum: 1,
      PNGimagePath: "assets/quran_images/8.png",
    ) ];

  Future<void> fetchImages() async {
    

    // if (jsonResult == null) {
    //   print("image path is null");
    //   return;
    // }

    final List<pg.Page> fillPages = [];


   for(  int i = 1 ; i <= 604; i++ ) { 
     fillPages.add(pg.Page(pageNum: i , PNGimagePath:"assets/quran_images/8.png"));
   }  
    
    print(fillPages.length);
    // print("reached here");

  //   jsonResult['data'].forEach((data) =>


  //       );
 
   loadedpages = fillPages;
   notifyListeners();
  // }
 }
  List<pg.Page> get imageslist {

    return [...loadedpages];
  }
}
