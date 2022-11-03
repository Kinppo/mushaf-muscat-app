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

int indexSelectedSurahFrom = 114;
int indexSelectedSurahTo = 1;

String SurahFrom = 'الفاتحة';
String SurahTo = 'الناس';

String AyaFrom = '1';
String AyaTo = '6';

List<String> surahTitlesFrom = [];
List<String> surahTitlesTo = [];

List<String> numbersFrom = ['1', '2', '3', '4', '5', '6', '7'];
List<String> numbersTo = ['1', '2', '3', '4', '5', '6'];
List<String> ayaNumbersFrom = numbersFrom;
List<String> ayaNumbersTo = numbersTo;

var repititions
 = [
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
        surahTitlesFrom
       = SurahTitles;
        surahTitlesTo = SurahTitles;
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
            getSurahDropDown(0, surahTitlesFrom
          ),
            getSurahDropDown(1, surahTitlesTo),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getAyaDropDown(0, numbersFrom, AyaFrom),
            getAyaDropDown(1, numbersTo, AyaTo),
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
            getDropDown(repititions
            , "1"),
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

  DropdownButton getSurahDropDown(int tofrom, List<String> items) {
    return DropdownButton(
      value: (tofrom == 0) ? SurahFrom : SurahTo,
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
            
            indexSelectedSurahFrom = SurahTitles.indexOf(newValue);

            SurahFrom = newValue;


            ayaNumbersFrom = surahsData.getAyaList(indexSelectedSurahFrom);
            numbersFrom = ayaNumbersFrom;

            surahTitlesTo =
                SurahTitles.sublist(indexSelectedSurahFrom, SurahTitles.length);

            // numbersTo = surahsData.getAyaList(SurahTitles.indexOf(SurahTo));
            AyaFrom = numbersFrom.first;
          } else {
            SurahTo = newValue;

            indexSelectedSurahTo = SurahTitles.indexOf(newValue);

            surahTitlesFrom
           = SurahTitles.sublist(0, indexSelectedSurahTo + 1);
            ayaNumbersTo
           = surahsData.getAyaList(indexSelectedSurahTo);
            numbersTo = ayaNumbersTo
          ;
            AyaTo = numbersTo.last;
          }
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
      value: (tofrom == 0) ? AyaFrom : AyaTo,
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
            AyaFrom = newValue!;
          } else {
            AyaTo = newValue!;
          }
          if (SurahFrom == SurahTo) {
            numbersFrom = ayaNumbersFrom.sublist(0, ayaNumbersFrom.indexOf(AyaTo) + 1);
            numbersTo = ayaNumbersTo
          .sublist(
                ayaNumbersFrom.indexOf(AyaFrom), ayaNumbersTo
              .length);
          }
        });
      },
    );
  }
}
