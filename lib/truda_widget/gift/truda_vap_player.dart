import 'package:flutter/material.dart';
import 'package:flutter_vap2/vap_view.dart';
import 'package:truda/truda_widget/truda_cache_manager.dart';

import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_utils/truda_log.dart';
import '../../truda_utils/truda_queue_util.dart';
import 'truda_gift_animate.dart';

class TrudaVapPlayer extends StatefulWidget {
  late TrudaVapController vapController;

  TrudaVapPlayer({Key? key, required this.vapController}) : super(key: key);

  @override
  _TrudaVapPlayerState createState() => _TrudaVapPlayerState();
}

class TrudaVapController {
  _TrudaVapPlayerState? state;

  void playGift(TrudaGiftEntity gift) {
    TrudaLog.debug('NewHitaVapPlayer addGift ${gift.animEffectUrl}');
    if (state == null) return;
    state?.showPush(gift);
    if (gift.animEffectUrl == null || gift.animEffectUrl!.isEmpty) return;
    TrudaGiftCacheManager.instance
        .getSingleFile(gift.animEffectUrl ?? '')
        .then((value) {
      TrudaLog.debug('NewHitaVapPlayer getSingleFile ${value.path}');
      TrudaQueueUtil.get("vapQueue")?.addTask(() async {
        // if (state != null) {
        //   state?.play(true);
        //   await state?.vapViewController.playAsset(value.path);
        //   state?.play(false);
        // }
        await state?.playPath2(value.path);
      });
    });
  }

  void stop() {
    TrudaQueueUtil.get("vapQueue")?.cancelTask();
  }
}

class _TrudaVapPlayerState extends State<TrudaVapPlayer> {
  bool playing = false;
  List<Map> giftBannerView = []; // 礼物横幅列表JSON
  // late VapViewController vapViewController;
  String path = '';

  @override
  void initState() {
    super.initState();
    widget.vapController.state = this;
  }

  void play(bool playing) {
    TrudaLog.debug('NewHitaVapPlayer play = ${playing}');
    setState(() {
      this.playing = playing;
    });
  }

  Future playPath(String path) async {
    TrudaLog.debug('NewHitaVapPlayer playPath = ${path}');
    setState(() {
      playing = true;
    });
    // await vapViewController.playPath(path);
    setState(() {
      playing = false;
    });
  }

  Future playPath2(String path) async {
    TrudaLog.debug('NewHitaVapPlayer playPath = ${path}');
    setState(() {
      playing = true;
      this.path = path;
    });
    // await vapViewController.playPath(path);
    // setState(() {
    //   playing = false;
    // });
  }

  void showPush(TrudaGiftEntity gift) {
    var now = DateTime.now();
    var obj = {'stamp': now.millisecondsSinceEpoch, 'config': gift};
    TrudaGiftPusher.add(giftBannerView, obj, 6500, (giftBannerViewNew) {
      if (mounted) {
        setState(() {
          giftBannerView = giftBannerViewNew;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.vapController.state = null;
    widget.vapController.stop();
  }

  @override
  Widget build(BuildContext context) {
    // 这样目的是不动画时隐藏，防止出现意外遮挡
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: !playing
              ? const SizedBox()
              : IgnorePointer(
                  child: TrudaVapView(
                      path: path,
                      vapPlayCompleteCallBack: () {
                        setState(() {
                          playing = false;
                          path = '';
                        });
                      }),
                ),
        ),
        ..._setGiftBannerView(),
      ],
    );
  }

  List<Widget> _setGiftBannerView() {
    List<Widget> banner = [];
    for (var item in giftBannerView) {
      banner.add(item['widget']);
    }
    return banner;
  }
}

class TrudaVapView extends StatefulWidget {
  final String path;
  VoidCallback? vapPlayCompleteCallBack;

  TrudaVapView({Key? key, required this.path, this.vapPlayCompleteCallBack})
      : super(key: key);

  @override
  _TrudaVapViewState createState() => _TrudaVapViewState();
}

class _TrudaVapViewState extends State<TrudaVapView> {
  @override
  void initState() {
    super.initState();
  }

  playVap(VapViewController vapViewController) async {
    Future.delayed(Duration(milliseconds: 100), () async {
      var res = await vapViewController.playPath(widget.path);
      widget.vapPlayCompleteCallBack?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return VapView(
      scaleType: 2,
      onVapViewCreated: (controller) {
        playVap(controller);
      },
    );
  }
}
