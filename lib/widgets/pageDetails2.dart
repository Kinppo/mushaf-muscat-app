import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/models/book_mark.dart';
import 'package:mushafmuscat/providers/bookMarks_provider.dart';
import 'package:provider/provider.dart';

import 'package:mushafmuscat/models/pageText.dart';
import '../widgets/finalCarousel2.dart';
import '../models/AyatLines.dart';
import '../providers/audioplayer_provider.dart';
import '../providers/ayatLines_provider.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';

class pageDetails2 extends StatefulWidget {
  int id;
  int indexhighlight;
  int currentpage;
  bool ayaFlag;
  Function toggleClickedHighlight;
  int clickedHighlightNum;
  bool firstFlag;
  int prev;
  bool closedBottomSheet;

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
    required this.firstFlag,
    required this.prev,
    required this.closedBottomSheet,
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
var bookmarks;

  // int clickedHighlightNum = 0;
  bool firstFlag = false;
  bool clickHighlightWhilePlaying = false;
  int indexhighlighted = 0;
  int storeCurrentPage = 0;
  

  //bookmark variables
  bool bkSamePage= false;
   late Color bkColor;
   late int bkIndex;


 


  @override
  initState() {
    if (isLoaded == false) {
      loadTextandBookmarks(widget.currentpage);
      // print("audio list for page $widget.id is $audioList");
      // print(audioList.toString());

      //todo:fix this
      isLoaded = true;
    }

    super.initState();
  }


 Color pickColor (String type) {
    
    switch (type) {
      case '1':
      return CustomColors.yellow400;
        
      case '2':
      return CustomColors.pink100;

      case '3':
      return CustomColors.green200;

      case '4':
      return CustomColors.blue100;

      default:  return Colors.transparent;
    }
  }


  void loadTextandBookmarks(int page) {
    textlist =
        Provider.of<ayatLines_provider>(context, listen: false).getLines(page);

  }


  didChangeDependencies() {
    final List<BookMark> bk = Provider.of<BookMarks>(context, listen: true).bookmarks;

bk.forEach((element) {
  setState(() {
     if (element.pageNum== widget.currentpage){
    bkSamePage=true;
    bkColor = pickColor(element.type);
    bkIndex= element.highlightNum;
    print("we are in the same page");
  }});
  });
 
    super.didChangeDependencies();
  }




  List<TextSpan> createTextSpans() {
    if (widget.currentpage != widget.id) {
      setState(() {
        widget.indexhighlight = -1;
      });
    }
    //=======
    textlist = Provider.of<ayatLines_provider>(context, listen: false)
        .getLines(widget.id);
    List<String> textl = [];
Size s = (context.findRenderObject() as RenderBox)?.size ?? Size.zero;
print("SIZE IS $s");
    textlist.then((value) {

      for (int i=0; i<value.length; i++) {
        // print(value[value.length-1].text.toString());
        if (value[i].endOfSurah =='1' && i!= value.length-1 ) {
 textl.add(value[i].text!+'\n\n\n\n');
}
// else { 
// print(value[i].text.length);

// bool containsChars = value[i].text.contains('ۖ ')  || (value[i].text.contains('ۚ ')) || value[i].text.contains('۞')|| (value[i].text.contains(' ۛ'));

// if(value[i].text.length<85 && !containsChars) {



// if () {
// print("CONTAINSSSS");
// // int diff= 75 - value[i].text.length as int;
// var list = new List<String>.generate(8, (i) => ',');
// String added=list.join('');
// textl.add(value[i].text!+added);
// }

// else  {
// int diff= 85 - value[i].text.length as int;
// var list = new List<String>.generate(diff, (i) => ',');
// String added=list.join('');
// textl.add(value[i].text!+added);
// }
// }
//  textl.add(value[i].text!+"----------");
//  }
// else if(value[i].text.length<78) {
//  textl.add(value[i].text!+"------");
//  }

//  else if(value[i].text.length<88) {
//  textl.add(value[i].text!+"---");
//  }


 else  textl.add(value[i].text!);

// }
// }    
// print(value[i].text.toString() + '....' +(value[i].text.length.toString()));
        // print(value[i].text.length.toString());
        fulltext = textl.join('\n\n');

      }
//       value.forEach((item) {
//            if (item.endOfSurah =='1' ) {
//  textl.add(item.text!+'\n\n\n\n\n');
// }
// else { r
//  textl.add(item.text!);
// }     
       
     
        // fulltext = textl.join('\n\n');
      // });
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
    final List<TextSpan> arrayOfTextSpan = [];

    // final string = """Text seems like it should be so simple, but it really isn't.""";
    // final arrayStrings = string.split(" ");
    bool tapped = false;
    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index] + "";
      final span = TextSpan(
          text: text,

          style: TextStyle(
            background: Paint()..color = Colors.transparent
        


            
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                
                highlightFlag = true;
                idx = arrayOfTextSpan
                    .indexWhere((element) => element.text == text);
                print("highlighted line number  $idx");
                var intValue = int.parse(text.replaceAll(RegExp('[^0-9]'), ''));

                print("highlighted TEXT IS  " + intValue.toString());
                widget.clickedHighlightNum = idx + 1;
                widget.toggleClickedHighlight(idx + 1, intValue.toString());
              });

              // print("The word touched is $text");
            });
      arrayOfTextSpan.add(span);
    }
    setState(() {

      print("HIGHLIGHT FLAG IS CURRENTLY $highlightFlag");
      if (highlightFlag == true) {
        arrayOfTextSpan[idx].style?.background!.color =
            Colors.brown.withOpacity(0.25);
        arrayOfTextSpan[idx].style?.background!.strokeWidth = 8.9;
      highlightFlag=false;
      
      }
    });

     if (bkSamePage == true) { 
      arrayOfTextSpan[bkIndex].style?.background!.color =
    bkColor.withOpacity(0.25);
        arrayOfTextSpan[bkIndex].style?.background!.strokeWidth = 8.9;

     }



    setState(() {
      if (widget.currentpage == widget.prev &&
          widget.ayaFlag != false &&
          arrayStrings[0] != "") {
            
        ///====temp and may be disposed later based on the use case
        if (widget.closedBottomSheet == true ) {
          // highlightFlag = false;
                    widget.closedBottomSheet= false;

          arrayOfTextSpan[idx].style?.background!.color = Colors.transparent;
        }

        ///====
        arrayOfTextSpan[widget.indexhighlight].style?.background!.color =
            Color.fromARGB(255, 223, 223, 66).withOpacity(0.15);

    
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
        padding: EdgeInsets.fromLTRB(0, 55, 6, 0),
        child: Expanded(
            child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.start,
          overflow:TextOverflow.fade,
          textWidthBasis:TextWidthBasis.longestLine,

          text: new TextSpan(
            style: const TextStyle(
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.brown,
                wordSpacing: 2.2,
                letterSpacing: 1.1,
                                height: 1.4,

                // height: 1.68,
        

                ),
            children: createTextSpans(),
          ),
        )));
  }

  // Container? AllOtherPagesContainer() {
  //   return Container(
  //       padding: EdgeInsets.fromLTRB(12, 53, 6, 0),
  //       child: Expanded(
  //           child: RichText(
  //         textDirection: TextDirection.rtl,
  //         textAlign: TextAlign.justify,
  //         text: new TextSpan(
  //           style: const TextStyle(
  //               fontFamily: 'Amiri',
  //               fontWeight: FontWeight.bold,
  //               fontSize: 13,
  //               color: Colors.brown,
  //               wordSpacing: 2.6,
  //               letterSpacing: 1,
  //               height: 1.25),
  //           children: createTextSpans(),
  //         ),
  //       )));
  // }


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
