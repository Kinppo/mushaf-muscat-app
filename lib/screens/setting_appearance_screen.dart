import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../resources/colors.dart';

class SettingAppearanceScreen extends StatefulWidget {
  const SettingAppearanceScreen({super.key});
  static const routeName = '/setting-appearance';

  @override
  State<SettingAppearanceScreen> createState() =>
      _SettingAppearanceScreenState();
}

class _SettingAppearanceScreenState extends State<SettingAppearanceScreen> {
  String selectedRadio = 'system';

  @override
  void initState() {
    super.initState();
    selectedRadio = 'system';
  }

  @override
  void didChangeDependencies() {
    String currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    setState(() {
      selectedRadio = currentTheme;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .translate('setting_screen_title')
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
        child: Column(
          children: <Widget>[
            Consumer<ThemeProvider>(builder: (context, provider, child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                padding: const EdgeInsets.fromLTRB(0, 5, 10, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: CustomColors.yellow150),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .translate('setting_screen_appearance_system')
                                .toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Radio(
                              value: 'system',
                              activeColor: CustomColors.brown600,
                              groupValue: selectedRadio,
                              onChanged: (value) => {
                                    setState(() {
                                      selectedRadio = value as String;
                                    }),
                                    provider.changeTheme(value as String)
                                  }),
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Divider(
                        height: 1,
                        color: CustomColors.yellow200,
                        thickness: 1,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .translate('setting_screen_appearance_light')
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          Radio(
                              activeColor: CustomColors.brown600,
                              value: 'light',
                              groupValue: selectedRadio,
                              onChanged: (value) => {
                                    setState(() {
                                      selectedRadio = value as String;
                                    }),
                                    provider.changeTheme(value as String)
                                  }),
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Divider(
                        height: 1,
                        color: CustomColors.yellow200,
                        thickness: 1,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .translate('setting_screen_appearance_dark')
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          Radio(
                              value: 'dark',
                              activeColor: CustomColors.brown600,
                              groupValue: selectedRadio,
                              onChanged: (value) => {
                                    setState(() {
                                      selectedRadio = value as String;
                                    }),
                                    provider.changeTheme(value as String)
                                  }),
                        ]),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
