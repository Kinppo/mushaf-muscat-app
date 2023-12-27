import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/widgets/quran_screen_search_bar.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../models/surah.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';
import '../screens/quran_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function segmentedControlValue;
  final bool orientationPotrait;
  final Function toggleSearch;
  final double h;
  final Function changeSearchStatus;
  final Function toggleBars;
  final int segmentToggle;

  const CustomAppBar({
    super.key,
    required this.segmentedControlValue,
    required this.orientationPotrait,
    required this.toggleSearch,
    required this.h,
    required this.segmentToggle,
    required this.changeSearchStatus,
    required this.toggleBars,
  });
  @override
  State<CustomAppBar> createState() => AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(h);
}

class AppBarState extends State<CustomAppBar> {
  bool searchToggle = false;
  List<Surah> _surahSearchResults = [];
  List<GeneralAya> _ayaSearchResults = [];

  @override
  Widget build(BuildContext context) {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    Future<void> searchController(isStillSearching, search) async {
      _surahSearchResults = surahsData.getSeachResultsAppbar(search);
      _ayaSearchResults = surahsData.getAyaSeachResultsAppbar(search);

      setState(() {
        searchToggle = isStillSearching;
        widget.changeSearchStatus();
        widget.toggleSearch(
            searchToggle, _surahSearchResults, _ayaSearchResults);
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
                      padding: const EdgeInsets.only(top: 70),
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
                                  widget.segmentedControlValue(
                                    widget.segmentToggle,
                                  );
                                });
                              },
                            ),
                          ),
                          IconButton(
                            color: Colors.transparent,
                            iconSize: 28,
                            onPressed: () {},
                            icon: Icon(MdiIcons.screenRotation),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: <Widget>[Container()],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: CustomColors.yellow200,
                  height: 1.0,
                )),
            toolbarHeight: 140,
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
