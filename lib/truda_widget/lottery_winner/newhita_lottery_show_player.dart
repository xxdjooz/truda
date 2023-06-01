import 'package:flutter/material.dart';
import 'package:truda/truda_entities/truda_lottery_user_entity.dart';

import 'newhita_lottery_animate.dart';

class NewHitaLotteryWinnerPlayer extends StatefulWidget {
  late NewHitaLotteryWinnerController vapController;

  NewHitaLotteryWinnerPlayer({Key? key, required this.vapController})
      : super(key: key);

  @override
  _NewHitaLotteryWinnerPlayerState createState() =>
      _NewHitaLotteryWinnerPlayerState();
}

class NewHitaLotteryWinnerController {
  _NewHitaLotteryWinnerPlayerState? state;

  void showOne(TrudaLotteryUser gift) {
    if (state == null) return;
    state?.showPush(gift);
  }
}

class _NewHitaLotteryWinnerPlayerState extends State<NewHitaLotteryWinnerPlayer> {
  List<Map> giftBannerView = []; // 礼物横幅列表JSON

  @override
  void initState() {
    super.initState();
    widget.vapController.state = this;
  }

  void showPush(TrudaLotteryUser bean) {
    var now = DateTime.now();
    var obj = {'stamp': now.millisecondsSinceEpoch, 'config': bean};
    NewHitaLotteryPusher.add(giftBannerView, obj, 6500, (giftBannerViewNew) {
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
  }

  @override
  Widget build(BuildContext context) {
    // 这样目的是不动画时隐藏，防止出现意外遮挡
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
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
