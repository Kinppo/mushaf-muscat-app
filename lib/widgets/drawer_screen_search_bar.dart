import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../resources/colors.dart';

class drawerSearchBar extends StatefulWidget {
  Function searchController;



  drawerSearchBar({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  @override
  State<drawerSearchBar> createState() => _drawerSearchBarState();
}

class _drawerSearchBarState extends State<drawerSearchBar> {
    bool isStillSearching = false;
    bool firstFlag= false;
      
    final fieldText = TextEditingController();

 void clearText() {
    fieldText.clear();
    setState(() {
          isStillSearching=false;
           widget.searchController(isStillSearching, '');
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        setState(() {
          if (text!='' && firstFlag==false) {
          print("entered here");
                  firstFlag= true;
                  isStillSearching= true;
                            widget.searchController(isStillSearching, text);


          }

          else {
          // print(text);
        if (isStillSearching== false) {
            isStillSearching= true;
            // widget.searchController(isStillSearching, text);

        }

        else if (isStillSearching== true && text=='' ) {
          isStillSearching=false;
          //  widget.searchController(isStillSearching, text);
        }
         widget.searchController(isStillSearching, text);

          }

        });
        
   },
    onSubmitted: (text) {setState(() {
          if (text!='' && firstFlag==false) {
          print("entered here");
                  firstFlag= true;
                  isStillSearching= true;
                            widget.searchController(isStillSearching, text);


          }

          else {
          // print(text);
        if (isStillSearching== false) {
            isStillSearching= true;
            // widget.searchController(isStillSearching, text);

        }

        else if (isStillSearching== true && text=='' ) {
          isStillSearching=false;
          //  widget.searchController(isStillSearching, text);
        }
         widget.searchController(isStillSearching, text);

          }

        });},
        
   onEditingComplete: () {
     
   },

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
        prefixIcon: const Icon(Icons.search),
        iconColor: CustomColors.grey200,
        hintText:  AppLocalizations.of(context)!
                                .translate('drawer_screen_search_hint_surahs')
                                .toString(),
        hintStyle:  TextStyle(
          color: CustomColors.grey200,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ), 
          suffixIcon: isStillSearching==true ? IconButton(  color:CustomColors.grey200,     // Icon to 
                    icon: Icon(Icons.cancel), // clear text
                    onPressed: clearText,
                ) : null
      ),
      style: const TextStyle(
        color: Color.fromRGBO(148, 135, 121, 1),
      ),
              controller: fieldText,

    );
  }
}
