import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  PlayerState audioPlayerState = PlayerState.stopped;
  int timeProgress = 0;
  int audioDuration = 0;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  void playPauseMusic() async {
    if (audioPlayerState == PlayerState.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            iconSize: 30,
            onPressed: playPauseMusic,
            icon: Icon(audioPlayerState == PlayerState.playing
                ? Icons.pause
                : Icons.play_arrow),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(getTimeString(timeProgress)),
              SizedBox(width: 20),
              Expanded(flex: 8, child: Container(child: slider())),
              SizedBox(width: 20),
              Text(getTimeString(audioDuration)),
            ],
          ),
        )
      ],
    );
  }

  Widget slider() {
    return Container(
      child: timeProgress != 0 || audioDuration != 0
          ? Slider.adaptive(
              value: timeProgress.toDouble(),
              max: audioDuration.toDouble(),
              onChanged: (value) {
                seekToSec(value.toInt());
              })
          : Slider.adaptive(
              value: 1,
              max: 1,
              onChanged: (value) {
                seekToSec(value.toInt());
              }),
    );
  }
}
