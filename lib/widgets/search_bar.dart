import 'package:flutter/material.dart';

class searchBar extends StatelessWidget {
  String hint;

  searchBar({
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
        iconColor: const Color.fromRGBO(148, 135, 121, 1),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(148, 135, 121, 1),
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
