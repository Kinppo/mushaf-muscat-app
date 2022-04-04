import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  static const routeName = '/unknown';
  const UnknownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Unknown Screen"),
    );
  }
}
