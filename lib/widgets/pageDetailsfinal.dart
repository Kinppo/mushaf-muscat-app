import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mushafmuscat/models/pageText.dart';
import '../widgets/finalCarousel2.dart';
import '../models/AyatLines.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/ayatLines_provider.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';

class pageDetails2 extends StatefulWidget {
  static final GlobalKey<_pageDetails2State> globalKey2 = GlobalKey();

  int id;
  int indexhighlight;
  int currentpage;
  bool ayaFlag;
  Function toggleClickedHighlight;
  int clickedHighlightNum;
  Function ContinueNextPage;
  int savedPage;
  int savedHighlight;
  List<Audio> audiosList;
  List<String> FlagsAudio;
  bool pageDetails_playAudios;
    bool firstFlag;
    Function toggleIndex;

  // bool pageDetails_loadAudios;

// Function togg;

  pageDetails2({
    Key? key,
    required this.id,
    required this.indexhighlight,
    required this.currentpage,
    required this.ayaFlag,
    required this.toggleClickedHighlight,
    required this.clickedHighlightNum,
    required  this.ContinueNextPage,
    required this.savedPage, 
    required this.savedHighlight,
    required this.audiosList, 
    required this.FlagsAudio,
    required this.pageDetails_playAudios,
    required this.firstFlag,
    required this.toggleIndex,
  }) : super(key: key);

  @override
  State<pageDetails2> createState() => _pageDetails2State();
}

class _pageDetails2State extends State<pageDetails2> {
  String? fulltext;
  bool flag = false;
  List<String> splittedList = [''];
  late bool isLoaded = false;
  var textlist;
  String tempText = '';
  bool highlightFlag = false;
  int idx = 0;
  bool clickedListen = false;
//new vars
  List<String> audioPaths = [];
  List<Audio> audioList = [];
  final assetsAudioPlayer = AssetsAudioPlayer();
  // int clickedHighlightNum = 0;
  bool firstFlag = false;
  bool clickHighlightWhilePlaying = false;
  int indexhighlighted=0;
  List<String> FlagsAudio = [];
  int storeCurrentPage=0;


  @override
  initState() {
    if (isLoaded == false) {
    loadTextandAudios(widget.currentpage);
      // print("audio list for page $widget.id is $audioList");
      // print(audioList.toString());
     

      //todo:fix this
      isLoaded = true;
    }

    super.initState();
  }

   void loadTextandAudios(int page) {
      textlist = Provider.of<ayatLines_provider>(context, listen: false)
          .getLines(page);


  
     
  }

didChangeDependencies () {
  
  super.didChangeDependencies();
}

Future<void> loadAudios(int page) async {
  await Provider.of<AudioPlayer_Provider>(context, listen: false)
          .getAudioPaths(widget.id);
      // audioList = await Provider.of<AudioPlayer_Provider>(context, listen: false).aud;
      // FlagsAudio= await Provider.of<AudioPlayer_Provider>(context, listen: false).FlagsAudio;
    
    // setState(() {
    //   widget.pageDetails_loadAudios=false;
    // });
    // setState(() {
    //       widget.savedPage= page;

    // });
    
print("done");
}



void gotonextpage() {
  setState(() {
    widget.ContinueNextPage();
  });
}

  void playFromHighlightedText() {

    print("ENTERED HIGHLIGHTED");
//           storeCurrentPage=widget.id;
// print("Current page is $storeCurrentPage");
    assetsAudioPlayer.open(
        Playlist(audios: widget.audiosList, startIndex: idx),
        loopMode: LoopMode.none);
 assetsAudioPlayer.current.listen((playingAudio) {
      final asset = playingAudio!.audio;
print("---------saved page is " + widget.savedPage.toString());
 print("flag is $FlagsAudio");
 setState(() {
    indexhighlighted= playingAudio.index;
      widget.toggleIndex(indexhighlighted);
    print("INDEX HIGHLIGHT IS $indexhighlighted");

 });
      if (playingAudio.index != 0 &&
          FlagsAudio.length > 0 &&
          FlagsAudio[playingAudio.index - 1] == '1') {
        print("THIS IS THE LAST LAST AYA");
          assetsAudioPlayer.playlistAudioFinished.listen((event){
       });
      }


 if (playingAudio.index != 0 &&
          FlagsAudio.length > 0 &&
          FlagsAudio[playingAudio.index - 1].toString() == "0" &&
          playingAudio.index == FlagsAudio.length - 1) {
        assetsAudioPlayer.playlistFinished.listen((finished) {

          if (finished == true) {
                       gotonextpage();

            print("finished finsihed");
            // assetsAudioPlayer.stop();
            // FlagsAudio.clear();

            // moveToNextPage();
          // }
          } });}
setState(() {
  indexhighlighted= playingAudio.index;
  widget.ayaFlag=true;
  print(indexhighlighted);
});     

      
 
     
    assetsAudioPlayer.play();
 });}

 
  List<TextSpan> createTextSpans() {


    if (widget.currentpage != widget.id) {
      setState(() {
        widget.indexhighlight = 0;
                // widget.pageDetails_loadAudios=false;

      });
    }
    //=======
    textlist = Provider.of<ayatLines_provider>(context, listen: false)
        .getLines(widget.id);
    List<String> textl = [];

    textlist.then((value) {
      value.forEach((item) {
        textl.add(item.text!);
        fulltext = textl.join('\n\n');
      });
    });
    // print(fulltext);
    if (fulltext == null) {
      return [TextSpan(text: '')];
    }
    fulltext = fulltext!.replaceAll(')', ').');

    splittedList = fulltext!.split(".");
    // splittedList = fulltext!.replaceAll('.', ')');

    // splittedList = (HelperFunctions.splitLinesintoList(fulltext!));
    //=======
    final arrayStrings = splittedList;
    // final string = """Text seems like it should be so simple, but it really isn't.""";
    // final arrayStrings = string.split(" ");
    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index] + "";
      final span = TextSpan(
          text: text,
          style: TextStyle(
            background: Paint()..color = Colors.transparent,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                highlightFlag = true;
                idx = arrayOfTextSpan
                    .indexWhere((element) => element.text == text);

                print("highlighted line number  $idx");
                // widget.clickedHighlightNum = idx + 1;

      // if (firstFlag == true) {
      //   clickHighlightWhilePlaying = true;
      // }
              widget.toggleClickedHighlight(idx + 1);
              });

              // print("The word touched is $text");
              // Paint().color = Colors.red;
            });
      arrayOfTextSpan.add(span);
    }

    if (highlightFlag == true) {
      arrayOfTextSpan[idx].style?.background!.color =
          Colors.brown.withOpacity(0.25);

      arrayOfTextSpan[idx].style?.background!.strokeWidth = 8.9;
    }
    setState(() {
      print("Widget.currentpage: " + widget.currentpage.toString());
      print("widget.id: " + widget.id.toString());
      // print(arrayStrings);

      if (
          
          arrayStrings[0] != "" && widget.audiosList.length != 0 && widget.firstFlag==false)  {

           

           setState(() {
             widget.firstFlag=true;
           });
       
        print("Entered condition");
        // /====temp and may be disposed later based on the use case
        if (highlightFlag == true) {
          highlightFlag = false;
          arrayOfTextSpan[idx].style?.background!.color = Colors.transparent;
        }

        // /====

       

 arrayOfTextSpan[3].style?.background!.color =
            Color.fromARGB(255, 223, 223, 66).withOpacity(0.15);
                                                    playFromHighlightedText();

      }
    });

    return arrayOfTextSpan;
  }

  Container? Page1_and2Container() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 70, 22, 0),
      child: Expanded(
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          text: new TextSpan(
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.brown,
              wordSpacing: 2,
              letterSpacing: 1,
              height: 1.3,
            ),
            children: createTextSpans(),
          ),
        ),
      ),
    );
  }

  Container? AllOtherPagesContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 53, 6, 0),
      child: Expanded(
        child:    RichText(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
            text: new TextSpan(
              style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.brown,
                  wordSpacing: 2.6,
                  letterSpacing: 1,
                  height: 1.25),
              children: createTextSpans(),
            ),))
          );     


  
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Center(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: (widget.id == 1 || widget.id == 2)
                        ? Page1_and2Container()
                        : AllOtherPagesContainer(),
                  ),
                ]),
          )
        : CircularProgressIndicator();
  }
  
  
}
