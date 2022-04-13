import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../localization/app_localizations.dart';
import '../resources/colors.dart';
import '../screens/setting_appearance_screen.dart';

class SettingAppearance extends StatelessWidget {
  const SettingAppearance({Key? key}) : super(key: key);

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
        GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(SettingAppearanceScreen.routeName),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    MdiIcons.cog,
                    color: CustomColors.grey200,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .translate('setting_screen_appearance')
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
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translate('setting_screen_appearance_option1')
                          .toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.grey200),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Icon(
                      MdiIcons.chevronLeft,
                      color: CustomColors.grey200,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                  MdiIcons.fileDocumentOutline,
                  color: CustomColors.grey200,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .translate('setting_screen_quran')
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
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate('setting_screen_quran_option1')
                        .toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: CustomColors.grey200),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Icon(
                    MdiIcons.chevronLeft,
                    color: CustomColors.grey200,
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
