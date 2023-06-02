import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_type.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_entities/truda_gift_entity.dart';
import '../truda_routes/truda_pages.dart';
import '../truda_widget/newhita_net_image.dart';
import '../truda_widget/gift/truda_gift_data_helper.dart';

class TrudaGiftFollowTipController {
  bool _hadSendGift = false;
  bool hadFollow = false;
  String? herId;
  String? portrait;
  TrudaGiftEntity? gift;
  TrudaCallback<int>? callback;

  TrudaGiftFollowTipController() {
    TrudaGiftDataHelper.getGifts().then((value) {
      if (value != null && value.isNotEmpty) {
        gift = value.first;
      }
    });
  }

  void setUser(String? portrait, bool hadFollow) {
    this.portrait = portrait;
    this.hadFollow = hadFollow;
  }

  void hadSendGift() {
    _hadSendGift = true;
  }

  // 0关闭,1确定关注,2确定发礼物
  void listen(TrudaCallback<int> callback) {
    this.callback = callback;
  }
}

class TrudaGiftFollowTip extends StatefulWidget {
  TrudaGiftFollowTipController controller;

  TrudaGiftFollowTip({Key? key, required this.controller}) : super(key: key);

  @override
  State<TrudaGiftFollowTip> createState() => _TrudaGiftFollowTipState();
}

class _TrudaGiftFollowTipState extends State<TrudaGiftFollowTip> {
  OverlayEntry? overlayEntry;
  Timer? _timer;
  int _time = 0;
  late TrudaCallback<int> _callback;

  void showFollowGift({bool type = false}) {
    overlayEntry?.remove();
    overlayEntry = null;
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return GestureDetector(
        // onPointerMove: (event) {
        // if (mounted) {
        //   overlayEntry?.remove();
        //   overlayEntry = null;
        // }
        // },
        onTap: () {
          if (mounted) {
            overlayEntry?.remove();
            overlayEntry = null;
          }
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment(0.5, 0.5),
          padding:
          const EdgeInsetsDirectional.only(start: 15, end: 15, bottom: 30),
          child: type
              ? TrudaSendGiftTip(
            callback: _callback,
            gift: widget.controller.gift,
          )
              : TrudaFollowTip(
            callback: _callback,
            portrait: widget.controller.portrait,
          ),
        ),
      );
    });
    Overlay.of(context)?.insert(overlayEntry!);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _time++;
      // NewHitaLog.debug('NewHitaGiftFollowTip _time = $_time');
      if (_time == 10 && !widget.controller.hadFollow) {
        if (Get.currentRoute == TrudaAppPages.call ||
            Get.currentRoute == TrudaAppPages.chatPage) {
          showFollowGift();
        }
      }
      if (_time == 15) {
        overlayEntry?.remove();
        overlayEntry = null;
      }
      if (_time == 20 && !widget.controller._hadSendGift) {
        if (Get.currentRoute == TrudaAppPages.call ||
            Get.currentRoute == TrudaAppPages.chatPage) {
          showFollowGift(type: true);
        }
      }
      if (_time == 25) {
        overlayEntry?.remove();
        overlayEntry = null;
        _timer?.cancel();
        _timer = null;
      }
    });

    _callback = (i) {
      // 0关闭,1确定关注,2确定发礼物
      widget.controller.callback?.call(i);
      overlayEntry?.remove();
      overlayEntry = null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 1, height: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    overlayEntry?.remove();
  }
}

class TrudaFollowTip extends StatelessWidget {
  TrudaCallback<int> callback;
  String? portrait;

  TrudaFollowTip({
    Key? key,
    required this.callback,
    required this.portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsetsDirectional.only(
              start: 14, end: 14, bottom: 15, top: 10),
          padding: const EdgeInsetsDirectional.all(10),
          decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(8))),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: NewHitaNetImage(
                    portrait ?? '',
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 24,
                    ),
                    child: Text.rich(TextSpan(
                        text: TrudaLanguageKey.newhita_video_to_follow_tip.tr,
                        style: TextStyle(
                            color: TrudaColors.white, fontSize: 14))),
                  )),
              GestureDetector(
                onTap: () {
                  //关注主播
                  callback.call(1);
                },
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  'assets/images/newhita_call_follow.png',
                  width: 36,
                  height: 36,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            callback.call(0);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                "assets/images/newhita_close_white.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TrudaSendGiftTip extends StatelessWidget {
  TrudaCallback<int> callback;

  TrudaGiftEntity? gift;

  TrudaSendGiftTip({
    Key? key,
    required this.callback,
    required this.gift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(
              start: 14, end: 14, bottom: 15, top: 10),
          padding: EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(8))),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: NewHitaNetImage(
                    gift?.icon ?? '',
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 24,
                    ),
                    child: Text.rich(TextSpan(
                        text: TrudaLanguageKey.newhita_video_to_gift_tip.tr,
                        style: TextStyle(
                            color: TrudaColors.white, fontSize: 14))),
                  )),
              GestureDetector(
                onTap: () {
                  //送礼
                  if (gift != null){
                    callback.call(2);
                  } else {
                    callback.call(0);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        TrudaColors.baseColorGradient1,
                        TrudaColors.baseColorGradient2,
                      ]),
                      borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(54))),
                  padding: EdgeInsetsDirectional.all(5),
                  child: Image.asset(
                    "assets/images/newhita_arrow_right.png",
                    height: 26,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: 10,
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            callback.call(0);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                "assets/images/newhita_close_white.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        )
      ],
    );
  }
}
