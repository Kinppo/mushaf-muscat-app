import 'package:flutter/material.dart';
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

  // final toggleAppBar = return

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              title: const Text("Quran screen"),
            )
          : PreferredSize(
              child: Container(),
              preferredSize: const Size(0.0, 0.0),
            ),
      bottomNavigationBar: _showNavBar
          ? BottomNavigationBar(
              backgroundColor: Colors.blue,
              unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
              selectedItemColor: const Color.fromARGB(255, 39, 76, 199),
              currentIndex: 1,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'Other',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Text',
                ),
              ],
            )
          : const PreferredSize(
              child: Text(""),
              preferredSize: Size(0.0, 0.0),
            ),
      drawer: Container(
    width: double.infinity,
    child: MainDrawer(),),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(Dimens.px22),
                  color: Colors.white,
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
                    print(_showAppBar);
                  });
                }),
          ],
        ),
      ),

    );
  }
}

