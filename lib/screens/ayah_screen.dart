import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mushafmuscat/models/ayah.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'package:provider/provider.dart';
import '../providers/dailyAya_provider.dart';
import '../localization/app_localizations.dart';
import '../widgets/bottom_navigation_bar.dart';

class AyahScreen extends StatelessWidget {

  AyahScreen({Key? key}) : super(key: key);
  static const routeName = '/ayah';
  Ayah _ayah = Ayah(
      ayah:
          '﴿ كَيْفَ تَكْفُرُونَ بِاللَّهِ وَكُنتُمْ أَمْوَاتًا فَأَحْيَاكُمْ ۖ ثُمَّ يُمِيتُكُمْ ثُمَّ يُحْيِيكُمْ ثُمَّ إِلَيْهِ تُرْجَعُونَ﴾',
      content:
          ' قال ابن عطية : وهذا القول هو المراد بالآية ، وهو الذي لا محيد للكفار عنه لإقرارهم بهما ، وإذا أذعنت نفوس الكفار لكونهم أمواتا معدومين ، ثم للإحياء في الدنيا ، ثم للإماتة فيها قوي عليهم لزوم الإحياء الآخر وجاء جحدهم له دعوى لا حجة عليها . قال غيره : والحياة التي تكون في القبر على هذا التأويل في حكم حياة الدنيا .\n\n Ibn Attia said: This saying is what is meant by the verse, and it is the one that the infidels have no inevitable about because they acknowledge them, and if the souls of the infidels submit to the fact that they are dead, then there is no justification for them to revive in this world, then to die in it. Others said: And the life that is in the grave, according to this interpretation, is the ruling on the life of this world. \n 0 1 2 3 4 5 6 7 8 9 ',
      surah: 'سورة البقرة');

  @override
  Widget build(BuildContext context) {
      // DailyAya? txt= Provider.of<dailyAyaProvider>(context, listen: false ).dataModel;
       Provider.of<dailyAyaProvider>(context, listen: false ).getPostData(context);
dailyAya aya= Provider.of<dailyAyaProvider>(context, listen: false ).post;
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
                  Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 33),
                      decoration: BoxDecoration(
                          color: CustomColors.yellow150,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            // aya.Tafsir,
                            _ayah.ayah,
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
                              _ayah.surah,
                              style: TextStyle(
                                  fontFamily: 'OmanTypeface',
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
                              _ayah.content,
                              style: TextStyle(
                                  fontFamily: 'OmanTypeface',
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
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )));
  }
}
