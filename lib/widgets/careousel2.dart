import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/models/AyatLines.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/pageText.dart';
import '../providers/ayatLines_provider.dart';
import '../providers/quran_display_provider.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';

class Carousel2 extends StatefulWidget {
  Carousel2({
    Key? key,
  }) : super(key: key);

  @override
  State<Carousel2> createState() => _Carousel2State();
}

class _Carousel2State extends State<Carousel2> {
   
  final audios = <Audio>[];
  List<String> highlights = [];
  int ayaIndex = 0;
  bool play = true;
  bool startflag = true;
  PlayingAudio? prev;
  List<String> splittedText = [];
int pagenumber=1;
  //audioplayer variables
  bool firstFlag = false;
  bool showPauseIcon = false;
var asset;
  //List<Audio> audios = [];

  bool stopindex = false;
  bool seekBackward = false;
  final assetsAudioPlayer =
      AssetsAudioPlayer.withId(Random().nextInt(100).toString());

  @override
  void initState() {

    super.initState();
    print("INIT STATTE====================");
  }

  // void deactivate() {
  //   super.deactivate();
  //   assetsAudioPlayer.dispose();
  // }

  
  int activePage = 1;

  String  getData(int? i) {
 Provider.of<ayatLines_provider>(context, listen: false).getLines(i);
    var textData = Provider.of<ayatLines_provider>(context, listen: false);
    var textlist = textData.text;

    List<String> textl = [];

    textlist.forEach((item) {
      textl.add(item.text!);
    });
    String fulltext = textl.join('\n\n');
    return fulltext;
  }




  Widget getLines(int? i) {
    print(i);

    String fulltext= getData(i);
    splittedText = HelperFunctions.splitLinesintoList(fulltext);
    
    for (int j=1; j <= fulltext.length; j++) {
    String path = "00" + i.toString() + "00" + j.toString();
    audios.add(Audio("assets/audios/$i/$path.mp3"));}
    // highlights=[splittedText[0]];

    return DynamicTextHighlighting(
                    text: fulltext,
                    textAlign: TextAlign.center,
                    highlights: highlights,
                    color: Colors.yellow,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "IBMPlexSansArabic",
                      color: CustomColors.black200,
                      //color: Colors.black.withOpacity(0),
                    ),
                    caseSensitive: false,
                  );
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

        print(listofObjects);

    return Column(
      children: [
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
                        //if index of page is the same as index of the current playing audio
                        // if (index == )

                      if (asset!= null) {
print(asset);
                      }
                    // asset['path']? print(asset['path']) : print("null");
                    //     print("on page changed $index");


                      });
                    }
            ),
            items: listofObjects.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: getLines(i.pageNumber!),
                  );
                },
              );
            }).toList(),
          )
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
                    onPressed: () {}),
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
                      PlayAudios(splittedText);
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
                    onPressed: () {
                      if (firstFlag == false) {
                        setState(() {
                          showPauseIcon = true;
                        });
          
                        assetsAudioPlayer.open(Playlist(audios: audios),
                            loopMode: LoopMode.playlist);
                        PlayAudios(splittedText);
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
                          PlayAudios(splittedText);
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
                      PlayAudios(splittedText);
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
      ],
    );
  }

 Future<void> PlayAudios(splittedText) async {
      print("AYA INDEX: $ayaIndex");

      // print("PREVIOUS $prev");

      assetsAudioPlayer.current.listen((playingAudio) {
        // final asset = playingAudio!.audio;
                  asset= playingAudio!.audio;

        print("CURRENT $asset");
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
          highlights = [splittedText[0]];
        } else {
          ayaIndex = ayaIndex - 2;

          highlights = [splittedText[ayaIndex]];

          print("AYA INDEX SEEK BACK: $ayaIndex");
          print(splittedText[ayaIndex]);

          //  highlights = s;
          //highlights = [splittedText[ayaIndex]];
        }
      } else {
        //TODO: condition for last aya
        if (ayaIndex == splittedText.length - 1) {
          highlights = [splittedText[splittedText.length - 1]];
        } else {
          highlights = [splittedText[ayaIndex]];

          ayaIndex = ayaIndex + 1;
          //highlights = s;
        }
      }
    });
  }
    
    
    }
