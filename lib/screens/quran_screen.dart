import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class QuranScreen extends StatelessWidget {
  static const routeName = '/quran';
  const QuranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quran screen"),
      ),
      body: Text(
          AppLocalizations.of(context)!.translate('app_bar_title').toString()),
    );
  }
}
