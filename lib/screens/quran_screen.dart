import 'package:flutter/material.dart';
import '../resources/colors.dart';
import '../utils/helper_functions.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/custom.dart';
import '../widgets/drawer.dart';
import '../widgets/final_carousell.dart';
import '../widgets/tafsir_carousel.dart';
import '../widgets/quran_aya_search_tiles.dart';
import '../widgets/quran_surah_search_tiles.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
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
  late int globalCurrentPage = 0;
  var searchResSurah = [];
  var searchResAya = [];
  String searchResCombined = '';
  bool searchStatus = false;
  String surahFrom = "الفاتحة";

  @override
  void initState() {
    setState(() {
      segmentedControlValue = 0;
      globalCurrentPage = 1;
    });

    super.initState();
  }

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

  void controlSearch(search, surahResult, ayaResult) {
    searchResSurah = [];
    searchResAya = [];
    setState(() {
      toggleSearch = search;
      searchResSurah = surahResult;
      searchResAya = ayaResult;
    });
  }

  List<Widget> getSearchTiles() {
    List<ListTile> surahResultsTiles = [];
    List<ListTile> ayaResultsTiles = [];

    for (int i = 0; i < searchResSurah.length; i++) {
      surahResultsTiles.add(ListTile(
          title: Text(
        searchResSurah[i].surahTitle.toString(),
        style: TextStyle(color: CustomColors.black200),
      )));
    }

    for (int i = 0; i < searchResAya.length; i++) {
      ayaResultsTiles.add(ListTile(
          title: Text(
        searchResAya[i].text.toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: CustomColors.black200),
      )));
    }

    List<ListTile> finalList = [];

    finalList.add(ListTile(
        title: Text(
      "السور (${searchResSurah.length})",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: CustomColors.black200),
    )));
    finalList.addAll(surahResultsTiles);
    finalList.add(ListTile(
        title: Text(
      "الايات  (${searchResAya.length})",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: CustomColors.black200),
    )));
    finalList.addAll(ayaResultsTiles);

    return (finalList.isNotEmpty)
        ? finalList
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
      surahFrom = args['v4'] as String? ?? '';
    }

    void changeGlobal(int currpage) {
      setState(() {
        globalCurrentPage = currpage;
      });
    }

    void changeSearchStatus() {
      setState(() {
        searchStatus = true;
      });
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.2),
          child: GestureDetector(
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
        drawer: const SizedBox(
          width: double.infinity,
          child: MainDrawer(),
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
                        ? FinalCarousel2(
                            goToPage: (goToPage != 0 && globalCurrentPage == 1)
                                ? goToPage
                                : globalCurrentPage,
                            loop: loop,
                            toggleBars: toggleBars,
                            loophighlight: highlighNum,
                            globalCurrentPage: globalCurrentPage,
                            changeGlobal: changeGlobal,
                            surahFrom: surahFrom,
                          )
                        : (segmentedControlValue == 1
                            ? SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: TafsirCarousel(
                                  goToPage: globalCurrentPage,
                                  loop: loop,
                                  toggleBars: toggleBars,
                                  loophighlight: highlighNum,
                                  GlobalCurrentPage: globalCurrentPage,
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
                                  "السور (${searchResSurah.length})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                      color: CustomColors.black200),
                                )),
                                SizedBox(
                                  width: double.infinity,
                                  child: ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: false,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * 0.02),
                                    itemCount: searchResSurah.length,
                                    itemBuilder: (ctx, i) {
                                      int index = i;
                                      return (searchStatus == false)
                                          ? const CircularProgressIndicator()
                                          : QuranSurahSearchTiles(
                                              num: HelperFunctions
                                                  .convertToArabicNumbers(
                                                      searchResSurah[index]
                                                          .surahNum),
                                              title: searchResSurah[index]
                                                  .surahTitle,
                                              numAya:
                                                  HelperFunctions
                                                      .convertToArabicNumbers(
                                                          searchResSurah[index]
                                                              .numOfAyas),
                                              type: searchResSurah[index]
                                                  .surahType,
                                              firstPageNum:
                                                  searchResSurah[index]
                                                      .surahPageNum,
                                              tapHandler: tapHandlerFunc);
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "الايات (${searchResAya.length})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                        color: CustomColors.black200),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: false,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * 0.1),
                                    itemCount: searchResAya.length,
                                    itemBuilder: (ctx, i) {
                                      int index = i;
                                      return (searchStatus == false)
                                          ? const CircularProgressIndicator()
                                          : QuranAyaSearchTiles(
                                              surahNum: HelperFunctions
                                                  .convertToArabicNumbers(
                                                      searchResAya[index]
                                                          .index
                                                          .toString()),
                                              ayaText: searchResAya[index].text,
                                              numAya: HelperFunctions
                                                  .convertToArabicNumbers(
                                                      searchResAya[index]
                                                          .aya
                                                          .toString()),
                                              surahName:
                                                  searchResAya[index].surah,
                                              ayaPageNum:
                                                  searchResAya[index].page,
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
