import 'package:flutter/material.dart';

class SurahsList extends StatelessWidget {
  String num;
  String title;
  String numAya;
  String type;


SurahsList({Key? key, required this.num, required this.title, required this. numAya, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
            trailing: CircleAvatar(
              child: Text(
                num,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              radius: 20,
              backgroundColor: Theme.of(context).shadowColor,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: const Color.fromRGBO(36, 28, 21,1),
                  fontWeight: FontWeight.w600,
                  fontSize: 23),
            ),
            subtitle: Text("آياتها : $numAya   .   $type",
                style:
                    const TextStyle(color: Color.fromRGBO(148, 135, 121, 1.0))),
            onTap: () {});
  }
}