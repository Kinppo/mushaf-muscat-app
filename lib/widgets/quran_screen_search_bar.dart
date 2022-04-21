import 'package:flutter/material.dart';
import 'package:mushafmuscat/resources/colors.dart';

class QuranSearchBar extends StatefulWidget {

   Function searchController;

QuranSearchBar({ Key? key,  required this.searchController}) : super(key: key);

  @override
  State<QuranSearchBar> createState() => QuranSearchBarState();

}

class QuranSearchBarState extends State<QuranSearchBar> {
  bool isStillSearching = false;


  @override
  Widget build(BuildContext context,) {
    return TextField(

      onChanged: (text) {
        setState(() {
          print(text);
        if (isStillSearching== false) {
            isStillSearching= true;
            widget.searchController(isStillSearching);

        }

        else if (isStillSearching== true && text=='' ) {
          isStillSearching=false;
           widget.searchController(isStillSearching);
        }

        });
        
   },

   onSubmitted: (text) {},
   onEditingComplete: () {},

      textAlign: TextAlign.right,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).indicatorColor,
        prefixIcon:  Icon(Icons.search ,color: CustomColors.grey200),
        iconColor: CustomColors.grey200,
        hintText:  "البحث",
        hintStyle:  TextStyle(
          color: CustomColors.grey200,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style:  TextStyle(
        color: CustomColors.grey200,
      ),
    );
  }

}


