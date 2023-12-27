import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'package:provider/provider.dart';
import '../providers/daily_aya_provider.dart';
import '../localization/app_localizations.dart';
import '../widgets/bottom_navigation_bar.dart';

class AyahScreen extends StatefulWidget {
  const AyahScreen({super.key});
  static const routeName = '/ayah';

  @override
  State<AyahScreen> createState() => _AyahScreenState();
}

late final DailyAya aya;
bool loading = false;

class _AyahScreenState extends State<AyahScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<DailyAyaProvider>(context, listen: false)
          .getPostData(context);
      setState(() {
        aya = Provider.of<DailyAyaProvider>(context, listen: false).post;
        loading = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BNavigationBar(
          pageIndex: 2,
          toggleBars:
              () {}, //do nothing and only allow bottom nav bar to disappear in quran screen
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate('ayah_screen_title')
                        .toString(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  (loading == true)
                      ? Container(
                          margin: const EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 33),
                          decoration: BoxDecoration(
                              color: CustomColors.yellow150,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Text(aya.aya,
                                  style: TextStyle(
                                      fontFamily: 'ScheherazadeNew',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      color: CustomColors.black200)),
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  aya.surah,
                                  style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: CustomColors.brown400),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  aya.tafsir,
                                  style: TextStyle(
                                      fontFamily: 'IBMPlexSansArabic',
                                      fontSize: 19,
                                      fontWeight: FontWeight.w400,
                                      color: CustomColors.brown100),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: CustomColors.yellow100),
                                ),
                                child: IconButton(
                                  icon: Icon(MdiIcons.share),
                                  color: CustomColors.grey100,
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ))
                      : CircularProgressIndicator(
                          color: CustomColors.yellow200,
                        ),
                ],
              ),
            )));
  }
}
