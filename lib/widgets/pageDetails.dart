import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/models/pageText.dart';
import 'package:provider/provider.dart';

import '../models/AyatLines.dart';
import '../providers/ayatLines_provider.dart';
import '../resources/colors.dart';
import '../utils/helperFunctions.dart';

class pageDetails extends StatefulWidget {
  int id;

  int indexhighlight;
  int currentpage;
  bool ayaFlag;
  int clickedHighlightNum;
  Function toggleClickedHighlight;

// Function togg;

  pageDetails({
    Key? key,
    required this.id,
    required this.indexhighlight,
    required this.currentpage,
    required this.ayaFlag,
    required this.clickedHighlightNum,
    required this.toggleClickedHighlight,
    // required this.togg,
  }) : super(key: key);

  @override
  State<pageDetails> createState() => _pageDetailsState();
}

class _pageDetailsState extends State<pageDetails> {
  String? fulltext;
  bool flag = false;
  List<String> splittedList = [''];
  late bool isLoaded = false;
  var textlist;
  String tempText = '';
  bool highlightFlag = false;
  int idx = 0;
  bool clickedListen = false;

  @override
  initState() {
    if (isLoaded == false) {
      textlist = Provider.of<ayatLines_provider>(context, listen: false)
          .getLines(widget.id);

      //todo:fix this
      isLoaded = true;
    }

    super.initState();
  }

//  Future <void> test() async {
//   widget.togg( textlist[0].surahName.toString());
//     print("test");
//   }

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
      final text = arrayStrings[index] + " ";
      final span = TextSpan(
          text: text,
          style: TextStyle(background: Paint()..color = Colors.transparent),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                highlightFlag = true;
                idx = arrayOfTextSpan
                    .indexWhere((element) => element.text == text);
                
                print("highlighted line number  $idx");
                widget.clickedHighlightNum= idx+1;
                widget.toggleClickedHighlight(idx+1);

              });

              // print("The word touched is $text");
              // Paint().color = Colors.red;
            });
      arrayOfTextSpan.add(span);
    }

    if (highlightFlag == true) {
      arrayOfTextSpan[idx].style?.background!.color =
          Colors.brown.withOpacity(0.2);
    }  
      setState(() {
        if (widget.currentpage == widget.id &&
            widget.ayaFlag != false &&
            arrayStrings[0] != "") {

              ///====temp and may be disposed later based on the use case
              if (highlightFlag == true) {
                highlightFlag=false;
                arrayOfTextSpan[idx].style?.background!.color =
          Colors.transparent;
               }
               ///====

          arrayOfTextSpan[widget.indexhighlight].style?.background!.color =
              Colors.yellow;
        }
      });
    

//  highlights: (widget.currentpage != widget.id ||
    //                 widget.ayaFlag == false ||
    //                 splittedList[0] == "")
    //             ? ['  ']
    //             : [splittedList[widget.indexhighlight]],
    //         color: Colors.yellow,

    //  print(arrayOfTextSpan[3]);
    return arrayOfTextSpan;
  }

  String? getData() {
    if (widget.currentpage != widget.id) {
      setState(() {
        widget.indexhighlight = -1;
      });
    }

    print(widget.indexhighlight);

    // String c = widget.currentpage.toString();
    // String i = widget.id.toString();
    // print("current page is $c and widget id is $i");

    List<String> textl = [];

    textlist.then((value) {
      value.forEach((item) {
        textl.add(item.text!);
        fulltext = textl.join('\n\n');
      });
    });
    if (fulltext == null) {
      return '';
    }

    splittedList = (HelperFunctions.splitLinesintoList(fulltext!));
    // setState(() {
    //      widget.surahName= textlist[0].surahName;
    //   });

// if (widget.indexhighlight!=-1) {
// //  print(hi[widget.indexhighlight]);}

    return fulltext;
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Center(
            child: Column(children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 135),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: new TextSpan(
                      style: TextStyle(fontSize: 15, color: Colors.black, 
                      wordSpacing:3, height: 1.3),
                      children: createTextSpans(),
                    ),
                  ),
                ),
              ),
            ]),
          )

        //       child: Material(
        //         clipBehavior: Clip.hardEdge,

        //         child: InkWell(
        // splashColor: Colors.yellow,
        // highlightColor: Colors.blue,
        // onTap: (){},
        // child: Icon(Icons.add_circle, size: 50),
        //         ),),)
        //     child: DynamicTextHighlighting(
        //         text: "hello",

        //         textAlign: TextAlign.center,
        //         highlights: (widget.currentpage != widget.id ||
        //                 widget.ayaFlag == false ||
        //                 splittedList[0] == "")
        //             ? ['  ']
        //             : [splittedList[widget.indexhighlight]],
        //         color: Colors.yellow,
        //         style: TextStyle(
        //           fontSize: 15,
        //           fontFamily: "IBMPlexSansArabic",
        //           color: CustomColors.black200,
        //           //color: Colors.black.withOpacity(0),
        //         ),
        //         caseSensitive: false,
        //       ),
        //   ),
        // )
        : CircularProgressIndicator();
  }
}
