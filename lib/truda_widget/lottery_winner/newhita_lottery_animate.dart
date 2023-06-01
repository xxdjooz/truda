import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_entities/truda_lottery_user_entity.dart';

/*
 * @discripe: 弹幕区礼物横幅动画队列
 */
// 暴露给直播间调用的礼物横幅类
class NewHitaLotteryPusher {
  // 在礼物横幅队列中增加
  NewHitaLotteryPusher.add(
      List<Map> giftBannerView, Map json, int removeTime, Function cb) {
    json['widget'] = NewHitaLotteryBanner(
      bean: json['config'],
      queueLength: giftBannerView.length,
    );
    giftBannerView.add(json);
    cb(giftBannerView); // 将重新生成的礼物横幅队列Widget返回给直播间setState

    // 给定时间后从队列中将礼物移除
    Timer(Duration(milliseconds: removeTime), () {
      for (int i = 0; i < giftBannerView.length; i++) {
        if (json['stamp'] == giftBannerView[i]['stamp']) {
          giftBannerView.removeAt(i);
          cb(giftBannerView);
        }
      }
    });
  }
}

class NewHitaLotteryBanner extends StatefulWidget {
  final TrudaLotteryUser bean;
  final int queueLength;
  NewHitaLotteryBanner({required this.bean, required this.queueLength});

  @override
  _NewHitaLotteryBannerState createState() => _NewHitaLotteryBannerState();
}

// 单个礼物横幅的动画Widget
class _NewHitaLotteryBannerState extends State<NewHitaLotteryBanner>
    with SingleTickerProviderStateMixin {
  late Animation<double> animationGiftNum_1,
      animationGiftNum_2,
      animationGiftNum_3;
  late AnimationController controller;
  bool hadInit = false;
  @override
  void initState() {
    super.initState();
    if (widget.queueLength >= 4) return;
    hadInit = true;
    controller = AnimationController(
        duration: Duration(milliseconds: 1800), vsync: this);

    // 礼物数量图片变大
    animationGiftNum_1 = Tween(
      begin: 0.0,
      end: 1.7,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.75, 0.85, curve: Curves.easeOut),
    ));

    // 礼物数量图片变小
    animationGiftNum_2 = Tween(
      begin: 1.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.85, 1.0, curve: Curves.easeIn),
    ));

    // 横幅从屏幕外滑入
    double an3Begin = -280;
    animationGiftNum_3 = Tween(
      begin: an3Begin,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.65, 0.85, curve: Curves.easeIn),
    ));

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();

    if (hadInit) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return !hadInit
        ? const SizedBox()
        : AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) {
              return PositionedDirectional(
                start: animationGiftNum_3.value,
                top: 140.0 + 80 * widget.queueLength,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            TrudaColors.baseColorGradient1,
                            TrudaColors.baseColorGradient2
                          ]), // 渐变色
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(left: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(widget.bean.portrait ?? ''),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    TrudaLanguageKey.newhita_lottery_user.trParams({
                                      'name': widget.bean.nickname ?? '',
                                      'thing': widget.bean.name ?? '',
                                    }),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            child: null,
          );
  }
}
