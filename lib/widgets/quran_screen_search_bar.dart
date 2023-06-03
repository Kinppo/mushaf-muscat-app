import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mushafmuscat/resources/colors.dart';
import '../localization/app_localizations.dart';

class QuranSearchBar extends StatefulWidget {
  final Function searchController;

  QuranSearchBar({Key? key, required this.searchController}) : super(key: key);

  @override
  State<QuranSearchBar> createState() => QuranSearchBarState();
}

class QuranSearchBarState extends State<QuranSearchBar> {
  bool isStillSearching = false;
  bool firstFlag = false;
  Timer? searchOnStoppedTyping;

  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  void _onChangeHandler(String text) {
    if (searchOnStoppedTyping != null) {
      setState(() {
        if (isStillSearching == false) {
          isStillSearching = true;
        } else if (isStillSearching == true && text == '') {
          isStillSearching = false;
        }
      });
      searchOnStoppedTyping!.cancel();
    }
    searchOnStoppedTyping = Timer(Duration(milliseconds: 700), () {
      widget.searchController(isStillSearching, text);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextField(
      onChanged: _onChangeHandler,
      onSubmitted: (text) {
  setState(() {
    if (text != '' && firstFlag == false) {
      firstFlag = true;
      isStillSearching = true;
    } else {
      if (isStillSearching == false) {
        isStillSearching = true;
      } else if (isStillSearching == true && text == '') {
        isStillSearching = false;
      }
    }
    widget.searchController(isStillSearching, text);
  });
  FocusScope.of(context).unfocus();
},
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
          prefixIcon: Icon(Icons.search, color: CustomColors.grey200),
          iconColor: CustomColors.grey200,
          hintText: AppLocalizations.of(context)!
              .translate('search_screen_search')
              .toString(),
          hintStyle: TextStyle(
            color: CustomColors.grey200,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: isStillSearching == true
              ? IconButton(
                  color: CustomColors.grey200, 
                  icon: Icon(Icons.cancel), 
                  onPressed: clearText,
                )
              : null),
      style: TextStyle(
        color: CustomColors.grey200,
      ),
      controller: fieldText,
    );
  }
}
