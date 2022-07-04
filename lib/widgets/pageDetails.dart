import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
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
// Function togg;

  pageDetails({
    Key? key,
    required this.id,
    required this.indexhighlight,
    required this.currentpage,
    required this.ayaFlag,
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

  String? getData() {
  // setState(() {
  //   widget.surahName="rere";
  // });
    // test();
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
        ? DynamicTextHighlighting(
            text: getData(),
            textAlign: TextAlign.center,
            highlights: (widget.currentpage != widget.id ||
                    widget.ayaFlag == false ||
                    splittedList[0] == "")
                ? ['  ']
                : [splittedList[widget.indexhighlight]],
            color: Colors.yellow,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "IBMPlexSansArabic",
              color: CustomColors.black200,
              //color: Colors.black.withOpacity(0),
            ),
            caseSensitive: false,
          )
        : CircularProgressIndicator();
  }
}
