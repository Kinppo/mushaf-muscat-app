import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/providers/tafsir_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/AyatLines.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';

class TafsirCarousel extends StatefulWidget {
  int goToPage;
  int? loop;
  Function toggleBars;
  int? loophighlight;
  int? GlobalCurrentPage;
  Function changeGlobal;
  TafsirCarousel({
    Key? key,
    required this.goToPage,
    this.loop,
    required this.toggleBars,
    this.loophighlight,
    required this.GlobalCurrentPage,
    required this.changeGlobal,
  }) : super(key: key);

  @override
  State<TafsirCarousel> createState() => _TafsirCarousel();
}

class _TafsirCarousel extends State<TafsirCarousel> {
  var textlist;
  // integers
  int overallid = 0;
  int currentPage = 1;
  int activeAya = -1;
  int activeIndex = 1;
  int clickedHighlightNum = 0;
  String? AyaStringNum = '';
  int prev = 0;
  //  int ayaFrom;
// bools and flags
  bool BasmalaFlag = false;
  bool cameFromMenu = false;
  bool _isInit = true;
  bool _isLoading = true;
  late bool ShowAudioPlayer;
  late bool ShowOnlyPageNum;
  bool ayaFlag = false;
  bool firstFlag = false;
  bool moveNextPage = false;
  bool closedBottomSheet = false;
  bool loopFlag = false;
// strings
  String surahName = 'الفاتحة';
  int navigatedFromBK = 0;
// lists
  late final List<String?> _surahNames;
  late final List<List<int>> _flagsForEndofSurah;
  late final List<List<String?>> _ayaNumbers;
  List<String?> ayaStrings = [];
  List<String?> ayaTafsirs = [];
  List<String> ayaNumsforThePage = [];


// controllers
  CarouselController carouselController = new CarouselController();
  CarouselController carouselController2 = new CarouselController();

//new state management
// bool pageDetails_loadAudios=false;

  @override
  void initState() {
    print("building......" + widget.GlobalCurrentPage.toString());
    final tafsirProv = Provider.of<TafsirProvider>(context, listen: false);
    if (widget.goToPage != null && widget.goToPage != 0) {
      overallid = (widget.goToPage as int) - 1;
      currentPage = (widget.goToPage as int) - 1;
      cameFromMenu = true;

      setState(() {
        navigatedFromBK = (widget.goToPage as int) - 1;

        _surahNames = tafsirProv.loadSurahs();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //initialize first tafsir page
          if (widget.goToPage != null && widget.goToPage != 0) {
    widget.changeGlobal(currentPage);

          await loadTafisrs(widget.GlobalCurrentPage!);

   }
   else {
              await loadTafisrs(1);

   }
         print("%%%%%%NAVIGATED FROM BK: $navigatedFromBK");
        print("%%%%%GLOBALLLL: " +widget.GlobalCurrentPage!.toString());

    
    });

    

   
    ShowOnlyPageNum = true;

    super.initState();
  }

  Future<void> loadTafisrs(int page) async {
    final tafsirProv = Provider.of<TafsirProvider>(context, listen: false);

     textlist = await tafsirProv.getLines(page);
      // print(textlist);
      setState(() {
ayaStrings.clear();
ayaTafsirs.clear();
        for (int i = 0; i < textlist.length; i++) {
          ayaStrings.add(textlist[i].text);
          ayaTafsirs.add(textlist[i].tafsir);
        }

        print("vvvvvvvvvvvvvvvv $ayaStrings");
        print("vvvvvvvvvvvvvvvv $ayaTafsirs");
      });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("RRRRRRRRRRRR PAGE IS " + widget.GlobalCurrentPage.toString());

    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    print("orientation is $isLandscape");

    List<int> listindex = new List<int>.generate(604, (i) => i + 1);
    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));
    return Container(
      color: CustomColors.yellow100,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: (isLandscape == false)
                ? EdgeInsets.fromLTRB(0, 155, 0, 0)
                : EdgeInsets.fromLTRB(10, 155, 10, 50),
            color: CustomColors.yellow100,
            child: CarouselSlider(
              options: CarouselOptions(

                  // height: MediaQuery.of(context).size.height,
                  height: (isLandscape == false && ShowOnlyPageNum == false)
                      ? 672
                      : (isLandscape == false && ShowOnlyPageNum == true)
                          ? 800
                          : 1400,
                  reverse: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  initialPage: (cameFromMenu == true)
                                ? widget.GlobalCurrentPage!
                                : 0,
                  //if infinite scroll is false, then initial page has to be -1 not 0
                  // (cameFromMenu == true) ? (widget.goToPage as int) - 1 : 0,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) async {
                    // await loadTafisrs();

                    setState(()  {
                      // ayaNumsforThePage.clear();

                      print("we are in next page");
                      overallid = index;
                      currentPage = index + 1;
                      // surahName = _surahNames[index]!;
                      widget.changeGlobal(currentPage);
                      print("CURRENT PAGE IS $currentPage");
                      print("the value of go to page is ....." +
                          widget.goToPage.toString());
                    });
                    await loadTafisrs(currentPage);


                  }),
              items: listofObjects.map((i) {
                int idx = listofObjects.indexOf(i);
                // print("building... $idx")

                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        ShowOnlyPageNum = !ShowOnlyPageNum;
                      },
                      child: Stack(fit: StackFit.passthrough, children: [
                        // IgnorePointer()

                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          margin: EdgeInsets.all(2),
                          child: ListView.builder(
                            // shrinkWrap: true,

                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                            itemCount: ayaStrings.length,
                            itemBuilder: (ctx, i) {
                              return Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 17),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 33),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                              ayaStrings[i].toString(),
                                              textAlign: TextAlign.right,
                                              // _ayah.ayah,
                                              style: TextStyle(
                                                  fontFamily:
                                                      'ScheherazadeNew',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 22,
                                                  color:
                                                      CustomColors.black200)),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                            color: CustomColors.yellow200,
                                            thickness: 1.3,
                                            endIndent: 18),
                                        Align(
                                          alignment: Alignment.topRight,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                          child: Text(
                                            ayaTafsirs[i].toString(),
                                            // _ayah.content,
                                            style: TextStyle(
                                                fontFamily:
                                                    'IBMPlexSansArabic',
                                                fontSize: 19,
                                                // fontWeight: FontWeight.w400,
                                                color: CustomColors.brown100),
                                          ),
                                          alignment: Alignment.topRight,
                                        ),
                                      ])),
                                  (i == ayaStrings.length - 1)
                                      ? Container(
                                          padding:
                                              EdgeInsets.only(bottom: 60),
                                          color: CustomColors.yellow100,
                                          height: (ShowOnlyPageNum == false)
                                              ? 30
                                              : 100)
                                      : Container(),
                                ],
                              );
                            },
                          ),
                        )
                      ]),
                    );
                  },
                );
              }).toList(),
              carouselController: carouselController,
            ),
          ),

          //====================PAGE INDICATOR=====================

          (ShowOnlyPageNum == false)
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      ShowOnlyPageNum = !ShowOnlyPageNum;
                      // print("what is this");
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    // margin: EdgeInsets.only(bottom: 70),
                    // padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    height: 85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: CustomColors.yellow200,
                          width: 1,
                        ),
                        color: CustomColors.yellow500),
                    child: Column(
                      children: [
                        Text(
                          surahName,
                          style: TextStyle(color: CustomColors.red300),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        CarouselSlider(
                          carouselController: carouselController2,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              // _currentIndex = index;
                              // print("INDEX IS $index");
                            },
                            height: 34.0,
                            viewportFraction: 0.16,
                            reverse: false,
                            initialPage: (cameFromMenu == true)
                                ? widget.GlobalCurrentPage!
                                : 0,
                            scrollDirection: Axis.horizontal,
                            pageSnapping: true,
                            enableInfiniteScroll: true,
                    ),
                          items: listindex.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: 50,
                                  height: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        surahName = _surahNames[i - 1]!;
                                        carouselController2
                                            .animateToPage(i - 1);
                                        carouselController.animateToPage(i - 1);
                                        // ShowOnlyPageNum=true;
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: (i - 1 == overallid)
                                                  ? CustomColors.grey200
                                                  : CustomColors.yellow200,
                                              width: 1,
                                            ),
                                            color: Colors.white),
                                        height: 30,
                                        width: 40,
                                        child: Text(
                                          HelperFunctions
                                                  .convertToArabicNumbers(
                                                      i.toString())
                                              .toString(),
                                          style: TextStyle(
                                              color: (i - 1 == overallid)
                                                  ? CustomColors.red300
                                                  : CustomColors.grey200,
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                )

              //===================PAGE NUMBER====================
              : Container(
                  // color: CustomColors.yellow100,
                  // color: Colors.red,

                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (cameFromMenu == true) {
                          // print(surahName);
                          surahName =
                              _surahNames[(widget.goToPage as int) - 1]!;
                        }
                        print("========PRESSED");

                        ShowOnlyPageNum = !ShowOnlyPageNum;
                      });
                    },
                  ),
                ),
        ]),
      ),
    );
  }
}
