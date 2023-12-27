import 'package:flutter/material.dart';
import 'package:mushafmuscat/providers/tilawaOptions_provider.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/ayat_lines_provider.dart';
import '../resources/colors.dart';

class WhereToPlay extends StatefulWidget {
  const WhereToPlay({super.key});

  @override
  State<WhereToPlay> createState() => WhereToPlayState();
}

List<String> surahTitles = [];
int indexSelectedSurahFrom = 114;
int indexSelectedSurahTo = 1;
String surahFrom = "الفاتحة";
String surahTo = "الناس";
String ayaFrom = '1';
String ayaTo = '6';
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

bool loaded = false;
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
final repititions = [
  '1',
  '2',
  '3',
  '4',
  '5',
];
String loopdropdownvalue = '1';

class WhereToPlayState extends State<WhereToPlay> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<tilawaOptions>(context, listen: false).fetchSurahs();
      setState(() {
        surahTitles =
            Provider.of<tilawaOptions>(context, listen: false).SurahsList;

        if (surahTitlesFrom.isEmpty && surahTitlesTo.isEmpty) {
          surahTitlesFrom = surahTitles;
          surahTitlesTo = surahTitles;
        }
      });
      saveSharedPref(
          'surahFrom',
          await Provider.of<tilawaOptions>(context, listen: false)
              .getPageNumber(surahFrom, ayaFrom));
      saveSharedPref(
          'surahTo',
          await Provider.of<tilawaOptions>(context, listen: false)
              .getPageNumber(surahTo, ayaTo));
    });
    super.initState();
  }

  dynamic getInt(key) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    dynamic res = prefs.getInt("$key");
    return res;
  }

  dynamic saveSharedPref(key, val) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("$key", val);
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = surahTitlesFrom.isEmpty && surahTitlesTo.isEmpty;

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
                        padding: const EdgeInsets.all(20),
                        child: const Text(
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
                      padding: const EdgeInsets.all(17),
                      child: const Text(
                        "تحديد البدء و الانتهاء",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const Row(
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
                    getAyaDropDown(0, numbersFrom, ayaFrom),
                    getAyaDropDown(1, numbersTo, ayaTo),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: const Text(
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
                    const Text("التكرار للآية",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    getDropDown(repititions),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      onPressed: () async {
                        dynamic page =
                            await getInt("surahFrom").then((value) => value);

                        dynamic ayafrom =
                            await getInt("ayaFrom").then((value) => value);
                        int? highlight = await Provider.of<AyatLinesProvider>(
                                context,
                                listen: false)
                            .getAya(page, ayafrom as int, surahFrom);

                        Navigator.of(context)
                            .popAndPushNamed(QuranScreen.routeName, arguments: {
                          'v1': page as int,
                          'v2': 1,
                          'v3': highlight,
                          'v4': surahFrom,
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              CustomColors.yellow100),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 87, 60, 50),
                                          width: 0.5)))),
                      child: SizedBox(
                          width: 110,
                          height: 25,
                          child: Text(
                            'تشغيل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: CustomColors.black200, fontSize: 17),
                          )))
                ]),
              ])
            : CircularProgressIndicator(
                color: CustomColors.yellow200,
              ));
  }

  DropdownButton getSurahDropDown(int tofrom, List<String> items) {
    return DropdownButton(
      value: (tofrom == 0) ? surahFrom : surahTo,
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

          if (tofrom == 0) {
            indexSelectedSurahFrom = surahTitles.indexOf(newValue);
            surahFrom = newValue;
            ayaNumbersFrom = surahsData.getAyaList(indexSelectedSurahFrom);
            numbersFrom = ayaNumbersFrom;
            surahTitlesTo =
                surahTitles.sublist(indexSelectedSurahFrom, surahTitles.length);
            ayaFrom = numbersFrom.first;
          } else {
            surahTo = newValue;
            indexSelectedSurahTo = surahTitles.indexOf(newValue);
            surahTitlesFrom = surahTitles.sublist(0, indexSelectedSurahTo + 1);
            ayaNumbersTo = surahsData.getAyaList(indexSelectedSurahTo);
            numbersTo = ayaNumbersTo;
            ayaTo = numbersTo.last;
          }
        });
        saveSharedPref("repNum", int.parse(loopdropdownvalue));
        saveSharedPref(
            (tofrom == 0) ? 'surahFrom' : 'surahTo',
            await Provider.of<tilawaOptions>(context, listen: false)
                .getPageNumber(surahFrom, (tofrom == 0) ? ayaFrom : ayaTo));
      },
    );
  }

  DropdownButton getDropDown(List<String> items) {
    return DropdownButton(
      value: loopdropdownvalue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          loopdropdownvalue = newValue!;
          saveSharedPref("repNum", int.parse(loopdropdownvalue));
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
      value: (tofrom == 0) ? ayaFrom : ayaTo,
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
            ayaFrom = newValue!;
          } else {
            ayaTo = newValue!;
          }

          if (surahFrom == surahTo) {
            numbersFrom =
                ayaNumbersFrom.sublist(0, ayaNumbersFrom.indexOf(ayaTo) + 1);
            numbersTo = ayaNumbersTo.sublist(
                ayaNumbersFrom.indexOf(ayaFrom), ayaNumbersTo.length);
          }
        });
        int temp = await surahsData.getPageNumber(
            (tofrom == 0) ? surahFrom : surahTo,
            (tofrom == 0) ? ayaFrom : ayaTo);

        saveSharedPref((tofrom == 0) ? 'surahFrom' : 'surahTo', temp);
        saveSharedPref(
            (tofrom == 0) ? 'ayaFrom' : 'ayaTo', int.parse(newValue));
      },
    );
  }
}
