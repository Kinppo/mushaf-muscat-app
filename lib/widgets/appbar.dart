import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mushafmuscat/widgets/quran_screen_search_bar.dart';

import '../localization/app_localizations.dart';
import '../resources/colors.dart';
import '../screens/quran_screen.dart';

class appBar extends StatefulWidget implements PreferredSizeWidget {
  Function segmentedControlValue;
  bool orientationPotrait;
  Function toggleSearch;
  double h;
  appBar({
    Key? key,
    required this.segmentedControlValue,
    required this.orientationPotrait,
    required this.toggleSearch,
    required this.h,
    // this variable is not used yet
  }) : super(key: key);
  @override
  State<appBar> createState() => _appBarState();

  @override
  Size get preferredSize =>  Size.fromHeight(h);


}

class _appBarState extends State<appBar> {
  int segmentToggle = 0;
  bool searchToggle = false;

  // search controller
  void searchController(search) {
    setState(() {
      searchToggle = search;
      widget.toggleSearch(searchToggle);
      //print("toggle search after $searchToggle");
    });
  }

  Widget build(BuildContext context) {

    return (searchToggle == false)
        ? AppBar(
            bottom: PreferredSize(
                child: Container(
                  color: CustomColors.yellow200,
                  height: 1.0,
                ),
                preferredSize: Size.fromHeight(1.0)),
            // leading: Builder(
            //   builder: (context) => IconButton(
            //     icon: const Icon(Icons.menu_rounded),
            //     onPressed: () => Scaffold.of(context).openDrawer(),
            //   ),
            // ),
            // iconTheme: IconThemeData(color: CustomColors.black200),
            toolbarHeight: 140, // Set this height
            flexibleSpace: Container(
              color: CustomColors.yellow500,
                            // color:Colors.blue,

              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                                // iconSize: 20,
                                icon: SvgPicture.asset(
                                    "assets/images/Icon.svg",
                                    width: 27,
                                    height: 27,
                                    fit: BoxFit.contain), onPressed:() => Scaffold.of(context).openDrawer(),),
              //           IconButton(
              //   icon: const Icon(Icons.menu_rounded),
              //   onPressed: () => Scaffold.of(context).openDrawer(),
              // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                            minWidth: 180,
                          ),
                          child: Container(
                            child: CupertinoSlidingSegmentedControl(
                                groupValue: segmentToggle,
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
                                    segmentToggle = value as int;
                                    print("app bar $segmentToggle");
                                    widget.segmentedControlValue(segmentToggle);
                                  });
                                }),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 5,
                        // ),
                        IconButton(
                          iconSize: 28,
                          onPressed: () {
                            setState(() {
                              if (widget.orientationPotrait == true) {
                                widget.orientationPotrait =
                                    !widget.orientationPotrait;

                                SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.landscapeRight]);
                              } else {
                                widget.orientationPotrait =
                                    !widget.orientationPotrait;

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
                    child: QuranSearchBar(searchController: searchController),
                  ),
                ],
              ),
            ),
          )
        : AppBar(
          elevation: 0,
            automaticallyImplyLeading:
                false, // this will hide Drawer hamburger icon
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
                              .toString() ,style: Theme.of(context)
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