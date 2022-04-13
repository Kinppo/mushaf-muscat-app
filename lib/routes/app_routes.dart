import 'package:flutter/material.dart';
import 'package:mushafmuscat/screens/book_marks_screen.dart';

import '../screens/ayah_screen.dart';
import '../screens/quran_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/unknown_screen.dart';

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case QuranScreen.routeName:
        return MaterialPageRoute(builder: (_) => QuranScreen());
        break;
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => SplashScreen());
        break;
      case BookMarksScreen.routeName:
        return MaterialPageRoute(builder: (_) => BookMarksScreen());
        break;
      case AyahScreen.routeName:
        return MaterialPageRoute(builder: (_) => AyahScreen());
        break;
      case SettingScreen.routeName:
        return MaterialPageRoute(builder: (_) => SettingScreen());
        break;
      default:
        return null;
    }
  }

  static Route onUnkownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => UnknownScreen());
  }
}
