import 'package:flutter/material.dart';
import '../resources/colors.dart';

class QuranSurahSearchTiles extends StatelessWidget {
  String? num;
  String? title;
  String? numAya;
  String? type;
  String? firstPageNum;
  Function? tapHandler;



QuranSurahSearchTiles({Key? key,  this.num,  this.title,  this. numAya,  this.type, this.firstPageNum, this.tapHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
            trailing: CircleAvatar(
              child: Text(
                num!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              radius: 15,
              backgroundColor: Theme.of(context).shadowColor,
            ),
            title: Text(
              title!,
              style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: CustomColors.black200,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            subtitle: Text("آياتها : $numAya   .   $type",
                style:
                     TextStyle(color: CustomColors.grey200)),
            onTap: () {
            //   print("number: $num");
            //    print("title: $title");
            //   print("numAya: $numAya");
            // print("firstPageNum: $firstPageNum");
            //   print("tapped $firstPageNum");
              tapHandler!(firstPageNum);
            });
  }
}