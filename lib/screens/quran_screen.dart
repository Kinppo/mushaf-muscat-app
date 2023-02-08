import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';

import 'package:mushafmuscat/widgets/appbar.dart';
import 'package:provider/provider.dart';

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
  var searchRes_surah;
  var searchRes_aya;
  bool searchStatus= false;
  // int searchListLength=0;


  @override
  void initState() {
    //load all ayas for search
    setState(() {
      // loadAyas();
      segmentedControlValue = 0;
      GlobalCurrentPage = 1;
    });
    // TODO: implement initState
    super.initState();
  }

  // void loadAyas() async{
  //   final surahsData = Provider.of<SurahProvider>(context, listen: false);
  //    await surahsData.loadAllAyasJson();
  //    print(surahsData.ayaas);

  // }

  void controlSegment(segment) {
    setState(() {
      segmentedControlValue = segment;
      print("segmentedControlValue $segmentedControlValue");
    });
  }

  void controlSearch(search,surah_result, aya_result ) {
    searchRes_surah=[];
    searchRes_aya=[];

    setState(() {
      toggleSearch = search;
      // print("toggleSearch $toggleSearch");
      // print(result.toList().toString());

      searchRes_surah=surah_result;
      searchRes_aya=aya_result;
      // searchListLength= searchRes_surah.length+searchRes_aya.length;


    });
  }



List<Widget> getSearchTiles() {
  List<ListTile> SurahResultsTiles=[];
  List<ListTile> AyaResultsTiles=[];

for (int i=0; i<searchRes_surah.length; i++ ) {
SurahResultsTiles.add(ListTile(title: Text(searchRes_surah[i].surahTitle.toString(), style: TextStyle(color: CustomColors.black200),)));
}

for (int i=0; i<searchRes_aya.length; i++ ) {
AyaResultsTiles.add(ListTile(title: Text(searchRes_aya[i].text.toString(), 
overflow: TextOverflow.ellipsis,style: TextStyle(color: CustomColors.black200),)));
}

List< ListTile> FinalList=[];

FinalList.add(ListTile(title: Text("السور (" + searchRes_surah.length.toString()+ ")", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21, color: CustomColors.black200),)));
FinalList.addAll(SurahResultsTiles);
FinalList.add(ListTile(title: Text("الايات  (" + searchRes_aya.length.toString() + ")", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21, color: CustomColors.black200),)));
FinalList.addAll(AyaResultsTiles);

return 
(FinalList.isNotEmpty) ? 
FinalList
: [ListTile(title:Text("empty"))];

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

    void changeSearchStatus() {
      setState(() {
        searchStatus=true;
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
              changeSearchStatus: changeSearchStatus,
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

      
                       GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
                         child: Column(
                           children: [
                             Container(padding: EdgeInsets.only(top: Screenheight*0.22),
                             height: Screenheight,
                             width:double.infinity,
                               child: ListView.builder(
                                              
                                    // shrinkWrap: true,
                                              padding: const EdgeInsets.only(top: 20),
                                              itemCount: 1,
                                              itemBuilder: (ctx, i) {
                                                return Column(
                                                  children:
                                                  (searchStatus==false) ? [CircularProgressIndicator()] :
                                                          getSearchTiles(),                
                               //  ListTile.divideTiles( //          <-- ListTile.divideTiles
                               //       context: context,
                               //       tiles: [
                               //         getSearchTiles(),
                                  
                               //       ]
                               //   ).toList(),
                               
                                                
                                        
                                        // ListTile(title: Text(i.toString()),
                                        // textColor: Colors.red,
                                        // tileColor: Colors.white),
                                        // ListTile(title: Text(i.toString()),  textColor: Colors.red,
                                        // tileColor: Colors.white),
                                        
                                        // ListTile(title: Text(i.toString()),  textColor: Colors.red,
                                        // tileColor: Colors.white),
                                        
                                                  
                                                );
                                              }, ),
                             ),
                           ],
                         ),
                       ) 
          ]
        ),
      ),
    );
  }
}
