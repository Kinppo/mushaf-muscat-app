import 'dart:convert';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/models/AyatLines.dart';
import 'package:mushafmuscat/utils/helperFunctions.dart';
import 'package:mushafmuscat/widgets/aya_clicked_bottom_sheet.dart';
import 'package:mushafmuscat/widgets/pageDetails.dart';
import 'package:provider/provider.dart';
import '../providers/ayatLines_provider.dart';
import '../widgets/aya_clicked_bottom_sheet.dart';

import '../models/surah.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';

class finalCarousel extends StatefulWidget {
  int goToPage;
  finalCarousel({
    required this.goToPage,
    Key? key,
  }) : super(key: key);

  @override
  State<finalCarousel> createState() => _finalCarouselState();
}

class _finalCarouselState extends State<finalCarousel> {
  int clickedHighlightNum = 0;

  String surahName = 'الفاتحة';
  bool _isInit = true;
  bool _isLoading = true;
  CarouselController carouselController = new CarouselController();
  CarouselController carouselController2 = new CarouselController();

  late List<String> audioPaths = [''];
  late bool ShowAudioPlayer;
  bool tapped = false;
  late bool ShowOnlyPageNum;

  final audios = <Audio>[];
  List<String> highlights = [];
  int ayaIndex = 0;
  bool play = true;
  bool startflag = true;
  PlayingAudio? prev;
  List<String> splittedText = [];
  int pagenumber = 1;
  //audioplayer variables
  bool firstFlag = false;
  bool showPauseIcon = false;
  String alltext = '';
  int overallid = 0;

  int playingAudioID = 0;
  int currentPage = 1;
  int previousPage = 0;

  bool stopindex = false;
  bool seekBackward = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  List<String> FlagsAudio = [];

  bool checking = false;
  bool previouslyStopped = false;
  bool cameFromMenu = false;

  final List<String?> surahNamess = [];
  List<List<int>> flagsForEndofSurah = [];
  int listenToIndex = 1;
// important variables
  int currentPlayingPage = 1;
  int currentPlayingAya = 1;
  @override
  void initState() {
    setState(() {
      if (widget.goToPage != null && widget.goToPage != 0) {
        overallid = (widget.goToPage as int) - 1;
        cameFromMenu = true;
        currentPage = widget.goToPage as int;
        print("CAME FROM MENU IS $cameFromMenu");
      }
    });
    getAudioPaths();
    activate();
    ShowAudioPlayer = false;
    ShowOnlyPageNum = true;
    loadSurahs();

    super.initState();
  }

  void loadSurahs() async {
    var data =
        await rootBundle.loadString('lib/data/json_files/surahs_pages.json');
    var jsonResult = jsonDecode(data);
    for (int index = 0; index < jsonResult.length; index++) {
      surahNamess.add(HelperFunctions.normalise(jsonResult[index]['surah']));
    }

    for (int i = 1; i <= jsonResult.length; i++) {
      List<int> tempList = [];
      String flgs = await rootBundle
          .loadString('lib/data/json_files/quran_lines/quran_word_$i.json');

      var jsonResult2 = jsonDecode(flgs);

      for (int index = 0; index < jsonResult2.length; index++) {
        tempList.add(int.parse(jsonResult2[index]['EndOfSurah']));
      }
      flagsForEndofSurah.add(tempList);
      tempList = [];
    }

// print("LENGTH OF OUTER LIST: "+ flagsForEndofSurah.length.toString());
// print(flagsForEndofSurah.toString());
  }

  toggleClickedHighlight(int clickedIdx) {
    setState(() {
      print("CLICKED HIGHLIGHT NUM IS $clickedIdx");
      clickedHighlightNum = clickedIdx - 1;
      // change this to modal bottom sheet
      //  ShowAudioPlayer=true;
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
          );
        },
      );
    });

    // getAudioPaths();
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

      setState(() {
        _isLoading = false;
      });

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  void activate() {
    AssetsAudioPlayer.withId(Random().nextInt(100).toString());
  }

  void deactivate() {
    assetsAudioPlayer.dispose();

    super.deactivate();
  }

  int activeAya = -1;
  bool ayaFlag = false;
  void changehighlights() {
    setState(() {
      if (activeAya < audioPaths.length) {
        activeAya = activeAya + 1;
        ayaFlag = true;
        // print(activeAya);
      }
    });
  }

  void togglePlayer() {
    setState(() {
      ShowAudioPlayer = true;
    });
    print("TOGGLED TO $ShowAudioPlayer");
  }

  @override
  Widget build(BuildContext context) {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    final _surahs = surahsData.surahs;
    final List<Surah> _surahitem = _surahs;

    //TODO: This will be the whole quran later on
    // List<int> listindex = [1, 2, 3, 4];
    List<int> listindex = new List<int>.generate(604, (i) => i + 1);

    int activeIndex = 1;

    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));

    return Expanded(
      child: Container(
        //change color later based on requirements
        color: Colors.white,
        child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 90, 0, 20),
            // height: 550,
            // height: MediaQuery.of(context).size.height,

            child: CarouselSlider(
              options: CarouselOptions(
                  height: 590,
                  
                  //  height: 700,
          

                  // height: MediaQuery.of(context).size.height,

                  reverse: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  initialPage:
                      //if infinite scroll is false, then initial page has to be -1 not 0
                      (cameFromMenu == true) ? widget.goToPage - 1 : 0,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      overallid = index;
                      currentPage = index + 1;
                      surahName = surahNamess[index]!;
                      getAudioPaths();
                      PlayAudios();
                      // print("PAGE ID IS $currentPage");
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
                      onDoubleTap: () {
                        print(ShowAudioPlayer);
                        showModalBottomSheet<void>(
                          constraints:
                              BoxConstraints(maxWidth: 400, maxHeight: 460),
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return AyaClickedBottomSheet(
                              ShowAudioPlayer: togglePlayer,
                            );
                          },
                        );
                      },
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [Image.asset('assets/quran_images/img_1.jpg',
                                  fit: BoxFit.cover,                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height),
                              Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: pageDetails(
                              id: idx + 1,
                              indexhighlight: activeAya,
                              currentpage: currentPlayingPage,
                              ayaFlag: ayaFlag,
                              toggleClickedHighlight: toggleClickedHighlight,
                              clickedHighlightNum: clickedHighlightNum,
                            )),]
                      ),
                    );
                  },
                );
              }).toList(),
              carouselController: carouselController,
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),

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
                    // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                              print("INDEX IS $index");
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
                                        //  if(tapped==true &&overallid==i-1){
                                        //  ShowOnlyPageNum=!ShowOnlyPageNum;

                                        //  }

                                        // overallid=i-1;
                                        // fetchSurahName(i);

                                        surahName = surahNamess[i - 1]!;

                                        carouselController.animateToPage(i - 1);
                                        carouselController2
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
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                                  onPressed: () {
                                    // changehighlights();
                                  }),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Material(
                              color: Colors.transparent,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                  iconSize: 40,
                                  icon: SvgPicture.asset(
                                      "assets/images/Seek_right.svg",
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.fitWidth),
                                  //seek forward
                                  onPressed: () {
                                    assetsAudioPlayer.next();
                                    PlayAudios();
                                  }),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            CircleAvatar(
                              backgroundColor: CustomColors.grey200,
                              maxRadius: 20,
                              child: Material(
                                color: Colors.transparent,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                  icon: Icon(
                                    showPauseIcon
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: CustomColors.yellow100,
                                  ),
                                  iconSize: 20,
                                  onPressed: () async {
                                    if (previouslyStopped == true) {
                                      setState(() {
                                        activeAya = activeAya + 1;
                                        previouslyStopped = false;
                                      });
                                    }
                                    if (firstFlag == false) {
                                      if (clickedHighlightNum != 0) {
                                        activeAya = clickedHighlightNum - 1;
                                      }
                                      print("FIRST FLAG IS FALSE");
                                      setState(() {
                                        if (cameFromMenu == true) {
                                          currentPage = widget.goToPage;
                                        }
                                        currentPlayingPage = currentPage;
                                        overallid = currentPage;
                                        showPauseIcon = true;
                                        getAudioPaths();
                                      });
                                      audioPaths.forEach((item) {
                                        audios.add(Audio.network(item));
                                      });
                                      // print(audioPaths);
                                      assetsAudioPlayer.open(
                                        Playlist(
                                            audios: audios,
                                            startIndex: clickedHighlightNum != 0
                                                ? clickedHighlightNum
                                                : 0),
                                        loopMode: LoopMode.playlist,
                                      );
                                      assetsAudioPlayer.playOrPause();
                                      PlayAudios();
                                      firstFlag = true;
                                    }
                                    //plays from paused position
                                    else {
                                      setState(() {
                                        showPauseIcon = !showPauseIcon;
                                        play = !play;
                                      });
                                      assetsAudioPlayer.playOrPause();
                                      if (play == true) {
                                        PlayAudios();
                                      }
                                      //
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Material(
                              color: Colors.transparent,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                  iconSize: 40,
                                  icon: SvgPicture.asset(
                                      "assets/images/Seek_left.svg",
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.fitWidth),
                                  //seek forward
                                  onPressed: () {
                                    // initializeDuration();
                                    assetsAudioPlayer.previous();
                                    setState(() {
                                      seekBackward = true;
                                    });
                                    PlayAudios();
                                  }),
                            ),
                            // SizedBox(
                            //   width: 80,
                            // ),
                            SizedBox(
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 95),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (cameFromMenu == true) {
                              surahName =
                                  surahNamess[(widget.goToPage as int) - 1]!;
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
          // SizedBox(height: MediaQuery.of(context).size.height,)
        ]),
      ),
    );
  }

  Future<void> getAudioPaths() async {
    FlagsAudio.clear();
    final List<String> paths = [];

    //TODO: CONDITIONS FOR END OF SURAH

    print("CURRENT PAGE IS: " + currentPage.toString());

    String AudioData = await rootBundle.loadString(
        'lib/data/json_files/audio_page/quran_audio_$currentPage.json');
    var jsonAudioResult = jsonDecode(AudioData);
    print("AUDIO DATA IS: " + currentPage.toString());

    for (int index = 0; index < jsonAudioResult.length; index++) {
      paths.add(jsonAudioResult[index]['audio']);
      FlagsAudio.add(jsonAudioResult[index]['EndOfSurah']);
    }
    setState(() {
      audioPaths = paths;
    });
    print("AAAAAAA PATHS $audioPaths");
    print(FlagsAudio);
  }

  Future<void> PlayAudios() async {
    // print("AYA INDEX: $activeAya");
    //   print("REACHED FUNCTION");
    // if (clickedHighlightNum!=0) {
    //     activeAya= clickedHighlightNum-1;
    //   }
    int previousAudioId = 0;
    assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;

      // print("CURRENT $asset");
      // String curr =
      //     asset.assetAudioPath.substring(0, asset.assetAudioPath.length - 4);
      // print("CURRETN $curr");

      //finally works

      if (prev != asset && seekBackward == false) {
        changeText();

        setState(() {
          prev = asset;
        });
      } else if (seekBackward == true) {
        changeText();

        print("ASSET");
        print(asset);
        setState(() {
          prev = asset;
        });
      }
    });
  }

  changeStop() {
    setState(() {
      stopindex = true;
    });
  }

  changeText() {
    if (previouslyStopped) {
      setState(() {
        activeAya = activeAya + 1;

        previouslyStopped = false;
      });
    }
    if (checking == true) {
      assetsAudioPlayer.pause();
      setState(() {
        showPauseIcon = false;
        checking = false;
        previouslyStopped = true;
      });
      // deactivate();
    } else {
      setState(() {
        if (seekBackward == true) {
          seekBackward = false;

//condition for first aya
          if (ayaIndex == 0) {
            activeAya = 0;
            ayaFlag = true;
          } else {
            ayaIndex = ayaIndex - 2;
            activeAya = activeAya - 2;
            ayaFlag = true;

            print("AYA INDEX SEEK BACK: $ayaIndex");
          }
        }
        // //TODO: condition for last aya

        else {
          activeAya = activeAya + 1;
          ayaFlag = true;
        }

        playingAudioID = playingAudioID + 1;
      });

      print("ACTUAL ID IS $playingAudioID");
      print("FLAGGG IS " + FlagsAudio[playingAudioID - 1]);

      print("IDDDD " + (playingAudioID - 1).toString());

      if (FlagsAudio[activeAya].toString() == "1") {
        setState(() {
          print("THIS IS THE LAST AYA");
          checking = true;
        });
      } else {
        setState(() {
          checking = false;
        });
      }
    }
  }
}
