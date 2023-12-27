import 'package:flutter/material.dart';
import '../resources/colors.dart';

class SurahsList extends StatelessWidget {
  String? num;
  String? title;
  String? numAya;
  String? type;
  String? firstPageNum;
  Function? tapHandler;

  SurahsList(
      {Key? key,
      this.num,
      this.title,
      this.numAya,
      this.type,
      this.firstPageNum,
      this.tapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: CircleAvatar(
          child: Text(
            num!,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          radius: 20,
          backgroundColor: Theme.of(context).shadowColor,
        ),
        title: Text(
          title!,
          style: Theme.of(context).textTheme.headline1?.copyWith(
              color: CustomColors.black200,
              fontWeight: FontWeight.w600,
              fontSize: 23),
        ),
        subtitle: Text("آياتها : $type   .   $numAya",
            style: TextStyle(color: CustomColors.grey200)),
        onTap: () {
          tapHandler!(firstPageNum);
        });
  }
}
