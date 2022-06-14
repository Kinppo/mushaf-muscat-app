import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:mushafmuscat/widgets/quran.dart' as quranWidget;
import 'package:mushafmuscat/widgets/test3.dart';

import '../providers/ayatLines_provider.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';

class textCarousel extends StatefulWidget {
    int pageNum;

   textCarousel({
    Key? key,
    required this.pageNum,
  }) : super(key: key);

  @override
  State<textCarousel> createState() => _textCarouselState();
}

class _textCarouselState extends State<textCarousel> {
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

  //List<Audio> audios = [];

  bool stopindex = false;
  bool seekBackward = false;
  final assetsAudioPlayer =
      AssetsAudioPlayer.withId(Random().nextInt(100).toString());

  // final assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  @override
  void initState() {
    super.initState();
    // sid= widget.pageNum.toString();
    // print("PAGE ID= $sid");
    print("INIT STATTE====================");
    print(highlights);
  }

  // void deactivate() {
  //   super.deactivate();
  //   assetsAudioPlayer.dispose();
  // }

  changeStop() {
    setState(() {
      stopindex = true;
    });
  }

  changeText() {
    // print("New highlights");
    //print(s);

//  highlights = s;
    setState(() {
//print(s[0]);
      if (seekBackward == true) {
        seekBackward = false;

        // highlights = s;

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

  @override
  Widget build(BuildContext context) {
    Provider.of<ayatLines_provider>(context, listen: false)
        .getLines(widget.pageNum);
    var textData = Provider.of<ayatLines_provider>(context, listen: false);
    var textlist = textData.text;
    int lengthoflines = textlist.length;
    int page = widget.pageNum;

    for (int i = 1; i <= lengthoflines; i++) {
      String path = "00" + page.toString() + "00" + i.toString();
      audios.add(Audio("assets/audios/$page/$path.mp3"));
    }

    List<String> textl = [];

    textlist.forEach((item) {
      textl.add(item.text!);
    });
    String fulltext;

    fulltext = textl.join('\n\n');

    // final assetsAudioPlayer = AssetsAudioPlayer.withId("0");

    // final bool playing = assetsAudioPlayer.isPlaying.value;

    Future<void> PlayAudios(splittedText) async {
      print("AYA INDEX: $ayaIndex");

      // print("PREVIOUS $prev");

      assetsAudioPlayer.current.listen((playingAudio) {
        final asset = playingAudio!.audio;
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

//split full text by line and by aya numbers
    splittedText = HelperFunctions.splitLinesintoList(fulltext);

    //num of pages, for now its 4
    List<int> listindex = [1, 2, 3, 4];
int activeIndex = 1;

    return  
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(top:90),
              height: 550,
              child: SingleChildScrollView(
                child: CarouselSlider.builder(
                  
                  itemCount: listindex.length,
                  itemBuilder: (context, index, realIndex) {
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
                  },
                  options: CarouselOptions(
                      height: 800,
                      reverse: false,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      initialPage: -1,
                      scrollDirection: Axis.horizontal,
                      
                      onPageChanged: (index, reason) {
                        setState(() {
                          // print(reason);
                          activeIndex=activeIndex+1;
                          if( activeIndex<listindex.length) {
                          Provider.of<ayatLines_provider>(context, listen: false)
                              .getLines(activeIndex);}
                            // else if ( activeIndex==listindex.length){
                            //     Provider.of<ayatLines_provider>(context, listen: false)
                            //   .getLines(index+2);
                            //                            print("end of list");

                            //   }
                           
                            // activeIndex=index+1;
                            // print(index);

                            // if (activeIndex==1) {
                            //   print("do nothing");

                            // }
                            // else if(activeIndex>0 && activeIndex<listindex.length) {
                            //   print("condition active index $activeIndex");
                            //  Provider.of<ayatLines_provider>(context, listen: false)
                            //   .getLines(activeIndex);}
                        //  textData = Provider.of<ayatLines_provider>(context, listen: false);
                        //    textlist = textData.text;
                        // lengthoflines = textlist.length; 
                        });
                      }
                       ), 
                      ),
              ),
            ),
            SizedBox(height: 6,),
           
         Container(
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
        SizedBox(
          height: 80,
        ),
         ],
        ) ;

                   


                  // pageSnapping: false,
                  
       
   

  }
}
