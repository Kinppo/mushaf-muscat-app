import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/material.dart';

import 'package:mushafmuscat/models/quarter.dart';
import 'package:mushafmuscat/providers/ayatLines_provider.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../widgets/audioplayer.dart';

class Quran extends StatefulWidget {
 

  int pageNum;
  Quran({Key? key, required this.pageNum}) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
  
}

class _QuranState extends State<Quran> {
  final audios = <Audio>[];
  List<String> highlights = [];
  int ayaIndex = 0;
  bool play = true;
  bool startflag= true;



  bool stopindex =false;

  @override
  
  void initState() {
    super.initState();
    for (int i = 1; i <= 7; i++) {
      audios.add(Audio("assets/audios/1/00100$i.mp3"));
    }
  }


changeStop () {
  setState(() {
  stopindex=true;
}); 
}
  changeText(List<String> s) {
    // print("New highlights");
    //print(s);

//  highlights = s;
    setState(() {
//print(s[0]);
      highlights = s;
      ayaIndex = ayaIndex + 1;
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

    List<String> splittedText;

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

    final assetsAudioPlayer = AssetsAudioPlayer.withId("0");

    final bool playing = assetsAudioPlayer.isPlaying.value;

 
    Future<void> PlayAudios(List<String> listofstrings) async {
   

      assetsAudioPlayer.current.listen((playingAudio) {
        final asset = playingAudio!.audio;
        changeText([listofstrings[ayaIndex]]);
        print("ASSET");
        print(asset);

      
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
                 AudioPlayerWidget(),

        ],
      ),
    );
    
  }

}
