import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../localization/app_localizations.dart';
import '../resources/colors.dart';

class SettingAbout extends StatelessWidget {
  const SettingAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: CustomColors.yellow150),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
      padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.helpCircle,
                  color: CustomColors.grey200,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .translate('setting_screen_about')
                      .toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.black200),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                MdiIcons.chevronLeft,
                color: CustomColors.grey200,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Divider(
            height: 1,
            color: CustomColors.yellow200,
            thickness: 1,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.messageAlert,
                  color: CustomColors.grey200,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .translate('setting_screen_feedback')
                      .toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.black200),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                MdiIcons.chevronLeft,
                color: CustomColors.grey200,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
