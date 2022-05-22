import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/material.dart';

import 'package:mushafmuscat/models/quarter.dart';
import 'package:mushafmuscat/providers/ayatLines_provider.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';

class Quran extends StatelessWidget {
  int pageNum;
  Quran({Key? key, required this.pageNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ayatLines_provider>(context, listen: false).getLines(pageNum);
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

//split full text by line and by aya numbers
    splittedText = splitAyasandLines();

    print(splittedText);
//print("FULL TEXT $fulltext");
    return Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            DynamicTextHighlighting(
              text: fulltext,
              textAlign: TextAlign.center,
              highlights: splittedText.sublist(2, 4),
              color: Colors.yellow,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "IBMPlexSansArabic",
                color: CustomColors.black200,
              ),
              caseSensitive: false,
            ),

            // Text(fulltext, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
            //for (var item in textlist) Text(pageNum.toString() + item.text! + "\n" , style: TextStyle(fontSize: 15,  ),),
            // Text(pageNum.toString() + textlist.toString()),
          ],
        ));
  }
}
