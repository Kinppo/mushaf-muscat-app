import 'dart:math';
import '../models/surah.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:provider/provider.dart';

import '../localization/app_localizations.dart';
import '../models/surah.dart';
import '../widgets/drawer_screen_search_bar.dart';
import '../widgets/surahs_list.dart';

class TestScreen extends StatefulWidget {
  static const routeName = '/test';

  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
  
}



class _TestScreenState extends State<TestScreen> {
    bool _isInit = true;
    bool _isLoading = true;


  @override
  void initState() {
  
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<SurahProvider>(context).fetchSurahs().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    final surahsData = Provider.of<SurahProvider>(context, listen: false);
    final surahss =surahsData.surahs;
  
        final List<Surah> _surahitem = surahss;



  int segmentedControlValue = 0;
  String hint = 'البحث عن سورة';

  String hintText() {
    setState(() {
      if (segmentedControlValue == 0) {
        hint = AppLocalizations.of(context)!
            .translate('drawer_screen_search_hint_surahs')
            .toString();
      } else {
        hint = AppLocalizations.of(context)!
            .translate('drawer_screen_search_hint_quarters')
            .toString();
      }
    });

    return hint;
  }

  Widget buildSurahListTile(String? surahNum, String? surahTitle,
      String? surahType, String? numOfAyas, Function? tapHandler) {
    return SurahsList(
      num: surahNum,
      title: surahTitle,
      numAya: numOfAyas,
      type: surahType,
    );
  }


 
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
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
                            AppLocalizations.of(context)!
                                .translate('drawer_screen_switch_surahs')
                                .toString(),
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
                            AppLocalizations.of(context)!
                                .translate('drawer_screen_switch_quarters')
                                .toString(),
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
            padding:  EdgeInsets.all(20),
            child: drawerSearchBar(hint: hintText()),
          ),
          const Divider(
            height: 0,
          ),
          if (segmentedControlValue == 0) ...[
            Expanded(
              child:   _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: _surahitem.length,
                itemBuilder: (ctx, i) {
                  return Column(  
                    children: [  
                    buildSurahListTile(
                        _surahitem[i].surahNum,
                        _surahitem[i].surahTitle,
                        _surahitem[i].numOfAyas,
                        _surahitem[i].surahType,
                        () {},
                      ) ,
                      const Divider(
                        height: 20,
                      ) 
                    ], 
                   
                  );
                },
              ),
            ),
          ] else if (segmentedControlValue == 1) ...[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 2),
                itemCount: _surahitem.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                     Container(),
                    
                      const Divider(
                        height: 20,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

