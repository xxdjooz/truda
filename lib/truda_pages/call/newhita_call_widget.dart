import 'dart:ui';

//本地预览
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;

//远端预览
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';

import '../../truda_services/newhita_my_info_service.dart';
import '../../truda_widget/newhita_gradient_circular_progress_indicator.dart';
import '../../truda_widget/newhita_net_image.dart';
import 'newhita_call_controller.dart';

class NewHitaCallWidget extends GetView<NewHitaCallController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<NewHitaCallController>(
            id: NewHitaCallController.idAgora,
            builder: (controller) {
              return GestureDetector(
                onTap: () {
                  controller.cleanScreen.toggle();
                },
                child: Stack(
                  children: [
                    if (controller.audioMode.value)
                      Positioned.fill(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            NewHitaNetImage(
                              controller.detail?.portrait ?? "",
                              placeholder: (context, imageurl) =>
                                  const SizedBox(),
                              errorWidget: (context, url, error) =>
                                  const SizedBox(),
                              imageBuilder: (context, provider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: provider,
                                      //背景图片
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    // make sure we apply clip it properly
                                    child: BackdropFilter(
                                      //背景滤镜
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10), //背景模糊化
                                      child: Container(
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //   color:
                              //       TrudaColors.baseColorItem.withOpacity(0.3),
                              //   borderRadius: BorderRadius.circular(20),
                              // ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              margin: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  NewHitaNetImage(
                                    controller.detail?.portrait ?? '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: TrudaColors.white,
                                              width: 1),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle),
                                    ),
                                    width: 130,
                                    height: 130,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Image.asset(
                                    'assets/images_ani/newhita_voice_wave.webp',
                                    width: 140,
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    TrudaLanguageKey
                                        .newhita_video_voice_switch.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    if (!controller.audioMode.value)
                      Positioned.fill(
                          child: controller.switchView
                              ? const rtc_local_view.SurfaceView()
                              : rtc_remote_view.SurfaceView(
                                  uid: int.parse(controller.herId),
                                  channelId: controller.channelId ?? '',
                                )),
                    if (!controller.audioMode.value)
                      Positioned(
                          top: controller.toTop,
                          left: controller.toLeft,
                          child: GestureDetector(
                              onPanUpdate: controller.onPanUpdate,
                              onTap: controller.switchBig,
                              child: SizedBox(
                                width: 120,
                                height: 170,
                                child: Stack(
                                  fit: StackFit.expand,
                                  clipBehavior: Clip.none,
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      decoration:
                                          (NewHitaMyInfoService.to.isVipNow &&
                                                  !controller.switchView)
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(12),
                                                  border: Border.all(
                                                    color: TrudaColors
                                                        .baseColorTheme,
                                                    width: 1,
                                                  ),
                                                )
                                              : BoxDecoration(),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                12),
                                        child: !controller.switchView
                                            ? const rtc_local_view.SurfaceView()
                                            : rtc_remote_view.SurfaceView(
                                                uid:
                                                    int.parse(controller.herId),
                                                channelId:
                                                    controller.channelId ?? '',
                                              ),
                                      ),
                                    ),
                                    if (NewHitaMyInfoService.to.isVipNow &&
                                        !controller.switchView)
                                      PositionedDirectional(
                                        top: -22,
                                        start: 0,
                                        end: 0,
                                        child: Center(
                                          child: Image.asset(
                                            'assets/images_sized/newhita_me_vip.png',
                                            height: 24,
                                          ),
                                        ),
                                      ),
                                    if (NewHitaMyInfoService.to.isVipNow &&
                                        !controller.switchView)
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Image.asset(
                                          'assets/images/newhita_host_vip_user.png',
                                        ),
                                      ),
                                    // Positioned(
                                    //     left: 0,
                                    //     right: 0,
                                    //     bottom: 0,
                                    //     child: Center(
                                    //       child: Obx(() => controller
                                    //               .callTimeStr.value.isEmpty
                                    //           ? const SizedBox()
                                    //           : Container(
                                    //               padding: const EdgeInsets
                                    //                       .symmetric(
                                    //                   vertical: 2,
                                    //                   horizontal: 4),
                                    //               decoration: BoxDecoration(
                                    //                 color: TrudaColors
                                    //                     .baseColorRed,
                                    //                   // gradient:
                                    //                   //     const LinearGradient(
                                    //                   //         colors: [
                                    //                   //       TrudaColors
                                    //                   //           .baseColorRed,
                                    //                   //       TrudaColors
                                    //                   //           .baseColorOrange
                                    //                   //     ]),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(
                                    //                           20)),
                                    //               child: Row(
                                    //                 mainAxisSize:
                                    //                     MainAxisSize.min,
                                    //                 children: [
                                    //                   Visibility(
                                    //                     visible: controller
                                    //                         .callTimeShowCard
                                    //                         .value,
                                    //                     child: Image.asset(
                                    //                         'assets/images/newhita_me_cards.png'),
                                    //                   ),
                                    //                   Text(
                                    //                     controller
                                    //                         .callTimeStr.value,
                                    //                     style: const TextStyle(
                                    //                         fontSize: 12,
                                    //                         color:
                                    //                             Colors.white),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             )),
                                    //     ))
                                  ],
                                ),
                              )))
                  ],
                ),
              );
            }),
        PositionedDirectional(
          start: 20,
          end: 20,
          bottom: 30,
          child: GetBuilder<NewHitaCallController>(
            id: NewHitaCallController.idSwitch,
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 主播索要礼物
                  Obx(() {
                    final gift = controller.askGift.value;
                    if (gift == null) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.askGift.value = null;
                          },
                          child: Container(
                            padding: const EdgeInsetsDirectional.all(5),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          height: 74,
                          child: Row(
                            children: [
                              NewHitaNetImage(
                                gift.icon ?? '',
                                width: 54,
                                height: 54,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    TrudaLanguageKey.newhita_gift_ask
                                        .trArgs([gift.name ?? '']),
                                    style: const TextStyle(
                                        color: TrudaColors.white,
                                        fontSize: 14),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: EdgeInsetsDirectional.only(end: 4),
                                        width: 13,
                                        height: 13,
                                        child: Image.asset(
                                            "assets/images/newhita_diamond_small.png"),
                                      ),
                                      Text(
                                        gift.diamonds.toString(),
                                        style: TextStyle(
                                            color: TrudaColors.white,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                              GestureDetector(
                                onTap: () {
                                  controller.sendGift(controller.askGift.value!);
                                  controller.askGift.value = null;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      TrudaColors.baseColorGradient1,
                                      TrudaColors.baseColorGradient2,
                                    ]),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  child: Text(
                                    TrudaLanguageKey.newhita_gift_send.tr,
                                    style: const TextStyle(
                                        color: TrudaColors.white,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),

                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 50,
                  ),
                  /// 两分钟倒计时
                  Obx(() {
                    if (controller.showCount2Min.value > 0) {
                      // if (true) {
                      return Container(
                        width: Get.width * 2 / 3,
                        margin: EdgeInsetsDirectional.only(start: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 画一个倒三角，666，怎么实现的？
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                padding: EdgeInsetsDirectional.only(
                                    start: 9, end: 10, top: 10, bottom: 10),
                                //钻石余额不足的tip
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text.rich(TextSpan(
                                          text: TrudaLanguageKey
                                              .newhita_video_time_to_charge_1
                                              .tr,
                                          style: TextStyle(
                                              color: TrudaColors.white,
                                              fontSize: 12),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "${controller.count2MinLeft}",
                                                style: TextStyle(
                                                    color: TrudaColors
                                                        .baseColorRed,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: TrudaLanguageKey
                                                    .newhita_video_time_to_charge_2
                                                    .tr)
                                          ])),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                      height: 4,
                                    ),
                                  ],
                                )),
                            Container(
                              width: 20,
                              height: 0,
                              margin: EdgeInsetsDirectional.only(
                                  start: 20, bottom: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  // 四个值 top right bottom left
                                  top: BorderSide(
                                      color: Colors.black38,
                                      width: 8,
                                      style: BorderStyle.solid),
                                  right: const BorderSide(
                                      color: Colors.transparent,
                                      width: 10,
                                      style: BorderStyle.solid),
                                  left: const BorderSide(
                                      color: Colors.transparent,
                                      width: 10,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Visibility(
                          visible: !controller.cleanScreen.value,
                          child: GestureDetector(
                              onTap: controller.clickCharge,
                              child: Stack(
                                // fit: StackFit.expand,
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    alignment: AlignmentDirectional.center,
                                    child: Image.asset(
                                      'assets/images_sized/newhita_diamond_big.png',
                                      width: 35,
                                      height: 35,
                                    ),
                                  ),
                                  Obx(() {
                                    final bool show =
                                        controller.showCount2Min.value > 0;
                                    return !show
                                        ? const SizedBox()
                                        : NewHitaGradientCircularProgressIndicator(
                                            colors: const [
                                              Colors.green,
                                              Colors.orange
                                            ],
                                            backgroundColor: Colors.transparent,
                                            radius: 28,
                                            stokeWidth: 3.0,
                                            value: (60 -
                                                    controller
                                                        .count2MinLeft.value) /
                                                60,
                                          );
                                  }),
                                ],
                              )),
                        );
                      }),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        PositionedDirectional(
          end: 20,
          bottom: 30,
          child: GetBuilder<NewHitaCallController>(
            id: NewHitaCallController.idSwitch,
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    return Visibility(
                      visible: !controller.cleanScreen.value,
                      child: GestureDetector(
                        onTap: controller.quickSendGift,
                        child: Obx(() {
                          var url = controller.giftToQuickSend.value.icon;
                          if (url == null) {
                            return Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(40)),
                              alignment: AlignmentDirectional.center,
                              child: Image.asset(
                                'assets/images/newhita_call_gift.png',
                                width: 35,
                                height: 35,
                              ),
                            );
                          } else {
                            return Container(
                              width: 55,
                              height: 55,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(40)),
                              alignment: AlignmentDirectional.center,
                              child: NewHitaNetImage(
                                url,
                                width: 35,
                                height: 35,
                              ),
                            );
                          }
                        }),
                      ),
                    );
                  }),
                  GestureDetector(
                      onTap: controller.clickGift,
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(40)),
                        alignment: AlignmentDirectional.center,
                        child: Image.asset(
                          'assets/images/newhita_call_gift.png',
                          width: 35,
                          height: 35,
                        ),
                      )),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
