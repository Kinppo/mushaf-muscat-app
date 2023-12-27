import 'dart:convert';
import 'dart:core';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioPlayerProvider with ChangeNotifier {
  final assetsAudioPlayer = AssetsAudioPlayer();
  List<String> audioPaths = [];
  List<Audio> audios = [];
  List<String> flagsAudio = [];
  List<String> startFlagAudio = [];

  int activeAya = 0;
  bool callListener = false;
  List<Audio> audioList = [];

  bool checkifsent = false;
  late int current;

  List<Audio> get audiosList {
    return [...audioList];
  }

  Future<List<Audio>> getAudioPaths(int currentPage) async {
    flagsAudio.clear();
    startFlagAudio.clear();
    final List<String> paths = [];
    List<Audio> aud = [];

    String audioData = await rootBundle.loadString(
        'lib/data/json_files/audio_page/quran_audio_$currentPage.json');
    var jsonAudioResult = jsonDecode(audioData);

    for (int index = 0; index < jsonAudioResult.length; index++) {
      paths.add(jsonAudioResult[index]['audio']);
      flagsAudio.add(jsonAudioResult[index]['EndOfSurah']);
      startFlagAudio.add(jsonAudioResult[index]['StartOfSurah']);
    }

    for (var item in paths) {
      aud.add(Audio.network(item));
    }
    notifyListeners();
    return aud;
  }
}
