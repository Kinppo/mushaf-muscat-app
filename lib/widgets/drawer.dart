import 'package:flutter/material.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:mushafmuscat/widgets/quarters_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:mushafmuscat/models/surah.dart';
import 'package:mushafmuscat/models/quarter.dart';

import '../resources/dimens.dart';
import '../widgets/surahs_list.dart';
import '../widgets/quarters_list.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final List<Surah> _surah = [
    Surah(
      surahNum: "١",
      surahTitle: "الفاتحة",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
    Surah(
      surahNum: "٢",
      surahTitle: "البقرة",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
    Surah(
      surahNum: "٣",
      surahTitle: "آل عمران",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
    Surah(
      surahNum: "٤",
      surahTitle: "النساء",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
    Surah(
      surahNum: "٥",
      surahTitle: "المائدة",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
    Surah(
      surahNum: "٦",
      surahTitle: "الأنعام",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
    Surah(
      surahNum: "٧",
      surahTitle: "النساء",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
    Surah(
      surahNum: "٨",
      surahTitle: "المائدة",
      surahType: "مكية",
      numOfAyas: "٧",
    ),
  ];

  final List<Quarter> _quarter = [
    Quarter(
      startingJuzzIndex: true,
      startingHizbIndex: true,
      quarter: 1,
      hizbNum: "١",
      surahTitle: "الفاتحة",
      startingAya: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ",
      juzz: "الجزء الأول",
      quarterAyaNum: "١",
      quarterPageNum: "١",
    ),
    Quarter(
      startingJuzzIndex: false,
      startingHizbIndex: false,
      quarter: 2,
      hizbNum: "١",
      surahTitle: "البقرة",
      startingAya: "إِنَّ اللَه لَا يَسْتَحْيِي أَن يَضْرِبَ مَثَلًا مَّا...",
      juzz: "الجزء الأول",
      quarterAyaNum: "٢٦",
      quarterPageNum: "٥",
    ),
    Quarter(
      startingJuzzIndex: false,
      startingHizbIndex: false,
      quarter: 3,
      hizbNum: "١",
      surahTitle: "البقرة",
      startingAya:
          "أَتَأْمُرُونَ النَّاسَ بِالْبِرِّ وَتَنسَوْنَ أَنفُسَكُمْ ...",
      juzz: "الجزء الأول",
      quarterAyaNum: "٤٤",
      quarterPageNum: "٧",
    ),
    Quarter(
      startingJuzzIndex: false,
      startingHizbIndex: false,
      quarter: 4,
      hizbNum: "١",
      surahTitle: "البقرة",
      startingAya: "وَإِذِ اسْتَسْقَىٰ مُوسَىٰ لِقَوْمِهِ فَقُلْنَا اضْرِب...",
      juzz: "الجزء الأول",
      quarterAyaNum: "٦٠",
      quarterPageNum: "٩",
    ),
    // new hizb
    Quarter(
      startingJuzzIndex: false,
      startingHizbIndex: true,
      quarter: 1,
      hizbNum: "٢",
      surahTitle: "البقرة",
      startingAya:
          "أَفَتَطْمَعُونَ أَن يُؤْمِنُوا لَكُمْ وَقَدْ كَانَ فَرِيقٌ...",
      juzz: "الجزء الأول",
      quarterAyaNum: "٧٥",
      quarterPageNum: "١١",
    ),
    Quarter(
      startingJuzzIndex: false,
      startingHizbIndex: false,
      quarter: 2,
      hizbNum: "٢",
      surahTitle: "البقرة",
      startingAya:
          "وَلَقَدْ جَآءَكُم مُّوسَىٰ بِٱلْبَيِّنَٰتِ ثُمَّ ٱتَّخَذْتُمُ...",
      juzz: "الجزء الأول",
      quarterAyaNum: "٩٢",
      quarterPageNum: "١٤",
    ),
    Quarter(
      startingJuzzIndex: false,
      startingHizbIndex: false,
      quarter: 3,
      hizbNum: "٢",
      surahTitle: "البقرة",
      startingAya:
          "مَا نَنْسَخْ مِنْ آيَةٍ أَوْ نُنْسِهَا نَأْتِ بِخَيْرٍ مِنْهَا...",
      juzz: "الجزء الأول",
      quarterAyaNum: "١٠٦",
      quarterPageNum: "١٧",
    ),
    Quarter(
      startingJuzzIndex: false,
      startingHizbIndex: false,
      quarter: 4,
      hizbNum: "٢",
      surahTitle: "البقرة",
      startingAya:
          "وَإِذِ ابْتَلَىٰ إِبْرَاهِيمَ رَبُّهُ بِكَلِمَاتٍ فَأَتَمَّهُنَّ ...",
      juzz: "الجزء الأول",
      quarterAyaNum: "١٢٤",
      quarterPageNum: "١٩",
    ),
    // new juzz
  ];

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

  Widget buildListTile(String surahNum, String surahTitle, String surahType,
      String numOfAyas, Function tapHandler) {
    return segmentedControlValue == 0
        ? SurahsList(
            num: surahNum,
            title: surahTitle,
            numAya: numOfAyas,
            type: surahType)
        : Container();
    // : QuartersList(
    //     beginningIndex: beginningIndex,
    //     num: num,
    //     surah: title,
    //     aya: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    //     juzz: juzz,
    //     quarterAya: '٢٦',
    //     quarterPage: '٥');

    //SurahList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
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
            Expanded(
              child: ListView.builder(
                itemCount: 1,
              
                itemBuilder: (ctx, i) => const Text("dd")
                // buildListTile(
                //   _surah[i].surahNum,
                //   _surah[i].surahTitle,
                //   _surah[i].numOfAyas,
                //   _surah[i].surahType,
                //   () {},
                // ),
              ),),
            
            // buildListTile(true, "الأول", "٧", "مكية", "١", "الفاتحة", () {}),
            // const Divider(),
            // buildListTile(false, "الأول", "٧", "مكية", "١", "البقرة", () {}),
            // const Divider(),
            // buildListTile(false, "الأول", "٧", "مكية", "١", "آل عمران", () {}),
            // const Divider(),
            // buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
            // const Divider(),
            // buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
            // const Divider(),
            // buildListTile(true, "الثاني", "٧", "مكية", "١", "النساء", () {}),
            // const Divider(),
            // buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
            // const Divider(),
            // buildListTile(false, "الأول", "٧", "مكية", "١", "النساء", () {}),
          ],
        ),
      ),
    );
  }
}
