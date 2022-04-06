import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
      primaryColor: HexColor('#e3d8cc'),
      scaffoldBackgroundColor: HexColor('#241c15'),
      accentColor: HexColor('#c7beb5'),
      buttonColor: HexColor('#ffffff'),
      textSelectionColor: HexColor('#db0f00'),
      secondaryHeaderColor: HexColor('#948779'),
      fontFamily: "IBMPlexSansArabic",
      backgroundColor: HexColor('#f5efe9'),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 18,
            fontFamily: "IBMPlexSansArabic",
            fontWeight: FontWeight.w200),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'IBMPlexSansArabic'),
      ));

  static final ThemeData darkTheme = ThemeData();
}
