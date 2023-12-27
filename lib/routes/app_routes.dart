import 'package:flutter/material.dart';
import '../screens/about_app_screen.dart';
import '../screens/book_marks_screen.dart';
import '../screens/ayah_screen.dart';
import '../screens/quran_screen.dart';
import '../screens/setting_appearance_screen.dart';
import '../screens/setting_quran_view_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/unknown_screen.dart';

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case QuranScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => QuranScreen(), settings: settings);
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case BookMarksScreen.routeName:
        return MaterialPageRoute(builder: (_) => BookMarksScreen());
      case AyahScreen.routeName:
        return MaterialPageRoute(builder: (_) => AyahScreen());
      case SettingScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      case SettingQuranViewScreen.routeName:
        return MaterialPageRoute(builder: (_) => SettingQuranViewScreen());
      case SettingAppearanceScreen.routeName:
        return MaterialPageRoute(builder: (_) => SettingAppearanceScreen());
      case AboutAppScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AboutAppScreen());
      default:
        return null;
    }
  }

  static Route onUnkownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => const UnknownScreen());
  }
}
