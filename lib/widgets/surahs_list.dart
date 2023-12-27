import 'package:flutter/material.dart';
import '../resources/colors.dart';

class SurahsList extends StatelessWidget {
  final String? num;
  final String? title;
  final String? numAya;
  final String? type;
  final String? firstPageNum;
  final Function? tapHandler;

  const SurahsList(
      {super.key,
      this.num,
      this.title,
      this.numAya,
      this.type,
      this.firstPageNum,
      this.tapHandler});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).shadowColor,
          child: Text(
            num!,
            style: Theme.of(context).textTheme.labelMedium,
          ),
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
