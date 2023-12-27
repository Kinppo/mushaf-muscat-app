import 'package:flutter/material.dart';
import '../resources/colors.dart';

class QuranAyaSearchTiles extends StatelessWidget {
  final String? surahNum;
  final String? ayaText;
  final String? numAya;
  final String? surahName;
  final String? ayaPageNum;
  final Function? tapHandler;

  const QuranAyaSearchTiles(
      {super.key,
      this.surahNum,
      this.ayaText,
      this.numAya,
      this.surahName,
      this.ayaPageNum,
      this.tapHandler});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        enableFeedback: true,
        title: Text(
          ayaText!,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: CustomColors.black200, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text("$surahName . الآية: $numAya",
            style: TextStyle(color: CustomColors.grey200)),
        onTap: () {
          tapHandler!(ayaPageNum);
        });
  }
}
