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
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../widgets/finalCarousel2.dart';
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
  // int searchListLength=0;
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
  //    print(surahsData.ayaas);

  // }

  void controlSegment(segment) {
    setState(() {
      segmentedControlValue = segment;
      print("segmentedControlValue $segmentedControlValue");
    });
  }

  void tapHandlerFunc(String page) {
    print(page);
    setState(() {
      goToPage = int.parse(page);
    });
    print("go to page $page");
    Navigator.of(context).popAndPushNamed(
      QuranScreen.routeName,
      arguments: {
        'v1': goToPage,
        'v2': 0,
      },
    );
    // });
  }

  void controlSearch(search, surah_result, aya_result) {
    searchRes_surah = [];
    searchRes_aya = [];
// searchRes_combined=[];
    setState(() {
      toggleSearch = search;
      // print("toggleSearch $toggleSearch");
      // print(result.toList().toString());

      searchRes_surah = surah_result;
      searchRes_aya = aya_result;

      // searchRes_combined.addAll(surah_result);
      // searchRes_combined.addAll(aya_result);

      // searchListLength= searchRes_surah.length+searchRes_aya.length;
    });
  }

  List<Widget> getSearchTiles() {
    List<ListTile> SurahResultsTiles = [];
    List<ListTile> AyaResultsTiles = [];

    for (int i = 0; i < searchRes_surah.length; i++) {
      SurahResultsTiles.add(ListTile(
          title: Text(
        searchRes_surah[i].surahTitle.toString(),
        style: TextStyle(color: CustomColors.black200),
      )));
    }

    for (int i = 0; i < searchRes_aya.length; i++) {
      AyaResultsTiles.add(ListTile(
          title: Text(
        searchRes_aya[i].text.toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: CustomColors.black200),
      )));
    }

    List<ListTile> FinalList = [];

    FinalList.add(ListTile(
        title: Text(
      "السور (" + searchRes_surah.length.toString() + ")",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: CustomColors.black200),
    )));
    FinalList.addAll(SurahResultsTiles);
    FinalList.add(ListTile(
        title: Text(
      "الايات  (" + searchRes_aya.length.toString() + ")",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: CustomColors.black200),
    )));
    FinalList.addAll(AyaResultsTiles);

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
    print("WIDGET GLOBAL IS +" + GlobalCurrentPage.toString());
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var Screenheight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;

    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    if (arg != null) {
      goToPage = arg['v1'] as int;
      loop = arg['v2'] as int;
      highlighNum = arg['v3'] as int;
      SurahFrom = arg['v4'] as String;

      print("ARGSSSS: " + arg.toString());
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

      appBar: showAppBar
          ? appBar(
              segmentedControlValue: controlSegment,
              orientationPotrait: orientationPotrait,
              toggleSearch: controlSearch,
              h: (isLandscape == false) ? Screenheight * 0.18 : 200,
              segmentToggle: segmentedControlValue,
              changeSearchStatus: changeSearchStatus,
              toggleBars: toggleBars,
            )
          : PreferredSize(
              child: Container(),
              preferredSize: const Size(0.0, 0.0),
            ),
      bottomNavigationBar: showNavBar
          ? BNavigationBar(
              pageIndex: 0,
              toggleBars: toggleBars,
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
        physics: (toggleSearch != true)
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics(),
        child: Column(children: <Widget>[
          (toggleSearch != true)
              ? GestureDetector(

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
                                  goToPage:
                                      (goToPage != 0 && GlobalCurrentPage == 1)
                                          ? goToPage
                                          : GlobalCurrentPage,
                                  loop: loop,
                                  toggleBars: toggleBars,
                                  loophighlight: highlighNum,
                                  GlobalCurrentPage: GlobalCurrentPage,
                                  changeGlobal: changeGlobal,
                                  surahFrom: SurahFrom,
                                ),
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
                                child: TafsirCarousel(
                                  goToPage: GlobalCurrentPage,
                                  loop: loop,
                                  toggleBars: toggleBars,
                                  loophighlight: highlighNum,
                                  GlobalCurrentPage: GlobalCurrentPage,
                                  changeGlobal: changeGlobal,
                                  barsOn: showNavBar,
                                ),
                                // Text(AppLocalizations.of(context)!
                                //     .translate('tafsir_text')
                                //     .toString()),
                              ),
                            )
                          : Container(
                              height: 400,
                              child: Text("test"),
                              color: CustomColors.red200,
                            ),
                  onTap: () {
                    toggleBars();
                  })
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: Screenheight * 0.22),
                        width: double.infinity,
                      ),
                      ListTile(
                          title: Text(
                        "السور (" + searchRes_surah.length.toString() + ")",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: CustomColors.black200),
                      )),
                      Container(
                        // height: Screenheight,
                        width: double.infinity,
                        child: ListView.builder(
                          //  itemExtent: 200,

                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: false,
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 20),
                          // + 2 are the headers for each search category
                          itemCount: searchRes_surah.length,
                          itemBuilder: (ctx, i) {
                            int index = i;
                            return (searchStatus == false)
                                ? CircularProgressIndicator()
                                : QuranSurahSearchTiles(
                                    num: HelperFunctions.convertToArabicNumbers(
                                        searchRes_surah[index].surahNum),
                                    title: searchRes_surah[index].surahTitle,
                                    numAya:
                                        HelperFunctions.convertToArabicNumbers(
                                            searchRes_surah[index].numOfAyas),
                                    type: searchRes_surah[index].surahType,
                                    firstPageNum:
                                        searchRes_surah[index].surahPageNum,
                                    tapHandler: tapHandlerFunc);
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "الايات (" + searchRes_aya.length.toString() + ")",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              color: CustomColors.black200),
                        ),
                      ),
                      Container(
                        // height: Screenheight,
                        width: double.infinity,
                        child: ListView.builder(
                          //  itemExtent: 200,

                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: false,
                          shrinkWrap: true,
                          primary: false,

                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10),
                          // + 2 are the headers for each search category
                          itemCount: searchRes_aya.length,
                          itemBuilder: (ctx, i) {
                            int index = i;
                            return (searchStatus == false)
                                ? CircularProgressIndicator()
                                : QuranAyaSearchTiles(
                                    surahNum: HelperFunctions.convertToArabicNumbers(
                                        searchRes_aya[index].index.toString()),
                                    ayaText: searchRes_aya[index].text,
                                    numAya:
                                        HelperFunctions.convertToArabicNumbers(
                                            searchRes_aya[index].aya.toString()),
                                    surahName: searchRes_aya[index].surah,
                                    ayaPageNum:
                                        searchRes_aya[index].page,
                                    tapHandler: tapHandlerFunc);
                          //  : ListTile(
                          //       title: Text(
                          //       searchRes_aya[index].text.toString(),
                          //       overflow: TextOverflow.ellipsis,
                          //       style:
                          //           TextStyle(color: CustomColors.black200),
                          //     ));
                          },
                        ),
                      ),
                    ],
                  ),
                )
        ]),
      ),
    );
  }
}

// ListView.builder(
//                         padding: const EdgeInsets.only(top: 20),
//                         itemCount: _surah_search_results.length,
//                         itemBuilder: (ctx, i) {
//                           return Column(
//                             children: [
//                               buildSurahListTile(
//                                 HelperFunctions.convertToArabicNumbers(
//                                     _surah_search_results[i].surahNum),
//                                 _surah_search_results[i].surahTitle,
//                                 HelperFunctions.convertToArabicNumbers(
//                                     _surah_search_results[i].numOfAyas),
//                                 _surah_search_results[i].surahType,
//                                 _surah_search_results[i].surahPageNum,
//                                tapHandlerFunc,
//                               ),
//                               const Divider(
//                                 height: 20,
//                               )
//                             ],
//                           );
//                         },
//                       )