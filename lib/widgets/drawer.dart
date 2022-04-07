import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/cupertino.dart';
import '../resources/dimens.dart';
import '../widgets/surah_list.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int segmentedControlValue = 0;
  String hint = 'البحث عن سورة';

  String hintText() {
    setState(() {
      if (segmentedControlValue == 0) {
        hint = 'البحث عن سورة';
      } else {
        hint = 'البحث في الأجزاء (مثلا: ١٤)';
      }
    });

    return hint;
  }

  Widget buildListTile(
      String subtitle, String num, String title, Function tapHandler) {
    return segmentedControlValue == 0
        ? ListTile(
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
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            subtitle: Text(subtitle,
                style:
                    const TextStyle(color: Color.fromRGBO(148, 135, 121, 1.0))),
            onTap: () {})
        :
        //SurahList();
        Container();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(Dimens.px30),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.px30),
            child: Container(

              width: 190,
              height: 40,

              child: CupertinoSlidingSegmentedControl(
                  groupValue: segmentedControlValue,
                  backgroundColor: Theme.of(context).shadowColor,

                  children:  <int, Widget>{
                    0: Text('السور',style:Theme.of(context).textTheme.headline1?.copyWith(
                      color: const Color.fromRGBO(105, 91, 77,1), fontWeight: FontWeight.normal,
                      
                    ),
            ),
                    1: Text('الأرباع', style:Theme.of(context).textTheme.headline1?.copyWith(
                      color: const Color.fromRGBO(105, 91, 77,1), fontWeight: FontWeight.normal,
                    ),),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      segmentedControlValue = value as int;
                      
                      print(segmentedControlValue);
                    });
                  }),

            ),
          ),
          Container(
            width: double.infinity,
            height: 85,
            padding: const EdgeInsets.all(Dimens.px20),
            child: TextField(
              
              decoration: InputDecoration(
                 border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
                  width: 0, 
                  style: BorderStyle.none,
              ),
      ),
                filled:true,
                fillColor: Theme.of(context).indicatorColor,
                 prefixIcon: const Icon(Icons.search),
                iconColor: Color.fromRGBO(148, 135, 121,1),
                //fillColor: Color(0xe6ded6),
                //hintText: 'البحث عن سورة',
                hintText: hintText(),
                hintStyle: const TextStyle(
                color: Color.fromRGBO(148, 135, 121,1),
                  //color: Color.fromRGBO(230, 222, 214,1),
                
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: const TextStyle(
                color: Color.fromRGBO(148, 135, 121,1),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          buildListTile("آياتها : ٧ . مكية", "١", "الفاتحة", () {
            //Navigator.of(context).pushReplacementNamed('/');
          }),
          const Divider(),
          buildListTile("آياتها : ٧ . مكية", "٢", "البقرة", () {
            //Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
          }),
          const Divider(),
          buildListTile("آياتها : ٧ . مكية", "٣", "آل عمران", () {}),
          const Divider(),
          buildListTile("آياتها : ٧ . مكية", "٤", "النساء", () {}),
        ],
      ),
    );
  }
}
