// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';

// class SurahList extends StatefulWidget {


//   @override
//   State<SurahList> createState() => _SurahListState();
  
// }


// class _SurahListState extends State<SurahList> {
//  List _items = [];
 



//   // Future<void> readJson() async {
//   @override
 
//   Widget build(BuildContext context) {
//   //  _items = [
//   //     {},{},{}
//   //   ]
//     return Expanded(
//                   child: ListView.builder(
//                     itemCount: _items.length,
//                     itemBuilder: (context, index) {
//                       return Card(
          
//                         child: ListTile(
//                           leading: Text(_items[index]["name"]),
//                           title: Text(_items[index]["type"]),
//                           subtitle: Text(_items[index]["total_verses"]),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//   }
// }