import 'package:flutter/material.dart';
import 'package:flutter_vap2/vap_view.dart';
import 'package:truda/truda_widget/newhita_cache_manager.dart';

import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_utils/newhita_queue_util.dart';
import 'newhita_gift_animate.dart';

class NewHitaVapPlayer extends StatefulWidget {
  late NewHitaVapController vapController;

  NewHitaVapPlayer({Key? key, required this.vapController}) : super(key: key);

  @override
  _NewHitaVapPlayerState createState() => _NewHitaVapPlayerState();
}

class NewHitaVapController {
  _NewHitaVapPlayerState? state;

  void playGift(TrudaGiftEntity gift) {
    NewHitaLog.debug('NewHitaVapPlayer addGift ${gift.animEffectUrl}');
    if (state == null) return;
    state?.showPush(gift);
    if (gift.animEffectUrl == null || gift.animEffectUrl!.isEmpty) return;
    NewHitaGiftCacheManager.instance
        .getSingleFile(gift.animEffectUrl ?? '')
        .then((value) {
      NewHitaLog.debug('NewHitaVapPlayer getSingleFile ${value.path}');
      NewHitaQueueUtil.get("vapQueue")?.addTask(() async {
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
    NewHitaQueueUtil.get("vapQueue")?.cancelTask();
  }
}

class _NewHitaVapPlayerState extends State<NewHitaVapPlayer> {
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
    NewHitaLog.debug('NewHitaVapPlayer play = ${playing}');
    setState(() {
      this.playing = playing;
    });
  }

  Future playPath(String path) async {
    NewHitaLog.debug('NewHitaVapPlayer playPath = ${path}');
    setState(() {
      playing = true;
    });
    // await vapViewController.playPath(path);
    setState(() {
      playing = false;
    });
  }

  Future playPath2(String path) async {
    NewHitaLog.debug('NewHitaVapPlayer playPath = ${path}');
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
    NewHitaGiftPusher.add(giftBannerView, obj, 6500, (giftBannerViewNew) {
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
                  child: NewHitaVapView(
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

class NewHitaVapView extends StatefulWidget {
  final String path;
  VoidCallback? vapPlayCompleteCallBack;

  NewHitaVapView({Key? key, required this.path, this.vapPlayCompleteCallBack})
      : super(key: key);

  @override
  _NewHitaVapViewState createState() => _NewHitaVapViewState();
}

class _NewHitaVapViewState extends State<NewHitaVapView> {
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
