import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/screens/about_app_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/app_localizations.dart';
import '../resources/colors.dart';

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class SettingAbout extends StatelessWidget {

  void _launchURL() async {
  const url = 'mailto:MushafMuscat@etco.om?subject=Feedback';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

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
          onTap: () =>
              {Navigator.of(context).pushNamed(AboutAppScreen.routeName)},
          child: Row(
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
                        fontFamily: 'IBMPlexSansArabic',
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
        GestureDetector(
          onTap: () =>
           _launchURL(),
          child: Row(
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
          ),
        )
      ]),
    );
  }
}
