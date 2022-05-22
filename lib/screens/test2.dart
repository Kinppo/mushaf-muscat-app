import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:mushafmuscat/models/AyatLines.dart';
import 'package:mushafmuscat/models/pageText.dart';
import 'package:mushafmuscat/providers/pageText_provider.dart';
import 'package:mushafmuscat/providers/ayatLines_provider.dart';

import 'package:mushafmuscat/resources/colors.dart';
import 'package:mushafmuscat/widgets/appbar.dart';
import 'package:mushafmuscat/widgets/quran.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart';

import '../models/surah.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:provider/provider.dart';

import '../localization/app_localizations.dart';
import '../models/surah.dart';
import '../providers/quran_display_provider.dart';
import '../utils/helperFunctions.dart';
import '../widgets/drawer_screen_search_bar.dart';
import '../widgets/surahs_list.dart';

class Test2 extends StatefulWidget {
  static const routeName = '/test';

  const Test2({Key? key}) : super(key: key);

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {


  int ayaIndex =0;
  int activeIndex = 0;
  List<String> highlights= [];
  final audios = <Audio>[];

  bool _isInit = true;
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 6; i++) {
        audios.add(Audio("assets/audios/11400$i.mp3"));
  }}

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      
      // Provider.of<QuranDisplay>(context).fetchImages().then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });

      //   Provider.of<ayatLines_provider>(context).fetchPageText().then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  changeText(List <String> s) {
  // print("New highlights");
   //print(s);
    
//  highlights = s;
   setState(() {
//print(s[0]);
     highlights= s;
     ayaIndex=ayaIndex+1;

  }); }


  @override
  Widget build(BuildContext context) {
    //    final textData = Provider.of<ayatLines_provider>(context, listen: false);
    // final textlist = ["DDD","DDr"];

    final assetsAudioPlayer = AssetsAudioPlayer();
    //print(highlights);
    // print(textlist);

    final bool playing = assetsAudioPlayer.isPlaying.value;

    Future<void> openAudio() async {
      try {
        print(playing);
        await assetsAudioPlayer.open(
          Audio.network(
              "http://www.everyayah.com/data/Ghamadi_40kbps/114001.mp3"),
        );

        assetsAudioPlayer.play();
        //   print(playing);

        //  if (playing == false ) {
        //    print ("STOPPED");
        // }

      } catch (t) {
        print('not reachable');
        //mp3 unreachable
      }
    }

    Future<void> PlayAudios(List<String> listofstrings) async {
     
      print(audios);
      assetsAudioPlayer.open(Playlist(audios: audios),
          loopMode: LoopMode.playlist 

          );
          // print("CURRENT");
          // print(assetsAudioPlayer.current);



assetsAudioPlayer.setLoopMode(LoopMode.none);
      assetsAudioPlayer.next();
      assetsAudioPlayer.previous();
      assetsAudioPlayer.playlistPlayAtIndex(0);

assetsAudioPlayer.current.listen((playingAudio){
    final asset = playingAudio!.audio;
      changeText([listofstrings[ayaIndex]]);
    print("ASSET");
    print(asset);
  
});
    }


Widget ayatwidgets(String data) {
  return Text(data);
}
    String longtext = '';
    longtext =
        "قُلْ أَعُوذُ بِرَبِّ النَّاسِ (1) مَلِكِ النَّاسِ (2) إِلَهِ النَّاسِ (3) مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ (4) الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ (5) مِنَ الْجِنَّةِ وَالنَّاسِ (6)";

    String originalLongText = longtext.toString();
    longtext = longtext.replaceAll('(', '.');
    longtext = longtext.replaceAll(')', '.');
    longtext = longtext.replaceAll(RegExp(r'\d'), '.');

    longtext = longtext.replaceAll('...', 'L');
    // print(longtext);

    List<String> listofstrings = longtext.split('L');
    // print(listofstrings.length);

    for (int i = 0; i < listofstrings.length; i++) {
      // print(i.toString() + " " + listofstrings[i]);
    }
    listofstrings.removeLast();
    for (int i = 0; i < listofstrings.length; i++) {
      // print(i.toString() + " " + listofstrings[i]);
    }
     List <String> m= [];
                  m.add(listofstrings[0]);
        //  print(m);         
    List <String> s= [];
      
                 s.add(listofstrings[1]);
                 
    // print("updated " );
    // print(highlights);
   List <int> listindex =[1,2,3,4];
  //  List <String> pages= [""]
    return Scaffold(
      body: Center( 
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              // for (int j=0; j< textlist.length; j++) {
              
              // }
              Container(
                child: Column(
                  children: <Widget>[
            // for(var item in textlist) Text(item.text!),
        
            CarouselSlider.builder(
                itemCount: listindex.length,
                itemBuilder: (context, index, realIndex) {
                  // final urlImage = pages[index];
                  // print("INDEX: $index"  );
                  // print("REAL INDEX: $realIndex"  );
        
                  return Quran(pageNum: index+1);
                },
                options: CarouselOptions(
                    height: 800,
                    reverse: false,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    initialPage: -1,
                    scrollDirection: Axis.horizontal,
                    //aspectRatio: 3,
                    //enlargeCenterPage: true,
        
                    //disableCenter: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    }
                    //pageSnapping: false
                    )),
       
              ],
                  // children: <Widget>  [
                  //  for(int j=0; j< textlist.length; j++) { 
                  //       ayatwidgets(textlist[j].text);
                  //  }]
                   ),
                   
                ),
                //padding: EdgeInsets.all(40),
                //child: Text(textlist[2].text!),
               // child: DynamicTextHighlighting(
            //text:  "قُلْ أَعُوذُ بِرَبِّ النَّاسِ (1) مَلِكِ النَّاسِ (2) إِلَهِ النَّاسِ (3) مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ (4) الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ (5) مِنَ الْجِنَّةِ وَالنَّاسِ (6)",
           // highlights: highlights,
            //color: Colors.yellow,
            //style: TextStyle(
             // fontSize: 23,
             // fontFamily: "IBMPlexSansArabic",
             // color: CustomColors.black200,
            //),
           // caseSensitive: false,
          //),
                
               
             // ),
              ElevatedButton(
                  onPressed: () async {
                    await PlayAudios(listofstrings);
                  },
                  child: Text("Play Audio")),
              ElevatedButton(
                  onPressed: () {
                   
                    // changeText([listofstrings[ayaIndex]]);
                  } ,
                  
                  child: Text("Highlight Audio")),
            ],
          ),
        ),
      ),
    );
  }
}
  