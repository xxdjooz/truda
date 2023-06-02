import 'package:better_player/better_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_entities/truda_host_entity.dart';
import '../../truda_routes/newhita_pages.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_widget/newhita_net_image.dart';

class TrudaFullscreenSliderDemo extends StatefulWidget {
  List<TrudaHostMedia> list;
  int position;

  TrudaFullscreenSliderDemo({
    Key? key,
    required this.list,
    required this.position,
  }) : super(key: key);

  @override
  State<TrudaFullscreenSliderDemo> createState() =>
      _TrudaFullscreenSliderDemoState();
}

class _TrudaFullscreenSliderDemoState
    extends State<TrudaFullscreenSliderDemo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    _current = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: TrudaColors.baseColorBlackBg,
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final double height = MediaQuery.of(context).size.height;
                return CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    initialPage: widget.position,
                    height: height,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: widget.list.length > 2,
                    // autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: widget.list
                      .map((item) => Container(
                            child: Center(
                                child: TrudaMediaViewPage2(
                              path: item.path ?? '',
                              cover: item.cover,
                              type: item.type ?? 0,
                              heroId: item.mid ?? 0,
                              noAppBar: true,
                            )),
                          ))
                      .toList(),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.list.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: _current == entry.key ? 12.0 : 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white12
                              : Colors.white70)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TrudaMediaViewPage2 extends StatefulWidget {
  String path;
  String? cover;
  int type;
  int heroId;
  bool noAppBar;

  TrudaMediaViewPage2({
    Key? key,
    required this.path,
    this.cover,
    this.noAppBar = false,
    this.type = 0,
    this.heroId = 0,
  }) : super(key: key);

  @override
  State<TrudaMediaViewPage2> createState() => _TrudaMediaViewPage2State();

  static void startMe(BuildContext context,
      {required int heroId, required String path, String? cover, int? type}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TrudaMediaViewPage2(
          path: path,
          cover: cover,
          heroId: heroId,
          type: type ?? 0,
        ),
      ),
    );
  }
}

class _TrudaMediaViewPage2State extends State<TrudaMediaViewPage2>
    with WidgetsBindingObserver, RouteAware {
  bool playing = false;
  bool pause = false;

  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  late VoidCallback listener;

  void playIt() {
    _betterPlayerController.play();
    setState(() {
      playing = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // 注册应用生命周期监听
    WidgetsBinding.instance?.addObserver(this);
    Wakelock.enable();

    listener = () {
      var value = _betterPlayerController.videoPlayerController!.value;
      double playedPartPercent =
          value.position.inMilliseconds / value.duration!.inMilliseconds;
      if (playedPartPercent.isNaN) {
        playedPartPercent = 0;
      }
      // widget.callback?.call(playedPartPercent);
      // var finish = isVideoFinished(value);
      // if (finish && !hadNotifyFinish) {
      //   widget.callback?.call(2.0);
      //   hadNotifyFinish = true;
      // } else {
      //   widget.callback?.call(playedPartPercent);
      // }
    };

    // sub = widget.streamController.stream.listen((event) {
    //   if (event == 0) {
    //     _betterPlayerController.videoPlayerController?.pause();
    //   }
    // });
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
      aspectRatio: 9 / 16,
      fit: BoxFit.contain,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.path,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 100 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,

        ///Android only option to use cached video between app sessions
        key: widget.path,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册页面路由监听
    NewHitaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.noAppBar
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              title: Text(''),
              elevation: 0,
            ),
      extendBodyBehindAppBar: true,
      backgroundColor: TrudaColors.textColor333,
      body: playing
          ? GestureDetector(
              onTap: () {
                setState(() {
                  if (pause) {
                    pause = false;
                    _betterPlayerController.play();
                  } else {
                    pause = true;
                    _betterPlayerController.pause();
                  }
                });
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // Center(
                  //   child: AspectRatio(
                  //     aspectRatio: _betterPlayerController
                  //         .videoPlayerController!.value.aspectRatio,
                  //     child: BetterPlayer(controller: _betterPlayerController),
                  //   ),
                  // ),
                  // LayoutBuilder(builder: (context, cons) {
                  //   var w = cons.maxWidth;
                  //   var h = cons.maxHeight;
                  //   w = w - w % 32;
                  //   return Container(
                  //     alignment: AlignmentDirectional.center,
                  //     child: SizedBox(
                  //       width: w,
                  //       height: h,
                  //       child: BetterPlayer(
                  //         controller: _betterPlayerController,
                  //       ),
                  //     ),
                  //   );
                  // }),
                  BetterPlayer(
                    controller: _betterPlayerController,
                  ),
                  if (pause)
                    Center(
                      child: Icon(
                        Icons.play_circle_outline_rounded,
                        color: TrudaColors.white,
                        size: 100,
                      ),
                    ),
                ],
              ),
            )
          : Hero(
              tag: widget.heroId,
              child: SizedBox.expand(
                child: widget.type == 0
                    ? NewHitaNetImage(
                        widget.path,
                        fit: BoxFit.contain,
                      )
                    : GestureDetector(
                        onTap: playIt,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: NewHitaNetImage(widget.cover ?? ''),
                            ),
                            const Icon(
                              Icons.play_circle_outline_rounded,
                              color: TrudaColors.white,
                              size: 100,
                            )
                          ],
                        ),
                      ),
              ),
            ),
    );
  }

  /// 监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(':didChangeAppLifecycleState:$state');
    switch (state) {
      // 处于这种状态的应用程序应该假设他们可能在任何时候暂停
      case AppLifecycleState.inactive:
        break;
      // 从后台切前台，界面可见
      case AppLifecycleState.resumed:
        break;
      // 界面不可见，后台
      case AppLifecycleState.paused:
        if (playing) _betterPlayerController.pause();
        break;
      // APP 结束时调用
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    NewHitaLog.debug('LindaMediaViewPage didPopNext');
  }

  @override
  void didPush() {
    super.didPush();
    NewHitaLog.debug('LindaMediaViewPage didPush');
  }

  @override
  void didPushNext() {
    super.didPushNext();
    NewHitaLog.debug('LindaMediaViewPage didPushNext');
    if (playing) _betterPlayerController.pause();
  }

  @override
  void dispose() {
    super.dispose();
    // if (playing) {
    //   player.stop();
    //   player.release();
    // }
    _betterPlayerController.dispose();
    // 移除生命周期监听
    WidgetsBinding.instance?.removeObserver(this);

    // 移除页面路由监听
    NewHitaAppPages.observer.unsubscribe(this);
    Wakelock.disable();
  }
}
