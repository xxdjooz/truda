import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../../truda_common/truda_colors.dart';

class NewHitaCachePage extends StatefulWidget {
  String url;
  Function(double)? callback;
  final StreamController<int> streamController;

  NewHitaCachePage({
    Key? key,
    required this.url,
    required this.streamController,
    this.callback,
  }) : super(key: key);

  @override
  _NewHitaCachePageState createState() => _NewHitaCachePageState();
}

class _NewHitaCachePageState extends State<NewHitaCachePage> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  late VoidCallback listener;
  late final StreamSubscription<int> sub;
  bool hadNotifyFinish = false;
  bool shouldNotAutoPlay = false;
  bool showPic = true;
  @override
  void initState() {
    NewHitaLog.debug('NewHitaCachePage url=${widget.url}');

    listener = () {
      var value = _betterPlayerController.videoPlayerController!.value;
      double playedPartPercent =
          value.position.inMilliseconds / value.duration!.inMilliseconds;
      if (playedPartPercent.isNaN) {
        playedPartPercent = 0;
      }
      if (showPic && value.position.inMicroseconds > 0) {
        setState(() {
          showPic = false;
        });
      }
      widget.callback?.call(playedPartPercent);
      var finish = isVideoFinished(value);
      if (finish && !hadNotifyFinish) {
        widget.callback?.call(2.0);
        hadNotifyFinish = true;
      } else {
        widget.callback?.call(playedPartPercent);
      }
    };

    sub = widget.streamController.stream.listen((event) {
      if (event == 0) {
        _betterPlayerController.videoPlayerController?.pause();
        shouldNotAutoPlay = true;
      }
    });
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableMute: false,
        enableAudioTracks: false,
        enableFullscreen: false,
        enableOverflowMenu: false,
        enableSubtitles: false,
        enableQualities: false,
        enablePip: false,
        enablePlaybackSpeed: false,
        enablePlayPause: false,
        enableRetry: false,
        enableSkips: false,
        enableProgressBar: false,
        enableProgressBarDrag: false,
        enableProgressText: false,
        playerTheme: BetterPlayerTheme.custom,
        controlBarColor: Colors.transparent,
        showControlsOnInitialize: false,
        // customControlsBuilder: (controller, callBack) {
        //   return NewHitaBetterPlayerMyControls(
        //     controlsConfiguration: controller.betterPlayerControlsConfiguration,
        //     onControlsVisibilityChanged: callBack,
        //   );
        // },
      ),
      aspectRatio: Get.width / Get.height,
      fit: BoxFit.contain,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 100 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,

        ///Android only option to use cached video between app sessions
        key: widget.url,
      ),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setControlsAlwaysVisible(true);
    _betterPlayerController.setControlsEnabled(true);
    super.initState();
    _betterPlayerController.setupDataSource(_betterPlayerDataSource).then((d) {
      if (!mounted) return;
      _betterPlayerController.videoPlayerController?.addListener(listener);
      if (shouldNotAutoPlay) return;
      _betterPlayerController.play();
    });
  }

  bool isVideoFinished(VideoPlayerValue? videoPlayerValue) {
    return videoPlayerValue?.position != null &&
        videoPlayerValue?.duration != null &&
        videoPlayerValue!.position.inMilliseconds != 0 &&
        videoPlayerValue.duration!.inMilliseconds != 0 &&
        videoPlayerValue.position >= videoPlayerValue.duration!;
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
    _betterPlayerController.videoPlayerController?.removeListener(listener);
    _betterPlayerController.dispose();
    NewHitaLog.debug('NewHitaCachePage dispose');
  }

  // _betterPlayerController.preCache(_betterPlayerDataSource);
  // _betterPlayerController.stopPreCache(_betterPlayerDataSource);
  // _betterPlayerController.clearCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          setState(() {
            if (_betterPlayerController.isPlaying() != true) {
              if (isVideoFinished(
                  _betterPlayerController.videoPlayerController?.value)) {
                _betterPlayerController
                    .seekTo(Duration.zero)
                    .then((value) => _betterPlayerController.play());
              } else {
                _betterPlayerController.play();
              }
            } else {
              _betterPlayerController.pause();
            }
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            BetterPlayer(controller: _betterPlayerController),
            if (showPic) CircularProgressIndicator(),
            if (_betterPlayerController.isVideoInitialized() == true &&
                _betterPlayerController.isPlaying() != true)
              Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  color: TrudaColors.white,
                  size: 100,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
