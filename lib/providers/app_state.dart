import 'package:flutter/material.dart';


class AppProvider extends ChangeNotifier {
  // String currentTheme = 'light';
  int controller =0;

   void updateSearchController(int value) {
     controller=value;
     notifyListeners();
   }

  get Getcontroller {
     return controller;

   }
  
}
