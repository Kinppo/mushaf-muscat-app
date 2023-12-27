import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';

import 'package:mushafmuscat/widgets/appbar.dart';
import 'package:provider/provider.dart';

import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/custom.dart'; //new appbar
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../widgets/finalCarousell.dart';
import '../widgets/TafsirCarousel.dart';
import '../widgets/quran_aya_search_tiles.dart';
import '../widgets/surahs_list.dart';
import '../widgets/quran_surah_search_tiles.dart';

class QuranScreen extends StatefulWidget {
  static const routeName = '/quran';

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  bool showAppBar = true;
  bool showNavBar = true;
  late int segmentedControlValue;
  bool orientationPotrait = true;
  bool toggleSearch = false;
  bool showPlayer = true;
  int goToPage = 0;
  int loop = 0;
  int highlighNum = 0;
  late int GlobalCurrentPage;
  var searchRes_surah;
  var searchRes_aya;
  var searchRes_combined;
  bool searchStatus = false;
  String SurahFrom = "الفاتحة";

  @override
  void initState() {
    //load all ayas for search
    setState(() {
      // loadAyas();
      segmentedControlValue = 0;
      GlobalCurrentPage = 1;
    });
    // TODO: implement initState
    super.initState();
  }

  // void loadAyas() async{
  //   final surahsData = Provider.of<SurahProvider>(context, listen: false);
  //    await surahsData.loadAllAyasJson();

  // }

  void controlSegment(segment) {
    setState(() {
      segmentedControlValue = segment;
    });
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

  void controlSearch(search, surah_result, aya_result) {
    searchRes_surah = [];
    searchRes_aya = [];
    setState(() {
      toggleSearch = search;
      searchRes_surah = surah_result;
      searchRes_aya = aya_result;
    });
  }

  List<Widget> getSearchTiles() {
    List<ListTile> surahResultsTiles = [];
    List<ListTile> ayaResultsTiles = [];

    for (int i = 0; i < searchRes_surah.length; i++) {
      surahResultsTiles.add(ListTile(
          title: Text(
        searchRes_surah[i].surahTitle.toString(),
        style: TextStyle(color: CustomColors.black200),
      )));
    }

    for (int i = 0; i < searchRes_aya.length; i++) {
      ayaResultsTiles.add(ListTile(
          title: Text(
        searchRes_aya[i].text.toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: CustomColors.black200),
      )));
    }

    List<ListTile> FinalList = [];

    FinalList.add(ListTile(
        title: Text(
      "السور (${searchRes_surah.length})",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: CustomColors.black200),
    )));
    FinalList.addAll(surahResultsTiles);
    FinalList.add(ListTile(
        title: Text(
      "الايات  (" + searchRes_aya.length.toString() + ")",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: CustomColors.black200),
    )));
    FinalList.addAll(ayaResultsTiles);

    return (FinalList.isNotEmpty)
        ? FinalList
        : [
            ListTile(
              title: Text(
                "لم يتم العثور على نتائج",
                style: TextStyle(color: CustomColors.black200),
              ),
            )
          ];
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
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var screenHeight = MediaQuery.of(context).size.height;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      goToPage = args['v1'] as int? ?? 0;
      loop = args['v2'] as int? ?? 0;
      highlighNum = args['v3'] as int? ?? 0;
      SurahFrom = args['v4'] as String? ?? '';
    }

    void changeGlobal(int currpage) {
      setState(() {
        GlobalCurrentPage = currpage;
      });
    }

    void changeSearchStatus() {
      setState(() {
        searchStatus = true;
      });
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false, // set it to false

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.2),
          child: GestureDetector(
            // Add this
            onTap: toggleBars,
            child: Container(
              color: Colors.transparent,
              child: showAppBar
                  ? CustomAppBar(
                      segmentedControlValue: controlSegment,
                      orientationPotrait: orientationPotrait,
                      toggleSearch: controlSearch,
                      h: (isLandscape == false) ? screenHeight * 0.18 : 200,
                      segmentToggle: segmentedControlValue,
                      changeSearchStatus: changeSearchStatus,
                      toggleBars: toggleBars,
                    )
                  : Container(),
            ),
          ),
        ),
        drawer: Container(
          width: double.infinity,
          child: const MainDrawer(),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  toggleBars();
                },
                child: toggleSearch != true
                    ? (segmentedControlValue == 0
                        ? finalCarousel2(
                            goToPage: (goToPage != 0 && GlobalCurrentPage == 1)
                                ? goToPage
                                : GlobalCurrentPage,
                            loop: loop,
                            toggleBars: toggleBars,
                            loophighlight: highlighNum,
                            GlobalCurrentPage: GlobalCurrentPage,
                            changeGlobal: changeGlobal,
                            surahFrom: SurahFrom,
                          )
                        : (segmentedControlValue == 1
                            ? SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: TafsirCarousel(
                                  goToPage: GlobalCurrentPage,
                                  loop: loop,
                                  toggleBars: toggleBars,
                                  loophighlight: highlighNum,
                                  GlobalCurrentPage: GlobalCurrentPage,
                                  changeGlobal: changeGlobal,
                                  barsOn: showNavBar,
                                ),
                              )
                            : Container(
                                height: 400,
                                color: CustomColors.red200,
                              )))
                    : GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: screenHeight * 0.008),
                                  width: double.infinity,
                                ),
                                ListTile(
                                    title: Text(
                                  "السور (" +
                                      searchRes_surah.length.toString() +
                                      ")",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                      color: CustomColors.black200),
                                )),
                                Container(
                                  // height: screenHeight,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    //  itemExtent: 200,

                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: false,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * 0.02),
                                    // + 2 are the headers for each search category
                                    itemCount: searchRes_surah.length,
                                    itemBuilder: (ctx, i) {
                                      int index = i;
                                      return (searchStatus == false)
                                          ? CircularProgressIndicator()
                                          : QuranSurahSearchTiles(
                                              num: HelperFunctions
                                                  .convertToArabicNumbers(
                                                      searchRes_surah[index]
                                                          .surahNum),
                                              title: searchRes_surah[index]
                                                  .surahTitle,
                                              numAya: HelperFunctions
                                                  .convertToArabicNumbers(
                                                      searchRes_surah[index]
                                                          .numOfAyas),
                                              type: searchRes_surah[index]
                                                  .surahType,
                                              firstPageNum:
                                                  searchRes_surah[index]
                                                      .surahPageNum,
                                              tapHandler: tapHandlerFunc);
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "الايات (" +
                                        searchRes_aya.length.toString() +
                                        ")",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                        color: CustomColors.black200),
                                  ),
                                ),
                                Container(
                                  // height: screenHeight,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    //  itemExtent: 200,

                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: false,
                                    shrinkWrap: true,
                                    primary: false,

                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * 0.1),
                                    // + 2 are the headers for each search category
                                    itemCount: searchRes_aya.length,
                                    itemBuilder: (ctx, i) {
                                      int index = i;
                                      return (searchStatus == false)
                                          ? CircularProgressIndicator()
                                          : QuranAyaSearchTiles(
                                              surahNum: HelperFunctions
                                                  .convertToArabicNumbers(
                                                      searchRes_aya[index]
                                                          .index
                                                          .toString()),
                                              ayaText:
                                                  searchRes_aya[index].text,
                                              numAya: HelperFunctions
                                                  .convertToArabicNumbers(
                                                      searchRes_aya[index]
                                                          .aya
                                                          .toString()),
                                              surahName:
                                                  searchRes_aya[index].surah,
                                              ayaPageNum:
                                                  searchRes_aya[index].page,
                                              tapHandler: tapHandlerFunc);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                // Add this
                onTap: toggleBars,
                child: showNavBar
                    ? BNavigationBar(
                        pageIndex: 0,
                        toggleBars: toggleBars,
                      )
                    : Container(),
              ),
            ),
          ],
        ));
  }
}
