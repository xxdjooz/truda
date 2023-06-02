import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_widget/newhita_avatar_with_bg.dart';

import '../../truda_common/truda_common_dialog.dart';
import '../../truda_common/truda_language_key.dart';
import '../../truda_dialogs/truda_dialog_confirm_hang.dart';
import '../../truda_dialogs/truda_sheet_host_option.dart';
import '../../truda_routes/truda_pages.dart';
import '../../truda_utils/newhita_gift_follow_tip.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_widget/gift/newhita_vap_player.dart';
import '../../truda_widget/newhita_click_widget.dart';
import '../../truda_widget/newhita_net_image.dart';
import 'truda_call_controller.dart';
import 'truda_call_widget.dart';
import 'truda_contribute_view.dart';

class TrudaCallPage extends StatefulWidget {
  TrudaCallPage({Key? key}) : super(key: key);

  @override
  State<TrudaCallPage> createState() => _TrudaCallPageState();
}

class _TrudaCallPageState extends State<TrudaCallPage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TrudaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    TrudaAppPages.observer.unsubscribe(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    NewHitaLog.debug('TrudaCallPage didPopNext');
    // 发现Get.bottomSheet的弹窗关闭也会走到这里
    Get.find<TrudaCallController>().didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    // 全局topPadding高度
    double statusBarHeight = MediaQuery.of(context).padding.top;
    // AppBar 高度
    double appBarHeight = kToolbarHeight;
    return GetBuilder<TrudaCallController>(builder: (controller) {
      return controller.connecting
          ? _connectWidget(controller)
          : WillPopScope(
              onWillPop: () async {
                // Get.dialog(NewHitaDialogConfirm(
                //   title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                //   callback: (i) {
                //     controller.clickHangUp();
                //   },
                // ));

                TrudaCommonDialog.dialog(TrudaDialogConfirmHang(
                  title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                  callback: (i) {
                    if (i == 0) {
                      controller.clickHangUp();
                    }
                  },
                  isPick: false,
                ));
                return false;
              },
              child: Obx(() {
                return Scaffold(
                  appBar:controller.cleanScreen.value ? null : AppBar(
                    // toolbarHeight: 100,
                    leadingWidth: 0,
                    titleSpacing: 0,
                    // title: ,
                    leading: SizedBox(),
                    centerTitle: false,
                    title: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                          margin: EdgeInsetsDirectional.only(start: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NewHitaNetImage(
                                controller.detail?.portrait ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: TrudaColors.white, width: 1),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle),
                                ),
                                width: 36,
                                height: 36,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LimitedBox(
                                    maxWidth: 80,
                                    child: Text(
                                      controller.detail?.nickname ?? "",
                                      // "aaa aa aa aa aa aa aa aa aa aa aa aa aa aa aa",
                                      style: const TextStyle(
                                          color: TrudaColors.white,
                                          fontSize: 12),
                                      maxLines: 1,
                                    ),
                                  ),
                                  // Text(
                                  //   'ID:' + (controller.detail?.username ?? ""),
                                  //   // "aaa aa",
                                  //   style: const TextStyle(
                                  //       color: TrudaColors.white, fontSize: 12),
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Obx(() {
                                if (controller.followed.value == 1) {
                                  return GestureDetector(
                                    onTap: controller.handleFollow,
                                    child: Image.asset(
                                      'assets/images/newhita_call_followed.png',
                                      width: 36,
                                      height: 36,
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: controller.handleFollow,
                                  child: Image.asset(
                                    'assets/images/newhita_call_follow.png',
                                    width: 36,
                                    height: 36,
                                  ),
                                );
                              }),
                            ],
                          )),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      if (!controller.audioMode.value)
                        Obx(() {
                          return GestureDetector(
                              onTap: controller.switchVoice,
                              child: !controller.abandVolume.value
                                  ? Image.asset(
                                      'assets/images/newhita_call_voice.png',
                                      width: 34,
                                      height: 34,
                                    )
                                  : Image.asset(
                                      'assets/images/newhita_call_voice_no.png',
                                      width: 34,
                                      height: 34,
                                    ));
                        }),
                      const SizedBox(
                        width: 8,
                      ),
                      if (!controller.audioMode.value)
                        NewHitaClickWidget(
                            onTap: controller.switchCamera,
                            child: Image.asset(
                              'assets/images/newhita_call_camera.png',
                              width: 34,
                              height: 34,
                            )),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                          onTap: () async {
                            if (controller.detail == null) return;
                            var result = await Get.bottomSheet(
                                TrudaSheetHostOption(
                                    herId: controller.detail!.userId!),
                                backgroundColor: Colors.transparent);
                            if (result == 1) {
                              controller.clickHangUp();
                            }
                          },
                          child: Image.asset(
                            'assets/images/newhita_call_report.png',
                            width: 34,
                            height: 34,
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                          onTap: () {
                            // Get.dialog(NewHitaDialogConfirm(
                            //   title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                            //   callback: (i) {
                            //     controller.clickHangUp();
                            //   },
                            // ));

                            TrudaCommonDialog.dialog(TrudaDialogConfirmHang(
                              title:
                                  TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                              callback: (i) {
                                if (i == 0) {
                                  controller.clickHangUp();
                                }
                              },
                              isPick: false,
                            ));
                          },
                          child: Image.asset(
                            'assets/images/newhita_call_leave.png',
                            width: 34,
                            height: 34,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  extendBodyBehindAppBar: true,
                  body: SizedBox.expand(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned.fill(
                          /// 这里是打电话Rtc页面
                          child: TrudaCallWidget(),
                        ),
                        Positioned(
                          child: NewHitaGiftFollowTip(
                            controller: controller.tipController,
                          ),
                        ),
                        // 顶部布局
                        PositionedDirectional(
                          top: appBarHeight + statusBarHeight + 5,
                          start: 10,
                          child: Obx(() {
                            return Visibility(
                              visible: !controller.cleanScreen.value,
                              child: Row(
                                children: [
                                  Obx(() => controller.callTimeStr.value.isEmpty
                                      ? const SizedBox()
                                      : Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: TrudaColors.baseColorRed,
                                        borderRadius: BorderRadius.circular(20)),
                                    height: 32,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: TrudaColors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          width: 4,
                                          height: 4,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Visibility(
                                          visible:
                                          controller.callTimeShowCard.value,
                                          child: Image.asset(
                                              'assets/images/newhita_me_cards.png'),
                                        ),
                                        Visibility(
                                          visible:
                                          controller.callTimeShowCard.value,
                                          child: const SizedBox(
                                            width: 5,
                                          ),
                                        ),
                                        Text(
                                          controller.callTimeStr.value,
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 4,
                                    height: 4,
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.bottomSheet(
                                  //       NewHitaContributeView(
                                  //         herId: controller.herId,
                                  //       ),
                                  //     );
                                  //   },
                                  //   child: Container(
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: 6, vertical: 3),
                                  //     decoration: BoxDecoration(
                                  //         color: Colors.black26,
                                  //         borderRadius: BorderRadius.circular(30)),
                                  //     child: Row(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       children: [
                                  //         Image.asset(
                                  //           'assets/images/newhita_call_contribution.png',
                                  //           width: 24,
                                  //           height: 24,
                                  //         ),
                                  //         const SizedBox(
                                  //           width: 4,
                                  //           height: 4,
                                  //         ),
                                  //         Text(
                                  //           TrudaLanguageKey
                                  //               .newhita_contribute_weekly.tr,
                                  //           style: const TextStyle(
                                  //               color: TrudaColors.white,
                                  //               fontSize: 14),
                                  //         ),
                                  //         const SizedBox(
                                  //           width: 4,
                                  //           height: 4,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Column(
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     GestureDetector(
                                  //       onTap: () => controller.clickCharge(),
                                  //       child: Container(
                                  //         padding: EdgeInsets.symmetric(
                                  //             horizontal: 6, vertical: 3),
                                  //         decoration: BoxDecoration(
                                  //             color: Colors.black26,
                                  //             borderRadius: BorderRadius.circular(30)),
                                  //         child: Row(
                                  //           mainAxisSize: MainAxisSize.min,
                                  //           children: [
                                  //             Image.asset(
                                  //               'assets/images/newhita_diamond_big.png',
                                  //               width: 24,
                                  //               height: 24,
                                  //             ),
                                  //             const SizedBox(
                                  //               width: 4,
                                  //               height: 4,
                                  //             ),
                                  //             Obx(() {
                                  //               return Text(
                                  //                 (controller.myMoney.value ?? 0)
                                  //                     .toString(),
                                  //                 style: const TextStyle(
                                  //                     color: TrudaColors.white,
                                  //                     fontSize: 14),
                                  //               );
                                  //             }),
                                  //             const SizedBox(
                                  //               width: 4,
                                  //               height: 4,
                                  //             ),
                                  //             Image.asset(
                                  //               'assets/images/newhita_arrow_right.png',
                                  //               width: 24,
                                  //               height: 24,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            );
                          }
                          ),
                        ),
                        // PositionedDirectional(
                        //     bottom: 30,
                        //     start: 0,
                        //     end: 0,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsetsDirectional.only(
                        //               start: 30, end: 30),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             crossAxisAlignment: CrossAxisAlignment.end,
                        //             children: [
                        //               Expanded(child: SizedBox()),
                        //               GestureDetector(
                        //                 onTap: controller.quickSendGift,
                        //                 child: Obx(() {
                        //                   var url =
                        //                       controller.giftToQuickSend.value.icon;
                        //                   if (url == null) {
                        //                     return Image.asset(
                        //                       'assets/newhita_call_gift.webp',
                        //                       width: 60,
                        //                       height: 60,
                        //                     );
                        //                   } else {
                        //                     return Container(
                        //                       width: 60,
                        //                       height: 60,
                        //                       decoration: BoxDecoration(
                        //                           color: Colors.black38,
                        //                           borderRadius:
                        //                               BorderRadius.circular(30)),
                        //                       alignment:
                        //                           AlignmentDirectional.center,
                        //                       child: NewHitaNetImage(
                        //                         url,
                        //                         width: 40,
                        //                         height: 40,
                        //                       ),
                        //                     );
                        //                   }
                        //                 }),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     )),
                        // Obx(() {
                        //   return AnimatedPositionedDirectional(
                        //     top: controller.showWelcome.value ? 60 : -100,
                        //     start: 0,
                        //     end: 0,
                        //     duration: const Duration(seconds: 1),
                        //     child: AspectRatio(
                        //       aspectRatio: 346 / 85,
                        //       child: Container(
                        //         decoration: const BoxDecoration(
                        //           image: DecorationImage(
                        //             image: AssetImage(
                        //               'assets/images/newhita_call_welcome.png',
                        //             ),
                        //           ),
                        //         ),
                        //         padding: EdgeInsets.symmetric(horizontal: 30),
                        //         alignment: Alignment.center,
                        //         child: AutoSizeText(
                        //           controller.welcomeText,
                        //           minFontSize: 8,
                        //           maxLines: 1,
                        //           style: TextStyle(color: TrudaColors.white),
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }),
                        Positioned(
                            left: 10,
                            right: 10,
                            top: 10,
                            bottom: 10,
                            child: NewHitaVapPlayer(
                              vapController: controller.myVapController,
                            )),
                      ],
                    ),
                  ),
                );
                }
              ),
            );
    });
  }

  Widget _connectWidget(TrudaCallController controller) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: TrudaColors.baseColorBlackBg,
          appBar: AppBar(
            // toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            leadingWidth: 0,
            titleSpacing: 0,
            // title: ,
            leading: SizedBox(),
            elevation: 0,
            centerTitle: false,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              NewHitaNetImage(
                controller.detail?.portrait ?? "",
                placeholder: (context, url) => const SizedBox(),
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
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TrudaLanguageKey.newhita_video_call_wait.tr,
                    style: const TextStyle(
                        color: TrudaColors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: Get.height / 10,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 67 / 50,
                        child: Image.asset(
                            'assets/images_ani/newhita_call_lights.webp'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: AspectRatio(
                          aspectRatio: 2 / 1,
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              var bottom = constraints.maxHeight * 36 / 394;
                              var w = constraints.maxWidth * 290 / 313;
                              return Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    PositionedDirectional(
                                      start: 45,
                                      child: Container(
                                        width: 115,
                                        height: 115,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images_sized/newhita_call_link_her.png'),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(15),
                                        child: NewHitaAvatarWithBg(
                                          url:
                                              controller.detail?.portrait ?? "",
                                        ),
                                      ),
                                    ),
                                    PositionedDirectional(
                                      end: 45,
                                      child: Container(
                                        width: 115,
                                        height: 115,
                                        padding: const EdgeInsets.all(15),
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images_sized/newhita_call_link_me.png'),
                                          ),
                                        ),
                                        child: NewHitaAvatarWithBg(
                                          url: TrudaMyInfoService
                                                  .to.myDetail?.portrait ??
                                              "",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images_ani/newhita_call_linking.webp',
                        width: 55,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height / 6,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.dialog(NewHitaDialogConfirm(
                      //   title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                      //   callback: (i) {
                      //     controller.clickHangUp();
                      //   },
                      // ));

                      TrudaCommonDialog.dialog(TrudaDialogConfirmHang(
                        title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                        callback: (i) {
                          if (i == 0) {
                            controller.clickHangUp();
                          }
                        },
                        isPick: false,
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Text(
                        TrudaLanguageKey.newhita_base_cancel.tr,
                        style: const TextStyle(
                            color: TrudaColors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
