import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mushafmuscat/models/quarter.dart';
import 'package:mushafmuscat/providers/ayatLines_provider.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../widgets/audioplayer.dart';

class QuranTest extends StatefulWidget {
  int pageNum;
  QuranTest({Key? key, required this.pageNum}) : super(key: key);

  @override
  State<QuranTest> createState() => _QuranTestState();
}

class _QuranTestState extends State<QuranTest> {
  final audios = <Audio>[];
  List<String> highlights = [];
  int ayaIndex = 0;
  bool play = true;
  bool startflag = true;
  PlayingAudio? prev;
  List<String> splittedText = [];

  //audioplayer variables
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  bool firstFlag = false;
  bool showPauseIcon = false;
  //List<Audio> audios = [];

  bool stopindex = false;
  bool seekBackward = false;

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 7; i++) {
      audios.add(Audio("assets/audios/1/00100$i.mp3"));
    }
  }

  void deactivate() {
    super.deactivate();
    assetsAudioPlayer.dispose();
  }

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
    final textData = Provider.of<ayatLines_provider>(context, listen: false);
    final textlist = textData.text;

    List<String> textl = [];

    textlist.forEach((item) {
      textl.add(item.text!);
    });
    String fulltext;

    fulltext = textl.join('\n\n');

    List<String> splitAyasandLines() {
      String fulltexttosplit;

      fulltexttosplit = fulltext;

      fulltexttosplit = fulltexttosplit.replaceAll('(', '.');
      fulltexttosplit = fulltexttosplit.replaceAll(')', '.');
      fulltexttosplit = fulltexttosplit.replaceAll(RegExp(r'\d'), '.');

      fulltexttosplit = fulltexttosplit.replaceAll('...', 'L');

      List<String> final_list = fulltexttosplit.split('L');

      return final_list;
    }

    // final assetsAudioPlayer = AssetsAudioPlayer.withId("0");

    // final bool playing = assetsAudioPlayer.isPlaying.value;

    Future<void> PlayAudios(splittedText) async {
      print("AYA INDEX: $ayaIndex");

      // print("PREVIOUS $prev");

      assetsAudioPlayer.current.listen((playingAudio) {
        final asset = playingAudio!.audio;

        if (prev != asset && seekBackward == false) {
          // changeText([splittedText[ayaIndex]]);
          changeText();
          // print("ASSET");
          // print(asset);
          setState(() {
            prev = asset;
          });
        } else if (seekBackward == true) {
          // print("SPLITTED TEXT: $splittedText");

          //changeText([splittedText[ayaIndex-1]]);
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
    splittedText = splitAyasandLines();

    // print(splittedText);
//print("FULL TEXT $fulltext");
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: Column(
        children: [
          DynamicTextHighlighting(
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
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(color: CustomColors.brown700, width: 1),
            ),
            width: 650,
            height: 70,
            //  padding: EdgeInsets.all(5),
            //  margin: EdgeInsets.all(5),
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
          )
        ],
      ),
    );
  }
}
