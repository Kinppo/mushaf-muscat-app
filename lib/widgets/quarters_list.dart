import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/utils/helperFunctions.dart';
import '../resources/colors.dart';

class QuartersList extends StatelessWidget {
  bool? startingJuzzIndex;
  bool? startingHizbIndex;
  int? quarter;
  String? hizbNum;
  String? surahTitle;
  String? startingAya;
  String? juzz;
  String? quarterAyaNum;
  String? quarterPageNum;
  Function? tapHandler;
  QuartersList({
    Key? key,
    this.startingJuzzIndex,
    this.startingHizbIndex,
    this.quarter,
    this.hizbNum,
    this.surahTitle,
    this.startingAya,
    this.juzz,
    this.quarterAyaNum,
    this.quarterPageNum,
    this.tapHandler,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    IconData? getQuarterIcon(int quarter) {
      if (quarter == 2) {
        return MdiIcons.circleSlice2;
      } else if (quarter == 3) {
        return MdiIcons.circleSlice4;
      } else if (quarter == 4) {
        return MdiIcons.circleSlice6;
      }
      return null;
    }

    return Column(
      children: [
        if (startingJuzzIndex == true) ...[
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.fromLTRB(15, 15, 21, 15),
            child: Text(
              "الجزء $juzz",
              style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: CustomColors.black200,
                  fontWeight: FontWeight.w500,
                  fontSize: 23),
            ),
          ),
        ],
        ListTile(
            contentPadding: const EdgeInsets.fromLTRB(60, 0, 15, 0),
            leading: (quarter == 1)
                ? CircleAvatar(
                    child: Text(
                      hizbNum!,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                          color: CustomColors.black200,
                          fontSize: 18),
                    ),
                    radius: 20,
                    backgroundColor: Theme.of(context).shadowColor,
                  )
                : CircleAvatar(
                    backgroundColor: Theme.of(context).shadowColor,
                    radius: 20,
                    child: Icon(
                      getQuarterIcon(quarter!),
                      size: 40,
                      color: CustomColors.brown500,
                    ),
                  ),
            title: Text(
              startingAya!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: CustomColors.black200,
                  fontWeight: FontWeight.normal,
                  fontSize: 22),
            ),
            subtitle: Text(
              "$surahTitle $quarterAyaNum  .  الصفحة $quarterPageNum ",
              style: TextStyle(color: CustomColors.grey200),
            ),
            onTap: () {
                              String? n= 
 HelperFunctions.convertToEnglishNumbers(quarterPageNum!);
              tapHandler!(n
);
            }
            ),
      ],
    );
  }
}
