import 'package:flutter/material.dart';

import '../resources/colors.dart';

class drawerSearchBar extends StatelessWidget {
  String hint;


  drawerSearchBar({
     Key? key,
    required this.hint,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
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
        hintText: hint,
        hintStyle:  TextStyle(
          color: CustomColors.grey200,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: const TextStyle(
        color: Color.fromRGBO(148, 135, 121, 1),
      ),
    );
  }
}
