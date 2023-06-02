import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';

import '../../../truda_services/truda_my_info_service.dart';
import '../../../truda_widget/newhita_net_image.dart';
import '../../../truda_widget/newhita_video_player.dart';
import 'truda_aic_controller.dart';

class TrudaAicWidget extends GetView<TrudaAicController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: GetBuilder<TrudaAicController>(
              id: TrudaAicController.idAgora,
              builder: (controller) {
                if (controller.playFinish) {
                  return NewHitaNetImage(
                    controller.detail?.portrait ?? "",
                    placeholder: (context, imageurl) => const SizedBox(),
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
                            filter: ImageFilter.blur(
                                sigmaX: 10, sigmaY: 10), //背景模糊化
                            child: Container(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Stack(
                  children: [
                    Positioned.fill(
                        child: controller.switchView
                            ? NewHitaAicCamera()
                            : NewHitaVideoPlayer(
                                controller: controller.videoController,
                              )),
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
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    decoration: (TrudaMyInfoService
                                                .to.isVipNow &&
                                            !controller.switchView)
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(8),
                                            border: Border.all(
                                              color: TrudaColors.baseColorYellow,
                                              width: 1,
                                            ),
                                          )
                                        : BoxDecoration(),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(8),
                                      child: !controller.switchView
                                          ? NewHitaAicCamera()
                                          : NewHitaVideoPlayer(
                                              controller:
                                                  controller.videoController,
                                            ),
                                    ),
                                  ),

                                  if (TrudaMyInfoService.to.isVipNow &&
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
                                  // Positioned(
                                  //     left: 0,
                                  //     right: 0,
                                  //     bottom: 0,
                                  //     child: Center(
                                  //       child: Obx(() => Container(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     vertical: 2,
                                  //                     horizontal: 4),
                                  //             decoration: BoxDecoration(
                                  //                 gradient:
                                  //                     const LinearGradient(
                                  //                         colors: [
                                  //                       TrudaColors.baseColorRed,
                                  //                       TrudaColors
                                  //                           .baseColorOrange
                                  //                     ]),
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         20)),
                                  //             child: Row(
                                  //               children: [
                                  //                 Visibility(
                                  //                     visible:
                                  //                         controller.callTime <
                                  //                             0,
                                  //                     child: Image.asset(
                                  //                         'assets/images/newhita_me_cards.png')),
                                  //                 Text(
                                  //                   controller
                                  //                       .callTimeStr.value,
                                  //                   style: const TextStyle(
                                  //                       fontSize: 12,
                                  //                       color: Colors.white),
                                  //                 ),
                                  //               ],
                                  //               mainAxisSize: MainAxisSize.min,
                                  //             ),
                                  //           )),
                                  //     ))
                                ],
                              ),
                            )))
                  ],
                );
              }),
        ),
        PositionedDirectional(
            start: 20,
            end: 20,
            bottom: 30,
            child: GetBuilder<TrudaAicController>(
                id: TrudaAicController.idSwitch,
                builder: (controller) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// 两分钟倒计时
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // if (!controller.audioMode.value)
                          //   NewHitaClickWidget(
                          //       onTap: controller.switchCamera,
                          //       child: Image.asset(
                          //         'assets/images/newhita_call_camera.png',
                          //         width: 48,
                          //         height: 48,
                          //       ))
                          // else
                          //   const SizedBox(
                          //     width: 48,
                          //     height: 48,
                          //   ),
                          GestureDetector(
                              onTap: controller.clickCharge,
                              child: Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(40)),
                                alignment: AlignmentDirectional.center,
                                child: Image.asset(
                                  'assets/images_sized/newhita_diamond_big.png',
                                  width: 40,
                                  height: 40,
                                ),
                              )),
                          GestureDetector(
                              onTap: controller.clickGift,
                              child: Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(40)),
                                alignment: AlignmentDirectional.center,
                                child: Image.asset(
                                  'assets/images/newhita_call_gift.png',
                                  width: 40,
                                  height: 40,
                                ),
                              )),
                          GestureDetector(
                            onTap: controller.quickSendGift,
                            child: Obx(() {
                              var url = controller.giftToQuickSend.value.icon;
                              if (url == null) {
                                return Image.asset(
                                  'assets/newhita_call_gift.webp',
                                  width: 76,
                                  height: 76,
                                );
                              } else {
                                return Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(40)),
                                  alignment: AlignmentDirectional.center,
                                  child: NewHitaNetImage(
                                    url,
                                    width: 40,
                                    height: 40,
                                  ),
                                );
                              }
                            }),
                          ),
                          // if (!controller.audioMode.value)
                          //   GestureDetector(
                          //       onTap: controller.switchVoice,
                          //       child: !controller.abandVolume
                          //           ? Image.asset(
                          //               'assets/images/newhita_call_voice.png',
                          //               width: 48,
                          //               height: 48,
                          //             )
                          //           : Image.asset(
                          //               'assets/images/newhita_call_voice_no.png',
                          //               width: 48,
                          //               height: 48,
                          //             ))
                          // else
                          //   const SizedBox(
                          //     width: 48,
                          //     height: 48,
                          //   ),
                        ],
                      ),
                    ],
                  );
                }))
      ],
    );
  }
}

class NewHitaAicCamera extends StatelessWidget {
  NewHitaAicCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TrudaAicController>();
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        child: (controller.hadCameraInit && controller.cameraController != null)
            ? Container(
                child: Stack(children: <Widget>[
                  Center(
                    child: Transform.scale(
                      scale: controller.cameraController!.value.aspectRatio /
                          (Get.width / Get.height),
                      child: AspectRatio(
                        aspectRatio:
                            controller.cameraController!.value.aspectRatio,
                        child: Center(
                            child: CameraPreview(controller.cameraController!)),
                      ),
                    ),
                  ),
                ]),
              )
            : NewHitaNetImage(
                TrudaMyInfoService.to.userLogin?.portrait ?? "",
              ));
  }
}
