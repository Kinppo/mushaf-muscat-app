import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/models/pageText.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
                widget.clickedHighlightNum = idx + 1;
                widget.toggleClickedHighlight(idx + 1);
              });

              // print("The word touched is $text");
              // Paint().color = Colors.red;
            });
      arrayOfTextSpan.add(span);
    }

    if (highlightFlag == true) {
      arrayOfTextSpan[idx].style?.background!.color =
          Colors.brown.withOpacity(0.2);

      arrayOfTextSpan[idx].style?.background!.strokeWidth = 8.9;
    }
    setState(() {
      if (widget.currentpage == widget.id &&
          widget.ayaFlag != false &&
          arrayStrings[0] != "") {
        ///====temp and may be disposed later based on the use case
        if (highlightFlag == true) {
          highlightFlag = false;
          arrayOfTextSpan[idx].style?.background!.color = Colors.transparent;
        }

        ///====

        arrayOfTextSpan[widget.indexhighlight].style?.background!.color =
            Color.fromARGB(255, 227, 196, 111).withOpacity(0.2);
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

  Container? Page1_and2Container() {
    return Container(
      padding: EdgeInsets.only(top: 122),
      child: Expanded(
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          text: new TextSpan(
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.red,
              wordSpacing: 3,
              letterSpacing: 10,
              height: 1.4,
            ),
            children: createTextSpans(),
          ),
        ),
      ),
    );
  }

  Container? AllOtherPagesContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 52, 13, 0),
      child: Expanded(
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          text: new TextSpan(
            style: const TextStyle(
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.red,
                wordSpacing: 3,
                letterSpacing: 12,
                height: 1.7),
            children: createTextSpans(),
          ),
        ),
      ),
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
                    child: (widget.id == 1 || widget.id == 2) ? Page1_and2Container() :
                    AllOtherPagesContainer(),
                  ),
                ]),
          )
      
        : CircularProgressIndicator();
  }
}
