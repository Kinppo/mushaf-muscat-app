import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../localization/app_localizations.dart';
import '../resources/colors.dart';

class SettingAppearanceScreen extends StatefulWidget {
  static const routeName = '/setting-appearance';

  @override
  State<SettingAppearanceScreen> createState() =>
      _SettingAppearanceScreenState();
}

void setState(Null Function() param0) {}

class _SettingAppearanceScreenState extends State<SettingAppearanceScreen> {
  late int selectedRadio;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const Icon(MdiIcons.chevronRight),
        //centerTitle: false,
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
            Container(
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
                              .translate('setting_screen_appearance_option2')
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Radio(
                            value: 2,
                            groupValue: selectedRadio,
                            onChanged: (value) => {}),
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
                                .translate('setting_screen_appearance_option1')
                                .toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        Radio(
                            activeColor: CustomColors.brown600,
                            value: 1,
                            groupValue: selectedRadio,
                            onChanged: (value) => {}),
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
                                .translate('setting_screen_appearance_option3')
                                .toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        Radio(
                            value: 3,
                            groupValue: selectedRadio,
                            onChanged: (value) => {}),
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
