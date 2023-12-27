import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../localization/app_localizations.dart';
import '../resources/colors.dart';

class SettingStorage extends StatelessWidget {
  const SettingStorage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: CustomColors.yellow150),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.folder,
                  color: CustomColors.grey200,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .translate('setting_screen_storage')
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
                        .translate('setting_screen_storage_size')
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
        ));
  }
}
