import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mushafmuscat/models/pageText.dart';
import 'package:mushafmuscat/providers/pageText_provider.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'package:mushafmuscat/widgets/appbar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/surah.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/providers/surah_provider.dart';
import 'package:mushafmuscat/screens/quran_screen.dart';
import 'package:provider/provider.dart';

import '../localization/app_localizations.dart';
import '../models/surah.dart';
import '../providers/quran_display_provider.dart';
import '../utils/helperFunctions.dart';
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

  int activeIndex = 0;

  final controller = CarouselController();

  @override
  void initState() {
    filldata();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<QuranDisplay>(context).fetchImages().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

        Provider.of<PageText_provider>(context).fetchPageText().then((_) {
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
    // final surahsData = Provider.of<SurahProvider>(context, listen: false);
    // final surahss =surahsData.surahs;

    //     final List<Surah> _surahitem = surahss;

    final imagesData = Provider.of<QuranDisplay>(context, listen: false);
    final pagelist = imagesData.imageslist;

     final textData = Provider.of<PageText_provider>(context, listen: false);
    final textlist = textData.text;

    List <String?> names = [];

// for  (int i=0; i<= textlist.length; i++) {
//     names.add(textlist[i].text);
// }

Widget getTextWidgets( int id)
 {
   List<Widget> list = <Widget>[];

   List <PageText> temp = [];
   temp.addAll(textlist);

   temp.retainWhere((element) => 
   (element.page==id )
   );

    for(var i = 0; i < temp.length; i++){
           String? s= '';
           String? m =temp[i].text;
           print("M");
           print (m);

if (temp[i].text== null) {
   list.add(Row());
  print("null");
} 

else {
   s = s + ' '+ temp[i].text!;
}
print(s);
       list.add(Text(s,textDirection:TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.pink)));
s='';

   }
   return  Column(children: list);
 }
  
    
    //final List<Surah> _surahitem = surahss;
  String n= names.join(' ');

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              child: CarouselSlider.builder(
                carouselController: controller,
                options: CarouselOptions(
                  height: 650,
                  viewportFraction: 1,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
                itemCount: pagelist.length,
                itemBuilder: (
                  context,
                  index,
                  realIndex,
                ) {
                  //access one specific image
                  final imageItem = pagelist[index].PNGimagePath;
                  //print(imageItem);
                  return buildImage(imageItem, index);
                },
              ),
            ),
             Expanded(
              child:Container(
                ),
              // Text(
              //   n,
              //   style: TextStyle(color: Colors.pink,  fontSize: 12.0),
              // ),
              ),
            // const SizedBox(
            //   height: 13,
            // ),
            Container(
              margin: const EdgeInsets.fromLTRB(60, 0, 60, 0),
              //padding: EdgeInsets.all(10),
              child: getListData(pagelist.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String? imageItem, int index) {
    return FittedBox(
      //margin: EdgeInsets.all(2),
      //color: Colors.grey,
      child: Image.asset(imageItem!), fit: BoxFit.fill,
    );
  }

// Generate list of numbers and convert them to arabic using the helper function
  List<String> data = [];

  void filldata() {
    for (int i = 0; i < 100; i++) {
      String? num = HelperFunctions.convertToArabicNumbers(i.toString());
      data.add(num!);
    }
  }

// getListData(count) {

//         CarouselSlider(
//         items:data.map((i){
//           return Container(child: Text(i, style: TextStyle(color: Colors.black),));

//         }).toList(),options: CarouselOptions(
//                 enlargeCenterPage: true,
//                 autoPlay: true,
//                 autoPlayCurve: Curves.fastOutSlowIn,
//                 enableInfiniteScroll: true,
//               ),

//               );
// }

// IMPORTANT
// =========================
  // getListData(count) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Wrap(
  //           children:
  //        data
  //             .map((weakness) => FilterChip(
  //                 shape: RoundedRectangleBorder(
  //                   side: BorderSide(color: CustomColors.yellow200, width: 1),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 backgroundColor: Colors.white,
  //                 label: Container(
  //                   width: 32,
  //                   height: 28,
  //                   child: Center(
  //                     child: Text(
  //                       weakness,
  //                       style: TextStyle(color: CustomColors.grey200, fontSize: 17, fontFamily: "IBMPlexSansArabic", fontWeight: FontWeight.normal),
  //                     ),
  //                   ),
  //                 ),
  //                 onSelected: (b) {}))
  //             .toList(),
  //             spacing: 5,),
  //       ],
  //     ),
  //   );
  // }
// =========================

//    buildIndicator(int count) {
//     return  Column(
//                 children: <Widget>[
//                   Expanded(
//                     child: Wrap(
//           children: data.map((e) => _chip(e, context)).toList(),
//           spacing: 2, ),

//                   ), ] ); }
//         child: Wrap(
//           children: data.map((e) => _chip(e, context)).toList(),
//           spacing: 2,
//         ),
//       ),
//     );
//   }
// }

  Widget _chip(String data, BuildContext context) => ChoiceChip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          data,
          style: TextStyle(
              color: CustomColors.brown600,
              fontSize: 19,
              fontFamily: "IBMPlexSansArabic"),
        ),
        selectedColor: Colors.white,
        selected: true,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: CustomColors.yellow200, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        pressElevation: 1,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
      );

//==============================

  getListData(int count) {
    return Stack(
      children: <Widget>[
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: count,
          onDotClicked: animatetoSlide,
          effect: ScrollingDotsEffect(
              fixedCenter: true,
              spacing: 8.0,
              radius: 4.0,
              dotWidth: 35.0,
              dotHeight: 25.0,
              // paintStyle:  PaintingStyle.stroke,
              // strokeWidth:  1.5,
              activeDotColor: CustomColors.brown500,
              dotColor: Colors.white),
        ),
      ],
    );
  }
//==============================
  // effect: JumpingDotEffect(
  //   dotWidth: 20,
  //   dotHeight: 20,
  //   activeDotColor: CustomColors.brown100,
  //   dotColor: CustomColors.grey100,
  // ),
  // }

// ===============
  animatetoSlide(int index) {
    controller.animateToPage(index);
  }
}
// ===============
  