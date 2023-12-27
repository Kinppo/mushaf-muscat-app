import 'package:flutter/material.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/helper_functions.dart';
import '../localization/app_localizations.dart';
import '../providers/quarter_provider.dart';
import '../providers/surah_provider.dart';
import '../resources/dimens.dart';
import '../screens/quran_screen.dart';
import '../widgets/drawer_screen_search_bar.dart';
import '../widgets/surahs_list.dart';
import '../widgets/quarters_list.dart';
import '../models/quarter.dart';
import '../models/surah.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool _isInit = true;
  bool _isLoading = true;
  List<Surah> surahSearchResults = [];
  List<Surah> undiacritizedTitles = [];

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

  int segmentedControlValue = 0;
  bool searchToggle = false;
  int goToPage = 1;
  List<Surah> surahslist = [];
  void searchController(search, input) {
    setState(() {
      searchToggle = search;
      surahSearchResults = Provider.of<SurahProvider>(context, listen: false)
          .getSeachResults(input);
    });
  }

  void setSurahs(List<Surah> surahs) {
    surahslist = surahs;
  }

  void tapHandlerFunc(String page) {
    setState(() {
      goToPage = int.parse(page);
    });
    Navigator.of(context).popAndPushNamed(
      QuranScreen.routeName,
      arguments: {
        'v1': goToPage,
        'v2': 0,
      },
    );
  }

  Widget buildSurahListTile(
      String? surahNum,
      String? surahTitle,
      String? surahType,
      String? numOfAyas,
      String? firstPage,
      Function? tapHandler) {
    return SurahsList(
      num: surahNum,
      title: surahTitle,
      numAya: numOfAyas,
      type: surahType,
      firstPageNum: firstPage,
      tapHandler: tapHandler,
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
      tapHandler: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    final surahs = surahsData.surahs;
    final List<Surah> surahitem = surahs;

    final quartersData = Provider.of<QuarterProvider>(context, listen: false);
    final quarters = quartersData.quarters;
    final List<Quarter> quarteritem = quarters;

    setSurahs(surahitem);

    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: screenHeight * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: screenwidth * 0.17,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                    minWidth: 180,
                  ),
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
                        });
                      }),
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  iconSize: 28,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuranScreen(),
                        ),
                        (route) => false);
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ),
          ),
          if (segmentedControlValue == 0) ...[
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(Dimens.px20),
              child: DrawerSearchBar(searchController: searchController),
            ),
            const Divider(
              height: 0,
            ),
          ] else if (segmentedControlValue == 1) ...[
            Container(),
            const Divider(
              height: 20,
            ),
          ],
          if (segmentedControlValue == 0 && searchToggle == false) ...[
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: surahitem.length,
                      itemBuilder: (ctx, i) {
                        return Column(
                          children: [
                            buildSurahListTile(
                                HelperFunctions.convertToArabicNumbers(
                                    surahitem[i].surahNum),
                                surahitem[i].surahTitle,
                                HelperFunctions.convertToArabicNumbers(
                                    surahitem[i].numOfAyas),
                                surahitem[i].surahType,
                                surahitem[i].surahPageNum,
                                tapHandlerFunc),
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
                itemCount: quarters.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                      buildQuarterListTile(
                        quarteritem[i].startingJuzzIndex,
                        quarteritem[i].startingHizbIndex,
                        quarteritem[i].quarter,
                        quarteritem[i].hizbNum,
                        quarteritem[i].surahTitle,
                        quarteritem[i].startingAya,
                        quarteritem[i].juzz,
                        quarteritem[i].quarterAyaNum,
                        quarteritem[i].quarterPageNum,
                        tapHandlerFunc,
                      ),
                      const Divider(
                        height: 20,
                      ),
                    ],
                  );
                },
              ),
            ),
          ] else if (searchToggle == true && segmentedControlValue == 0) ...[
            Expanded(
                child: surahSearchResults.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: surahSearchResults.length,
                        itemBuilder: (ctx, i) {
                          return Column(
                            children: [
                              buildSurahListTile(
                                HelperFunctions.convertToArabicNumbers(
                                    surahSearchResults[i].surahNum),
                                surahSearchResults[i].surahTitle,
                                HelperFunctions.convertToArabicNumbers(
                                    surahSearchResults[i].numOfAyas),
                                surahSearchResults[i].surahType,
                                surahSearchResults[i].surahPageNum,
                                tapHandlerFunc,
                              ),
                              const Divider(
                                height: 20,
                              )
                            ],
                          );
                        },
                      )
                    : Container()),
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
