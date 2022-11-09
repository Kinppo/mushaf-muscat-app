import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mushafmuscat/providers/tilawaOptions_provider.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/surah.dart';
import '../providers/surah_provider.dart';
import '../resources/colors.dart';

class whereToPlay extends StatefulWidget {
  const whereToPlay({Key? key}) : super(key: key);

  @override
  State<whereToPlay> createState() => _whereToPlayState();
}

List<String> SurahTitles = [];

int indexSelectedSurahFrom = 114;
int indexSelectedSurahTo = 1;

String SurahFrom = "الفاتحة";
String SurahTo = "الناس";

String AyaFrom = '1';
String AyaTo = '6';

List<String> surahTitlesFrom = [];
List<String> surahTitlesTo = [];

List<String> numbersFrom = ['1', '2', '3', '4', '5', '6', '7'];
List<String> numbersTo = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
];
List<String> ayaNumbersFrom = numbersFrom;
List<String> ayaNumbersTo = numbersTo;

bool Loaded = false;
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

final repititions = [
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
    print('REBUILDING SHEET');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<tilawaOptions>(context, listen: false).fetchSurahs();
      setState(() {
        SurahTitles =
            Provider.of<tilawaOptions>(context, listen: false).SurahsList;

        if (surahTitlesFrom.isEmpty && surahTitlesTo.isEmpty) {
          surahTitlesFrom = SurahTitles;
          surahTitlesTo = SurahTitles;
          //  saveSharedPref(SurahTo temp);
        }
// SurahFrom = "الفاتحة";
//  SurahTo = "الناس";

//  indexSelectedSurahFrom = 114;
//  indexSelectedSurahTo = 1;

//  AyaFrom = '1';
//  AyaTo = '6';

// numbersFrom = ['1', '2', '3', '4', '5', '6', '7'];
// numbersTo = [
//   '1',
//   '2',
//   '3',
//   '4',
//   '5',
//   '6',
// ];
// ayaNumbersFrom = numbersFrom;
// ayaNumbersTo = numbersTo;

        // print("Surah from: $SurahFrom");
        // print("Surah to: $SurahTo");
        // print("SurahS FROM: $surahTitlesFrom");
        // print("SurahS TO: $surahTitlesTo");
      });
      saveSharedPref(
          'surahFrom',
          await Provider.of<tilawaOptions>(context, listen: false)
              .getPageNumber(SurahFrom, AyaFrom));
      saveSharedPref(
          'surahTo',
          await Provider.of<tilawaOptions>(context, listen: false)
              .getPageNumber(SurahTo, AyaTo));
    });
    super.initState();
  }

  dynamic getInt(key) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    dynamic _res = prefs.getInt("$key");
    print("+++++++++" + _res.toString());
    return _res;
    // print("SHARED PREF " + _res.toString());
  }

  dynamic saveSharedPref(key, val) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("$key", val);
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = surahTitlesFrom.isEmpty && surahTitlesTo.isEmpty;
    print(surahTitlesFrom.length);
    print(surahTitlesTo.length);

    print("the value of condition $isEmpty");
    final surahsData = Provider.of<tilawaOptions>(context, listen: false);

    return Container(
        width: 400,
        height: 480,
        color: Colors.white,
        child: (!isEmpty)
            ? Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: CustomColors.yellow100,
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "خيارات التلاوة",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "إلى",
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    getSurahDropDown(0, surahTitlesFrom),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("التكرار للآية",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    getDropDown(repititions, "1"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      onPressed: () async {
                        //navigate to selected page
                        dynamic page =
                            await getInt("surahFrom").then((value) => value);
                        // print("-------- "+ page.toString());
                        Navigator.of(context).popAndPushNamed(
                            QuranScreen.routeName,
                            arguments: page as int);
                      },
                      child: Container(
                          width: 110,
                          height: 25,
                          child: Text(
                            'تشغيل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: CustomColors.black200, fontSize: 17),
                          )),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              CustomColors.yellow100),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color:
                                              Color.fromARGB(255, 87, 60, 50),
                                          width: 0.5)))))
                ]),
              ])
            : CircularProgressIndicator(
                color: CustomColors.yellow200,
              ));
  }

  DropdownButton getSurahDropDown(int tofrom, List<String> items) {
    // print(items);
    return DropdownButton(
      // value: (tofrom == 0) ? SurahFrom : SurahTo,
      value: (tofrom == 0) ? SurahFrom : SurahTo,

      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (newValue) async {
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
            // saveSharedPref('surahFrom', indexSelectedSurahFrom);

            // numbersTo = surahsData.getAyaList(SurahTitles.indexOf(SurahTo));
            AyaFrom = numbersFrom.first;
          } else {
            SurahTo = newValue;

            indexSelectedSurahTo = SurahTitles.indexOf(newValue);

            surahTitlesFrom = SurahTitles.sublist(0, indexSelectedSurahTo + 1);
            ayaNumbersTo = surahsData.getAyaList(indexSelectedSurahTo);
            numbersTo = ayaNumbersTo;
            AyaTo = numbersTo.last;
            // saveSharedPref('surahTo', indexSelectedSurahTo);
          }
        });
        saveSharedPref(
            (tofrom == 0) ? 'surahFrom' : 'surahTo',
            await Provider.of<tilawaOptions>(context, listen: false)
                .getPageNumber(SurahFrom, (tofrom == 0) ? AyaFrom : AyaTo));
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
          saveSharedPref("repNum", int.parse(dropdownvalue));
        });
      },
    );
  }

  DropdownButton getAyaDropDown(
    int tofrom,
    List<String> items,
    String dropdownvalue,
  ) {
    final surahsData = Provider.of<tilawaOptions>(context, listen: false);

    return DropdownButton(
      value: (tofrom == 0) ? AyaFrom : AyaTo,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (newValue) async {
        setState(() {
          if (tofrom == 0) {
            AyaFrom = newValue!;
          } else {
            AyaTo = newValue!;
          }

          if (SurahFrom == SurahTo) {
            numbersFrom =
                ayaNumbersFrom.sublist(0, ayaNumbersFrom.indexOf(AyaTo) + 1);
            numbersTo = ayaNumbersTo.sublist(
                ayaNumbersFrom.indexOf(AyaFrom), ayaNumbersTo.length);
          }
        });
        int temp = await surahsData.getPageNumber(
            (tofrom == 0) ? SurahFrom : SurahTo,
            (tofrom == 0) ? AyaFrom : AyaTo);

        saveSharedPref((tofrom == 0) ? 'surahFrom' : 'surahTo', temp);
      },
    );
  }
}
