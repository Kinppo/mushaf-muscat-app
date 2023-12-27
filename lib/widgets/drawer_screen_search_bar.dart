import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../resources/colors.dart';

class DrawerSearchBar extends StatefulWidget {
  final searchController;

  const DrawerSearchBar({
    super.key,
    required this.searchController,
  });

  @override
  State<DrawerSearchBar> createState() => _DrawerSearchBarState();
}

class _DrawerSearchBarState extends State<DrawerSearchBar> {
  bool isStillSearching = false;
  bool firstFlag = false;

  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
    setState(() {
      isStillSearching = false;
      widget.searchController(isStillSearching, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        setState(() {
          if (text != '' && firstFlag == false) {
            firstFlag = true;
            isStillSearching = true;
            widget.searchController(isStillSearching, text);
          } else {
            if (isStillSearching == false) {
              isStillSearching = true;
            } else if (isStillSearching == true && text == '') {
              isStillSearching = false;
            }
            widget.searchController(isStillSearching, text);
          }
        });
      },
      onSubmitted: (text) {
        setState(() {
          if (text != '' && firstFlag == false) {
            firstFlag = true;
            isStillSearching = true;
            widget.searchController(isStillSearching, text);
          } else {
            if (isStillSearching == false) {
              isStillSearching = true;
            } else if (isStillSearching == true && text == '') {
              isStillSearching = false;
            }
            widget.searchController(isStillSearching, text);
          }
        });
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
          prefixIcon: const Icon(Icons.search),
          iconColor: CustomColors.grey200,
          hintText: AppLocalizations.of(context)!
              .translate('drawer_screen_search_hint_surahs')
              .toString(),
          hintStyle: TextStyle(
            color: CustomColors.grey200,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: isStillSearching == true
              ? IconButton(
                  color: CustomColors.grey200,
                  icon: const Icon(Icons.cancel),
                  onPressed: clearText,
                )
              : null),
      style: const TextStyle(
        color: Color.fromRGBO(148, 135, 121, 1),
      ),
      controller: fieldText,
    );
  }
}
