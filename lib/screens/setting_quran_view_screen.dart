import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../localization/app_localizations.dart';
import '../resources/colors.dart';

class SettingQuranViewScreen extends StatefulWidget {
  static const routeName = '/setting-quran-view';
  const SettingQuranViewScreen({super.key});

  @override
  State<SettingQuranViewScreen> createState() => _SettingQuranViewScreenState();
}

class _SettingQuranViewScreenState extends State<SettingQuranViewScreen> {
  String selectedRadio = 'fullscreen';
  final dataKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .translate('setting_screen_quran')
              .toString(),
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: CustomColors.brown600,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 64),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: CustomColors.yellow150),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.book,
                            color: CustomColors.yellow300,
                            size: 70,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('setting_screen_quran_fullscreen')
                                .toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Radio(
                              value: 'fullscreen',
                              activeColor: CustomColors.brown600,
                              groupValue: selectedRadio,
                              onChanged: (value) => {
                                    setState(() {
                                      selectedRadio = value as String;
                                    }),
                                  })
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.book,
                            color: CustomColors.yellow300,
                            size: 70,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('setting_screen_quran_book')
                                .toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Radio(
                              value: 'book',
                              activeColor: CustomColors.brown600,
                              groupValue: selectedRadio,
                              onChanged: (value) => {
                                    setState(() {
                                      selectedRadio = value as String;
                                    }),
                                  })
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
