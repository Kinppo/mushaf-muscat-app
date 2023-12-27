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
  int? globalCurrentPage;
  Function changeGlobal;
  bool barsOn;

  TafsirCarousel({
    super.key,
    required this.goToPage,
    this.loop,
    required this.toggleBars,
    this.loophighlight,
    required this.globalCurrentPage,
    required this.changeGlobal,
    required this.barsOn,
  });

  @override
  State<TafsirCarousel> createState() => _TafsirCarousel();
}

class _TafsirCarousel extends State<TafsirCarousel> {
  var textlist;
  int overallid = 0;
  int currentPage = 1;
  int activeAya = -1;
  int activeIndex = 1;
  int clickedHighlightNum = 0;
  String? ayaStringNum = '';
  int prev = 0;
  bool basmalaFlag = false;
  bool cameFromMenu = false;
  late bool showAudioPlayer;
  late bool showOnlyPageNum;
  bool ayaFlag = false;
  bool firstFlag = false;
  bool moveNextPage = false;
  bool closedBottomSheet = false;
  bool loopFlag = false;
  bool pageIndicatorCarouselLoaded = false;

  String surahName = 'الفاتحة';
  int navigatedFromBK = 0;
  late final List<String?> _surahNames;
  List<String?> ayaStrings = [];
  List<String?> ayaTafsirs = [];
  List<String> ayaNumsforThePage = [];

  late CarouselController carouselController;
  late CarouselController carouselController2;

  @override
  void initState() {
    final tafsirProv = Provider.of<TafsirProvider>(context, listen: false);
    if (widget.goToPage != 0) {
      overallid = (widget.goToPage) - 1;
      currentPage = (widget.goToPage) - 1;
      cameFromMenu = true;

      setState(() {
        navigatedFromBK = (widget.goToPage) - 1;
        _surahNames = tafsirProv.loadSurahs();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.goToPage != 0) {
        widget.changeGlobal(currentPage);

        await loadTafisrs(widget.globalCurrentPage!);
      } else {
        await loadTafisrs(1);
      }
    });

    showOnlyPageNum = true;

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
    List<int> listindex = List<int>.generate(604, (i) => i + 1);
    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        color: CustomColors.yellow100,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  height: size.height,
                  reverse: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  initialPage:
                      (cameFromMenu == true) ? widget.globalCurrentPage! : 0,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) async {
                    setState(() {
                      overallid = index;
                      currentPage = index + 1;
                      widget.changeGlobal(currentPage);
                      surahName = _surahNames[index]!;
                    });

                    await loadTafisrs(currentPage);
                    setState(() {
                      if (pageIndicatorCarouselLoaded == true) {
                        carouselController2.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease,
                        );
                      }
                    });
                  }),
              items: listofObjects.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          pageIndicatorCarouselLoaded = true;
                          widget.toggleBars();
                          if (widget.barsOn == true) {
                            showOnlyPageNum = true;
                          } else {
                            showOnlyPageNum = !showOnlyPageNum;
                          }
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        margin: const EdgeInsets.all(2),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          itemCount: ayaStrings.length + 1,
                          itemBuilder: (ctx, i) {
                            if (i != ayaStrings.length) {
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 17),
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 20, 25, 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(ayaStrings[i].toString(),
                                            textAlign: TextAlign.right,
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
                                      const Align(
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
                bottom: 1,
                left: 0,
                right: 0,
                child: //===================PAGE INDICATOR====================
                    (showOnlyPageNum == false)
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showOnlyPageNum = !showOnlyPageNum;
                              });
                            },
                            child: Container(
                              width: double.infinity,
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
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  CarouselSlider(
                                    carouselController: carouselController2,
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {},
                                      height: 30.0,
                                      viewportFraction: 0.13,
                                      reverse: false,
                                      initialPage: (cameFromMenu == true)
                                          ? widget.globalCurrentPage!
                                          : 0,
                                      scrollDirection: Axis.horizontal,
                                      pageSnapping: true,
                                      enableInfiniteScroll: true,
                                    ),
                                    items: listindex.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return SizedBox(
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
                if (widget.goToPage != 0) {
                  surahName = _surahNames[(widget.goToPage) - 1]!;
                } else {
                  surahName = _surahNames[0]!;
                }

                showOnlyPageNum = !showOnlyPageNum;
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
      return TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 19,
          color: CustomColors.brown100,
        ),
      );
    } else {
      final segments = <TextSpan>[];
      int lastIndex = 0;
      for (final match in matches) {
        if (match.start > lastIndex) {
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
