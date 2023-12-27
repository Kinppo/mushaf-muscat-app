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

class CustomAppBar extends StatefulWidget {
  final Function segmentedControlValue;
  final bool orientationPotrait;
  final Function toggleSearch;
  final double h;
  int segmentToggle;
  final Function changeSearchStatus;
  final Function toggleBars;

  CustomAppBar({
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
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool searchToggle = false;
  List<Surah> _surahSearchResults = [];
  List<GeneralAya> _ayaSearchResults = [];

  @override
  Widget build(BuildContext context) {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

    return SafeArea(
      child: Material(
        elevation: 4.0,
        child: Container(
          color: CustomColors.yellow500,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.045),
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
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      color: CustomColors.brown300,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    ),
                          ),
                          1: Text(
                            AppLocalizations.of(context)!
                                .translate('quran_screen_switch_tafsir')
                                .toString(),
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
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
                    IconButton(
                      color: Colors.transparent,
                      iconSize: 28,
                      onPressed: () {},
                      icon: Icon(MdiIcons.screenRotation),
                    ),
                  ],
                ),
              ),
              Container(
                  height: screenHeight * 0.06,
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.035,
                      screenHeight * 0.01, screenWidth * 0.035, 0),
                  child: QuranSearchBar(searchController: searchController)),
            ],
          ),
        ),
      ),
    );
  }
}
