import 'package:flutter/material.dart';

class QuartersList extends StatelessWidget {
  String num;
  String aya;
  String surah;
  String juzz;
  String quarterAya;
  String quarterPage;
  bool beginningIndex;


QuartersList({Key? key, required this.beginningIndex,required this.num,required this.aya, required this.surah, required this.juzz,required this. quarterAya, required this.quarterPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Column(


      children:[
      if (beginningIndex) ...[
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
                    num,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  radius: 20,
                  backgroundColor: Theme.of(context).shadowColor,
                ),
                title: Text(
                  aya,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: const Color.fromRGBO(36, 28, 21,1),
                      fontWeight: FontWeight.normal,
                      fontSize: 22),
                ),
                subtitle: Text("$surah $quarterAya  .  الصفحة $quarterPage ",
                    style:
                        const TextStyle(color: Color.fromRGBO(148, 135, 121, 1.0))),
                onTap: () {}),
      ],         
      
    );
  }
}