import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../resources/colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);
  static const routeName = '/about-app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const Icon(MdiIcons.chevronRight),
        //centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!
              .translate('setting_screen_about')
              .toString(),
          style:  TextStyle(fontFamily: 'IBMPlexSansArabic', fontWeight: FontWeight.w400, fontSize: 20,  color: CustomColors.black200),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: CustomColors.brown600,
        elevation: 0,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: CustomColors.yellow150),
                  child: Column(
                    children: [
                      Image.asset('./assets/images/playstore.png',
                      width: 60,
                      height: 60,
                         ),
                      Text(
                        AppLocalizations.of(context)!
                            .translate('app_version')
                            .toString(),
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('about_screen_details')
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 1.8),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('about_screen_details2')
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 1.8),
                        ),
                      ),
                     const SizedBox(
                        height: 10,
                      ),
                            
                     Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('about_screen_details3')
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 1.8),
                        ),
                      ),
                    ],
                  ))
            ]),
          )),
    );
  }
}
