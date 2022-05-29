import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mushafmuscat/widgets/appbar.dart';
import 'package:mushafmuscat/widgets/test3.dart';
import 'package:mushafmuscat/widgets/textCarousel.dart';

import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
import '../resources/colors.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../widgets/audioplayer.dart';


class QuranScreen extends StatefulWidget {
  static const routeName = '/quran';

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  GlobalKey<_QuranScreenState> myKey = GlobalKey();

  bool _showAppBar = true;
  bool _showNavBar = true;
  int segmentedControlValue = 0;
  bool orientationPotrait = true;
  bool toggleSearch = false;
  bool showPlayer= true;

  void controlSegment(segment) {
    setState(() {
      segmentedControlValue = segment;
      //print("segmentedControlValue $segmentedControlValue");
    });
  }

  void controlSearch(search) {
    setState(() {
      toggleSearch = search;
      print("toggleSearch $toggleSearch");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? appBar(
              segmentedControlValue: controlSegment,
              orientationPotrait: orientationPotrait,
              toggleSearch: controlSearch)
          : PreferredSize(
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
        child: const MainDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
                child: (segmentedControlValue == 0 && toggleSearch == false)
                    ? Container(
                        padding: const EdgeInsets.all(Dimens.px22),
                        color: Theme.of(context).backgroundColor,
                        width: double.infinity,
                        child:  SingleChildScrollView(
                          child: Column(
                            children:  [
                              Padding(
                                padding: EdgeInsets.only(top: 170),
                                child: textCarousel(),
                              ),
                              showPlayer ? AudioPlayerWidget():
                              Container()
                            ],
                          ),         
                        ),
                      )
                    : (segmentedControlValue == 1 && toggleSearch == false)
                        ? Container(
                            padding: const EdgeInsets.all(Dimens.px22),
                            color: Theme.of(context).backgroundColor,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Text(AppLocalizations.of(context)!
                                  .translate('tafsir_text')
                                  .toString()),
                            ),
                          )

                        // if user is searching
                        : (toggleSearch == true)
                            ? Container(
                                color: CustomColors.yellow500,
                                child: const SizedBox(
                                  child: Text("s"),
                                  height: double.infinity,
                                  width: double.infinity,
                                ))
                            : Container(
                                color: CustomColors.yellow500,
                              ),
                onTap: () {
                  setState(() {
                  showPlayer= !showPlayer;
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
