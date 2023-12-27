import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mushafmuscat/widgets/quran_screen_search_bar.dart';
import 'package:provider/provider.dart';

import '../localization/app_localizations.dart';
import '../models/surah.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';
import '../screens/quran_screen.dart';

class appBar extends StatefulWidget implements PreferredSizeWidget {
  Function segmentedControlValue;
  bool orientationPotrait;
  Function toggleSearch;
  double h;
  int segmentToggle;
  Function changeSearchStatus;
  Function toggleBars;
  appBar({
    Key? key,
    required this.segmentedControlValue,
    required this.orientationPotrait,
    required this.toggleSearch,
    required this.h,
    required this.segmentToggle,
    required this.changeSearchStatus,
    required this.toggleBars,
    // this variable is not used yet
  }) : super(key: key);
  @override
  State<appBar> createState() => _appBarState();

  @override
  Size get preferredSize => Size.fromHeight(h);
}

class _appBarState extends State<appBar> {
  // int segmentToggle = 0;
  bool searchToggle = false;
  List<Surah> _surah_search_results = [];
  List<generalAya> _aya_search_results = [];

  Widget build(BuildContext context) {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    final _surahs = surahsData.surahs;
    final List<Surah> _surahitem = _surahs;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarTopPadding = screenHeight * 0.03;
    final appBarBottomPadding = screenHeight * 0.03;

    final searchBarPadding = screenWidth * 0.04;

    Future<void> searchController(isStillSearching, search) async {
      _surah_search_results = await surahsData.getSeachResults_appbar(search);
      _aya_search_results = await surahsData.getAyaSeachResults_appbar(search);

      setState(() {
        searchToggle = isStillSearching;
        widget.changeSearchStatus();

        //todo: send search result here
        widget.toggleSearch(
            searchToggle, _surah_search_results, _aya_search_results);
      });
    }

    return (searchToggle == false)
        ? GestureDetector(
            onTap: () => widget.toggleBars(),
            child: SafeArea(
              child: AppBar(
                title: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              "assets/images/Icon.svg",
                              width: 27,
                              height: 27,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                              minWidth: 180,
                            ),
                            child: Container(
                              child: CupertinoSlidingSegmentedControl(
                                groupValue: widget.segmentToggle,
                                backgroundColor: Theme.of(context).shadowColor,
                                children: <int, Widget>{
                                  0: Text(
                                    AppLocalizations.of(context)!
                                        .translate('quran_screen_switch_quran')
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.copyWith(
                                          color: CustomColors.brown300,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17,
                                        ),
                                  ),
                                  1: Text(
                                    AppLocalizations.of(context)!
                                        .translate('quran_screen_switch_tafsir')
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.copyWith(
                                          color: CustomColors.brown300,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17,
                                        ),
                                  ),
                                },
                                onValueChanged: (value) {
                                  setState(() {
                                    widget.segmentToggle = value as int;
                                    widget.segmentedControlValue(
                                      widget.segmentToggle,
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                          // lock device orientation change
                          //TODO: Support landscape orientation
                          IconButton(
                            // do not remove button, instead make it transparent
                            //so that it doesn't mess with the layout of the app bar
                            color: Colors.transparent,
                            iconSize: 28,
                            onPressed: () {
                              // setState(() {
                              //   if (widget.orientationPotrait == true) {
                              //     widget.orientationPotrait =
                              //         !widget.orientationPotrait;

                              //     SystemChrome.setPreferredOrientations(
                              //         [DeviceOrientation.landscapeRight]);
                              //   } else {
                              //     widget.orientationPotrait =
                              //         !widget.orientationPotrait;

                              //     SystemChrome.setPreferredOrientations(
                              //         [DeviceOrientation.portraitUp]);
                              //   }
                              // });
                            },
                            icon: Icon(MdiIcons.screenRotation),
                          ),
                        ],
                      ),
                    ),

                    // Container(
                    //   padding: EdgeInsets.only(top: 60),
                    //   color: Colors.red,
                    //   height: 80,
                    // )
//  QuranSearchBar(searchController: searchController),
                  ],
                ),
              ),
            ),
          )
        : AppBar(
            elevation: 0,
            automaticallyImplyLeading:
                false, // this will hide Drawer hamburger icon
            actions: <Widget>[
              Container()
            ], // this will hide endDrawer hamburger icon

            bottom: PreferredSize(
                child: Container(
                  color: CustomColors.yellow200,
                  height: 1.0,
                ),
                preferredSize: const Size.fromHeight(1.0)),

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
                        Container(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('search_screen_search')
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(
                                    color: CustomColors.black200,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 27),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(QuranScreen.routeName);
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('search_screen_cancel')
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(
                                    color: CustomColors.black200,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 21),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(34, 13, 34, 0),
                    width: double.infinity,
                    height: 50,
                    child: QuranSearchBar(searchController: searchController),
                  ),
                ],
              ),
            ),
          );
  }
}
