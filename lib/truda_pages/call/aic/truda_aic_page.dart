import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_widget/truda_decoration_bg.dart';
import 'package:truda/truda_widget/truda_net_image.dart';

import '../../../truda_common/truda_language_key.dart';
import '../../../truda_dialogs/truda_dialog_confirm_hang.dart';
import '../../../truda_dialogs/truda_sheet_host_option.dart';
import '../../../truda_widget/gift/truda_vap_player.dart';
import '../../../truda_widget/truda_click_widget.dart';
import '../truda_contribute_view.dart';
import 'truda_aic_controller.dart';
import 'truda_aic_widget.dart';

class TrudaAicPage extends GetView<TrudaAicController> {
  TrudaAicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 全局topPadding高度
    double statusBarHeight = MediaQuery.of(context).padding.top;
    // AppBar 高度
    double appBarHeight = kToolbarHeight;
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<TrudaAicController>(builder: (controller) {
        return controller.connecting
            ? _connectWidget()
            : Scaffold(
                appBar: AppBar(
                  // toolbarHeight: 100,
                  leadingWidth: 0,
                  titleSpacing: 0,
                  // title: ,
                  leading: SizedBox(),
                  centerTitle: false,
                  title: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Stack(
                      children: [
                        Container(
                            margin:
                                EdgeInsetsDirectional.only(start: 10, end: 30),
                            decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TrudaNetImage(
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
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LimitedBox(
                                      child: Text(
                                        controller.detail?.nickname ?? "",
                                        // "aaa aa aa aa aa aa aa aa aa aa aa aa aa aa aa",
                                        style: const TextStyle(
                                            color: TrudaColors.white,
                                            fontSize: 14),
                                        maxLines: 1,
                                      ),
                                      maxWidth: 150,
                                    ),
                                    // Text(
                                    //   'ID:' +
                                    //       (controller.detail?.username ?? ""),
                                    //   // "aaa aa",
                                    //   style: const TextStyle(
                                    //       color: TrudaColors.white,
                                    //       fontSize: 12),
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                        PositionedDirectional(
                            end: 0,
                            top: 0,
                            bottom: 0,
                            child: Obx(() {
                              if (controller.followed.value == 1) {
                                return const SizedBox();
                              }
                              return GestureDetector(
                                onTap: controller.handleFollow,
                                child: Image.asset(
                                    'assets/images/newhita_call_follow.png'),
                              );
                            })),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
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
                      width: 10,
                    ),
                    TrudaClickWidget(
                        onTap: controller.switchCamera,
                        child: Image.asset(
                          'assets/images/newhita_call_camera.png',
                          width: 34,
                          height: 34,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (controller.detail == null) return;
                          // showModalBottomSheet(
                          //     context: context,
                          //     backgroundColor: Colors.transparent,
                          //     builder: (context) {
                          //       return NewHitaSheetHostOption(
                          //           herId: controller.detail!.userId!);
                          //     });

                          var result = await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return TrudaSheetHostOption(
                                    herId: controller.detail!.userId!);
                              });
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
                      width: 10,
                    ),
                    GestureDetector(
                        // onTap: controller.clickHangUp,
                        onTap: () {
                          // Get.dialog(NewHitaDialogConfirm(
                          //   title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                          //   callback: (i) {
                          //     controller.clickHangUp();
                          //   },
                          // ));

                          Get.dialog(TrudaDialogConfirmHang(
                            title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
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
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: TrudaAicWidget(),
                    ),
                    // 顶部布局
                    PositionedDirectional(
                      top: appBarHeight + statusBarHeight + 5,
                      start: 10,
                      child: Row(
                        children: [
                          Obx(() => controller.callTimeStr.value.isEmpty
                              ? const SizedBox()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: TrudaColors.baseColorRed,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        visible: controller.callTime < 0,
                                        child: Image.asset(
                                            'assets/images/newhita_me_cards.png'),
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
                          //           TrudaLanguageKey.newhita_contribute_weekly.tr,
                          //           style: const TextStyle(
                          //               color: TrudaColors.white, fontSize: 14),
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
                    ),
                    // Positioned(
                    //   bottom: 30,
                    //   left: 50,
                    //   right: 50,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     children: [
                    //       // GestureDetector(
                    //       //   onTap: () => controller.clickCharge(),
                    //       //   child: Image.asset(
                    //       //     'assets/newhita_call_gift.png',
                    //       //     width: 60,
                    //       //     height: 60,
                    //       //   ),
                    //       // ),
                    //       // Padding(
                    //       //   padding: const EdgeInsets.only(bottom: 15),
                    //       //   child: GestureDetector(
                    //       //       onTap: controller.clickGift,
                    //       //       child: Image.asset('assets/newhita_call_gift.webp',
                    //       //           width: 60, height: 60)),
                    //       // ),
                    //       Expanded(child: SizedBox()),
                    //       GestureDetector(
                    //         onTap: controller.quickSendGift,
                    //         child: Obx(() {
                    //           var url = controller.giftToQuickSend.value.icon;
                    //           if (url == null) {
                    //             return Image.asset('assets/newhita_call_gift.webp',
                    //                 width: 60, height: 60);
                    //           } else {
                    //             return Container(
                    //               width: 60,
                    //               height: 60,
                    //               decoration: BoxDecoration(
                    //                   color: Color(0xFF2A1223),
                    //                   borderRadius: BorderRadius.circular(30)),
                    //               alignment: AlignmentDirectional.center,
                    //               child: NewHitaNetImage(
                    //                 url,
                    //                 width: 40,
                    //                 height: 40,
                    //               ),
                    //             );
                    //           }
                    //         }),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Positioned(
                        left: 10,
                        right: 10,
                        top: 10,
                        bottom: 10,
                        child: TrudaVapPlayer(
                          vapController: controller.myVapController,
                        ))
                  ],
                ),
              );
      }),
    );
  }

  Widget _connectWidget() {
    return Scaffold(
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: Container(
          decoration: const TrudaDecorationBg(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 130,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 35,
                      child: Transform.rotate(
                        angle: pi / 12.0,
                        child: TrudaNetImage(
                          controller.detail?.portrait ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                              width: 150,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 35,
                      child: Transform.rotate(
                        angle: -pi / 12.0,
                        child: TrudaNetImage(
                          TrudaMyInfoService.to.userLogin?.portrait ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                              width: 150,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset('assets/images_ani/newhita_call_linking.webp')
            ],
          ),
        ));
  }
}
