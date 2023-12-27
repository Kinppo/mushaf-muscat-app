import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mushafmuscat/providers/audioplayer_provider.dart';
import 'package:mushafmuscat/providers/ayat_lines_provider.dart';
import 'package:mushafmuscat/providers/daily_aya_provider.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';
import 'package:mushafmuscat/providers/tilawaOptions_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'localization/app_localizations_setup.dart';
import './routes/app_routes.dart';
import '../screens/splash_screen.dart';
import '../themes/app_themes.dart';
import './providers/theme_provider.dart';
import 'providers/bookmarks_provider.dart';
import '../providers/quarter_provider.dart';
import 'dart:async';
import 'models/book_mark.dart';
import 'providers/tafsir_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(BookMarkAdapter());
  // Opening the box
  await Hive.openBox<BookMark>('bookMarks');

  runApp(ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider()..initialize(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TafsirProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DailyAyaProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => tilawaOptions(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AudioPlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AyatLinesProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BookMarks(),
        ),
        ChangeNotifierProvider(
          create: (
            ctx,
          ) =>
              SurahProvider(userQuery: ''),
        ),
        ChangeNotifierProvider(
          create: (ctx) => QuarterProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              title: 'Mushaf Muscat',
              onGenerateRoute: AppRoutes.onGenerateRoute,
              onUnknownRoute: AppRoutes.onUnkownRoute,
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localizationsDelegates:
                  AppLocalizationsSetup.localizationsDelegates,
              locale: const Locale('ar'),
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeProvider.themeMode,
              home: const SplashScreen(),
              // home: QuranScreen(),
            );
          });
        },
      ),
    );
  }
}
