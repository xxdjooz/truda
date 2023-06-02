import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../../truda_common/truda_colors.dart';

class TrudaVideoTestPage extends StatefulWidget {
  String url;
  Function(double)? callback;

  static void startMe(BuildContext context, {required String url}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TrudaVideoTestPage(
          url: url,
        ),
      ),
    );
  }

  TrudaVideoTestPage({
    Key? key,
    required this.url,
    this.callback,
  }) : super(key: key);

  @override
  _TrudaVideoTestPageState createState() => _TrudaVideoTestPageState();
}

class _TrudaVideoTestPageState extends State<TrudaVideoTestPage> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  late VoidCallback listener;
  bool hadNotifyFinish = false;

  @override
  void initState() {
    TrudaLog.debug('TrudaCachePage url=${widget.url}');

    listener = () {
      var value = _betterPlayerController.videoPlayerController!.value;
      double playedPartPercent =
          value.position.inMilliseconds / value.duration!.inMilliseconds;
      if (playedPartPercent.isNaN) {
        playedPartPercent = 0;
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
        //   return TrudaBetterPlayerMyControls(
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
    _betterPlayerController.setupDataSource(_betterPlayerDataSource).then((d) =>
        _betterPlayerController.videoPlayerController?.addListener(listener));
    _betterPlayerController.play();
  }

  void changeVideo() {
    var url =
        // 'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/resources/wang/20228291.mp4';
        'https://s3.sowotop.com/users/awss3/112646698/upload/media/video/2022_06_24_18_15_12/_1656074712164_compression.mp4';
    _betterPlayerController.pause();
    _betterPlayerController.videoPlayerController?.removeListener(listener);
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 100 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,

        ///Android only option to use cached video between app sessions
        key: url,
      ),
    );
    _betterPlayerController.setupDataSource(_betterPlayerDataSource).then((d) {
      _betterPlayerController.videoPlayerController?.addListener(listener);
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
    super.dispose();
    _betterPlayerController.videoPlayerController?.removeListener(listener);
    _betterPlayerController.dispose();
    TrudaLog.debug('TrudaCachePage dispose');
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
            if (_betterPlayerController.isPlaying() != true)
              Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  color: TrudaColors.white,
                  size: 100,
                ),
              ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: GestureDetector(
                onTap: changeVideo,
                child: Container(
                  color: Colors.white60,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(18.0),
                  child: Text('change video'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
