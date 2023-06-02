import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_end_type_2.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_dialogs/truda_dialog_confirm_hang.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../../../truda_utils/newhita_format_util.dart';
import '../../../truda_widget/newhita_avatar_with_bg.dart';
import 'truda_local_controller.dart';

class TrudaLocalPage extends GetView<TrudaLocalController> {
  TrudaLocalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: TrudaColors.baseColorBlackBg,
        extendBodyBehindAppBar: true,
        body: Container(
          color: Colors.black54,
          width: double.infinity,
          height: double.infinity,
          child: GetBuilder<TrudaLocalController>(builder: (controller) {
            return Stack(
              fit: StackFit.expand,
              children: [
                NewHitaNetImage(
                  controller.detail?.portrait ?? "",
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
                    SizedBox(height: Get.height / 10),
                    // NewHitaNetImage(
                    //   controller.detail?.portrait ?? "",
                    //   width: 84,
                    //   height: 84,
                    //   imageBuilder: (context, provider) {
                    //     return Container(
                    //       decoration: BoxDecoration(
                    //           image: DecorationImage(
                    //               image: provider, fit: BoxFit.cover),
                    //           borderRadius: BorderRadius.circular(42),
                    //           border:
                    //               Border.all(color: TrudaColors.white, width: 2)),
                    //     );
                    //   },
                    // ),
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
                              color: Color(0xFFFF51A8).withOpacity(0.1),
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
                                '${NewHitaFormatUtil.getAge(DateTime.fromMillisecondsSinceEpoch(controller.detail?.birthday ?? 0))}',
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
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                                    color: Color(0xff19D9B9), fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                    Obx(() => Text(
                          controller.waitingStr.value,
                          style: const TextStyle(
                              color: TrudaColors.white, fontSize: 16),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      // onTap: controller.hangUp,
                      onTap: () {
                        Get.dialog(TrudaDialogConfirmHang(
                          title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                          callback: (i) {
                            if (i == 0) {
                              controller.hangUp(TrudaEndType2.callingCancel);
                            }
                          },
                          isPick: false,
                        ));
                      },
                      child: Image.asset(
                        "assets/images/newhita_call_hang.png",
                        height: 70,
                        width: 70,
                      ),
                    ),
                    SizedBox(
                        height: Get.height / 20
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
