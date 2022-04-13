import 'package:flutter/material.dart';

class QuartersList extends StatelessWidget {
      bool startingJuzzIndex;
      bool startingHizbIndex;
      int quarter;
      String hizbNum;
      String surahTitle;
      String startingAya;
      String juzz;
      String quarterAyaNum;
      String quarterPageNum;

QuartersList({Key? key, required this.startingJuzzIndex,required this.startingHizbIndex,required this.quarter,
required this.hizbNum, required this.surahTitle,required this. startingAya, required this.juzz,
required this.quarterAyaNum,
required this.quarterPageNum,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Column(


      children:[
      if (startingJuzzIndex) ...[
          Container
      (alignment: Alignment.topRight,
      padding: const EdgeInsets.fromLTRB(15, 15, 21, 15),
        child: Text("الجزء $juzz", style: Theme.of(context).textTheme.headline1?.copyWith(
          color:const Color.fromRGBO(36, 28, 21,1),
                      fontWeight: FontWeight.w500,
                      fontSize: 23),
                      ),
          
                 ),
       ],
        

   
         ListTile(
                leading: CircleAvatar(
                  child: Text(
                    hizbNum,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  radius: 20,
                  backgroundColor: Theme.of(context).shadowColor,
                ),
                title: Text(
                  startingAya,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: const Color.fromRGBO(36, 28, 21,1),
                      fontWeight: FontWeight.normal,
                      fontSize: 22),
                ),
                subtitle: Text("$surahTitle $quarterAyaNum  .  الصفحة $quarterPageNum ",
                    style:
                        const TextStyle(color: Color.fromRGBO(148, 135, 121, 1.0))),
                onTap: () {}),
      ],         
      
    );
  }
}