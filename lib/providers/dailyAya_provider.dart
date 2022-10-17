import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<dailyAya> getSinglePostData(context) async {
  late dailyAya result;
  try {
    final response = await http
        .get(Uri.parse('https://api.omanfont.om/'),headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = dailyAya.fromJson(item);
    } else {
      print("ERROR");
    }
  } catch (e) {
    log(e.toString());
  }
  return result;
}

class dailyAya {
  final int id;
  final String Aya;
  final String Surah;
  final String Tafsir;

  dailyAya({required this.id, required this.Aya, required this.Surah, required this.Tafsir});

  factory dailyAya.fromJson(Map<String, dynamic> json) {
    return dailyAya(
      id: json['id'],
      Aya: json['Aya'],
      Surah: json['Surah'] ?? "",
      Tafsir: json['Tafsir'] ?? "",
    );
  }
}

class dailyAyaProvider with ChangeNotifier {
  dailyAya post = dailyAya(id: 0, Aya: '', Surah: '', Tafsir: '');
  bool loading = false;

  getPostData(context) async {
    loading = true;
    post = await getSinglePostData(context);
    loading = false;
print(post.Aya);
    notifyListeners();
  }
}

  