import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/widgets/aya_clicked_bottom_sheet.dart';
import 'package:mushafmuscat/widgets/page_details2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/aya_lines.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';
import '../utils/helper_functions.dart';
import 'choose_where_to_play.dart';

class FinalCarousel2 extends StatefulWidget {
  int goToPage;
  int? loop;
  Function toggleBars;
  int? loophighlight;
  int? globalCurrentPage;
  Function changeGlobal;
  String surahFrom;

  FinalCarousel2({
    Key? key,
    required this.goToPage,
    this.loop,
    required this.toggleBars,
    this.loophighlight,
    required int globalCurrentPage,
    required this.changeGlobal,
    required this.surahFrom,
  }) : super(key: key);

  @override
  State<FinalCarousel2> createState() => _FinalCarousel2();
}

class _FinalCarousel2 extends State<FinalCarousel2> {
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

  String surahName = 'الفاتحة';
  int navigatedFromBK = 0;
  late final List<String?> _surahNames;
  final assetsAudioPlayer = AssetsAudioPlayer.withId("main");

  List<String> ayaNumsforThePage = [];
  List<Audio> audiosList = [];
  List<String> flagsAudio = [];
  List<String> startFlagAudio = [];
  List<int> loopIndicesList = [];

  CarouselController carouselController = CarouselController();
  CarouselController carouselController2 = CarouselController();
  final assetsAudioPlayerBasmala = AssetsAudioPlayer();

  @override
  void initState() {
    AssetsAudioPlayer.withId("main").stop();

    if (widget.goToPage != 0) {
      overallid = (widget.goToPage) - 1;
      currentPage = (widget.goToPage) - 1;
      cameFromMenu = true;

      setState(() {
        navigatedFromBK = (widget.goToPage) - 1;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadSurahs;

      setState(() {
        loadSurahs();
        if (widget.goToPage != 0) {
          widget.changeGlobal(currentPage + 1);
        }
      });
    });

    showAudioPlayer = false;
    showOnlyPageNum = true;

    super.initState();
  }

  void loadSurahs() {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    _surahNames = surahsData.loadSurahs();
  }

  morePlayOptions() {
    setState(() {
      moreplay = true;
    });
  }

  toggleClickedHighlight(
      int clickedIdx, String ayaS, String ayaString, String singleSurahName) {
    setState(() {
      ayaStringNum = ayaS;

      clickedHighlightNum = clickedIdx - 1;

      if (firstFlag == true) {
        clickHighlightWhilePlaying = true;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        double bottomSheetHeight = MediaQuery.of(context).size.height * 0.7;
        double bottomSheetWidth = MediaQuery.of(context).size.width * 0.96;

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
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 660),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return const WhereToPlay();
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
    flagsAudio.clear();
    startFlagAudio.clear();
    await loadAudios(currentPage);
    clickedHighlightNum = 0;
    openPlayer();
  }

  void handleAyaFlag() {
    setState(() {
      if (ayaFlag == false) {
        ayaFlag = true;
      }
    });
  }

  void togglePlayer() {
    if (showAudioPlayer == true) {
      setState(() async {
        if (showPauseIcon == false) {
          showPauseIcon = !showPauseIcon;
        }
        if (prev != currentPage) {
          await loadAudios(currentPage + 1);

          openPlayer();
        } else {
          if (ayaStringNum == '1') {
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
          }
        }

        audioListener();
      });
    } else {
      setState(() {
        widget.toggleBars();
        showAudioPlayer = true;
      });
    }
  }

  void loopFunction() async {
    int rep = await getInt("repNum") as int;
    await loadAudiosLoop(currentPage + 1, rep);
    setState(() {
      loopFlag = true;
      showAudioPlayer = true;
      openPlayerLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    setState(() {
      if (widget.goToPage != 0) {
        overallid = (widget.goToPage) - 1;
        currentPage = (widget.goToPage) - 1;
      } else {
        setState(() {
          cameFromMenu = false;
        });
      }
    });

    if (widget.loop == 1 && loopFlag == false) {
      loopFunction();
    }

    List<int> listindex = List<int>.generate(604, (i) => i + 1);
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
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
        );
      }

      return Stack(alignment: Alignment.center, children: [
        Container(
          color: const Color.fromRGBO(245, 239, 234, 1),
          margin: EdgeInsets.only(
              top: screenheight > 700
                  ? screenheight * 0.17
                  : screenheight * 0.07),
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            options: CarouselOptions(
                height: 602,
                reverse: false,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                initialPage: navigatedFromBK,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
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
                      showOnlyPageNum = !showOnlyPageNum;
                    },
                    child: Stack(fit: StackFit.passthrough, children: [
                      IgnorePointer(
                        child: (idx == 0 || idx == 1)
                            ? Image.asset(
                                'assets/quran_images/images/${idx + 1}.jpg',
                                height: 300,
                                fit: BoxFit.fitWidth,
                                width: MediaQuery.of(context).size.width,
                              )
                            : Image.asset(
                                'assets/quran_images/images/${idx + 1}.jpg',
                                height: 300,
                                fit: BoxFit.fitWidth,
                                width: MediaQuery.of(context).size.width,
                              ),
                      ),
                      Positioned(
                        top: (idx == 0 || idx == 1)
                            ? 0
                            : screenheight > 800
                                ? -screenheight * 0.008
                                : screenheight > 700
                                    ? -screenheight * 0.03
                                    : -screenheight * 0.0,
                        child: Consumer<AudioPlayerProvider>(builder:
                            (BuildContext context, value, Widget? child) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: (idx == 0 || idx == 1)
                                ? const EdgeInsets.only(top: 100)
                                : const EdgeInsets.only(right: 20),
                            child: PageDetails2(
                              id: idx + 1,
                              indexhighlight: activeAya,
                              currentpage: idx + 1,
                              ayaFlag: ayaFlag,
                              toggleClickedHighlight: toggleClickedHighlight,
                              clickedHighlightNum: clickedHighlightNum - 1,
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

        (showAudioPlayer != true && showOnlyPageNum == false)
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
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
                          style: TextStyle(color: CustomColors.red300),
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
                                ? widget.goToPage - 1
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
                                        surahName = _surahNames[i - 1]!;
                                        carouselController2.jumpToPage(i - 1);
                                        carouselController.animateToPage(i - 1);
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
                                        HelperFunctions.convertToArabicNumbers(
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
            : (showAudioPlayer == true)
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(screenwidth * 0.02, 0,
                          screenwidth * 0.02, screenheight * 0.02),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        border:
                            Border.all(color: CustomColors.brown700, width: 1),
                      ),
                      width: 650,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
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
                                onPressed: () async {
                                  if (activeAya != 0 &&
                                      flagsAudio.isNotEmpty &&
                                      flagsAudio[activeAya - 1].toString() ==
                                          "0" &&
                                      activeAya == flagsAudio.length - 1) {
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

                                        if (ayaStringNum == '1' &&
                                                (cameFromMenu == false &&
                                                    currentPage != 1 &&
                                                    currentPage != 187) ||
                                            (cameFromMenu == true &&
                                                currentPage != 0 &&
                                                currentPage != 186)) {
                                          basmalaFlag = true;
                                          await playBasmala();
                                        }

                                        firstFlag = true;
                                        showPauseIcon = true;
                                        openPlayer();
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
                                onPressed: () async {
                                  if (flagsAudio.isNotEmpty && activeAya == 0) {
                                    carouselController.previousPage();
                                    carouselController2.previousPage();
                                    audiosList.clear();
                                    flagsAudio.clear();
                                    startFlagAudio.clear();
                                    await loadAudios(currentPage - 1);
                                    clickedHighlightNum = flagsAudio.length - 1;

                                    openPlayer();
                                  } else {
                                    assetsAudioPlayer.previous();
                                  }
                                  if (showPauseIcon == false) {
                                    showPauseIcon = true;
                                  }
                                }),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: IconButton(
                                iconSize: 40,
                                icon: SvgPicture.asset("assets/images/exit.svg",
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fitWidth),
                                onPressed: () {
                                  setState(() {
                                    showAudioPlayer = false;
                                    showOnlyPageNum = true;
                                  });
                                }),
                          ),
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
                              surahName = _surahNames[(widget.goToPage) - 1]!;
                            }

                            showOnlyPageNum = !showOnlyPageNum;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: screenheight * 0.01),
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
              "https://everyayah.com/data/Minshawy_Murattal_128kbps/001001.mp3")
        ], startIndex: 0),
        loopMode: LoopMode.none);
  }

//=========================LOOP====================
  void openPlayerLoop() async {
    int rep = await getInt("repNum") as int;
    int surahToLoop = await getInt("surahTo") as int;
    int ayaToLoop = await getInt("ayaTo") as int;
    AssetsAudioPlayer.withId("main").stop();

    await playBasmala();
    basmalaFlag = true;
    if (basmalaFlag == true) {
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
              basmalaFlag = false;
            });
          }
        });
      });
    }
    audioListenerLoop(surahToLoop, ayaToLoop, rep, widget.loophighlight);
  }

  void audioListenerLoop(surahToLoop, ayaToLoop, rep, ayaToHighlight) {
    assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;
      activeAya = ayaToHighlight;

      setState(() {
        isPlaying = true;
        activeAya = loopIndicesList[playingAudio.index];
        if (startFlagAudio[playingAudio.index] == "1") {
          for (int i = 0; i < rep; i++) {
            int c = i + 1;
            startFlagAudio[playingAudio.index + c] = "0";
          }
        }
      });
      if (startFlagAudio[playingAudio.index] == "1") {
        assetsAudioPlayer.pause().then((value) async {
          var tempAudioPlayer = AssetsAudioPlayer();
          await tempAudioPlayer.open(Audio.network(
              "https://everyayah.com/data/Minshawy_Murattal_128kbps/001001.mp3"));

          tempAudioPlayer.current.listen((event) {
            tempAudioPlayer.isPlaying.listen((event2) {
              if (event2 == false) {
                assetsAudioPlayer.play();
              }
            });
          });
        });
      }
      setState(() {
        if (playingAudio.index != 0 &&
            (currentPage) == surahToLoop &&
            ayaToHighlight == loopIndicesList[playingAudio.index - 1] &&
            ayaToHighlight != loopIndicesList[playingAudio.index]) {
          assetsAudioPlayer.pause();
          activeAya = loopIndicesList[playingAudio.index] - 1;
        }
        if (playingAudio.index != 0 &&
            (currentPage + 1) == surahToLoop &&
            ayaToHighlight == loopIndicesList[playingAudio.index - 1] &&
            ayaToHighlight != loopIndicesList[playingAudio.index]) {
          assetsAudioPlayer.pause();
          activeAya = loopIndicesList[playingAudio.index] - 1;
        }

        if (playingAudio.index != 0 &&
            flagsAudio.isNotEmpty &&
            playingAudio.index == flagsAudio.length - 1) {
          assetsAudioPlayer.playlistFinished.listen((finished) async {
            if (finished == true) {
              if ((currentPage + 1) != surahToLoop) {
                carouselController.nextPage();
                loopIndicesList.clear();
                audiosList.clear();
                flagsAudio.clear();
                startFlagAudio.clear();
                clickedHighlightNum = 0;
                await loadAudiosLoop(currentPage + 2, rep);
                openPlayerLoop();
              }
            }
          });
        }
      });
      return;
    });
  }

  Future<void> loadAudiosLoop(page, rep) async {
    var audddd = await Provider.of<AudioPlayerProvider>(context, listen: false)
        .getAudioPaths(page);

    var flagsss =
        Provider.of<AudioPlayerProvider>(context, listen: false).flagsAudio;
    var startflags =
        Provider.of<AudioPlayerProvider>(context, listen: false).startFlagAudio;

    List<Audio> loopPlaylist = [];
    List<String> loopFlags = [];
    List<String> loopStartFlags = [];
    List<int> loopIndices = [];
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
      flagsAudio = loopFlags;
      startFlagAudio = loopStartFlags;
      prev = page;
      loopIndicesList = loopIndices;
      audiosList = loopPlaylist;
    });
  }

//==================================

  void openPlayer() async {
    if (basmalaFlag == true) {
      assetsAudioPlayerBasmala.current.listen((event) {
        assetsAudioPlayerBasmala.isPlaying.listen((event2) {
          if (event2 == false) {
            setState(() {
              assetsAudioPlayer.open(
                  Playlist(audios: audiosList, startIndex: clickedHighlightNum),
                  loopMode: LoopMode.none);
              activeAya = clickedHighlightNum;
              ayaFlag = true;
              basmalaFlag = false;
            });
            audioListener();
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
      audioListener();
    }
  }

  Future<void> loadAudios(page) async {
    var audddd = await Provider.of<AudioPlayerProvider>(context, listen: false)
        .getAudioPaths(page);

    var flagsss =
        Provider.of<AudioPlayerProvider>(context, listen: false).flagsAudio;
    var startflags =
        Provider.of<AudioPlayerProvider>(context, listen: false).startFlagAudio;

    setState(() {
      flagsAudio = flagsss;
      startFlagAudio = startflags;
      prev = page;
      audiosList = audddd;
    });
  }

  dynamic getInt(key) async {
    Future<SharedPreferences> pref = SharedPreferences.getInstance();
    final SharedPreferences prefs = await pref;
    int? res = prefs.getInt("$key");
    return res;
  }

  void audioListener() {
    assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;

      setState(() {
        isPlaying = true;

        handleActiveAya(playingAudio.index);
        activeAya = playingAudio.index;
        handleAyaFlag();

        handleActiveAya(playingAudio.index);
        if (playingAudio.index != 0 &&
            flagsAudio.isNotEmpty &&
            flagsAudio[playingAudio.index - 1] == '1') {
          assetsAudioPlayer.pause();
          showPauseIcon = false;
        }

        if (playingAudio.index != 0 &&
            flagsAudio.isNotEmpty &&
            flagsAudio[playingAudio.index].toString() == "0" &&
            playingAudio.index == flagsAudio.length - 1) {
          assetsAudioPlayer.playlistFinished.listen((finished) async {
            if (finished == true) {
              carouselController.nextPage();
              carouselController2.nextPage();
              audiosList.clear();
              flagsAudio.clear();
              await loadAudios(currentPage + 1);
              clickedHighlightNum = 0;
              openPlayer();
            }
          });
        }
      });
      return;
    });
  }
}
