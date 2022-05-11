import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/helperFunctions.dart';

import '../localization/app_localizations.dart';
import '../providers/quarter_provider.dart';
import '../providers/surah_provider.dart';
import '../resources/dimens.dart';
import '../screens/quran_screen.dart';
import '../widgets/drawer_screen_search_bar.dart';
import '../widgets/surahs_list.dart';
import '../widgets/quarters_list.dart';
import '../widgets/sample_data.dart';
import '../models/quarter.dart';
import '../models/surah.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool _isInit = true;
  bool _isLoading = true;

  // list of retrieved search result
  List<Quarter> _quarter_search_results = [];
  List<Surah> _surah_search_results = [];
  List<Surah> undiacritized_titles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<SurahProvider>(context).fetchSurahs().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      Provider.of<QuarterProvider>(context).fetchQuarters().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // final List<Surah> _surah = surah;

  int segmentedControlValue = 0;
  String hint = 'البحث عن سورة';
  bool searchToggle = false;

  // List <Surah> surahs= [];
  List<Surah> surahslist = [];

// search controller
  void searchController(search, input) {
    setState(() {
      searchToggle = search;
      compared(input);
      print(input);
      print("toggle search after $searchToggle");
    });
  }

  String hintText() {
    setState(() {
      if (segmentedControlValue == 0) {
        hint = AppLocalizations.of(context)!
            .translate('drawer_screen_search_hint_surahs')
            .toString();
      } else {
        hint = AppLocalizations.of(context)!
            .translate('drawer_screen_search_hint_quarters')
            .toString();
      }
    });

    return hint;
  }

  void setSurahs(List<Surah> surahs) {
    surahslist = surahs;
  }

  void compared(String text) async {
    List<Surah> matches = [];

    matches.addAll(surahslist);

    matches.retainWhere((surah) =>
        (HelperFunctions.removeAllDiacritics(surah.surahTitle)!
            .contains(HelperFunctions.removeAllDiacritics(text)!)) ||
        (HelperFunctions.removeAllDiacritics(surah.surahTitle!.substring(2))!
            .startsWith(HelperFunctions.removeAllDiacritics(text)!)) ||
        (HelperFunctions.removeAllDiacritics(surah.surahTitle!)!
            .endsWith(HelperFunctions.removeAllDiacritics(text)!)));

    setState(() {
      _surah_search_results = matches;
    });

  }

  Widget buildSurahListTile(String? surahNum, String? surahTitle,
      String? surahType, String? numOfAyas, Function? tapHandler) {
    return SurahsList(
      num: surahNum,
      title: surahTitle,
      numAya: numOfAyas,
      type: surahType,
    );
  }

  Widget buildQuarterListTile(
      bool? startingJuzzIndex,
      bool? startingHizbIndex,
      int? quarter,
      String? hizbNum,
      String? surahTitle,
      String? startingAya,
      String? juzz,
      String? quarterAyaNum,
      String? quarterPageNum,
      Function? tapHandler) {
    return QuartersList(
      startingJuzzIndex: startingJuzzIndex,
      startingHizbIndex: startingHizbIndex,
      quarter: quarter,
      hizbNum: hizbNum,
      surahTitle: surahTitle,
      startingAya: startingAya,
      juzz: juzz,
      quarterAyaNum: quarterAyaNum,
      quarterPageNum: quarterPageNum,
    );
  }

  @override
  Widget build(BuildContext context) {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    final _surahs = surahsData.surahs;
    final List<Surah> _surahitem = _surahs;

    final quartersData = Provider.of<QuarterProvider>(context, listen: false);
    final _quarters = quartersData.quarters;
    final List<Quarter> _quarteritem = _quarters;
    // print(_quarteritem.length);
    //print(_surahitem.length);

    //final List<Quarter> _quarter = quarter;
    // for searching
    setSurahs(_surahitem);

    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            //margin: EdgeInsets.all(16.0),
            padding: const EdgeInsets.only(top: 80.0),
            // width: 180,

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
                        backgroundColor: Theme.of(context).shadowColor,
                        children: <int, Widget>{
                          0: Text(
                            AppLocalizations.of(context)!
                                .translate('drawer_screen_switch_surahs')
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
                                .translate('drawer_screen_switch_quarters')
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
                    Navigator.of(context)
                        .popAndPushNamed(QuranScreen.routeName);
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.all(Dimens.px20),
            child: drawerSearchBar(
                hint: hintText(), searchController: searchController),
          ),
          const Divider(
            height: 0,
          ),
          if (segmentedControlValue == 0 && searchToggle == false) ...[
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: _surahitem.length,
                      itemBuilder: (ctx, i) {
                        return Column(
                          children: [
                            buildSurahListTile(
                              HelperFunctions.convertToArabicNumbers(
                                  _surahitem[i].surahNum),
                              _surahitem[i].surahTitle,
                              HelperFunctions.convertToArabicNumbers(
                                  _surahitem[i].numOfAyas),
                              _surahitem[i].surahType,
                              () {},
                            ),
                            const Divider(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
            ),
          ] else if (segmentedControlValue == 1 && searchToggle == false) ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 2),
                itemCount: _quarters.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                      buildQuarterListTile(
                        _quarteritem[i].startingJuzzIndex,
                        _quarteritem[i].startingHizbIndex,
                        _quarteritem[i].quarter,
                        _quarteritem[i].hizbNum,
                        _quarteritem[i].surahTitle,
                        _quarteritem[i].startingAya,
                        _quarteritem[i].juzz,
                        _quarteritem[i].quarterAyaNum,
                        _quarteritem[i].quarterPageNum,
                        () {},
                      ),
                      const Divider(
                        height: 20,
                      ),
                    ],
                  );
                },
              ),
            ),
            //search in juzz
          ] else if (searchToggle == true && segmentedControlValue == 0) ...[
            Expanded(
                child: (_surah_search_results.length) != 0
                    ? ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: _surah_search_results.length,
                        itemBuilder: (ctx, i) {
                          return Column(
                            children: [
                              buildSurahListTile(
                                HelperFunctions.convertToArabicNumbers(
                                    _surah_search_results[i].surahNum),
                                _surah_search_results[i].surahTitle,
                                HelperFunctions.convertToArabicNumbers(
                                    _surah_search_results[i].numOfAyas),
                                _surah_search_results[i].surahType,
                                () {},
                              ),
                              const Divider(
                                height: 20,
                              )
                            ],
                          );
                        },
                      )
                    : Container()),
            // search in quarter
          ] else if (searchToggle == true && segmentedControlValue == 1) ...[
            Expanded(
              child: Container(),
            ),
          ],
        ],
      ),
    );
  }
}
