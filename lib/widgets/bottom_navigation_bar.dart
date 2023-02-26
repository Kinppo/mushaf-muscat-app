import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mushafmuscat/screens/setting_screen.dart';

import '../localization/app_localizations.dart';
import '../resources/colors.dart';
import '../screens/ayah_screen.dart';
import '../screens/book_marks_screen.dart';
import '../screens/quran_screen.dart';

class BNavigationBar extends StatefulWidget {
  final int pageIndex;
  Function toggleBars;

   BNavigationBar({
    Key? key,
    required this.pageIndex,
   required this.toggleBars,
  }) : super(key: key);

   
  @override
  State<BNavigationBar> createState() => _BNavigationBarState();
}

class _BNavigationBarState extends State<BNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.yellow200),
        color: Theme.of(context).buttonColor,
      ),
      child: GestureDetector(
        onTap: () => widget.toggleBars(),
        child: BottomNavigationBar(
          mouseCursor: SystemMouseCursors.grab,
          elevation: 0,
          backgroundColor: Theme.of(context).buttonColor,
          unselectedItemColor: Theme.of(context).secondaryHeaderColor,
          selectedItemColor: Theme.of(context).hintColor,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          currentIndex: widget.pageIndex,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.of(context)
                    .pushReplacementNamed(QuranScreen.routeName);
                break;

              case 1:
                Navigator.of(context)
                    .pushReplacementNamed(BookMarksScreen.routeName);
                break;

              case 2:
                Navigator.of(context)
                    .pushReplacementNamed(AyahScreen.routeName);
                break;

              case 3:
                Navigator.of(context)
                    .pushReplacementNamed(SettingScreen.routeName);
                break;

              default:
              // Navigator.of(context)
              //     .pushReplacementNamed(QuranScreen.routeName);
              // break;
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.bookOpenPageVariant,
                color: widget.pageIndex == 0
                    ? Theme.of(context).hintColor
                    : Theme.of(context).accentColor,
              ),
              label: AppLocalizations.of(context)!
                  .translate('quran_screen_navigation_bar_item1')
                  .toString(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.bookmark,
                color: widget.pageIndex == 1
                    ? Theme.of(context).hintColor
                    : Theme.of(context).accentColor,
              ),
              label: AppLocalizations.of(context)!
                  .translate('quran_screen_navigation_bar_item2')
                  .toString(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.clipboardList,
                color: widget.pageIndex == 2
                    ? Theme.of(context).hintColor
                    : Theme.of(context).accentColor,
              ),
              label: AppLocalizations.of(context)!
                  .translate('quran_screen_navigation_bar_item3')
                  .toString(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.cog,
                color: widget.pageIndex == 3
                    ? Theme.of(context).hintColor
                    : Theme.of(context).accentColor,
              ),
              label: AppLocalizations.of(context)!
                  .translate('quran_screen_navigation_bar_item4')
                  .toString(),
            ),
          ],
        ),
      ),
    );
  }
}
