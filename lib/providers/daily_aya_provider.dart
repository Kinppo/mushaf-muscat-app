import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('api.omanfont.om');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

Future<DailyAya> getSinglePostData(context) async {
  late DailyAya result;

  try {
    final response =
        await http.get(Uri.parse('https://api.omanfont.om/'), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = DailyAya.fromJson(item);
    }
  } catch (e) {
    log(e.toString());
  }
  return result;
}

class DailyAya {
  final int id;
  final String aya;
  final String surah;
  final String tafsir;

  DailyAya(
      {required this.id,
      required this.aya,
      required this.surah,
      required this.tafsir});

  factory DailyAya.fromJson(Map<String, dynamic> json) {
    return DailyAya(
      id: json['id'],
      aya: json['Aya'],
      surah: json['Surah'] ?? "",
      tafsir: json['Tafsir'] ?? "",
    );
  }
}

class DailyAyaProvider with ChangeNotifier {
  late DailyAya post;
  bool loading = false;

  getPostData(context) async {
    final bool checkInternet = await hasNetwork();
    if (checkInternet == true) {
      post = await getSinglePostData(context);
    }
    notifyListeners();
  }
}
