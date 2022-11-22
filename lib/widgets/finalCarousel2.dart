import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/providers/ayatLines_provider.dart';

import 'package:mushafmuscat/widgets/aya_clicked_bottom_sheet.dart';
import 'package:mushafmuscat/widgets/pageDetails2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/bookMarks_provider.dart';
import '../models/AyatLines.dart';
import '../models/surah.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';
import 'pageDetails2.dart';
import '../widgets/chooseWhereToPlay.dart';

class finalCarousel2 extends StatefulWidget {
  int goToPage;
  int? loop;
  Function toggleBars;
  int? loophighlight;
  finalCarousel2({
    Key? key,
    required this.goToPage,
    this.loop,
    required this.toggleBars,
    this.loophighlight,
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
  final assetsAudioPlayer = AssetsAudioPlayer();

  List<Audio> audiosList = [];
  List<String> FlagsAudio = [];
  List<int> LoopIndices = [];

// controllers
  CarouselController carouselController = new CarouselController();
  CarouselController carouselController2 = new CarouselController();

//new state management
// bool pageDetails_loadAudios=false;

  @override
  void initState() {
    print("building......");

    if (widget.goToPage != null && widget.goToPage != 0) {
      overallid = (widget.goToPage as int) - 1;
      currentPage = (widget.goToPage as int) - 1;
      cameFromMenu = true;

      setState(() {
        navigatedFromBK = (widget.goToPage as int) - 1;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSurahs;
// var temp;
// int highlight=0;
      // var temp = await getInt('ayaFrom');
      //  highlight= await Provider.of<ayatLines_provider>(context, listen: false).getAya(await getInt("ayaFrom"));

      setState(() {
        loadSurahs();

        //   if ( widget.loophighlight!= null){

        //   print("VALUE OF LOOP HIGHLIGHT IS .." +widget.loophighlight.toString());
        //         clickedHighlightNum= widget.loophighlight! as int;

        //   }
        //   else {
        // clickedHighlightNum=highlight;}
        // ayaFrom= temp;
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
  }

  morePlayOptions() {
    setState(() {
      moreplay = true;
    });

    print("more play is $moreplay");
  }

// void updateHighligh

  toggleClickedHighlight(int clickedIdx, String ayaS, String ayaString) {
    setState(() async {
      print(ayaS);
      print("CLICKED HIGHLIGHT NUM IS $clickedIdx");
      clickedHighlightNum = clickedIdx - 1;

      if (firstFlag == true) {
        clickHighlightWhilePlaying = true;
      }

      if (isPlaying == true) {
        if (prev != currentPage) {
          await loadAudios(currentPage);
         
            OpenPlayer();
          
        } else {
          assetsAudioPlayer.playlistPlayAtIndex(clickedHighlightNum);
        }
        print("audio playing is $prev");
        print("currently in page $currentPage");
        AudioListener();
      }

      showModalBottomSheet<void>(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: 460),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return AyaClickedBottomSheet(
            ShowAudioPlayer: togglePlayer,
            ayaNum: HelperFunctions.convertToArabicNumbers(ayaS)!,
            clickedHighlightNum: clickedHighlightNum,
            currentPage: currentPage,
            surahName: surahName,
            highlightedAyaText: ayaString,
            playMoreOptions: morePlayOptions,
          );
        },
      ).whenComplete(_onBottomSheetClosed);
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

    print("ACTIVEEEE IS $activeAya");
  }

  handlePlayButton() async {
    carouselController.nextPage();
    carouselController2.nextPage();
    audiosList.clear();
    FlagsAudio.clear();
    await loadAudios(currentPage + 1);
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
    setState(() {
      if (firstFlag == true &&
          clickHighlightWhilePlaying == true &&
          ShowAudioPlayer == true) {
        if (showPauseIcon == false) {
          showPauseIcon = !showPauseIcon;
        }
      } else {
        widget.toggleBars();
        ShowAudioPlayer = true;
      }
    });

    print("TOGGLED TO $ShowAudioPlayer");
  }

  void loopFunction() async {
    //  var temp= await getInt('ayaFrom');
        int rep = await getInt("repNum") as int;

          await loadAudiosLoop(currentPage + 1, rep);

    setState(() {
      loopFlag = true;
      ShowAudioPlayer = true;
// clickedHighlightNum= 2;
      // handlePlayButton();

      OpenPlayerLoop();
      print(audiosList);
    });
  }

// findWhichHighlight () async{
//   //chosen aya number from the dropdown is not the same as the highlight number
//   //so we need to find it
//  int highlight= await Provider.of<ayatLines_provider>(context, listen: false).getAya(currentPage, await getInt("ayaFrom"));

// setState(() {
//   clickedHighlightNum=highlight;
// });

// }
  @override
  Widget build(BuildContext context) {
    if (widget.loop == 1 && loopFlag == false) {
      // if ( widget.loophighlight!= null){
      //   setState(() {
      //     print("VALUE OF LOOP HIGHLIGHT IS .." +widget.loophighlight.toString());
      //           clickedHighlightNum= widget.loophighlight!;

      //   });
      // }
      // findWhichHighlight();
      loopFunction();
    }

    // getInt("surahFrom");
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    print("orientation is $isLandscape");
    // print(_surahNames);
    // print(_ayaNumbers);

    final Audioplayer_Provider =
        Provider.of<AudioPlayer_Provider>(context, listen: false);

    List<int> listindex = new List<int>.generate(604, (i) => i + 1);
    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: (isLandscape == false)
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: (isLandscape == false)
                ? EdgeInsets.fromLTRB(0, 155, 0, 0)
                : EdgeInsets.fromLTRB(10, 155, 10, 50),
            color: Colors.white,
            child: CarouselSlider(
              options: CarouselOptions(

                  // height: MediaQuery.of(context).size.height,
                  height: (isLandscape == false) ? 672 : 1400,
                  reverse: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  initialPage: navigatedFromBK,
                  //if infinite scroll is false, then initial page has to be -1 not 0
                  // (cameFromMenu == true) ? (widget.goToPage as int) - 1 : 0,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      print("we are in next page");
                      overallid = index;
                      currentPage = index + 1;
                      surahName = _surahNames[index]!;
                      print("CURRENT PAGE IS $currentPage");
                      print("the value of go to page is ....." +
                          widget.goToPage.toString());
                    });
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
                        // IgnorePointer(
                        //   child:(idx==0) ? Image.asset(  'assets/quran_images/img_1.jpg',   height:300,
                        //                   fit: BoxFit.fitWidth,       width: MediaQuery.of(context).size.width,    ) :
                        //                   Image.asset(  'assets/quran_images/img_3.jpg',   height:900,
                        //                   fit: BoxFit.fitWidth,       width: MediaQuery.of(context).size.width,    )

                        //                   // SvgPicture.asset('assets/quran_images/svg/$currentPage.svg', fit: BoxFit.cover ,
                        //                   //                         width:MediaQuery.of(context).size.width  , height:980 , alignment: Alignment.center,  clipBehavior: Clip.none,
                        //                   //                        )

                        //         ),

                        //             ): )
                        //  child: (idx==603) ? SvgPicture.asset('assets/quran_images/604.svg',
                        //     // height:200,
                        //             fit: BoxFit.fitWidth,
                        //                                     width: MediaQuery.of(context).size.width,
                        //             ):
                        //                  Image.asset( (idx==0) ? 'assets/quran_images/img_1.jpg' :
                        //                'assets/quran_images/img_3.jpg',
                        //     height:300,
                        //             fit: BoxFit.fitWidth,                              width: MediaQuery.of(context).size.width,
                        //       ),
                        // //   //  Image.asset( (idx==0) ? 'assets/quran_images/img_1.jpg' : (idx==603 ? 'assets/quran_images/img_604.jpg' : 'assets/quran_images/img_3.jpg'),
                        // //   // height:300,
                        // //     //       fit: BoxFit.fitWidth,                              width: MediaQuery.of(context).size.width,
                        // //     // ),
                        // // ),
                        Consumer<AudioPlayer_Provider>(builder:
                            (BuildContext context, value, Widget? child) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: (idx == 0 || idx == 1)
                                ? EdgeInsets.only(top: 100)
                                : EdgeInsets.only(top: 0),
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: pageDetails2(
                              id: idx + 1,
                              indexhighlight: activeAya,
                              currentpage: idx + 1,
                              ayaFlag: ayaFlag,
                              toggleClickedHighlight: toggleClickedHighlight,
                              clickedHighlightNum: clickedHighlightNum - 1,
                              // clickedHighlightNum: 1,

                              firstFlag: firstFlag,
                              prev: prev,
                              closedBottomSheet: closedBottomSheet,
                            ),
                          );
                        }),
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

              //====================AUDIOPLAYER=====================
              : (ShowAudioPlayer == true)
                  ? Container(
                      // padding: EdgeInsets.only(bottom: 95),
                      child: Container(
                        // alignment: Alignment.bottomCenter
                        margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
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
                                        FlagsAudio[activeAya - 1].toString() ==
                                            "0" &&
                                        activeAya == FlagsAudio.length - 1) {
                                      handlePlayButton();
                                    } else {
                                      assetsAudioPlayer.next();
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
                                          await loadAudios(currentPage);
                                          print(audiosList);
                                          //                            if (loopFlag==true) {
                                          //  OpenPlayerLoop();
                                          OpenPlayer();
                                          // }
                                          firstFlag = true;
                                          showPauseIcon = true;
                                        });
                                      }
                                      print("CLICKED PLAY");
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
                                      await loadAudios(currentPage - 1);
                                      clickedHighlightNum =
                                          FlagsAudio.length - 1;
                                     
                                        OpenPlayer();
                                      
                                    } else {
                                      assetsAudioPlayer.previous();
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
                                    print("pressed exit");
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
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (cameFromMenu == true) {
                              surahName =
                                  surahName[(widget.goToPage as int) - 1]!;
                            }
                            print("========PRESSED");

                            ShowOnlyPageNum = !ShowOnlyPageNum;
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
                            width: 40,
                            child: Text(
                              HelperFunctions.convertToArabicNumbers(
                                      (overallid + 1).toString())
                                  .toString(),
                              style: TextStyle(
                                  color: CustomColors.grey200, fontSize: 18),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
        ]),
      ),
    );
  }

//=========================LOOP====================
  void OpenPlayerLoop() async {
    int rep = await getInt("repNum") as int;
    int surahToLoop = await getInt("surahTo") as int;
    int ayaToLoop = await getInt("ayaTo") as int;

    // await loadAudiosLoop(currentPage + 1, rep);
    print("highlight number AND CURRENT PAGE..... " + currentPage.toString());

    print("highlight number of chosen aya is..... " +
        widget.loophighlight.toString());
    print("page number of chosen aya is..... " + currentPage.toString());
    // print("NUMBER OF REPS ..... " + rep.toString());
     int? ayaToHighlight = await Provider.of<ayatLines_provider>(context, listen: false).getAya(surahToLoop, ayaToLoop as int);

// print(audiosList);

// print(loopPlaylist);
    setState(() {
      assetsAudioPlayer.open(
          Playlist(
            audios: audiosList,
            startIndex:
                (loopFirstPage == false) ? widget.loophighlight! * rep : 0,
          ),
          loopMode: LoopMode.none);
      // assetsAudioPlayer.toggleLoop(); //toggle the value of looping
      print(LoopIndices.toString());
      clickedHighlightNum = (loopFirstPage == false) ? widget.loophighlight!  : 0;
      activeAya = clickedHighlightNum;
      ayaFlag = true;
      loopFirstPage = true;
    });
    AudioListenerLoop(surahToLoop, ayaToLoop, rep, ayaToHighlight);
  }

  void AudioListenerLoop(surahToLoop, ayaToLoop, rep, ayaToHighlight) {
// if (assetsAudioPlayer.isPlaying== false){
//   return;
// }
    assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;

      setState(() {
        if (asset != null) {
          isPlaying = true;
        }
        print("========highlight: $clickedHighlightNum");
        print("========playing id: " + playingAudio.index.toString());
        print("========loop indice: " +
            LoopIndices[playingAudio.index].toString());

        // handleActiveAya(LoopIndices[playingAudio.index]-1);
        activeAya = LoopIndices[playingAudio.index];
        // handleAyaFlag();

        // handleActiveAya(LoopIndices[playingAudio.index]);
        print("flag is $FlagsAudio");
        // if (playingAudio.index != 0 &&
        //     FlagsAudio.length > 0 &&
        //     FlagsAudio[playingAudio.index - 1] == '1') {
        //   print("THIS IS THE LAST LAST AYA");
        //   assetsAudioPlayer.pause();
        // }
             if (playingAudio.index!=0 && (currentPage + 1) == surahToLoop  && ayaToHighlight==LoopIndices[playingAudio.index-1]
             && ayaToHighlight!=LoopIndices[playingAudio.index]) {
              
            //todo: condition if surahTo = surahFrom
print("^^^^^^^PLAYER SHOUDL STOP NOWWWWW^^^^^^^");
assetsAudioPlayer.pause();
clickedHighlightNum=LoopIndices[playingAudio.index-1];
             }
             
        if (playingAudio.index != 0 &&
            FlagsAudio.length > 0 &&
            playingAudio.index == FlagsAudio.length - 1) {
          assetsAudioPlayer.playlistFinished.listen((finished) async {
            //todo: condition if surahTo = surahFrom
            if (finished == true) {
         

              if ((currentPage + 1) != surahToLoop) {
                print("finished finsihed");
                 carouselController.nextPage();
                //  carouselController2.nextPage();
                LoopIndices.clear();

                audiosList.clear();
                FlagsAudio.clear();
  
clickedHighlightNum=0;
                await loadAudiosLoop(currentPage+2,rep);
                print( "NEXT PAGEEEEE " + audiosList.toString());

    
     
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

    var audddd = await Provider.of<AudioPlayer_Provider>(context, listen: false)
        .getAudioPaths(page);

    var flagsss =
        await Provider.of<AudioPlayer_Provider>(context, listen: false)
            .FlagsAudio;

    List<Audio> loopPlaylist = [];
    List<String> loopFlags = [];
    List<int> loopIndices = [];

//todo: check if this is the first page
    if (page == pageFrom) {
      print('THIS IS THE FIRST PAGE');
// audddd =audddd.sublist(widget.loophighlight!);
      print(audddd);
    }

// if (page==pageTo){
//   print('THIS IS THE LAST PAGE');
// audddd =audddd.sublist(0,widget.loophighlight!);
// print(audddd);
// }
// print(audios2);
    int temp = 0;

    for (int i = 0; i < audddd.length; i++) {
      for (int j = 0; j < rep; j++) {
        // print(audddd[i]);
        loopFlags.add('0');
        loopPlaylist.add(audddd[i]);
        loopIndices.add(temp);
      }
      temp = temp + 1;
    }
    print(FlagsAudio.length.toString() + " ==== " + FlagsAudio.toString());
    print(loopIndices.length.toString() + " ==== " + loopIndices.toString());
    print(loopPlaylist.length.toString() + " ==== " + loopPlaylist.toString());

    setState(() {
      clickedHighlightNum=0;
      activeAya=0;
      FlagsAudio = loopFlags;
      prev = page;
      LoopIndices = loopIndices;
      audiosList = loopPlaylist;
    });
  }

//==================================

  void OpenPlayer() async {
    setState(() {
      assetsAudioPlayer.open(
          Playlist(audios: audiosList, startIndex: clickedHighlightNum),
          loopMode: LoopMode.none);
      activeAya = clickedHighlightNum;
      ayaFlag = true;
    });
    AudioListener();
  }

  Future<void> loadAudios(page) async {
    var audddd = await Provider.of<AudioPlayer_Provider>(context, listen: false)
        .getAudioPaths(page);

    var flagsss =
        await Provider.of<AudioPlayer_Provider>(context, listen: false)
            .FlagsAudio;
    setState(() {
      FlagsAudio = flagsss;
      prev = page;

      audiosList = audddd;
    });
  }

  dynamic getInt(key) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int? _res = prefs.getInt("$key");
    print("SHARED PREF " + _res.toString());
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
        print("flag is $FlagsAudio");
        if (playingAudio.index != 0 &&
            FlagsAudio.length > 0 &&
            FlagsAudio[playingAudio.index - 1] == '1') {
          print("THIS IS THE LAST LAST AYA");
          assetsAudioPlayer.pause();
        }

        if (playingAudio.index != 0 &&
            FlagsAudio.length > 0 &&
            FlagsAudio[playingAudio.index - 1].toString() == "0" &&
            playingAudio.index == FlagsAudio.length - 1) {
          assetsAudioPlayer.playlistFinished.listen((finished) async {
            if (finished == true) {
              print("finished finsihed");
              carouselController.nextPage();
              carouselController2.nextPage();
              audiosList.clear();
              FlagsAudio.clear();
              await loadAudios(currentPage + 1);
              clickedHighlightNum = 0;
              
     
                OpenPlayer();
              
            }
          });
        }
      });
      return;
    });
  }
}
