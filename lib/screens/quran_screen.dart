import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../screens/book_marks_screen.dart';
import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
import '../resources/colors.dart';
import '../widgets/quran_screen_search_bar.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/drawer.dart';
import '../providers/app_state.dart';

class QuranScreen extends StatefulWidget {
  static const routeName = '/quran';



  @override
  State<QuranScreen> createState() => _QuranScreenState();

}


class _QuranScreenState extends State<QuranScreen> {

  bool _showAppBar = true;
  bool _showNavBar = true;
  int segmentedControlValue = 0;
  bool orientationPotrait = true;

  // final toggleAppBar = return
  //GlobalKey<QuranSearchBarState> segmentGlobalKey = new GlobalKey<QuranSearchBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              iconTheme: IconThemeData(
                  color: Theme.of(context).scaffoldBackgroundColor),
              toolbarHeight: 140, // Set this height
              flexibleSpace: Container(
                color: CustomColors.yellow500,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                              minWidth: 180,
                            ),
                            child: Container(
                              child: CupertinoSlidingSegmentedControl(
                                  groupValue: segmentedControlValue,
                                  backgroundColor:
                                      Theme.of(context).shadowColor,
                                  children: <int, Widget>{
                                    0: Text(
                                      AppLocalizations.of(context)!
                                          .translate(
                                              'quran_screen_switch_quran')
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(
                                            color: const Color.fromRGBO(
                                                105, 91, 77, 1),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                          ),
                                    ),
                                    1: Text(
                                      AppLocalizations.of(context)!
                                          .translate(
                                              'quran_screen_switch_tafsir')
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(
                                            color: const Color.fromRGBO(
                                                105, 91, 77, 1),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                          ),
                                    ),
                                  },
                                  onValueChanged: (value) {
                                    setState(() {
                                      segmentedControlValue = value as int;

                                      print(segmentedControlValue);
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            iconSize: 28,
                            onPressed: () {
                              setState(() {
                                if (orientationPotrait == true) {
                                  orientationPotrait = !orientationPotrait;

                                  SystemChrome.setPreferredOrientations(
                                      [DeviceOrientation.landscapeRight]);
                                } else {
                                  orientationPotrait = !orientationPotrait;

                                  SystemChrome.setPreferredOrientations(
                                      [DeviceOrientation.portraitUp]);
                                }
                              });
                            },
                            icon: const Icon(MdiIcons.screenRotation),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(34, 10, 34, 0),
                      width: double.infinity,
                      height: 50,
                      child: QuranSearchBar(
                       "البحث", 
                      ),
                    ),
                  ],
                ),
              ),
            )
          :

          // ? AppBar(
          //     backgroundColor: Theme.of(context).primaryColor,
          //     title: Text(
          //       AppLocalizations.of(context)!
          //           .translate('quran_screen_title')
          //           .toString(),
          //       style: Theme.of(context).textTheme.headline1,
          //     ),
          //   )
          PreferredSize(
              child: Container(),
              preferredSize: const Size(0.0, 0.0),
            ),
      bottomNavigationBar: _showNavBar
          ? const BNavigationBar(
              pageIndex: 0,
            )
          : const PreferredSize(
              child: Text(""),
              preferredSize: Size(0.0, 0.0),
            ),
      drawer: Container(
        width: double.infinity,
        child: MainDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
                child: (segmentedControlValue == 0)
                    ? Container(
                        padding: const EdgeInsets.all(Dimens.px22),
                        color: Theme.of(context).backgroundColor,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Text(AppLocalizations.of(context)!
                              .translate('dummy_text')
                              .toString()),
                        ),
                      )
                    : (segmentedControlValue == 0)
                        ? Container(
                            color: Theme.of(context).backgroundColor,
                            child: Text("Tafsir"),
                          )
                        : Container(
                            color: Theme.of(context).backgroundColor,
                          ),
                onTap: () {
                  setState(() {
                    _showAppBar = !_showAppBar;
                    _showNavBar = !_showNavBar;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
