import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_entities/truda_gift_entity.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';

import '../../truda_common/truda_colors.dart';

/*
 * @discripe: 弹幕区礼物横幅动画队列
 */
// 暴露给直播间调用的礼物横幅类
class NewHitaGiftPusher {
  // 在礼物横幅队列中增加
  NewHitaGiftPusher.add(
      List<Map> giftBannerView, Map json, int removeTime, Function cb) {
    json['widget'] = NewHitaGiftBanner(
      giftInfo: json['config'],
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

class NewHitaGiftBanner extends StatefulWidget {
  final TrudaGiftEntity giftInfo;
  final int queueLength;
  NewHitaGiftBanner({required this.giftInfo, required this.queueLength});

  @override
  _NewHitaGiftBannerState createState() => _NewHitaGiftBannerState();
}

// 单个礼物横幅的动画Widget
class _NewHitaGiftBannerState extends State<NewHitaGiftBanner>
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
        duration: Duration(milliseconds: 3800), vsync: this);

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
    double an3Begin = -(Get.width);
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
                top: 145.0 + 80 * widget.queueLength,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            TrudaColors.baseColorRed,
                            TrudaColors.baseColorOrange
                          ]), // 渐变色
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(left: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                    NewHitaMyInfoService.to.myDetail?.portrait ??
                                        ''),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${TrudaLanguageKey.newhita_gift_send.tr} ",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Image.network(
                            widget.giftInfo.icon ?? '',
                            height: 40,
                          ),
                          // Padding(padding: EdgeInsets.only(right: 50)),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Transform.scale(
                              scale: animationGiftNum_1.value >= 1.7
                                  ? animationGiftNum_2.value
                                  : animationGiftNum_1.value,
                              // child: Image.asset(
                              //   'assets/images/newhita_diamond_small.png',
                              //   height: 10,
                              // ),
                              child: Text(
                                '×',
                                style: TextStyle(
                                    color: TrudaColors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: animationGiftNum_1.value >= 1.7
                                ? animationGiftNum_2.value
                                : animationGiftNum_1.value,
                            child: Text(
                              '1',
                              style: TextStyle(
                                  color: TrudaColors.white, fontSize: 18),
                            ),
                            // child: Image.asset(
                            //   'assets/images/newhita_diamond_small.png',
                            //   height: 30,
                            // ),
                          ),
                          const SizedBox(width: 8)
                        ],
                      ),
                    ),
                    // PositionedDirectional(
                    //   end: -50,
                    //   bottom: 0,
                    //   child: Image.network(
                    //     widget.giftInfo.icon ?? '',
                    //     height: 50,
                    //   ),
                    // ),
                  ],
                ),
              );
            },
            child: null,
          );
  }
}
