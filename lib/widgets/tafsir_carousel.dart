import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/providers/tafsir_provider.dart';
import 'package:provider/provider.dart';
import '../models/aya_lines.dart';
import '../resources/colors.dart';
import '../utils/helper_functions.dart';

class TafsirCarousel extends StatefulWidget {
  int goToPage;
  int? loop;
  Function toggleBars;
  int? loophighlight;
  int? GlobalCurrentPage;
  Function changeGlobal;
  bool barsOn;
  TafsirCarousel({
    Key? key,
    required this.goToPage,
    this.loop,
    required this.toggleBars,
    this.loophighlight,
    required this.GlobalCurrentPage,
    required this.changeGlobal,
    required this.barsOn,
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
  bool pageIndicatorCarouselLoaded = false;

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
  late CarouselController carouselController;
  late CarouselController carouselController2;
//new state management
// bool pageDetails_loadAudios=false;

  @override
  void initState() {
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
      } else {
        await loadTafisrs(1);
      }
    });

    ShowOnlyPageNum = true;

    super.initState();
    carouselController = CarouselController();
    carouselController2 = CarouselController();
  }

  Future<void> loadTafisrs(int page) async {
    final tafsirProv = Provider.of<TafsirProvider>(context, listen: false);

    textlist = await tafsirProv.getLines(page);
    setState(() {
      ayaStrings.clear();
      ayaTafsirs.clear();
      for (int i = 0; i < textlist.length; i++) {
        ayaStrings.add(textlist[i].text);
        ayaTafsirs.add(textlist[i].tafsir);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var Screenheight = MediaQuery.of(context).size.height;
    var Screenwidth = MediaQuery.of(context).size.width;

    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    List<int> listindex = new List<int>.generate(604, (i) => i + 1);
    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));
    return Column(children: [
      Container(
        // height: (ShowOnlyPageNum == false) ? 720 : 750,
        width: MediaQuery.of(context).size.width,
        // margin: (isLandscape == false)
        //     ? EdgeInsets.fromLTRB(0, Screenheight*0.05, 0, Screenheight*0.08)
        //     : EdgeInsets.fromLTRB(10, 50, 10, 50),
        color: CustomColors.yellow100,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(

                  // height: MediaQuery.of(context).size.height,
                  // height: (isLandscape == false && ShowOnlyPageNum == false)
                  //     ? 672
                  //     : (isLandscape == false && ShowOnlyPageNum == true)
                  //         ? 800
                  //         : 1400,
                  height: size.height,
                  reverse: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  initialPage:
                      (cameFromMenu == true) ? widget.GlobalCurrentPage! : 0,
                  //if infinite scroll is false, then initial page has to be -1 not 0
                  // (cameFromMenu == true) ? (widget.goToPage as int) - 1 : 0,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) async {
                    // await loadTafisrs();

                    setState(() {
                      // ayaNumsforThePage.clear();

                      overallid = index;
                      currentPage = index + 1;
                      // surahName = _surahNames[index]!;
                      widget.changeGlobal(currentPage);
                      surahName = _surahNames[index]!;
                    });

                    await loadTafisrs(currentPage);
                    setState(() {
                      if (pageIndicatorCarouselLoaded == true) {
                        carouselController2.animateToPage(
                          index,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.ease,
                        );

                        //  carouselController2.jumpToPage(
                        //                     index,

                        //                   );
                      }
                    });
                  }),
              items: listofObjects.map((i) {
                int idx = listofObjects.indexOf(i);

                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          pageIndicatorCarouselLoaded = true;
                          widget.toggleBars();
                          if (widget.barsOn == true) {
                            ShowOnlyPageNum = true;
                          } else {
                            ShowOnlyPageNum = !ShowOnlyPageNum;
                          }
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        margin: EdgeInsets.all(2),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          itemCount: ayaStrings.length + 1,
                          itemBuilder: (ctx, i) {
                            if (i != ayaStrings.length) {
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 17),
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 20, 25, 10),
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal: 22, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(ayaStrings[i].toString(),
                                            textAlign: TextAlign.right,
                                            // _ayah.ayah,
                                            style: TextStyle(
                                                fontFamily: 'ScheherazadeNew',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 22,
                                                color: CustomColors.black200)),
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
                                        child: RichText(
                                          text: _getHighlightedTextSpan(
                                              ayaTafsirs[i].toString()),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  // (i == ayaStrings.length - 1)
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              carouselController: carouselController,
            ),
            Positioned(
                bottom: 1, // you can adjust this value
                left: 0,
                right: 0,
                child: //===================PAGE INDICATOR====================
                    (ShowOnlyPageNum == false)
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                ShowOnlyPageNum = !ShowOnlyPageNum;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              // margin: EdgeInsets.only(bottom: 70),
                              // : EdgeInsets.fromLTRB(0, 0, 0, 10),
                              height: 70,

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
                                    style:
                                        TextStyle(color: CustomColors.red300),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  CarouselSlider(
                                    carouselController: carouselController2,
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        // setState(() {
                                        //                               pageIndicatorCarouselLoaded=true;

                                        // });
                                        // _currentIndex = index;
                                      },
                                      height: 30.0,
                                      viewportFraction: 0.13,
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
                                            width: 40,
                                            height: 2,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  surahName =
                                                      _surahNames[i - 1]!;
                                                  carouselController2
                                                      .animateToPage(i - 1);
                                                  carouselController
                                                      .animateToPage(i - 1);
                                                  // ShowOnlyPageNum=true;
                                                });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color:
                                                            (i - 1 == overallid)
                                                                ? CustomColors
                                                                    .grey200
                                                                : CustomColors
                                                                    .yellow200,
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
                                                        color:
                                                            (i - 1 == overallid)
                                                                ? CustomColors
                                                                    .red300
                                                                : CustomColors
                                                                    .grey200,
                                                        fontSize: 15),
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
                        : _getPageNumber())
          ],
        ),
      ),
      // Container(color: Colors.red, height:300),
    ]);
  }

  Center _getPageNumber() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (cameFromMenu == true) {
                if (widget.goToPage as int != 0) {
                  surahName = _surahNames[(widget.goToPage as int) - 1]!;
                } else {
                  surahName = _surahNames[0]!;
                }

                ShowOnlyPageNum = !ShowOnlyPageNum;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: CustomColors.yellow200,
                  width: 1,
                ),
                color: Colors.white),
            height: 30,
            width: 39,
            child: Text(
              HelperFunctions.convertToArabicNumbers((overallid + 1).toString())
                  .toString(),
              style: TextStyle(color: CustomColors.grey200, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _getHighlightedTextSpan(String text) {
    final braceRegExp = RegExp(r'\{[^\}]+\}');
    final matches = braceRegExp.allMatches(text);

    if (matches.isEmpty) {
      // no curly braces found, return a single TextSpan
      return TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 19,
          color: CustomColors.brown100,
        ),
      );
    } else {
      // split the text into segments, alternating between curly brace segments
      // (to be highlighted) and non-curly brace segments (to be displayed normally)
      final segments = <TextSpan>[];
      int lastIndex = 0;
      for (final match in matches) {
        if (match.start > lastIndex) {
          // add a normal segment
          final normalText = text.substring(lastIndex, match.start);
          segments.add(TextSpan(
            text: normalText,
            style: TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontSize: 19,
              color: CustomColors.brown100,
            ),
          ));
        }
        // add a highlighted segment
        final braceText = text.substring(match.start, match.end);
        segments.add(TextSpan(
          text: braceText,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 19,
            color: CustomColors.green300,
          ),
        ));
        lastIndex = match.end;
      }
      // add the last normal segment (if any)
      if (lastIndex < text.length) {
        final normalText = text.substring(lastIndex);
        segments.add(TextSpan(
          text: normalText,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            fontSize: 19,
            color: CustomColors.brown100,
          ),
        ));
      }
      return TextSpan(children: segments);
    }
  }
}
