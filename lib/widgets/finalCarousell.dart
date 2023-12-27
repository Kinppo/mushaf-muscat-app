import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/providers/ayat_lines_provider.dart';

import 'package:mushafmuscat/widgets/aya_clicked_bottom_sheet.dart';
import 'package:mushafmuscat/widgets/pageDetails2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/bookmarks_provider.dart';
import '../models/aya_lines.dart';
import '../models/surah.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/surah_provider.dart';
import '../providers/tafsir_provider.dart';
import '../resources/colors.dart';
import '../utils/helper_functions.dart';
import 'pageDetails2.dart';
import '../widgets/chooseWhereToPlay.dart';

class finalCarousel2 extends StatefulWidget {
  int goToPage;
  int? loop;
  Function toggleBars;
  int? loophighlight;
  int? GlobalCurrentPage;
  Function changeGlobal;
  String surahFrom;

  finalCarousel2({
    Key? key,
    required this.goToPage,
    this.loop,
    required this.toggleBars,
    this.loophighlight,
    required int GlobalCurrentPage,
    required this.changeGlobal,
    required this.surahFrom,
  }) : super(key: key);

  @override
  State<finalCarousel2> createState() => _finalCarousel2();
}

class _finalCarousel2 extends State<finalCarousel2> {
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
  bool showPauseIcon = false;
  bool firstFlag = false;
  bool clickHighlightWhilePlaying = false;
  bool moveNextPage = false;
  late final bookMarkProvider;
  late final audioProvider;
  bool isPlaying = false;
  bool closedBottomSheet = false;
  bool seekRight = false;
  bool moreplay = false;
  bool loopFlag = false;
  bool loopFirstPage = false;
// strings
  String surahName = 'الفاتحة';
  int navigatedFromBK = 0;
// lists
  late final List<String?> _surahNames;
  late final List<List<int>> _flagsForEndofSurah;
  late final List<List<String?>> _ayaNumbers;
  final assetsAudioPlayer = AssetsAudioPlayer.withId("main");

  List<String> ayaNumsforThePage = [];
  List<Audio> audiosList = [];
  List<String> FlagsAudio = [];
  List<String> StartFlagAudio = [];

  List<int> LoopIndices = [];

// controllers
  CarouselController carouselController = CarouselController();
  CarouselController carouselController2 = CarouselController();
  final assetsAudioPlayerBasmala = AssetsAudioPlayer();

//new state management
// bool pageDetails_loadAudios=false;

  @override
  void initState() {
    AssetsAudioPlayer.withId("main").stop();

    if (widget.goToPage != null && widget.goToPage != 0) {
      overallid = (widget.goToPage as int) - 1;
      currentPage = (widget.goToPage as int) - 1;
      cameFromMenu = true;

      setState(() {
        navigatedFromBK = (widget.goToPage as int) - 1;
        // widget.changeGlobal(currentPage);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSurahs;

      setState(() {
        loadSurahs();
        if (widget.goToPage != null && widget.goToPage != 0) {
          widget.changeGlobal(currentPage + 1);
        }
      });
    });

    ShowAudioPlayer = false;
    ShowOnlyPageNum = true;

    super.initState();
  }

  void loadSurahs() {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    _surahNames = surahsData.loadSurahs();
    _flagsForEndofSurah = surahsData.loadFlags();
    _ayaNumbers = surahsData.loadAyaNum();

    // For searching through ayas
    final _AyaData =
        Provider.of<SurahProvider>(context, listen: false).fetchSurahs();
  }

  morePlayOptions() {
    setState(() {
      moreplay = true;
    });
  }

// void updateHighligh

  toggleClickedHighlight(
      int clickedIdx, String ayaS, String ayaString, String singleSurahName) {
    setState(() {
      AyaStringNum = ayaS;

      clickedHighlightNum = clickedIdx - 1;

      if (firstFlag == true) {
        clickHighlightWhilePlaying = true;
      }
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        double bottomSheetHeight = MediaQuery.of(context).size.height *
            0.7; // Set the desired percentage of the screen height
        double bottomSheetWidth = MediaQuery.of(context).size.width *
            0.96; // Set the desired percentage of the screen height

        showModalBottomSheet<void>(
          constraints: BoxConstraints(
              maxWidth: bottomSheetWidth, maxHeight: bottomSheetHeight),
          clipBehavior: Clip.hardEdge,
          backgroundColor: CustomColors.yellow100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          context: context,
          builder: (BuildContext context) {
            return AyaClickedBottomSheet(
              showAudioPlayer: togglePlayer,
              ayaNum: HelperFunctions.convertToArabicNumbers(ayaS)!,
              clickedHighlightNum: clickedHighlightNum,
              currentPage: currentPage,
              surahName: singleSurahName,
              highlightedAyaText: ayaString,
              playMoreOptions: morePlayOptions,
            );
          },
        ).whenComplete(_onBottomSheetClosed);
      });
    });
    // getAudioPaths();
  }

  void _onBottomSheetClosed() {
    setState(() {
      closedBottomSheet = true;
      if (moreplay == true) {
        bottomsheet2();
      }
    });
  }

  bottomsheet2() {
    setState(() {
      moreplay = false;
      showModalBottomSheet<void>(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: 660),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return whereToPlay();
        },
      ).whenComplete(_onBottomSheetClosed);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void handleActiveAya(int updatedAya) {
    setState(() {
      activeAya = updatedAya;
    });
  }

  handlePlayButton() async {
    carouselController.nextPage();
    carouselController2.nextPage();
    audiosList.clear();
    FlagsAudio.clear();
    StartFlagAudio.clear();
    await loadAudios(currentPage);
    clickedHighlightNum = 0;
    //                        if (loopFlag==true) {
    //  OpenPlayerLoop();
    // }
    // else {
    OpenPlayer();
  }

// }
  void handleAyaFlag() {
    setState(() {
      if (ayaFlag == false) {
        ayaFlag = true;
      }
    });
  }

  void togglePlayer() {
    // if (firstFlag == true &&
    //     clickHighlightWhilePlaying == true &&
    //     ShowAudioPlayer == true) {
    if (ShowAudioPlayer == true) {
      setState(() async {
        if (showPauseIcon == false) {
          showPauseIcon = !showPauseIcon;
        }
        if (prev != currentPage) {
          await loadAudios(currentPage + 1);

          OpenPlayer();
        } else {
          if (AyaStringNum == '1') {
            assetsAudioPlayer.pause();
            await playBasmala();
            assetsAudioPlayerBasmala.current.listen((event) {
              assetsAudioPlayerBasmala.isPlaying.listen((event2) {
                if (event2 == false) {
                  setState(() {
                    assetsAudioPlayer.playlistPlayAtIndex(clickedHighlightNum);
                  });
                }
              });
            });

            // BasmalaFlag=true;
          }
          // else {
          //   assetsAudioPlayer.playlistPlayAtIndex(clickedHighlightNum);
          // }
        }

        AudioListener();
      });
    } else {
      setState(() {
        widget.toggleBars();
        ShowAudioPlayer = true;
      });
    }
  }

  void loopFunction() async {
    //  var temp= await getInt('ayaFrom');
    int rep = await getInt("repNum") as int;

    await loadAudiosLoop(currentPage + 1, rep);

    setState(() {
      loopFlag = true;
      ShowAudioPlayer = true;

      OpenPlayerLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var Screenheight = MediaQuery.of(context).size.height;
    var Screenwidth = MediaQuery.of(context).size.width;

    setState(() {
      if (widget.goToPage != null && widget.goToPage != 0) {
        overallid = (widget.goToPage as int) - 1;
        currentPage = (widget.goToPage as int) - 1;
      } else {
        setState(() {
          cameFromMenu = false;
        });
      }
    });

    if (widget.loop == 1 && loopFlag == false) {
      loopFunction();
    }

    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final Audioplayer_Provider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    List<int> listindex = new List<int>.generate(604, (i) => i + 1);
    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      if (orientation == Orientation.landscape) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        SystemChrome.setPreferredOrientations(
          // Set your preferred orientations here
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
        );
      }

      return Stack(
          alignment: Alignment.center, // Centers all non-positioned children

          children: [
            Container(
              color: Color.fromRGBO(245, 239, 234, 1),
              margin: EdgeInsets.only(
                  top: Screenheight > 700
                      ? Screenheight * 0.17
                      : Screenheight * 0.07),
              // padding: EdgeInsets.only(top: Screenheight*0.1),
              width: MediaQuery.of(context).size.width,

              // height: MediaQuery.of(context).size.height*0.9,
              child: CarouselSlider(
                options: CarouselOptions(

                    // height: MediaQuery.of(context).size.height*0.65,
                    height: 602,
                    reverse: false,
                    viewportFraction: 1,
                    enableInfiniteScroll: true,
                    initialPage: navigatedFromBK,
                    //if infinite scroll is false, then initial page has to be -1 not 0
                    // (cameFromMenu == true) ? (widget.goToPage as int) - 1 : 0,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        // ayaNumsforThePage.clear();

                        overallid = index;
                        currentPage = index + 1;
                        widget.changeGlobal(currentPage);

                        surahName = _surahNames[index]!;

                        carouselController2.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease,
                        );
                      });
                    }),
                items: listofObjects.map((i) {
                  int idx = listofObjects.indexOf(i);

                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          ShowOnlyPageNum = !ShowOnlyPageNum;
                        },
                        child: Stack(fit: StackFit.passthrough, children: [
                          IgnorePointer(
                            child: (idx == 0 || idx == 1)
                                ? Image.asset(
                                    'assets/quran_images/images/' +
                                        (idx + 1).toString() +
                                        '.jpg',
                                    height: 300,
                                    fit: BoxFit.fitWidth,
                                    width: MediaQuery.of(context).size.width,
                                  )
                                : Image.asset(
                                    'assets/quran_images/images/' +
                                        (idx + 1).toString() +
                                        '.jpg',
                                    height: 300,
                                    fit: BoxFit.fitWidth,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                          ),
                          Positioned(
                            top: (idx == 0 || idx == 1)
                                ? 0
                                : Screenheight > 800
                                    ? -Screenheight * 0.008
                                    : Screenheight > 700
                                        ? -Screenheight * 0.03
                                        : -Screenheight * 0.0,

                            // -Screenheight*0.008,
                            // -10, // adjust this value to move your content up and down

                            child: Consumer<AudioPlayerProvider>(builder:
                                (BuildContext context, value, Widget? child) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                padding: (idx == 0 || idx == 1)
                                    ? EdgeInsets.only(top: 100)
                                    : EdgeInsets.only(right: 20),
                                // : EdgeInsets.only(top: 0.05),
                                // margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: pageDetails2(
                                  id: idx + 1,
                                  indexhighlight: activeAya,
                                  currentpage: idx + 1,
                                  ayaFlag: ayaFlag,
                                  toggleClickedHighlight:
                                      toggleClickedHighlight,
                                  clickedHighlightNum: clickedHighlightNum - 1,
                                  // clickedHighlightNum: 1,

                                  firstFlag: firstFlag,
                                  prev: prev,
                                  closedBottomSheet: closedBottomSheet,
                                  ayaNumsforThePage: ayaNumsforThePage,
                                ),
                              );
                            }),
                          ),
                        ]),
                      );
                    },
                  );
                }).toList(),
                carouselController: carouselController,
              ),
            ),
            //====================PAGE INDICATOR=====================

            (ShowAudioPlayer != true && ShowOnlyPageNum == false)
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          ShowOnlyPageNum = !ShowOnlyPageNum;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        // margin: EdgeInsets.only(top: 0),
                        // padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                              style: TextStyle(color: CustomColors.red300),
                            ),
                            SizedBox(
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
                                    ? widget.goToPage - 1
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
                                            surahName = _surahNames[i - 1]!;
                                            carouselController2
                                                .jumpToPage(i - 1);
                                            carouselController
                                                .animateToPage(i - 1);
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
                                                fontSize: 15),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                //====================AUDIOPLAYER=====================
                : (ShowAudioPlayer == true)
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          // alignment: Alignment.bottomCenter
                          margin: EdgeInsets.fromLTRB(Screenwidth * 0.02, 0,
                              Screenwidth * 0.02, Screenheight * 0.02),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            border: Border.all(
                                color: CustomColors.brown700, width: 1),
                          ),
                          width: 650,
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Material(
                                color: Colors.transparent,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                    iconSize: 30,
                                    icon: SvgPicture.asset(
                                        "assets/images/Settings.svg",
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.fitWidth),
                                    onPressed: () {}),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                    iconSize: 40,
                                    icon: SvgPicture.asset(
                                        "assets/images/Seek_right.svg",
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.fitWidth),
                                    //seek forward
                                    onPressed: () async {
                                      if (activeAya != 0 &&
                                          FlagsAudio.length > 0 &&
                                          FlagsAudio[activeAya - 1]
                                                  .toString() ==
                                              "0" &&
                                          activeAya == FlagsAudio.length - 1) {
                                        handlePlayButton();
                                      } else {
                                        assetsAudioPlayer.next();
                                      }

                                      if (showPauseIcon == false) {
                                        showPauseIcon = true;
                                      }
                                    }),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CircleAvatar(
                                backgroundColor: CustomColors.grey200,
                                maxRadius: 20,
                                child: Material(
                                  color: Colors.transparent,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                      icon: Icon(
                                        showPauseIcon
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: CustomColors.yellow100,
                                      ),
                                      iconSize: 20,
                                      onPressed: () {
                                        if (firstFlag == true) {
                                          setState(() {
                                            showPauseIcon = !showPauseIcon;
                                            assetsAudioPlayer.playOrPause();
                                          });
                                        } else if (firstFlag == false) {
                                          setState(() async {
                                            if (cameFromMenu == true) {
                                              await loadAudios(currentPage + 1);
                                            } else {
                                              await loadAudios(currentPage);
                                            }

                                            if (AyaStringNum == '1' &&
                                                    (cameFromMenu == false &&
                                                        currentPage != 1 &&
                                                        currentPage != 187) ||
                                                (cameFromMenu == true &&
                                                    currentPage != 0 &&
                                                    currentPage != 186)) {
                                              BasmalaFlag = true;
                                              await playBasmala();
                                            }

                                            firstFlag = true;
                                            showPauseIcon = true;
                                            OpenPlayer();
                                            // }
                                          });
                                        }
                                      }),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                    iconSize: 40,
                                    icon: SvgPicture.asset(
                                        "assets/images/Seek_left.svg",
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.fitWidth),
                                    //seek forward
                                    onPressed: () async {
                                      if (FlagsAudio.length > 0 &&
                                          activeAya == 0) {
                                        carouselController.previousPage();
                                        carouselController2.previousPage();
                                        audiosList.clear();
                                        FlagsAudio.clear();
                                        StartFlagAudio.clear();
                                        await loadAudios(currentPage - 1);
                                        clickedHighlightNum =
                                            FlagsAudio.length - 1;

                                        OpenPlayer();
                                      } else {
                                        assetsAudioPlayer.previous();
                                      }
                                      if (showPauseIcon == false) {
                                        showPauseIcon = true;
                                      }
                                      // initializeDuration();

                                      // assetsAudioPlayer.previous();
                                      // seekBackward = true;
                                      // Audioplayer_Provider.seekBackward();

                                      // PlayAudios();
                                    }),
                              ),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              const SizedBox(
                                width: 25,
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                    iconSize: 40,
                                    icon: SvgPicture.asset(
                                        "assets/images/exit.svg",
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.fitWidth),
                                    //seek forward
                                    onPressed: () {
                                      setState(() {
                                        ShowAudioPlayer = false;
                                        ShowOnlyPageNum = true;
                                      });
                                    }),
                              ),
                              //  SizedBox(
                              //   width: 20,
                              // ),
                            ],
                          ),
                        ),
                      )
                    //===================PAGE NUMBER====================
                    : Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (cameFromMenu == true) {
                                  surahName = _surahNames[
                                      (widget.goToPage as int) - 1]!;
                                }

                                ShowOnlyPageNum = !ShowOnlyPageNum;
                              });
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: Screenheight * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: CustomColors.yellow200,
                                  width: 1,
                                ),
                                color: Colors.white,
                              ),
                              height: 30,
                              width: 39,
                              child: Text(
                                HelperFunctions.convertToArabicNumbers(
                                  (overallid + 1).toString(),
                                ).toString(),
                                style: TextStyle(
                                  color: CustomColors.grey200,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
          ]);
    });
  }

  Future<void> playBasmala() async {
    await assetsAudioPlayerBasmala.open(
        Playlist(audios: [
          Audio.network(
              "https:\/\/everyayah.com\/data\/Minshawy_Murattal_128kbps\/001001.mp3")
        ], startIndex: 0),
        loopMode: LoopMode.none);

    //   assetsAudioPlayerBasmala.open(
    //     Audio.network("https:\/\/everyayah.com\/data\/Minshawy_Murattal_128kbps\/001001.mp3"),

    // );

// assetsAudioPlayer.dispose();

// final bool playing = assetsAudioPlayer.isPlaying.value;
    //mp3 unreachable
  }

//=========================LOOP====================
  void OpenPlayerLoop() async {
    int rep = await getInt("repNum") as int;
    int surahToLoop = await getInt("surahTo") as int;
    int ayaToLoop = await getInt("ayaTo") as int;

    AssetsAudioPlayer.withId("main").stop();

    // int? ayaToHighlight =
    //   await Provider.of<ayatLines_provider>(context, listen: false)
    //    .getAya(surahToLoop as int, ayaToLoop as int, widget.surahFrom as String);
// int? ayaToHighlight =
//       await Provider.of<ayatLines_provider>(context, listen: false)
//        .getAya(surahToLoop as int, ayaToLoop as int, SurahFrom);

    await playBasmala();
    BasmalaFlag = true;
    if (BasmalaFlag == true) {
      assetsAudioPlayerBasmala.current.listen((event) {
        assetsAudioPlayerBasmala.isPlaying.listen((event2) {
          if (event2 == false) {
            setState(() {
              assetsAudioPlayer.open(
                  Playlist(
                    audios: audiosList,
                    startIndex: (loopFirstPage == false)
                        ? widget.loophighlight! * rep
                        : 0,
                  ),
                  loopMode: LoopMode.none);

              clickedHighlightNum =
                  (loopFirstPage == false) ? widget.loophighlight! : 0;
              activeAya = clickedHighlightNum;
              ayaFlag = true;
              loopFirstPage = true;
              BasmalaFlag = false;
            });

            // assetsAudioPlayer.open(
            //     Playlist(audios: audiosList, startIndex: clickedHighlightNum),
            //     loopMode: LoopMode.none);
            // activeAya = clickedHighlightNum;

            // AudioListener();
          }
        });
      });
    }
    // setState(() {
    //   assetsAudioPlayer.open(
    //       Playlist(
    //         audios: audiosList,
    //         startIndex:
    //             (loopFirstPage == false) ? widget.loophighlight! * rep : 0,
    //       ),
    //       loopMode: LoopMode.none);
    //   // assetsAudioPlayer.toggleLoop(); //toggle the value of looping
    //   clickedHighlightNum =
    //       (loopFirstPage == false) ? widget.loophighlight! : 0;
    //   activeAya = clickedHighlightNum;
    //   ayaFlag = true;
    //   loopFirstPage = true;
    // });

    // if (ayaNumsforThePage.length==audiosList.length){
    AudioListenerLoop(surahToLoop, ayaToLoop, rep, widget.loophighlight);
    // }
  }

  void AudioListenerLoop(surahToLoop, ayaToLoop, rep, ayaToHighlight) {
// if (assetsAudioPlayer.isPlaying== false){
//   return;
// }
    assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;
      activeAya = ayaToHighlight;

      setState(() {
        if (asset != null) {
          isPlaying = true;
        }

        // handleActiveAya(LoopIndices[playingAudio.index]-1);
        activeAya = LoopIndices[playingAudio.index];
        // handleAyaFlag();

        // handleActiveAya(LoopIndices[playingAudio.index]);

//fixes repition of basmala when repeating the first ayats between surahs
        if (StartFlagAudio[playingAudio.index] == "1") {
          for (int i = 0; i < rep; i++) {
            int c = i + 1;
            StartFlagAudio[playingAudio.index + c] = "0";
          }
        }
      });
//Check if we started a new surah
      if (StartFlagAudio[playingAudio.index] == "1") {
        // assetsAudioPlayer.playlistAudioFinished.listen((event) {
        //   if (event.) {

        assetsAudioPlayer.pause().then((value) async {
          var tempAudioPlayer = AssetsAudioPlayer();

          try {
            await tempAudioPlayer.open(Audio.network(
                "https:\/\/everyayah.com\/data\/Minshawy_Murattal_128kbps\/001001.mp3"));
          } catch (t) {}

// assetsAudioPlayerBasmala.open(
//               Playlist(audios: [
//                 Audio.network(
//                     "https:\/\/everyayah.com\/data\/Minshawy_Murattal_128kbps\/001001.mp3")
//               ], startIndex: 0),
//               loopMode: LoopMode.none);

//           assetsAudioPlayerBasmala.playlistFinished.listen((event) {
//             if (event == true) {
//               assetsAudioPlayer.play();
//             }
//           });
          tempAudioPlayer.current.listen((event) {
            tempAudioPlayer.isPlaying.listen((event2) {
              if (event2 == false) {
                assetsAudioPlayer.play();
              }
            });
          });

//          assetsAudioPlayerBasmala.open(
//         Audio.network("https:\/\/everyayah.com\/data\/Minshawy_Murattal_128kbps\/001001.mp3")
// );
// //  playBasmala();
// BasmalaFlag=true;
// if (BasmalaFlag==true ) {
//  assetsAudioPlayerBasmala.current.listen((event) {
//         assetsAudioPlayerBasmala.isPlaying.listen((event2) {
//           if (event2 == false) {
//             // setState(() {

//               assetsAudioPlayer.play();

//     // });
//           // assetsAudioPlayerBasmala.open(
//           //     Playlist(audios: [
//           //       Audio.network(
//           //           "https:\/\/everyayah.com\/data\/Minshawy_Murattal_128kbps\/001001.mp3")
//           //     ], startIndex: 0),
//           //     loopMode: LoopMode.none);

//           // assetsAudioPlayerBasmala.playlistFinished.listen((event) {
//           //   if (event == true) {
//           //     assetsAudioPlayer.play();
//           //   }
//           // });

// // assetsAudioPlayerBasmala.current.listen((event) {
// //   var asset= event!.audio;
// //               assetsAudioPlayerBasmala.isPlaying.listen((event2) {
// //                 if (event2 == true) {
// //                 }});});

//         }});});
// }}
        });
      }
      setState(() {
        if (playingAudio.index != 0 &&
            (currentPage) == surahToLoop &&
            ayaToHighlight == LoopIndices[playingAudio.index - 1] &&
            ayaToHighlight != LoopIndices[playingAudio.index]) {
          //todo: condition if surahTo = surahFrom
          assetsAudioPlayer.pause();
          activeAya = LoopIndices[playingAudio.index] - 1;
        }
        if (playingAudio.index != 0 &&
            (currentPage + 1) == surahToLoop &&
            ayaToHighlight == LoopIndices[playingAudio.index - 1] &&
            ayaToHighlight != LoopIndices[playingAudio.index]) {
          //todo: condition if surahTo = surahFrom
          assetsAudioPlayer.pause();
          activeAya = LoopIndices[playingAudio.index] - 1;
        }

        if (playingAudio.index != 0 &&
            FlagsAudio.length > 0 &&
            playingAudio.index == FlagsAudio.length - 1) {
          assetsAudioPlayer.playlistFinished.listen((finished) async {
            //todo: condition if surahTo = surahFrom
            if (finished == true) {
              if ((currentPage + 1) != surahToLoop) {
                carouselController.nextPage();
                //  carouselController2.nextPage();
                LoopIndices.clear();

                audiosList.clear();
                FlagsAudio.clear();
                StartFlagAudio.clear();

                clickedHighlightNum = 0;
                await loadAudiosLoop(currentPage + 2, rep);

                // AudioListenerLoop(surahToLoop, ayaToLoop, rep);
                OpenPlayerLoop();
              }
              //       carouselController.nextPage();
              //       carouselController2.nextPage();
              //       audiosList.clear();
              //       FlagsAudio.clear();
              //       await loadAudios(currentPage + 1);
              //       clickedHighlightNum = 0;
              //       if (loopFlag==true) {
              //          OpenPlayerLoop();
              //       }
              //       else {OpenPlayer();}
            }
          });
        }
      });
      return;
    });
  }

  Future<void> loadAudiosLoop(page, rep) async {
    int pageFrom = await getInt("surahFrom") as int;
    int pageTo = await getInt("surahTo") as int;

    var audddd = await Provider.of<AudioPlayerProvider>(context, listen: false)
        .getAudioPaths(page);

    var flagsss = await Provider.of<AudioPlayerProvider>(context, listen: false)
        .flagsAudio;
    // _ayaNumbers = surahsData.loadAyaNum();
    var startflags =
        await Provider.of<AudioPlayerProvider>(context, listen: false)
            .startFlagAudio;

    List<Audio> loopPlaylist = [];
    List<String> loopFlags = [];
    List<String> loopStartFlags = [];

    List<int> loopIndices = [];

//todo: check if this is the first page
    if (page == pageFrom) {
// audddd =audddd.sublist(widget.loophighlight!);
    }

    int temp = 0;

    for (int i = 0; i < audddd.length; i++) {
      for (int j = 0; j < rep; j++) {
        loopFlags.add(flagsss[i]);
        loopStartFlags.add(startflags[i]);

        loopPlaylist.add(audddd[i]);
        loopIndices.add(temp);
      }
      temp = temp + 1;
    }

    setState(() {
      clickedHighlightNum = 0;
      activeAya = 0;
      FlagsAudio = loopFlags;
      StartFlagAudio = loopStartFlags;
      prev = page;
      LoopIndices = loopIndices;
      audiosList = loopPlaylist;
    });
  }

//==================================

  void OpenPlayer() async {
// if (AyaStringNum=='1' ) {
//   setState(() {
//     returning=false;
//   });
    // await  playBasmala();
// }

    // if (AyaStringNum == '1' &&
    //         (cameFromMenu == false && currentPage != 1 && currentPage != 187) ||
    //     (cameFromMenu == true && currentPage != 0 && currentPage != 186)) {
    if (BasmalaFlag == true) {
      assetsAudioPlayerBasmala.current.listen((event) {
        assetsAudioPlayerBasmala.isPlaying.listen((event2) {
          if (event2 == false) {
            setState(() {
              assetsAudioPlayer.open(
                  Playlist(audios: audiosList, startIndex: clickedHighlightNum),
                  loopMode: LoopMode.none);
              activeAya = clickedHighlightNum;
              ayaFlag = true;
              BasmalaFlag = false;
            });
            AudioListener();
          }
        });
      });
    } else {
      setState(() {
        assetsAudioPlayer.open(
            Playlist(audios: audiosList, startIndex: clickedHighlightNum),
            loopMode: LoopMode.none);
        activeAya = clickedHighlightNum;
        ayaFlag = true;
      });
      AudioListener();
    }
//  if (assetsAudioPlayerBasmala.isPlaying ==true) {
//  }
  }

  Future<void> loadAudios(page) async {
    var audddd = await Provider.of<AudioPlayerProvider>(context, listen: false)
        .getAudioPaths(page);

    var flagsss = await Provider.of<AudioPlayerProvider>(context, listen: false)
        .flagsAudio;
    var startflags =
        await Provider.of<AudioPlayerProvider>(context, listen: false)
            .startFlagAudio;

    setState(() {
      FlagsAudio = flagsss;
      StartFlagAudio = startflags;
      prev = page;

      audiosList = audddd;
    });
  }

  dynamic getInt(key) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int? _res = prefs.getInt("$key");
    return _res;
  }

  void AudioListener() {
// if (assetsAudioPlayer.isPlaying== false){
//   return;
// }
    assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;

      setState(() {
        if (asset != null) {
          isPlaying = true;
        }

        handleActiveAya(playingAudio.index);
        activeAya = playingAudio.index;
        handleAyaFlag();

        handleActiveAya(playingAudio.index);
        if (playingAudio.index != 0 &&
            FlagsAudio.length > 0 &&
            FlagsAudio[playingAudio.index - 1] == '1') {
//     assetsAudioPlayer.playlistAudioFinished.listen((Playing playing){
// });
          assetsAudioPlayer.pause();
          showPauseIcon = false;
        }

        if (playingAudio.index != 0 &&
            FlagsAudio.length > 0 &&
            FlagsAudio[playingAudio.index].toString() == "0" &&
            playingAudio.index == FlagsAudio.length - 1) {
          assetsAudioPlayer.playlistFinished.listen((finished) async {
            if (finished == true) {
              carouselController.nextPage();
              carouselController2.nextPage();
              audiosList.clear();
              FlagsAudio.clear();
              await loadAudios(currentPage + 1);
              clickedHighlightNum = 0;
              // isPlaying = false;

              OpenPlayer();
            }
          });
        }
      });
      return;
    });
  }
}
