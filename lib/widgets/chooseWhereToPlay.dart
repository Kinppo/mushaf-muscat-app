import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../resources/colors.dart';

class whereToPlay extends StatefulWidget {
  const whereToPlay({Key? key}) : super(key: key);

  @override
  State<whereToPlay> createState() => _whereToPlayState();
}

var items = [
  'Item 1',
  'Item 2',
  'Item 3',
  'Item 4',
  'Item 5',
];
String dropdownvalue = 'Item 1';

class _whereToPlayState extends State<whereToPlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 480,
      color: Colors.white,
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                color: CustomColors.yellow100,
                padding: EdgeInsets.all(20),
                child: Text(
                  "خيارات التلاوة",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(17),
              child: Text(
                "تحديد البدء و الانتهاء",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "من",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "إلى",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getDropDown(),
            getDropDown(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getDropDown(),
            getDropDown(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              child: Text(
                "التكرار",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("التكرار للآية",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            getDropDown(),
          ],
        ),
        SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
  onPressed: () {},
  child: Container(width:110, height: 25,
  child: Text('تشغيل',textAlign: TextAlign.center, 
   style: TextStyle(color: CustomColors.black200, fontSize: 17),)),
 style: ButtonStyle(
  backgroundColor:MaterialStateProperty.all<Color>(CustomColors.yellow100),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: Color.fromARGB(255, 87, 60, 50),width:0.5)
    )
  )
)
)
          
        ]),
      ]),
    );
  }

  DropdownButton getDropDown() {
    return DropdownButton(
      // Initial Value
      value: dropdownvalue,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
      // After selecting the desired option,it will
      // change button value to selected value
    );
  }
}
