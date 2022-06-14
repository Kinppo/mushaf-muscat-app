import 'dart:convert';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/models/AyatLines.dart';
import 'package:mushafmuscat/widgets/pageDetails.dart';

import '../resources/colors.dart';

class finalCarousel extends StatefulWidget {
  finalCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<finalCarousel> createState() => _finalCarouselState();
}

class _finalCarouselState extends State<finalCarousel> {
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

  // void deactivate() {
  //   super.deactivate();
  //   assetsAudioPlayer.dispose();
  // }

  int activeAya = -1;
  bool ayaFlag=false;
  void changehighlights() {
  
    setState(() {
      if (activeAya < audioPaths.length) {
        activeAya = activeAya + 1;
        ayaFlag=true;
        // print(activeAya);
      }
    }); 
  }

  @override
  Widget build(BuildContext context) {
    List<int> listindex = [1, 2, 3, 4];
    int activeIndex = 1;

    List<AyatLines> listofObjects = [];

    listindex.forEach((i) => listofObjects.add(AyatLines(
          text: '',
          pageNumber: i,
        )));

    // print(listofObjects);

    return Column(children: [
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
                    currentPage = index + 1;
                    getAudioPaths();
                                         PlayAudios();


                    print("PAGE ID IS $currentPage");
                  });
                 } ),
            items: listofObjects.map((i) {

              int idx = listofObjects.indexOf(i) ;
              // print("building... $idx")
              setState(() {
                
                overallid = idx;
              });
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: pageDetails(
                      id: idx + 1,
                      indexhighlight: activeAya,
                      currentpage: currentPlayingPage, 
                      ayaFlag: ayaFlag
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
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
              IconButton(
                  iconSize: 30,
                  icon: SvgPicture.asset("assets/images/Settings.svg",
                      width: 30, height: 30, fit: BoxFit.fitWidth),
                  //seek forward
                  onPressed: () {
                    changehighlights();
                  }),
              SizedBox(
                width: 30,
              ),
              IconButton(
                  iconSize: 40,
                  icon: SvgPicture.asset("assets/images/Seek_right.svg",
                      width: 40, height: 40, fit: BoxFit.fitWidth),
                  //seek forward
                  onPressed: () {
                    assetsAudioPlayer.next();
                    PlayAudios();
                  }),
              SizedBox(
                width: 20,
              ),
              CircleAvatar(
                backgroundColor: CustomColors.grey200,
                maxRadius: 20,
                child: IconButton(
                  icon: Icon(
                    showPauseIcon ? Icons.pause : Icons.play_arrow,
                    color: CustomColors.yellow100,
                  ),
                  iconSize: 20,
                  onPressed: () async {
                    if (firstFlag == false) {
                      setState(() {
                      currentPlayingPage=currentPage;
                                              
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
              SizedBox(
                width: 20,
              ),
              IconButton(
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
              SizedBox(
                width: 80,
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 80,
      )
    ]);
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
          ayaFlag=true;
          // highlights = [splittedText[0]];
        } else {
          ayaIndex = ayaIndex - 2;
          activeAya = activeAya - 2;
          ayaFlag=true;

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
                  ayaFlag=true;

      }

//           // ayaIndex = ayaIndex + 1;
//           //highlights = s;
//         }
      // }
      // });
    });
  }
}
