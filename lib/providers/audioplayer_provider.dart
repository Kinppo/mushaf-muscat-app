import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mushafmuscat/models/AyatLines.dart';

import '../utils/helperFunctions.dart';

class AudioPlayer_Provider with ChangeNotifier {
  final assetsAudioPlayer = AssetsAudioPlayer();
  List<String> audioPaths = [];
  List<Audio> audios = [];
  List<String> FlagsAudio = [];
  int ActiveAya = 0;
  bool callListener = false;
  List<Audio> audioList = [];
  //  List<Audio> aud = [];

  bool checkifsent = false;
  late int current;

  List<Audio> get audiosList {
    print(audioList);
    return [...audioList];
  }

  Future<List<Audio>> getAudioPaths(int currentPage) async {
    FlagsAudio.clear();
    // audioList.clear();
    // if (checkifsent==true){
    //   aud.clear();
    //       FlagsAudio.clear();

    //   checkifsent=false;
    //   notifyListeners();
    // }
    print("ENTERED PROVIDER $currentPage");
    print("we are here 1 current page is $currentPage");
    final List<String> paths = [];
    List<Audio> aud = [];

    String AudioData = await rootBundle.loadString(
        'lib/data/json_files/audio_page/quran_audio_$currentPage.json');
    var jsonAudioResult = jsonDecode(AudioData);

    // audioPaths.forEach((item) {
    //   audios.add(Audio.network(item));
    // });

    for (int index = 0; index < jsonAudioResult.length; index++) {
      paths.add(jsonAudioResult[index]['audio']);
      FlagsAudio.add(jsonAudioResult[index]['EndOfSurah']);
    }
    // audioPaths = paths;
    paths.forEach((item) {
      aud.add(Audio.network(item));
    });
// print (aud);
    notifyListeners();
    return aud;
// checkifsent=true;
  }
}
