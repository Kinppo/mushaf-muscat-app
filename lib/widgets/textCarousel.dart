import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/widgets/quran.dart' as quranWidget;
import 'package:mushafmuscat/widgets/test3.dart';

class textCarousel extends StatefulWidget {
  const textCarousel({Key? key}) : super(key: key);

  @override
  State<textCarousel> createState() => _textCarouselState();
}

class _textCarouselState extends State<textCarousel> {
  @override
  Widget build(BuildContext context) {
    //num of pages, for now its 4
    List<int> listindex = [1, 2, 3, 4];
    int activeIndex = 0;

    return CarouselSlider.builder(
      itemCount: listindex.length,
      itemBuilder: (context, index, realIndex) {
        return QuranTest(pageNum: index + 1);
      },
      options: CarouselOptions(
          height: 800,
          reverse: false,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          initialPage: -1,
          scrollDirection: Axis.horizontal,
          //aspectRatio: 3,
          //enlargeCenterPage: true,

          //disableCenter: true,
          onPageChanged: (index, reason) {
            setState(() {
              activeIndex = index;
            });
          }
          //pageSnapping: false
          ),
    );
  }
}
