// import 'dart:convert';

// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:mushafmuscat/widgets/aya_clicked_bottom_sheet.dart';
// import 'package:mushafmuscat/widgets/pageDetails.dart';
// import 'package:provider/provider.dart';

// import '../models/AyatLines.dart';
// import '../models/surah.dart';
// import '../providers/audioplayer_provider.dart';
// import '../providers/surah_provider.dart';
// import '../resources/colors.dart';
// import '../utils/helperFunctions.dart';

// class finalCarouselTesting extends StatefulWidget {
//   int goToPage;
//   Function toggleBars;
//   finalCarouselTesting({
//     Key? key,
//     required this.goToPage,
//     required this.toggleBars,
//   }) : super(key: key);

//   @override
//   State<finalCarouselTesting> createState() => _finalCarouselTestingState();
// }

// class _finalCarouselTestingState extends State<finalCarouselTesting> {
// // integers
//   int overallid = 0;
//   int currentPage = 0;
//   int activeAya = -1;
//   int activeIndex = 1;
//   int clickedHighlightNum = 0;

// // bools and flags
//   bool cameFromMenu = false;
//   bool _isInit = true;
//   bool _isLoading = true;
//   late bool ShowAudioPlayer;
//   late bool ShowOnlyPageNum;
//   bool ayaFlag = false;
//   bool showPauseIcon = false;
//   bool firstFlag = false;
//   bool clickHighlightWhilePlaying = false;
//   bool moveNextPage = false;

// // strings
//   String surahName = 'الفاتحة';

// // lists
//   late final List<String?> _surahNames;
//   late final List<List<int>> _flagsForEndofSurah;

// // controllers
//   CarouselController carouselController = new CarouselController();
//   CarouselController carouselController2 = new CarouselController();

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await loadSurahs;
//       setState(() {
//         loadSurahs();
//         // Provider.of<AudioPlayer_Provider>(context, listen: false)
//         //     .getAudioPaths(1);
//         // Provider.of<AudioPlayer_Provider>(context, listen: false)
//         //     .openAudioPlayer();

//         if (widget.goToPage != null && widget.goToPage != 0) {
//           overallid = (widget.goToPage as int) - 1;
//           cameFromMenu = true;
//           currentPage = widget.goToPage as int;
//           print("CAME FROM MENU IS $cameFromMenu");
//         }
//       });
//     });

//     // getAudioPaths();
//     // activate();
//     ShowAudioPlayer = false;
//     ShowOnlyPageNum = true;

//     super.initState();
//   }

//   void loadSurahs() {
//     final surahsData = Provider.of<SurahProvider>(context, listen: false);
//     _surahNames = surahsData.loadSurahs();
//     _flagsForEndofSurah = surahsData.loadFlags();
//   }

//   toggleClickedHighlight(int clickedIdx) {
//     setState(() {
//       print("CLICKED HIGHLIGHT NUM IS $clickedIdx");
//       clickedHighlightNum = clickedIdx - 1;
//       if (firstFlag == true) {
//         clickHighlightWhilePlaying = true;
//       }
//       // clickedHighlightNum=-1;
// // showPauseIcon=!showPauseIcon;
//       // change this to modal bottom sheet
//       //  ShowAudioPlayer=true;
//       showModalBottomSheet<void>(
//         constraints: BoxConstraints(maxWidth: 400, maxHeight: 460),
//         clipBehavior: Clip.hardEdge,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25.0),
//         ),
//         context: context,
//         builder: (BuildContext context) {
//           return AyaClickedBottomSheet(
//             ShowAudioPlayer: togglePlayer,
//           );
//         },
//       );
//     });

//     // getAudioPaths();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   void handleActiveAya(int updatedAya) {
//     setState(() {
//       activeAya = updatedAya;
//     });

//     print("ACTIVEEEE IS $activeAya");
//   }

//   void handleAyaFlag() {
//     setState(() {
//       if (ayaFlag == false) {
//         ayaFlag = true;
//       }
//     });
//   }

// moveToNextPage()   {

// //   //  print()
// //     print("======****************==============");
// // setState(() {
// //   activeAya=0;
// //   clickedHighlightNum=0;
// //   currentPage=currentPage+1;
// // });
// // await Provider.of<AudioPlayer_Provider>(context, listen: false).clearEverything();
    
//     print("calling next page");
//     carouselController.nextPage();
//     carouselController2.nextPage();

//         Provider.of<AudioPlayer_Provider>(context, listen: false).AudioListener(handleActiveAya, handleAyaFlag, moveToNextPage);

//     // print("hello hello");

//     // clickedHighlightNum = 0;
//     // moveNextPage = true;
//   }

//   void togglePlayer() {
//     setState(() {
//       if (firstFlag == true &&
//           clickHighlightWhilePlaying == true &&
//           ShowAudioPlayer == true) {
//         if (showPauseIcon == false) {
//           showPauseIcon = !showPauseIcon;
//         }

//         Provider.of<AudioPlayer_Provider>(context, listen: false)
//             .playFromHighlightedText(
//           clickedHighlightNum,
//           currentPage,
//           moveNextPage,
//         );
//         Provider.of<AudioPlayer_Provider>(context, listen: false)
//             .AudioListener(handleActiveAya, handleAyaFlag, moveToNextPage);
//         clickHighlightWhilePlaying = false;
//         ShowAudioPlayer = true;
//       } else {
//         widget.toggleBars();
//         ShowAudioPlayer = true;
//       }
//     });

//     print("TOGGLED TO $ShowAudioPlayer");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Audioplayer_Provider =
//         Provider.of<AudioPlayer_Provider>(context, listen: false);

//     // instantiate pages
//     // List<AyatLines> listofObjects = [];
//     // for (int i = 0; i < 604; i++) {
//     //   listofObjects.add(AyatLines(
//     //     text: '',
//     //     pageNumber: i,
//     //   ));
//     // }
//     // print(listofObjects);
//     List<int> listindex = new List<int>.generate(604, (i) => i + 1);
//     List<AyatLines> listofObjects = [];

//     listindex.forEach((i) => listofObjects.add(AyatLines(
//           text: '',
//           pageNumber: i,
//         )));
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height,
//       child: Column(children: [
//         Container(
//           padding: EdgeInsets.fromLTRB(0, 155, 0, 0),
//           color: Colors.white,
//           child: CarouselSlider(
//             options: CarouselOptions(

//                 // height: MediaQuery.of(context).size.height,
//                 height: 672,
//                 reverse: false,
//                 viewportFraction: 1,
//                 enableInfiniteScroll: true,
//                 initialPage:
//                     //if infinite scroll is false, then initial page has to be -1 not 0
//                     (cameFromMenu == true) ? widget.goToPage - 1 : 0,
//                 scrollDirection: Axis.horizontal,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     print("we are in next page");
//                     overallid = index;
//                     currentPage = index + 1;
//                     surahName = _surahNames[index]!;
//                     print("CURRENT PAGE IS $currentPage");

//                     // Audioplayer_Provider.getAudioPaths(currentPage);
//                     print("got new audio paths");

//                     // Audioplayer_Provider.openAudioPlayer();
//                     // PlayAudios();

//                     // print("PAGE ID IS $currentPage");
//                   });
//                 }),
//             items: listofObjects.map((i) {
//               int idx = listofObjects.indexOf(i);
//               // print("building... $idx")

//               return Builder(
//                 builder: (BuildContext context) {
//                   return GestureDetector(
//                     onTap: () {
//                       ShowOnlyPageNum = !ShowOnlyPageNum;
//                     },
//                     child: Stack(fit: StackFit.passthrough, children: [
//                       // IgnorePointer(
//                       //   child:
//                       //    Image.asset( (idx==0) ? 'assets/quran_images/img_1.jpg' : (idx==603 ? 'assets/quran_images/img_604.jpg' : 'assets/quran_images/img_3.jpg'),
//                       //   // height:300,
//                       //           fit: BoxFit.fitWidth,                              width: MediaQuery.of(context).size.width,
//                       //     ),
//                       // ),
//                       Consumer<AudioPlayer_Provider>(builder:
//                           (BuildContext context, value, Widget? child) {
//                         return Container(
//                           width: MediaQuery.of(context).size.width,
//                           padding: (idx == 0 || idx == 1)
//                               ? EdgeInsets.only(top: 100)
//                               : EdgeInsets.only(top: 0),
//                           margin: EdgeInsets.symmetric(horizontal: 5.0),
//                           child: pageDetails(
//                             id: idx + 1,
//                             indexhighlight: activeAya,
//                             currentpage: idx + 1,
//                             ayaFlag: ayaFlag,
//                             toggleClickedHighlight: toggleClickedHighlight,
//                             clickedHighlightNum: clickedHighlightNum - 1,
//                              ContinueNextPage: moveToNextPage,
//                           ),
//                         );
//                       }),
//                     ]),
//                   );
//                 },
//               );
//             }).toList(),
//             carouselController: carouselController,
//           ),
//         ),
//         //====================PAGE INDICATOR=====================

//         (ShowAudioPlayer != true && ShowOnlyPageNum == false)
//             ? GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     ShowOnlyPageNum = !ShowOnlyPageNum;
//                     // print("what is this");
//                   });
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   // margin: EdgeInsets.only(bottom: 70),
//                   // padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//                   height: 85,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(7),
//                       shape: BoxShape.rectangle,
//                       border: Border.all(
//                         color: CustomColors.yellow200,
//                         width: 1,
//                       ),
//                       color: CustomColors.yellow500),
//                   child: Column(
//                     children: [
//                       Text(
//                         surahName,
//                         style: TextStyle(color: CustomColors.red300),
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       CarouselSlider(
//                         carouselController: carouselController2,
//                         options: CarouselOptions(
//                           onPageChanged: (index, reason) {
//                             // _currentIndex = index;
//                             // print("INDEX IS $index");
//                           },
//                           height: 34.0,
//                           viewportFraction: 0.16,
//                           reverse: false,
//                           initialPage:
//                               (cameFromMenu == true) ? widget.goToPage - 1 : 0,
//                           scrollDirection: Axis.horizontal,
//                           pageSnapping: true,
//                           enableInfiniteScroll: true,
//                         ),
//                         items: listindex.map((i) {
//                           return Builder(
//                             builder: (BuildContext context) {
//                               return Container(
//                                 width: 50,
//                                 height: 2,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       surahName = _surahNames[i - 1]!;
//                                       carouselController2.animateToPage(i - 1);
//                                       carouselController.animateToPage(i - 1);
//                                       // ShowOnlyPageNum=true;
//                                     });
//                                   },
//                                   child: Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(7),
//                                           shape: BoxShape.rectangle,
//                                           border: Border.all(
//                                             color: (i - 1 == overallid)
//                                                 ? CustomColors.grey200
//                                                 : CustomColors.yellow200,
//                                             width: 1,
//                                           ),
//                                           color: Colors.white),
//                                       height: 30,
//                                       width: 40,
//                                       child: Text(
//                                         HelperFunctions.convertToArabicNumbers(
//                                                 i.toString())
//                                             .toString(),
//                                         style: TextStyle(
//                                             color: (i - 1 == overallid)
//                                                 ? CustomColors.red300
//                                                 : CustomColors.grey200,
//                                             fontSize: 18),
//                                         textAlign: TextAlign.center,
//                                       )),
//                                 ),
//                               );
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               )

//             //====================AUDIOPLAYER=====================
//             : (ShowAudioPlayer == true)
//                 ? Container(
//                     // padding: EdgeInsets.only(bottom: 95),
//                     child: Container(
//                       // alignment: Alignment.bottomCenter
//                       margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
//                       decoration: BoxDecoration(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(15.0)),
//                         border:
//                             Border.all(color: CustomColors.brown700, width: 1),
//                       ),
//                       width: 650,
//                       height: 70,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Material(
//                             color: Colors.transparent,
//                             shape: CircleBorder(),
//                             clipBehavior: Clip.hardEdge,
//                             child: IconButton(
//                                 iconSize: 30,
//                                 icon: SvgPicture.asset(
//                                     "assets/images/Settings.svg",
//                                     width: 30,
//                                     height: 30,
//                                     fit: BoxFit.fitWidth),
//                                 onPressed: () {}),
//                           ),
//                           const SizedBox(
//                             width: 30,
//                           ),
//                           Material(
//                             color: Colors.transparent,
//                             shape: const CircleBorder(),
//                             clipBehavior: Clip.hardEdge,
//                             child: IconButton(
//                                 iconSize: 40,
//                                 icon: SvgPicture.asset(
//                                     "assets/images/Seek_right.svg",
//                                     width: 40,
//                                     height: 40,
//                                     fit: BoxFit.fitWidth),
//                                 //seek forward
//                                 onPressed: () {
//                                   Audioplayer_Provider.seekForward();
//                                 }),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           CircleAvatar(
//                             backgroundColor: CustomColors.grey200,
//                             maxRadius: 20,
//                             child: Material(
//                               color: Colors.transparent,
//                               shape: const CircleBorder(),
//                               clipBehavior: Clip.hardEdge,
//                               child: IconButton(
//                                   icon: Icon(
//                                     showPauseIcon
//                                         ? Icons.pause
//                                         : Icons.play_arrow,
//                                     color: CustomColors.yellow100,
//                                   ),
//                                   iconSize: 20,
//                                   onPressed: () {
//                                     setState(()   async {
//                                       await  pageDetails.globalKey.currentState?.loadAudios(currentPage);
//                                       if (firstFlag == false) {
//                                        pageDetails.globalKey.currentState?.playFromHighlightedText();

//                                         // Audioplayer_Provider
//                                         //     .playFromHighlightedText(
//                                         //   clickedHighlightNum,
//                                         //   currentPage,
//                                         //   moveNextPage,
//                                         // );
//                                         showPauseIcon = !showPauseIcon;
//                                         Audioplayer_Provider.AudioListener(
//                                             handleActiveAya,
//                                             handleAyaFlag,
//                                             moveToNextPage);
//                                         firstFlag = true;
//                                         showPauseIcon = true;
//                                         clickedHighlightNum = 0;
//                                       } else if (firstFlag == true) {
//                                         showPauseIcon = !showPauseIcon;

//                                         Audioplayer_Provider.pauseOrPlay();
//                                       }
//                                     });
//                                   }),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Material(
//                             color: Colors.transparent,
//                             shape: const CircleBorder(),
//                             clipBehavior: Clip.hardEdge,
//                             child: IconButton(
//                                 iconSize: 40,
//                                 icon: SvgPicture.asset(
//                                     "assets/images/Seek_left.svg",
//                                     width: 40,
//                                     height: 40,
//                                     fit: BoxFit.fitWidth),
//                                 //seek forward
//                                 onPressed: () {
//                                   // initializeDuration();
//                                   setState(() {
//                                     // seekBackward = true;
//                                     Audioplayer_Provider.seekBackward();
//                                   });
//                                   // PlayAudios();
//                                 }),
//                           ),
//                           // SizedBox(
//                           //   width: 80,
//                           // ),
//                           const SizedBox(
//                             width: 25,
//                           ),
//                           Material(
//                             color: Colors.transparent,
//                             shape: CircleBorder(),
//                             clipBehavior: Clip.hardEdge,
//                             child: IconButton(
//                                 iconSize: 40,
//                                 icon: SvgPicture.asset("assets/images/exit.svg",
//                                     width: 30,
//                                     height: 30,
//                                     fit: BoxFit.fitWidth),
//                                 //seek forward
//                                 onPressed: () {
//                                   setState(() {
//                                     ShowAudioPlayer = false;
//                                     ShowOnlyPageNum = true;
//                                   });
//                                   print("pressed exit");
//                                 }),
//                           ),
//                           //  SizedBox(
//                           //   width: 20,
//                           // ),
//                         ],
//                       ),
//                     ),
//                   )
//                 //===================PAGE NUMBER====================
//                 : Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if (cameFromMenu == true) {
//                             surahName =
//                                 surahName[(widget.goToPage as int) - 1]!;
//                           }
//                           print("========PRESSED");

//                           ShowOnlyPageNum = !ShowOnlyPageNum;
//                         });
//                       },
//                       child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7),
//                               shape: BoxShape.rectangle,
//                               border: Border.all(
//                                 color: CustomColors.yellow200,
//                                 width: 1,
//                               ),
//                               color: Colors.white),
//                           height: 30,
//                           width: 40,
//                           child: Text(
//                             HelperFunctions.convertToArabicNumbers(
//                                     (overallid + 1).toString())
//                                 .toString(),
//                             style: TextStyle(
//                                 color: CustomColors.grey200, fontSize: 18),
//                             textAlign: TextAlign.center,
//                           )),
//                     ),
//                   ),
//       ]),
//     );
//   }
// }
