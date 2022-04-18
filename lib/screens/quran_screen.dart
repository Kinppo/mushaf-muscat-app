import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../screens/book_marks_screen.dart';
import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
import '../resources/colors.dart';
 import '../widgets/search_bar.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/drawer.dart';



class QuranScreen extends StatefulWidget {
  static const routeName = '/quran';

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  bool _showAppBar = true;
  bool _showNavBar = true;

  // final toggleAppBar = return

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
      ? AppBar(
          leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),),
    iconTheme:IconThemeData(color: Theme.of(context).scaffoldBackgroundColor),
    toolbarHeight: 120, // Set this height
    flexibleSpace: Container(
                  padding: const EdgeInsets.all(30),

      color: CustomColors.yellow500,
      child: Column(
        children: [SizedBox(height: 40,),
            Container(
            padding: const EdgeInsets.only(top:50),
            width: double.infinity,
            height: 40,
            child: searchBar(hint: "البحث",),
          ),
        ],
      ), ), ):
   
          // ? AppBar(
          //     backgroundColor: Theme.of(context).primaryColor,
          //     title: Text(
          //       AppLocalizations.of(context)!
          //           .translate('quran_screen_title')
          //           .toString(),
          //       style: Theme.of(context).textTheme.headline1,
          //     ),
          //   )
            PreferredSize(
              child: Container(),
              preferredSize: const Size(0.0, 0.0),
            ),
      bottomNavigationBar: _showNavBar
          ? const BNavigationBar(
              pageIndex: 0,
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
