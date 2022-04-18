import 'package:flutter/material.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:mushafmuscat/widgets/quarters_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:mushafmuscat/models/surah.dart';
import 'package:mushafmuscat/models/quarter.dart';
import 'package:mushafmuscat/widgets/search_bar.dart';

import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
import '../widgets/surahs_list.dart';
import '../widgets/quarters_list.dart';
import '../widgets/sample_data.dart';
import '../widgets/search_bar.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final List<Surah> _surah = surah;
  final List<Quarter> _quarter = quarter;

  int segmentedControlValue = 0;
  String hint = 'البحث عن سورة';

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

  Widget buildSurahListTile(String surahNum, String surahTitle,
      String surahType, String numOfAyas, Function tapHandler) {
    return SurahsList(
        num: surahNum, title: surahTitle, numAya: numOfAyas, type: surahType);
  }

  Widget buildQuarterListTile(
      bool startingJuzzIndex,
      bool startingHizbIndex,
      int quarter,
      String hizbNum,
      String surahTitle,
      String startingAya,
      String juzz,
      String quarterAyaNum,
      String quarterPageNum,
      Function tapHandler) {
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
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(
                                  color: const Color.fromRGBO(105, 91, 77, 1),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17,
                                ),
                          ),
                          1: Text(
                            AppLocalizations.of(context)!
                                .translate('drawer_screen_switch_quarters')
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(
                                  color: const Color.fromRGBO(105, 91, 77, 1),
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
            child: searchBar(hint: hintText()),
            // child: TextField(
            //   textAlign: TextAlign.right,
            //   textAlignVertical: TextAlignVertical.bottom,
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //       borderSide: const BorderSide(
            //         width: 0,
            //         style: BorderStyle.none,
            //       ),
            //     ),
            //     filled: true,
            //     fillColor: Theme.of(context).indicatorColor,
            //     prefixIcon: const Icon(Icons.search),
            //     iconColor: const Color.fromRGBO(148, 135, 121, 1),
            //     hintText: hintText(),
            //     hintStyle: const TextStyle(
            //       color: Color.fromRGBO(148, 135, 121, 1),
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   style: const TextStyle(
            //     color: Color.fromRGBO(148, 135, 121, 1),
            //   ),
            // ),
          ),
          const Divider(
            height: 0,
          ),
          if (segmentedControlValue == 0) ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: _surah.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                      buildSurahListTile(
                        _surah[i].surahPageNum,
                        _surah[i].surahTitle,
                        _surah[i].numOfAyas,
                        _surah[i].surahType,
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
          ] else if (segmentedControlValue == 1) ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 2),
                itemCount: _surah.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                      buildQuarterListTile(
                        _quarter[i].startingJuzzIndex,
                        _quarter[i].startingHizbIndex,
                        _quarter[i].quarter,
                        _quarter[i].hizbNum,
                        _quarter[i].surahTitle,
                        _quarter[i].startingAya,
                        _quarter[i].juzz,
                        _quarter[i].quarterAyaNum,
                        _quarter[i].quarterPageNum,
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
          ],
        ],
      ),
    );
  }
}
