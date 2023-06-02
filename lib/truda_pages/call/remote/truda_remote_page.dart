import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_widget/newhita_avatar_with_bg.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_dialogs/truda_dialog_confirm_hang.dart';
import '../../../truda_utils/truda_format_util.dart';
import '../../../truda_utils/truda_permission_handler.dart';
import 'truda_remote_controller.dart';

class TrudaRemotePage extends GetView<TrudaRemoteController> {
  TrudaRemotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaRemoteController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            color: TrudaColors.baseColorBlackBg,
            child: Stack(
              fit: StackFit.expand,
              children: [
                NewHitaNetImage(
                  controller.portrait ?? "",
                  placeholderAsset: 'assets/images_sized/newhita_home_girl.png',
                  errorWidget: (context, url, error) => const SizedBox(),
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
                          filter:
                              ImageFilter.blur(sigmaX: 10, sigmaY: 10), //背景模糊化
                          child: Container(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const AspectRatio(aspectRatio: 3),
                    SizedBox(height: Get.height / 10),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: NewHitaAvatarWithBg(
                        url: controller.portrait,
                        width: 105,
                        height: 105,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      controller.detail?.nickname ?? "",
                      style: const TextStyle(
                        color: TrudaColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: Color(0xFF51A8).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/newhita_base_female.png',
                                width: 12,
                                height: 12,
                              ),
                              Text(
                                '${TrudaFormatUtil.getAge(DateTime.fromMillisecondsSinceEpoch(controller.detail?.birthday ?? 0))}',
                                style: const TextStyle(
                                    color: TrudaColors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 0, vertical: 0),
                        //   margin: const EdgeInsets.symmetric(horizontal: 4),
                        //   decoration: BoxDecoration(
                        //       color: Colors.white12,
                        //       borderRadius: BorderRadius.circular(20)),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       NewHitaNetImage(
                        //         controller.detail?.area?.path ?? "",
                        //         radius: 9,
                        //         width: 14,
                        //         height: 14,
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 4, vertical: 2),
                        //         child: Text(
                        //           controller.detail?.area?.title ?? "",
                        //           style: const TextStyle(
                        //               color: TrudaColors.white, fontSize: 12),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        if (controller.freeTip == 0)
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Obx(() => Text.rich(TextSpan(
                                      text: "${controller.herCharge}",
                                      style: const TextStyle(
                                          color: TrudaColors.white,
                                          fontSize: 12),
                                      children: [
                                        WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Image.asset(
                                              "assets/images/newhita_diamond_small.png",
                                              height: 12,
                                              width: 12,
                                            )),
                                        TextSpan(
                                            text: TrudaLanguageKey
                                                .newhita_video_time_unit.tr),
                                      ])))),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                        child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset('assets/images/newhita_call_report.png'),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Text(
                                TrudaLanguageKey.newhita_video_warning.tr,
                                style: const TextStyle(
                                    color: TrudaColors.white, fontSize: 10),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                    Obx(() => Text(
                          controller.waitingStr.value,
                          style: const TextStyle(
                              color: Color(0xff19D9B9), fontSize: 16),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    if (controller.freeTip > 0)
                      Container(
                          padding: const EdgeInsetsDirectional.only(
                              start: 10, end: 10, top: 3, bottom: 3),
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xffE07DE6),
                                  Color(0xff8F62FB),
                                ],
                              ),
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(11))),
                          child: controller.freeTip == 1
                              ? Text(
                                  TrudaLanguageKey.newhita_call_free.tr,
                                  style: TextStyle(
                                      color: TrudaColors.white, fontSize: 14),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/images/newhita_call_card.png",
                                      height: 22,
                                    ),
                                    LimitedBox(
                                      maxWidth: 220,
                                      child: Text(
                                        TrudaLanguageKey
                                            .newhita_video_called_free_card_tip
                                            .trArgs([
                                          ((TrudaMyInfoService.to.myDetail
                                                          ?.callCardDuration ??
                                                      30000) ~/
                                                  1000)
                                              .toString()
                                        ]),
                                        style: TextStyle(
                                            color: TrudaColors.white,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            // onTap: controller.hangUp,
                            onTap: () {
                              Get.dialog(TrudaDialogConfirmHang(
                                title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                                callback: (i) {
                                  if (i == 1) {
                                    controller.pickUp();
                                  } else {
                                    controller.hangUp();
                                  }
                                },
                              ));
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              child: Image.asset(
                                "assets/images/newhita_call_hang.png",
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              TrudaPermissionHandler.checkCallPermission()
                                  .then((value) {
                                if (value) {
                                  controller.pickUp();
                                }
                              });
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              child: Image.asset(
                                "assets/images_ani/newhita_call_pick.webp",
                              ),
                            ),
                            // child: Container(
                            //   height: 64,
                            //   width: 64,
                            //   decoration: BoxDecoration(
                            //     color: Colors.green,
                            //     shape: BoxShape.circle,
                            //   ),
                            //   padding: EdgeInsets.all(15),
                            //   child: Image.asset(
                            //     "assets/images_ani/newhita_host_call.webp",
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: Get.height / 20
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
