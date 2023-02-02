import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mushafmuscat/widgets/appbar.dart';

import '../localization/app_localizations.dart';
import '../resources/dimens.dart';
import '../resources/colors.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../widgets/finalCarousel2.dart';
import '../widgets/TafsirCarousel.dart';

class QuranScreen extends StatefulWidget {
  static const routeName = '/quran';

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  bool showAppBar = true;
  bool showNavBar = true;
  late int segmentedControlValue;
  bool orientationPotrait = true;
  bool toggleSearch = false;
  bool showPlayer = true;
  int goToPage = 0;
  int loop = 0;
  int highlighNum = 0;
  late int GlobalCurrentPage;
  var searchRes;

  @override
  void initState() {
    print("133333333333333333333");
    // _detailListBloc = DetailListBloc(widget.apiUrl);
    setState(() {
      segmentedControlValue = 0;
      GlobalCurrentPage = 1;
    });
    // TODO: implement initState
    super.initState();
  }

  void controlSegment(segment) {
    setState(() {
      segmentedControlValue = segment;
      print("segmentedControlValue $segmentedControlValue");
    });
  }

  void controlSearch( search,result ) {
    searchRes=[];
    setState(() {
      toggleSearch = search;
      print("toggleSearch $toggleSearch");
      // print(result.toList().toString());
      searchRes=result;
    });
  }

List<ListTile> getSearchTiles() {
  List<ListTile> resultstiles=[];

for (int i=0; i<searchRes.length; i++ ) {
resultstiles.add(ListTile(title: Text(searchRes[i].surahTitle.toString())));
}


return resultstiles.isNotEmpty? resultstiles : [ListTile(title:Text("empty"))];

}



  void toggleBars() {
    setState(() {
      showPlayer = !showPlayer;
      showAppBar = !showAppBar;
      showNavBar = !showNavBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("WIDGET GLOBAL IS +" + GlobalCurrentPage.toString());
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var Screenheight = MediaQuery.of(context).size.height;

    // Future.delayed(Duration.zero,(){//you can await it if you want
    //   print('init=${ModalRoute.of(context)!.settings.arguments}');
    // goToPage = ModalRoute.of(context)!.settings.arguments?[0] as int;
    // loop = ModalRoute.of(context)!.settings.arguments[1];
//  List<dynamic> args = [goToPage, 0];
// args=  ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    if (arg != null) {
      goToPage = arg['v1'] as int;
      loop = arg['v2'] as int;
      highlighNum = arg['v3'] as int;
      print("ARGSSSS: " + arg.toString());
    }
//  goToPage = arg['v1'] as int;
// int randomVar2 = arg['v2'];
// print("argsssssss1: "+ randomVar1.toString());
// print("argsssssss2: "+ randomVar2.toString());

// if (args.length!= null){
// print((args.length>1)? "this is null": args[1].toString());
// }
//   setState(() {

// if (!args.first.isEmpty) {

//       goToPage=args. as int;
// }
// if (!argRs.last.isEmpty) {

// loop=args[1] as int;
// }R
//   });

    void changeGlobal(int currpage) {
      setState(() {
        GlobalCurrentPage = currpage;
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false, // set it to false

      appBar: showAppBar
          ? appBar(
              segmentedControlValue: controlSegment,
              orientationPotrait: orientationPotrait,
              toggleSearch: controlSearch,
              h: (isLandscape == false) ? Screenheight * 0.18 : 200,
              segmentToggle: segmentedControlValue,
            )
          : PreferredSize(
              child: Container(),
              preferredSize: const Size(0.0, 0.0),
            ),
      bottomNavigationBar: showNavBar
          ? const BNavigationBar(
              pageIndex: 0,
            )
          : const PreferredSize(
              child: Text(""),
              preferredSize: Size(0.0, 0.0),
            ),
      drawer: Container(
        width: double.infinity,
        child: const MainDrawer(),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
                                     (toggleSearch != true) ?

            GestureDetector(

                // behavior: HitTestBehavior.deferToChild,
                child: (segmentedControlValue == 0 && toggleSearch == false)
                    ? Container(
                        // padding: const EdgeInsets.all(Dimens.px22),
                        color: Theme.of(context).backgroundColor,
                        height: MediaQuery.of(context).size.height,

                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              // child: finalCarousel(goToPage: goToPage, toggleBars:toggleBars),
                              child: finalCarousel2(
                                  goToPage:
                                      (goToPage != 0 && GlobalCurrentPage == 1)
                                          ? goToPage
                                          : GlobalCurrentPage,
                                  loop: loop,
                                  toggleBars: toggleBars,
                                  loophighlight: highlighNum,
                                  GlobalCurrentPage: GlobalCurrentPage,
                                  changeGlobal: changeGlobal),
                            ),
                            // showPlayer ? AudioPlayerWidget():
                            // Container()
                          ],
                        ),
                      )
                    : (segmentedControlValue == 1 && toggleSearch == false)
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            // padding: const EdgeInsets.all(Dimens.px22),
                            color: Theme.of(context).backgroundColor,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: TafsirCarousel(
                                goToPage: GlobalCurrentPage,
                                loop: loop,
                                toggleBars: toggleBars,
                                loophighlight: highlighNum,
                                GlobalCurrentPage: GlobalCurrentPage,
                                changeGlobal: changeGlobal,
                              ),
                              // Text(AppLocalizations.of(context)!
                              //     .translate('tafsir_text')
                              //     .toString()),
                            ),
                          )

                            : Container(
                                height: 400,
                                child:
                                    Text("grokgrogjkaoeajeotjejotjeotetetwtw"),
                                color: CustomColors.red200,
                              ),
                onTap: () {
                  toggleBars();
                }) :

      
                       Container(
                        padding: EdgeInsets.only(top:Screenheight * 0.22),
                         child: ListView.builder(
                              shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 20),
                                        itemCount:  1,
                                        itemBuilder: (ctx, i) {
                                          return Column(
                                            children:
                                               getSearchTiles()

                                  
                                  // ListTile(title: Text(i.toString()),
                                  // textColor: Colors.red,
                                  // tileColor: Colors.white),
                                  // ListTile(title: Text(i.toString()),  textColor: Colors.red,
                                  // tileColor: Colors.white),
                                  
                                  // ListTile(title: Text(i.toString()),  textColor: Colors.red,
                                  // tileColor: Colors.white),
                                  
                                            ,
                                          );
                                        }, ),
                       ) 
          ]
        ),
      ),
    );
  }
}
