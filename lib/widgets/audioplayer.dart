import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mushafmuscat/resources/colors.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool firstFlag = false;
  bool showPauseIcon = false;
  late Duration abc;
  List<Audio> audios = [];

  @override
  initState() {
    for (int i = 1; i <= 7; i++) {
      audios.add(Audio("assets/audios/1/00100$i.mp3"));
    }
    // audios[0].networkHeaders.
    abc = Duration(
        hours: 00, minutes: 00, seconds: 4, milliseconds: 0, microseconds: 0);

    super.initState();
    //initializeDuration();
  }

  void deactivate() {
    super.deactivate();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        border: Border.all(color: CustomColors.brown700, width: 1),
      ),
      width: 650,
      height: 70,
      //  padding: EdgeInsets.all(5),
      //  margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              iconSize: 30,
              icon: SvgPicture.asset("assets/images/Settings.svg",
                  width: 30, height: 30, fit: BoxFit.fitWidth),
              //seek forward
              onPressed: () {}),
          SizedBox(
            width: 30,
          ),
          IconButton(
              iconSize: 40,
              icon: SvgPicture.asset("assets/images/Seek_right.svg",
                  width: 40, height: 40, fit: BoxFit.fitWidth),
              //seek forward
              onPressed: () {
                print("abc before $abc");
                // assetsAudioPlayer.seekBy(abc);
                assetsAudioPlayer.next();

                abc = assetsAudioPlayer.current.value!.audio.duration;
                print("abc after $abc");
              }),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            backgroundColor: CustomColors.grey200,
            maxRadius: 20,
            child: IconButton(
              icon: Icon(
                showPauseIcon ? Icons.pause : Icons.play_arrow,
                color: CustomColors.yellow100,
              ),
              iconSize: 20,
              onPressed: () {
                if (firstFlag == false) {
                  setState(() {
                    showPauseIcon = true;
                  });

                  assetsAudioPlayer.open(Playlist(audios: audios),
                      loopMode: LoopMode.playlist);
                  firstFlag = true;
                }
                //plays from paused position
                else {
                  setState(() {
                    showPauseIcon = !showPauseIcon;
                    abc = assetsAudioPlayer.current.value!.audio.duration;
                  });
                  assetsAudioPlayer.playOrPause();
                }
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              iconSize: 40,
              icon: SvgPicture.asset("assets/images/Seek_left.svg",
                  width: 40, height: 40, fit: BoxFit.fitWidth),
              //seek forward
              onPressed: () {
                // initializeDuration();
                assetsAudioPlayer.previous();
                // assetsAudioPlayer.play(n);

                abc = assetsAudioPlayer.current.value!.audio.duration;
              }),
          SizedBox(
            width: 80,
          ),
        ],
      ),
    );
  }
}
