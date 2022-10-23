import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'package:mushafmuscat/widgets/appbar.dart';
import 'package:mushafmuscat/widgets/finalCarousel.dart';

import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
import '../resources/colors.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../widgets/finalCarousel2.dart';
import '../widgets/finalCarouselTesting.dart';

class QuranScreen extends StatefulWidget {
  static const routeName = '/quran';

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  bool showAppBar = true;
  bool showNavBar = true;
  int segmentedControlValue = 0;
  bool orientationPotrait = true;
  bool toggleSearch = false;
  bool showPlayer = true;
  int goToPage = 0;

  @override
  // void initState() {

  //     // _detailListBloc = DetailListBloc(widget.apiUrl);

  //   // TODO: implement initState
  //   super.initState();
  // }

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

  void toggleBars() {
    setState(() {
      showPlayer = !showPlayer;
      showAppBar = !showAppBar;
      showNavBar = !showNavBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero,(){//you can await it if you want
    //   print('init=${ModalRoute.of(context)!.settings.arguments}');
    goToPage = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false, // set it to false

      appBar: showAppBar
          ? appBar(
              segmentedControlValue: controlSegment,
              orientationPotrait: orientationPotrait,
              toggleSearch: controlSearch,
              height_mq: MediaQuery.of(context).size.height)
          : PreferredSize(
              child: Container(),
              preferredSize: const Size(0.0, 0.0),
            ),
      bottomNavigationBar: showNavBar
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
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            GestureDetector(

                // behavior: HitTestBehavior.deferToChild,
                child: (segmentedControlValue == 0 && toggleSearch == false)
                    ? Container(
                        // padding: const EdgeInsets.all(Dimens.px22),
                        color: Theme.of(context).backgroundColor,
                        height: MediaQuery.of(context).size.height,

                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              // child: finalCarousel(goToPage: goToPage, toggleBars:toggleBars),
                              child: finalCarousel2(
                                  goToPage: goToPage, toggleBars: toggleBars),
                            ),
                            // showPlayer ? AudioPlayerWidget():
                            // Container()
                          ],
                        ),
                      )
                    : (segmentedControlValue == 1 && toggleSearch == false)
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            // padding: const EdgeInsets.all(Dimens.px22),
                            color: Theme.of(context).backgroundColor,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child:                     
                              Text(AppLocalizations.of(context)!
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
                  toggleBars();
                }),
          ],
        ),
      ),
    );
  }
}
