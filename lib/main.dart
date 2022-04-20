import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'localization/app_localizations_setup.dart';

import './routes/app_routes.dart';
import '../screens/splash_screen.dart';
import '../themes/app_themes.dart';
import './providers/theme_provider.dart';
import '../providers/bookMarks_provider.dart';

//temp
import './screens/quran_screen.dart';
import 'dart:async';

import 'models/book_mark.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(BookMarkAdapter());
  // Opening the box
  await Hive.openBox<BookMark>('bookMarks');

  runApp(ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider()..initialize(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => BookMarks(),
          ),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              onGenerateRoute: AppRoutes.onGenerateRoute,
              onUnknownRoute: AppRoutes.onUnkownRoute,
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localizationsDelegates:
                  AppLocalizationsSetup.localizationsDelegates,
              locale: const Locale('ar'),
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeProvider.themeMode,
              //home: const SplashScreen(),
              home: QuranScreen(),
            );
          },
        ));
  }
}
