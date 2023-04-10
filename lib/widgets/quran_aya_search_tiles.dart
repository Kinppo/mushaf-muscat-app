import 'package:flutter/material.dart';
import '../resources/colors.dart';

class QuranAyaSearchTiles extends StatelessWidget {
  String? surahNum;
  String? ayaText;
  String? numAya;
  String? surahName;
  String? ayaPageNum;
  Function? tapHandler;



QuranAyaSearchTiles({Key? key,  this.surahNum,  this.ayaText,  this. numAya,  this.surahName, this.ayaPageNum, this.tapHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
            title: Text(
              ayaText!,
              style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: CustomColors.black200,
                  fontSize: 18),
                                                  overflow: TextOverflow.ellipsis,

            ),
            subtitle: Text("$surahName . الآية: $numAya",
                style:
                     TextStyle(color: CustomColors.grey200)),
            onTap: () {
            //   print("number: $num");
            //    print("title: $title");
            //   print("numAya: $numAya");
            // print("firstPageNum: $firstPageNum");
            //   print("tapped $firstPageNum");
              tapHandler!(ayaPageNum);
            });
  }
}