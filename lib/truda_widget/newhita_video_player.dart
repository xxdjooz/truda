import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../truda_pages/call/aic/newhita_aic_controller.dart';

class NewHitaVideoPlayer extends StatefulWidget {
  // String netUrl;
  // String imageUrl;
  VideoPlayerController controller;

  NewHitaVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  _NewHitaVideoPlayerState createState() => _NewHitaVideoPlayerState();
}

class _NewHitaVideoPlayerState extends State<NewHitaVideoPlayer> {
  late VideoPlayerController _controller;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var aicController = Get.find<NewHitaAicController>();
    return Material(
      elevation: 0,
      child: SizedBox.expand(
        child: (!aicController.playerInited)
            ? ColoredBox(color: Colors.black)
            : FittedBox(
                // 这个做了满屏处理
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
      ),
    );
  }
}
