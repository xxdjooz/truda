import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:video_player/video_player.dart';

import '../../../truda_services/newhita_my_info_service.dart';
import '../../../truda_widget/newhita_net_image.dart';
import 'truda_aiv_controller.dart';

class TrudaAivWidget extends GetView<TrudaAivController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: GetBuilder<TrudaAivController>(
              id: TrudaAivController.idAgora,
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
                return GestureDetector(
                  onTap: () {
                    controller.cleanScreen.toggle();
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: controller.switchView
                              ? TrudaAivCamera()
                              : TrudaAivVideoPlayer(
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
                                            BorderRadiusDirectional.circular(12),
                                        child: !controller.switchView
                                            ? TrudaAivCamera()
                                            : TrudaAivVideoPlayer(
                                                controller:
                                                    controller.videoController,
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
                  ),
                );
              }),
        ),
        PositionedDirectional(
            start: 20,
            bottom: 30,
            child: Obx(() {
              return Visibility(
                visible: !controller.cleanScreen.value,
                child: GetBuilder<TrudaAivController>(
                    id: TrudaAivController.idSwitch,
                    builder: (controller) {
                      return GestureDetector(
                          onTap: controller.clickCharge,
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(40)),
                            alignment: AlignmentDirectional.center,
                            child: Image.asset(
                              'assets/images_sized/newhita_diamond_big.png',
                              width: 35,
                              height: 35,
                            ),
                          ));
                    }),
              );
            })),
        PositionedDirectional(
          end: 20,
          bottom: 30,
          child: GetBuilder<TrudaAivController>(
            id: TrudaAivController.idSwitch,
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

class TrudaAivCamera extends StatelessWidget {
  TrudaAivCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TrudaAivController>();
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
                NewHitaMyInfoService.to.userLogin?.portrait ?? "",
              ));
  }
}

class TrudaAivVideoPlayer extends StatefulWidget {
  // String netUrl;
  // String imageUrl;
  VideoPlayerController controller;

  TrudaAivVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  _TrudaAivVideoPlayerState createState() => _TrudaAivVideoPlayerState();
}

class _TrudaAivVideoPlayerState extends State<TrudaAivVideoPlayer> {
  late VideoPlayerController _controller;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var aicController = Get.find<TrudaAivController>();
    return Material(
      elevation: 0,
      child: SizedBox.expand(
        child: (!aicController.playerInited)
            ? ColoredBox(color: Colors.black)
            : FittedBox(
                // 这个做了满屏处理
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
      ),
    );
  }
}
