import 'dart:convert';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/models/AyatLines.dart';
import 'package:mushafmuscat/utils/helperFunctions.dart';
import 'package:mushafmuscat/widgets/aya_clicked_bottom_sheet.dart';
import 'package:mushafmuscat/widgets/pageDetails.dart';
import 'package:provider/provider.dart';
import '../widgets/aya_clicked_bottom_sheet.dart';

import '../models/surah.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';

class finalCarousel extends StatefulWidget {
  finalCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<finalCarousel> createState() => _finalCarouselState();
}

class _finalCarouselState extends State<finalCarousel> {
  String surahName = '';
  bool _isInit = true;
  bool _isLoading = true;
  int _currentPage = 0;
  CarouselController carouselController = new CarouselController();
    CarouselController carouselController2 = new CarouselController();


  late List<String> audioPaths = [''];

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
  int overallid = 1;

  int playingAudioID = 1;
  int currentPage = 0;
  int previousPage = 0;

  bool stopindex = false;
  bool seekBackward = false;
  final assetsAudioPlayer =
      AssetsAudioPlayer.withId(Random().nextInt(100).toString());

// important variables
  int currentPlayingPage = 1;
  int currentPlayingAya = 1;

  @override
  void initState() {
    super.initState();
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

      _isInit = false;
      super.didChangeDependencies();
    }
  }
  // void deactivate() {
  //   super.deactivate();
  //   assetsAudioPlayer.dispose();
  // }

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

 

  @override
  Widget build(BuildContext context) {
    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    final _surahs = surahsData.surahs;
    final List<Surah> _surahitem = _surahs;
    // print(_surahitem);

    //TODO: This will be the whole quran later on
    List<int> listindex = [1, 2, 3, 4];
    int activeIndex = 1;

    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));

    void fetchSurahName(int i) {
      setState(() {
        List<Surah> _surah_search_results = [];
        _surah_search_results =
            Provider.of<SurahProvider>(context, listen: false)
                .getSurahName((i));
        // surahName= "hello";
        print(_surah_search_results);
        // if (i< int.parse(_surah_search_results[i])) {

        // }
        surahName = _surah_search_results[0].surahTitle.toString();
      });
    }

    // print(listofObjects);

    return Container(
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 90),
          height: 550,
          child: SingleChildScrollView(
            child: CarouselSlider(
              options: CarouselOptions(
                  height: 800,
                  reverse: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  initialPage: -1,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      overallid = index;
                      currentPage = index + 1;
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
                      onDoubleTap: (){
                      
                        showModalBottomSheet<void>(
                          shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10.0),
  ),
            context: context,
            builder: (BuildContext context) {
              return AyaClickedBottomSheet();
            },
          );
      
      
                        //  AyaClickedBottomSheet;
                        // print("Double clicked");
                         },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: pageDetails(
                            id: idx + 1,
                            indexhighlight: activeAya,
                            currentpage: currentPlayingPage,
                            ayaFlag: ayaFlag),
                      ),
                    );
                  },
                );
              }).toList(),
              carouselController: carouselController,
            ),
          ),
        ),

        SizedBox(
          height: 20,
        ),

        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 15),
          height: 100,
          color: CustomColors.yellow500,
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
                            initialPage: 0,
                                      scrollDirection: Axis.horizontal,
                                      pageSnapping: true,
          enableInfiniteScroll: true,
        ),

                items: [1, 2, 3, 4].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 50,
                        height: 2,
//                         margin: EdgeInsets.symmetric(horizontal: 7.0),
                        // decoration: BoxDecoration(
                        //   color: Colors.black,
                        // ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // overallid=i-1;
                              fetchSurahName(i);

                              carouselController.animateToPage(i - 1);
                             carouselController2.animateToPage(i-1);

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
        SizedBox(
          height: 50,
        ),

        //   buttonSelectedForegroundColor: CustomColors.red300,
        //   buttonUnselectedForegroundColor: CustomColors.grey200,
        //   buttonUnselectedBackgroundColor: Colors.white,
        //   buttonSelectedBackgroundColor: Colors.white,
        // )
        // ,
        Container(
          padding: EdgeInsets.only(bottom: 95),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(color: CustomColors.brown700, width: 1),
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
                      icon: SvgPicture.asset("assets/images/Settings.svg",
                          width: 30, height: 30, fit: BoxFit.fitWidth),
                      //seek forward
                      onPressed: () {
                        changehighlights();
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
                      icon: SvgPicture.asset("assets/images/Seek_right.svg",
                          width: 40, height: 40, fit: BoxFit.fitWidth),
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
                        showPauseIcon ? Icons.pause : Icons.play_arrow,
                        color: CustomColors.yellow100,
                      ),
                      iconSize: 20,
                      onPressed: () async {
                        if (firstFlag == false) {
                          setState(() {
                            currentPlayingPage = currentPage;
                  
                            showPauseIcon = true;
                          });
                          audioPaths.forEach((item) {
                            audios.add(Audio.network(item));
                          });
                          // print(audioPaths);
                          assetsAudioPlayer.open(Playlist(audios: audios),
                              loopMode: LoopMode.playlist);
                  
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
                      icon: SvgPicture.asset("assets/images/Seek_left.svg",
                          width: 40, height: 40, fit: BoxFit.fitWidth),
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
                SizedBox(
                  width: 80,
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 80,
        ),
  
      ]),
    );
  }

  Future<void> getAudioPaths() async {
    final List<String> paths = [];
    String AudioData = await rootBundle
        .loadString('lib/data/json_files/audio_page/audio_$currentPage.json');

    var jsonAudioResult = jsonDecode(AudioData);

    for (int index = 0; index < jsonAudioResult.length; index++) {
      paths.add(jsonAudioResult[index]['audio']);
    }
    setState(() {
      audioPaths = paths;
    });
    // print(audioPaths);
  }

  Future<void> PlayAudios() async {
    // print("AYA INDEX: $ayaIndex");

    // print("PREVIOUS $prev");
    int previousAudioId = 0;
    assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;
      // print("CURRETN PLAYING PAGE IS $currentPlayingPage");

      // print("CURRENT $asset");
      String curr =
          asset.assetAudioPath.substring(0, asset.assetAudioPath.length - 4);
      // print(curr.substring(curr.length - 6));

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
    setState(() {
      if (seekBackward == true) {
        seekBackward = false;

//condition for first aya
        if (ayaIndex == 0) {
          activeAya = 0;
          ayaFlag = true;
          // highlights = [splittedText[0]];
        } else {
          ayaIndex = ayaIndex - 2;
          activeAya = activeAya - 2;
          ayaFlag = true;

          // highlights = [splittedText[ayaIndex]];

          print("AYA INDEX SEEK BACK: $ayaIndex");
          // print(splittedText[ayaIndex]);

          //  highlights = s;
          //highlights = [splittedText[ayaIndex]];
        }
      }
      //else {
      // //TODO: condition for last aya
      // if (ayaIndex == splittedText.length - 1) {
      //   highlights = [splittedText[splittedText.length - 1]];

      // }
      else {
        // highlights = [splittedText[ayaIndex]];
        activeAya = activeAya + 1;
        ayaFlag = true;
      }

//           // ayaIndex = ayaIndex + 1;
//           //highlights = s;
//         }
      // }
      // });
    });
  }
}
