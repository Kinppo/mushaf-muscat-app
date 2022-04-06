import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
// import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

class QuranScreen extends StatefulWidget {
  static const routeName = '/quran';

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  // const QuranScreen({Key? key}) : super(key: key);

  bool _showAppBar = true;
  bool _showNavBar = true;
  int index = 0;

  // final toggleAppBar = return

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                AppLocalizations.of(context)!
                    .translate('quran_screen_title')
                    .toString(),
                style: Theme.of(context).textTheme.headline1,
              ),
            )
          : PreferredSize(
              child: Container(),
              preferredSize: const Size(0.0, 0.0),
            ),
      bottomNavigationBar: _showNavBar
          ? Container(
              height: 80,
              //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: HexColor('#ebe4dd'), width: 1)),
                  color: Theme.of(context).buttonColor),
              //color: Theme.of(context).buttonColor,
              child: Center(
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).buttonColor,
                  unselectedItemColor: Theme.of(context).secondaryHeaderColor,
                  selectedItemColor: Theme.of(context).textSelectionColor,
                  selectedLabelStyle: TextStyle(fontSize: 12),
                  currentIndex: index,
                  onTap: (int index) {
                    setState(() {
                      this.index = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        MdiIcons.bookOpenPageVariant,
                        color: index == 0
                            ? Theme.of(context).textSelectionColor
                            : Theme.of(context).accentColor,
                      ),
                      label: AppLocalizations.of(context)!
                          .translate('quran_screen_navigation_bar_item1')
                          .toString(),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        MdiIcons.bookmark,
                        color: index == 1
                            ? Theme.of(context).textSelectionColor
                            : Theme.of(context).accentColor,
                      ),
                      label: AppLocalizations.of(context)!
                          .translate('quran_screen_navigation_bar_item2')
                          .toString(),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        MdiIcons.clipboardList,
                        color: index == 2
                            ? Theme.of(context).textSelectionColor
                            : Theme.of(context).accentColor,
                      ),
                      label: AppLocalizations.of(context)!
                          .translate('quran_screen_navigation_bar_item3')
                          .toString(),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        MdiIcons.cog,
                        color: index == 3
                            ? Theme.of(context).textSelectionColor
                            : Theme.of(context).accentColor,
                      ),
                      label: AppLocalizations.of(context)!
                          .translate('quran_screen_navigation_bar_item4')
                          .toString(),
                    ),
                  ],
                ),
              ),
            )
          : const PreferredSize(
              child: Text(""),
              preferredSize: Size(0.0, 0.0),
            ),
      drawer: Container(
        width: double.infinity,
        child: MainDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(Dimens.px22),
                  color: Theme.of(context).backgroundColor,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Text(AppLocalizations.of(context)!
                        .translate('dummy_text')
                        .toString()),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _showAppBar = !_showAppBar;
                    _showNavBar = !_showNavBar;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
