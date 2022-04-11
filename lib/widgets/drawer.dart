import 'package:flutter/material.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:mushafmuscat/widgets/quarters_list.dart';
import 'package:flutter/cupertino.dart';
import '../resources/dimens.dart';
import '../widgets/surahs_list.dart';
import '../widgets/quarters_list.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int segmentedControlValue = 0;
  String hint = 'البحث عن سورة';

  String hintText() {
    setState(() {
      if (segmentedControlValue == 0) {
        hint = 'البحث عن سورة';
      } else {
        hint = 'البحث في الأجزاء (مثلا: ١٤)';
      }
    });

    return hint;
  }

  Widget buildListTile(bool beginningIndex, String juzz, String numAya,
      String type, String num, String title, Function tapHandler) {
    return segmentedControlValue == 0
        ? SurahsList(num: num, title: title, numAya: numAya, type: type)
        : QuartersList(
            beginningIndex: beginningIndex,
            num: num,
            surah: title,
            aya: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            juzz: juzz,
            quarterAya: '٢٦',
            quarterPage: '٥');

    //SurahList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //margin: EdgeInsets.all(16.0),
              padding: const EdgeInsets.only(top: 80.0),
              // width: 180,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 70,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      minWidth: 180,
                    ),
                    child: Container(
                      child: CupertinoSlidingSegmentedControl(
                          groupValue: segmentedControlValue,
                          backgroundColor: Theme.of(context).shadowColor,
                          children: <int, Widget>{
                            0: Text(
                              'السور',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    color: const Color.fromRGBO(105, 91, 77, 1),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                            ),
                            1: Text(
                              'الأرباع',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    color: const Color.fromRGBO(105, 91, 77, 1),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                            ),
                          },
                          onValueChanged: (value) {
                            setState(() {
                              segmentedControlValue = value as int;

                              print(segmentedControlValue);
                            });
                          }),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    iconSize: 28,
                    onPressed: () {
                      Navigator.of(context)
                          .popAndPushNamed(QuranScreen.routeName);
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(Dimens.px20),
              child: TextField(
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).indicatorColor,
                  prefixIcon: const Icon(Icons.search),
                  iconColor: const Color.fromRGBO(148, 135, 121, 1),
                  hintText: hintText(),
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(148, 135, 121, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: const TextStyle(
                  color: Color.fromRGBO(148, 135, 121, 1),
                ),
              ),
            ),
            const Divider(height: 0),
            buildListTile(true, "الأول", "٧", "مكية", "١", "الفاتحة", () {}),
            const Divider(),
            buildListTile(false, "الأول", "٧", "مكية", "١", "البقرة", () {}),
            const Divider(),
            buildListTile(false, "الأول", "٧", "مكية", "١", "آل عمران", () {}),
            const Divider(),
            buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
            const Divider(),
            buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
            const Divider(),
            buildListTile(true, "الثاني", "٧", "مكية", "١", "النساء", () {}),
            const Divider(),
            buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
            const Divider(),
            buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
          ],
        ),
      ),
    );
  }
}
