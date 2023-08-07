import 'package:flutter/material.dart';
import 'package:mushafmuscat/resources/colors.dart';
import 'dart:async';

import '../screens/quran_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(QuranScreen.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: CustomColors.brown200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: CustomColors.brown200,
            child: Image.asset(
              'assets/images/playstore.png',
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
          Container(
          color: CustomColors.brown200,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.height * 0.05,
            child: CircularProgressIndicator(
                color: CustomColors.yellow400),
          ),
        ],
      ),
    );
  }
}
