import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/cupertino.dart';
import '../resources/dimens.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int segmentedControlValue = 0;
  String hint = 'البحث عن سورة';

   String hintText() {
    setState(() {
      if( segmentedControlValue ==0) {
     hint = 'البحث عن سورة';
    }

    else {
     hint = 'البحث في الأجزاء (مثلا: ١٤)';
    }
    });

    return hint;
  }

  Widget buildListTile(String title, Function tapHandler) {
    return segmentedControlValue == 0 ? ListTile(
       
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {}
        ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
        Container(
          padding: EdgeInsets.all(Dimens.px30),
        ),
          Padding(
            padding:  EdgeInsets.all(Dimens.px30) ,
            child: Container(
              width: 189,
              height: 32,
              child: CupertinoSlidingSegmentedControl(
                  groupValue: segmentedControlValue,
                  backgroundColor: Colors.blue.shade200,
                  children: const <int, Widget>{
                    0: Text('السور'),
                    1: Text('الأرباع'),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      segmentedControlValue = value as int;
                      print(segmentedControlValue);
                    });
                  }),
            ),
          ),
  TextField(
    decoration: InputDecoration(
      icon: Icon(Icons.search),
      iconColor: Colors.brown,
      fillColor: Color(0xe6ded6),
    //hintText: 'البحث عن سورة',
    hintText: hintText(),
    hintStyle: TextStyle(
     color: Colors.brown,
     fontSize: 16,
     fontWeight: FontWeight.bold,
    ),

    ),
    style: TextStyle(
    color: Colors.brown,
    ),
   ),
          SizedBox(
            height: 20,
          ),
          buildListTile("الفاتحة", () {
            //Navigator.of(context).pushReplacementNamed('/');
          }),
          Divider(),
          buildListTile("البقرة", () {
            //Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
          }),
           Divider(),
          buildListTile("آل عمران", () {
          }),
           Divider(),
          buildListTile("النساء", () {
          }),
        ],
      ),
    );
  }
}
