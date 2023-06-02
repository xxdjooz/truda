import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_common_type.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../truda_common/truda_constants.dart';

class TrudaCount20 extends StatefulWidget {
  int leftSecond;
  TrudaCallback<bool> callback;

  TrudaCount20({
    Key? key,
    required this.leftSecond,
    required this.callback,
  }) : super(key: key);

  @override
  State<TrudaCount20> createState() => _TrudaCount20State();
}

class _TrudaCount20State extends State<TrudaCount20> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(bottom: 30, start: 10, end: 10),
          padding: const EdgeInsetsDirectional.only(
              start: 15, end: 15, bottom: 15, top: 15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(25),
              topEnd: Radius.circular(25),
              bottomStart: Radius.circular(25),
              bottomEnd: Radius.circular(25),
            ),
            color: Colors.black87,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TrudaTipRechargeCircle(() {
                widget.callback.call(false);
              }, widget.leftSecond, 50),
              Expanded(
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                    start: 10,
                    end: 10,
                  ),
                  child: TrudaConstants.isFakeMode
                      ? const SizedBox()
                      : Text.rich(
                          TextSpan(
                              text:
                                  "${TrudaLanguageKey.newhita_chat_left_charge_tip_1.tr} ",
                              style: TextStyle(
                                  color: TrudaColors.white, fontSize: 14),
                              children: [
                                TextSpan(
                                    text: NewHitaMyInfoService
                                            .to.config?.chargePrice
                                            .toString() ??
                                        "--",
                                    style: TextStyle(
                                        color: TrudaColors.baseColorYellow,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Image.asset(
                                      "assets/images/newhita_diamond_small.png",
                                      width: 20,
                                      height: 20,
                                    )),
                                TextSpan(
                                    text:
                                        " ${TrudaLanguageKey.newhita_chat_left_charge_tip_2.tr} "),
                              ]),
                          textAlign: TextAlign.start,
                        ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      widget.callback.call(true);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.only(
                          start: 10, end: 10, bottom: 10, top: 10),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            TrudaColors.baseColorGradient1,
                            TrudaColors.baseColorGradient2,
                          ]), // 渐变色
                          borderRadius: BorderRadiusDirectional.circular(21)),
                      child: Text(
                        TrudaLanguageKey.newhita_chat_left_charge_continue.tr,
                        style: TextStyle(
                            fontSize: 12,
                            color: TrudaColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        PositionedDirectional(
          start: 35,
          top: -22,
          child: GestureDetector(
            onTap: () {
              widget.callback.call(false);
              Get.back();
            },
            child: Container(
              padding: const EdgeInsetsDirectional.all(5),
              decoration: const BoxDecoration(
                color: Color(0xff26073E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Image.asset(
                'assets/images/newhita_base_close.png',
                width: 12,
                height: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrudaTipRechargeCircle extends StatefulWidget {
  //在20s之前关闭充值弹窗 避免在通话页面结束的瞬间 点击了充值
  Function beforeDismiss;

  // bool isAia;
  int leftSecond;
  double size;

  TrudaTipRechargeCircle(
    this.beforeDismiss,
    this.leftSecond,
    this.size,
  );

  @override
  _TrudaTipRechargeCircleState createState() =>
      _TrudaTipRechargeCircleState();
}

class _TrudaTipRechargeCircleState extends State<TrudaTipRechargeCircle> {
  var test = 10.obs;
  Timer? _timerLink;
  var countTime = 0.obs;

  @override
  void initState() {
    super.initState();
    countTime.value = widget.leftSecond;
    _timerLink = Timer.periodic(const Duration(seconds: 1), (timer) {
      countTime--;
      NewHitaLog.debug('countTime.value == $countTime');
      if (countTime.value == 1) {
        _timerLink?.cancel();
        _timerLink = null;
        // hangUp();
        Get.back();
        widget.beforeDismiss.call();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timerLink?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int currentChatTime = 0;
      double percent = 0;
      int callDuration = 0;

      //AIA情况下 AIA视频结束后AIA页面开启一个定时器
      // if (widget.isAia == true) {
      //   CblAIBChatEngineController aibChatEngineController =
      //       Get.find<CblAIBChatEngineController>(
      //           tag: CblAIBChatEngineController.AIBChatControllerTag);
      //   //通话倒计时触发
      //   callDuration = (20 - aibChatEngineController.leftDuration.value) * 1000;
      //   percent = callDuration / (20 * 1000);
      // } else {
      //   CblChatEngineController binChatEngineController =
      //       Get.find<CblChatEngineController>(
      //           tag: CblChatEngineController.ChatControllerTag);
      //   //通话倒计时触发
      //   currentChatTime = binChatEngineController.seconds.value;
      //   //20s弹窗出现 开始倒计时
      //   callDuration = (60 - currentChatTime % 60) * 1000;
      //   percent = callDuration / (20 * 1000);
      //   NewHitaLog.debug("20s倒计时提示卡 callDuration = ${callDuration}");
      // }
      currentChatTime = countTime.value;
      percent = currentChatTime / widget.leftSecond;
      NewHitaLog.debug('countTime == $currentChatTime $percent');
      if (percent < 0 || percent > 1) {
        percent = 0;
      }

      if (callDuration < 0 || callDuration >= 60 * 1000) {
        callDuration = 0;
      }
      return Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: widget.size,
            height: widget.size,
            child: Container(
              alignment: Alignment.center,
              width: widget.size - 7.5,
              height: widget.size - 7.5,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius:
                      BorderRadiusDirectional.circular(widget.size / 2)),
              child: Text(
                "${currentChatTime}",
                style: TextStyle(
                    fontSize: widget.size / 2,
                    color: TrudaColors.baseColorRed,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: CircularPercentIndicator(
                reverse: true,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 0,
                percent: percent,
                lineWidth: 2,
                // center: Container(
                //   width: 160,
                //   height: 160,
                // ),
                backgroundColor: Colors.white24,
                progressColor: TrudaColors.baseColorRed,
                radius: widget.size / 2),
          )
        ],
      );
    });
  }
}

// class _TrudaCount20State extends State<TrudaCount20> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsetsDirectional.only(
//           start: 20, end: 20, bottom: 20, top: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadiusDirectional.circular(30),
//         // gradient: LinearGradient(
//         //     begin: Alignment.topCenter,
//         //     end: Alignment.bottomCenter,
//         //     colors: [
//         //       TrudaColors.baseColorGradient1,
//         //       TrudaColors.baseColorGradient2,
//         //     ]),
//         color: Colors.black87,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Align(
//             alignment: AlignmentDirectional.centerStart,
//             child: Container(
//               height: 24,
//               padding: EdgeInsetsDirectional.only(start: 6, end: 6),
//               decoration: BoxDecoration(
//                   color: Colors.white12,
//                   borderRadius: BorderRadiusDirectional.circular(12)),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: EdgeInsetsDirectional.only(end: 3),
//                     child: Image.asset(
//                       "assets/images/newhita_diamond_small.png",
//                       width: 13,
//                       height: 13,
//                     ),
//                   ),
//                   Text(
//                     "${NewHitaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? '--'}",
//                     style: TextStyle(
//                         color: TrudaColors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           NewHitaTipRechargeCircle(
//             () {
//               widget.callback.call(false);
//             },
//             widget.leftSecond,
//           ),
//           Container(
//             margin: EdgeInsetsDirectional.only(
//                 start: 38, end: 38, top: 30, bottom: 20),
//             child: NewHitaConstants.isFakeMode
//                 ? const SizedBox()
//                 : Text.rich(
//                     TextSpan(
//                         text:
//                             "${TrudaLanguageKey.newhita_chat_left_charge_tip_1.tr} ",
//                         style: TextStyle(color: TrudaColors.white, fontSize: 14),
//                         children: [
//                           TextSpan(
//                               text: NewHitaMyInfoService.to.config?.chargePrice
//                                       .toString() ??
//                                   "--",
//                               style: TextStyle(
//                                   color: TrudaColors.baseColorYellow,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold)),
//                           WidgetSpan(
//                               alignment: PlaceholderAlignment.middle,
//                               child: Image.asset(
//                                 "assets/images/newhita_diamond_small.png",
//                                 width: 20,
//                                 height: 20,
//                               )),
//                           TextSpan(
//                               text:
//                                   " ${TrudaLanguageKey.newhita_chat_left_charge_tip_2.tr} "),
//                         ]),
//                     textAlign: TextAlign.center,
//                   ),
//           ),
//           Container(
//             margin: EdgeInsetsDirectional.only(start: 38, end: 38, bottom: 20),
//             child: Text(
//               TrudaLanguageKey.newhita_chat_left_charge_continue_tip.tr,
//               style: TextStyle(
//                   color: TrudaColors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   // wholeCancelFunc.call();
//                   // //AIA的情况下 跳过按钮倒计时充值进入结算页面
//                   // if (isAia == true) {
//                   //   finishCallBack?.call();
//                   // }
//                   widget.callback.call(false);
//                   Get.back();
//                 },
//                 child: Container(
//                   height: 42,
//                   alignment: Alignment.center,
//                   padding: EdgeInsetsDirectional.only(start: 30, end: 30),
//                   decoration: BoxDecoration(
//                       color: Color(0x33FFFFFF),
//                       borderRadius: BorderRadiusDirectional.circular(21)),
//                   child: Text(
//                     TrudaLanguageKey.newhita_chat_left_charge_skip.tr,
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: TrudaColors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   //AIA的情况下 点击充值不关闭倒计时弹窗
//                   // if (isAia == true) {
//                   //   await showRecharge("chat_left_20s_show_recharge",
//                   //       upid: upDetailData.userId);
//                   //   // Future.delayed(Duration(seconds: 3), (){
//                   //   //   finishCallBack?.call();
//                   //   // });
//                   // } else {
//                   //   wholeCancelFunc.call();
//                   //   showRecharge("chat_left_20s_show_recharge",
//                   //       upid: upDetailData.userId);
//                   // }
//                   widget.callback.call(true);
//                 },
//                 child: Container(
//                   height: 42,
//                   alignment: Alignment.center,
//                   padding: EdgeInsetsDirectional.only(start: 30, end: 30),
//                   decoration: BoxDecoration(
//                       color: TrudaColors.baseColorGreen,
//                       borderRadius: BorderRadiusDirectional.circular(21)),
//                   child: Text(
//                     TrudaLanguageKey.newhita_chat_left_charge_continue.tr,
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: TrudaColors.textColor333,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
