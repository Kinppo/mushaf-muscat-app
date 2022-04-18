import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/setting_about.dart';
import '../widgets/setting_appearance.dart';
import '../widgets/setting_storage.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static const routeName = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BNavigationBar(
          pageIndex: 3,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('setting_screen_title')
                        .toString(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SettingAppearance(),
                const SettingStorage(),
                SettingAbout(),
              ]),
            )));
  }
}
