import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mushafmuscat/providers/tilawaOptions_provider.dart';
import 'package:provider/provider.dart';

import '../models/surah.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';

class whereToPlay extends StatefulWidget {
  const whereToPlay({Key? key}) : super(key: key);

  @override
  State<whereToPlay> createState() => _whereToPlayState();
}

List<String> SurahTitles = [];
List<String> AyaNumbers = [];

int indexSelectedSurah1 = 114;
int indexSelectedSurah2 = 1;

int indexSelectedAya1 = 8;
int indexSelectedAya2 = 1;

String Surah1 = 'الفاتحة';
String Surah2 = 'البقرة';

String Aya1 = '1';
String Aya2 = '2';

List<String> surahTitles1=[];
List<String> surahTitles2=[];

List<String> numbers1 = ['0', '1', '2', '3', '4', '5', '6', '7'];
List<String> numbers2 = ['0', '1', '2', '3', '4', '5', '6', '7'];

var items2 = [
  '1',
  '2',
  '3',
  '4',
  '5',
];
String dropdownvalue = '1';

class _whereToPlayState extends State<whereToPlay> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        Provider.of<tilawaOptions>(context, listen: false).fetchSurahs();
        SurahTitles =
            Provider.of<tilawaOptions>(context, listen: false).SurahsList;
        AyaNumbers =
            Provider.of<tilawaOptions>(context, listen: false).AyasList;
            surahTitles1=SurahTitles;
            surahTitles2=SurahTitles;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final surahsData =  Provider.of<tilawaOptions>(context, listen: false);

    return Container(
      width: 400,
      height: 480,
      color: Colors.white,
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                color: CustomColors.yellow100,
                padding: EdgeInsets.all(20),
                child: Text(
                  "خيارات التلاوة",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(17),
              child: Text(
                "تحديد البدء و الانتهاء",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "من",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "إلى",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getSurahDropDown(0, surahTitles1),
            getSurahDropDown(1, surahTitles2),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // getAyaDropDown(0, numbers1.sublist(0, indexSelectedAya1), Aya1),
            // getAyaDropDown(
            //     1, numbers2.sublist(indexSelectedAya2, numbers2.length), Aya2),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              child: Text(
                "التكرار",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("التكرار للآية",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            getDropDown(items2, "1"),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {},
              child: Container(
                  width: 110,
                  height: 25,
                  child: Text(
                    'تشغيل',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: CustomColors.black200, fontSize: 17),
                  )),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(CustomColors.yellow100),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: Color.fromARGB(255, 87, 60, 50),
                              width: 0.5)))))
        ]),
      ]),
    );
  }

  void check (String type) {

    if (type=='Surah') {
      if (indexSelectedSurah2 > indexSelectedSurah1){
        print("condition true");
      }

    }


  }

  void handleIndices(int tofrom, String newValue, int indexSelected) {
    final surahsData = Provider.of<tilawaOptions>(context, listen: false);

    setState(() {
      if (tofrom == 0) {
        Surah1 = newValue;
        numbers1 = surahsData.getAyaList(indexSelected);
        Surah2 = newValue;
        numbers2 = surahsData.getAyaList(indexSelected);
        // print("done1" + numbers2.length.toString());
        Aya2 = (numbers2.length - 1).toString();
      } else {
        Surah2 = newValue;
        numbers2 = surahsData.getAyaList(indexSelected);
        Aya2 = numbers2.length.toString();
      }
    });
  }


  DropdownButton getSurahDropDown(int tofrom, List<String> items) {
    return DropdownButton(
      value: (tofrom == 0) ? Surah1 : Surah2,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          final surahsData = Provider.of<tilawaOptions>(context, listen: false);

          // dropdownvalue = newValue!;

          if (tofrom == 0) {
            indexSelectedSurah1 = SurahTitles.indexOf(newValue);

            Surah1 = newValue;
            // numbers1 = surahsData.getAyaList(indexSelectedSurah2);
            Surah2 = newValue;

            surahTitles2= SurahTitles.sublist(indexSelectedSurah1, SurahTitles.length);
            // numbers2 = surahsData.getAyaList(indexSelectedSurah2);
            // print("done1" + numbers2.length.toString());
            // Aya2 = (numbers2.length - 1).toString();
          } else {
            Surah2 = newValue;
            // Aya1 = (numbers1[1]).toString();
            indexSelectedSurah2 = SurahTitles.indexOf(newValue);
            surahTitles1= SurahTitles.sublist(0, indexSelectedSurah2+1);

            // numbers2 = surahsData.getAyaList(indexSelectedSurah2);
            // indexSelectedAya1 = numbers2.length;
            // numbers1 = numbers2;
            // Surah1 = SurahTitles[indexSelectedSurah2];
          }
          // handleIndices(tofrom, newValue, indexSelectedSurah1);
          check('Surah');
        });
      },
    );
  }

  DropdownButton getDropDown(List<String> items, String dropdownvalue) {
    return DropdownButton(
      value: dropdownvalue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }

  DropdownButton getAyaDropDown(
    int tofrom,
    List<String> items,
    String dropdownvalue,
  ) {
    return DropdownButton(
      value: (tofrom == 0) ? Aya1 : Aya2,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          if (tofrom == 0) {
            Aya1 = newValue!;
            indexSelectedAya2 = numbers2.indexOf(newValue) + 1;
          } else {
            Aya2 = newValue!;
            indexSelectedAya1 = numbers1.indexOf(newValue);
          }
        });
      },
    );
  }
}
