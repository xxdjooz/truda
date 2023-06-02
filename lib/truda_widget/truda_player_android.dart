import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../truda_utils/truda_log.dart';
import 'truda_net_image.dart';

// ignore: must_be_immutable
class TrudaPlayerAndroid extends StatefulWidget {
  String? cover;
  String? path;
  Stream? stream;

  TrudaPlayerAndroid({
    Key? key,
    this.cover,
    this.path,
    this.stream,
  }) : super(key: key);

  @override
  _TrudaPlayerAndroidState createState() => _TrudaPlayerAndroidState();
}

class _TrudaPlayerAndroidState extends State<TrudaPlayerAndroid> {
  bool playing = false;
  bool pause = false;
  late VideoPlayerController _controller;

  void playIt() {
    _controller.play();
    setState(() {
      playing = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.path!,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    widget.stream?.listen((event) {
      _controller.pause();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TrudaLog.debug("${context.widget.runtimeType} build");

    return playing
        ? GestureDetector(
            onTap: () {
              setState(() {
                if (pause) {
                  pause = false;
                  _controller.play();
                } else {
                  pause = true;
                  _controller.pause();
                }
              });
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                if (pause)
                  Center(
                    child: Icon(
                      Icons.play_circle_outline_rounded,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          )
        : SizedBox.expand(
            child: GestureDetector(
              onTap: playIt,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: TrudaNetImage(widget.cover ?? ''),
                  ),
                  const Icon(
                    Icons.play_circle_outline_rounded,
                    color: Colors.white,
                    size: 100,
                  )
                ],
              ),
            ),
          );
  }
}
