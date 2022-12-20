import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/models/ayah.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'package:provider/provider.dart';
import '../providers/dailyAya_provider.dart';
import '../localization/app_localizations.dart';
import '../widgets/bottom_navigation_bar.dart';

class AyahScreen extends StatefulWidget {

  AyahScreen({Key? key}) : super(key: key);
  static const routeName = '/ayah';

  @override
  State<AyahScreen> createState() => _AyahScreenState();
}

late final dailyAya aya;
bool loading= false;

class _AyahScreenState extends State<AyahScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await            Provider.of<dailyAyaProvider>(context, listen: false ).getPostData(context);
;
      setState(() {
 aya= Provider.of<dailyAyaProvider>(context, listen: false ).post;
 loading=true;
      });
    });

    super.initState();
  }
  // Ayah _ayah = Ayah(
  @override
  Widget build(BuildContext context) {
      // DailyAya? txt= Provider.of<dailyAyaProvider>(context, listen: false ).dataModel;
// print(txt);
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
        bottomNavigationBar: const BNavigationBar(
          pageIndex: 2,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate('ayah_screen_title')
                        .toString(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  (loading==true)? Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 33),
                      decoration: BoxDecoration(
                          color: CustomColors.yellow150,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            aya.Aya,
                            // _ayah.ayah,
                              style: TextStyle(
                                  fontFamily: 'ScheherazadeNew',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: CustomColors.black200)),
                          const SizedBox(
                            height: 5,
                          ),
                          Align(
                            child: Text(
                              aya.Surah,
                              // _ayah.surah,
                              style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.brown400),
                            ),
                            alignment: Alignment.topRight,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Align(
                            child: Text(
                               aya.Tafsir,
                              // _ayah.content,
                              style: TextStyle(
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400,
                                  color: CustomColors.brown100),
                            ),
                            alignment: Alignment.topRight,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: CustomColors.yellow100),
                              //color: CustomColors.brown100,
                            ),
                            child: IconButton(
                              icon: const Icon(MdiIcons.share),
                              color: CustomColors.grey100,
                              onPressed: () {},
                            ),
                          )
                        ],
                      )): CircularProgressIndicator(color: CustomColors.yellow200,),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )));
  }
}
