import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_widget/newhita_ball_beat.dart';
import 'package:truda/truda_widget/newhita_click_widget.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_dialogs/truda_sheet_host_option.dart';
import '../../../truda_widget/newhita_decoration_bg.dart';
import '../../../truda_widget/newhita_gradient_button.dart';
import '../../chat/newhita_chat_controller.dart';
import '../local/truda_local_controller.dart';
import 'truda_end_controller.dart';

// 结算页面
class TrudaEndPage extends StatelessWidget {
  TrudaEndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaEndController>(
        tag: DateTime.now().millisecondsSinceEpoch.toString(),
        init: TrudaEndController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: TrudaColors.baseColorBlackBg,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () => Navigator.maybePop(Get.context!),
                child: Container(
                  padding: const EdgeInsetsDirectional.only(start: 15),
                  alignment: AlignmentDirectional.centerStart,
                  child: Image.asset(
                    'assets/images/newhita_base_back.png',
                    color: Colors.white,
                    matchTextDirection: true,
                  ),
                ),
              ),
              actions: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (controller.detail == null) return;
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return TrudaSheetHostOption(
                                herId: controller.detail!.userId!);
                          });
                    },
                    child: Image.asset('assets/images/newhita_call_report.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       Get.back();
                //     },
                //     child: Image.asset('assets/images/newhita_call_leave.png'),
                //   ),
                // ),
                // SizedBox(
                //   width: 10,
                // )
              ],
            ),
            body: Container(
                decoration: const NewHitaDecorationBg(),
                child: Stack(
                  fit: StackFit.expand,
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
                              filter: ImageFilter.blur(
                                  sigmaX: 40, sigmaY: 40), //背景模糊化
                              child: Container(
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const AspectRatio(aspectRatio: 4),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            fit: StackFit.loose,
                            children: [
                              NewHitaNetImage(
                                controller.detail?.portrait ?? "",
                                width: 105,
                                height: 105,
                                imageBuilder: (context, provider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: provider, fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: TrudaColors.white, width: 2),
                                    ),
                                  );
                                },
                              ),
                              if (controller.detail != null)
                                GestureDetector(
                                  // onTap: _controller.handleFollow,
                                  onTap: () {
                                    if (controller.detail!.followed == 1) {
                                      TrudaCommonDialog.dialog(
                                          TrudaDialogConfirm(
                                        title: TrudaLanguageKey
                                            .newhita_details_tip.tr,
                                        callback: (i) {
                                          controller.handleFollow();
                                        },
                                      ));
                                    } else {
                                      controller.handleFollow();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: controller.detail!.followed == 1
                                          ? TrudaColors.white
                                          : TrudaColors.baseColorTheme,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: controller.detail!.followed == 1
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                  'assets/images/newhita_host_followed.png'),
                                              const SizedBox(
                                                width: 4,
                                                height: 4,
                                              ),
                                              Text(
                                                TrudaLanguageKey
                                                    .newhita_details_following
                                                    .tr,
                                                style: const TextStyle(
                                                  color: TrudaColors
                                                      .baseColorTheme,
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                  'assets/images/newhita_host_follow.png'),
                                              const SizedBox(
                                                width: 4,
                                                height: 4,
                                              ),
                                              Text(
                                                TrudaLanguageKey
                                                    .newhita_details_follow.tr,
                                                style: const TextStyle(
                                                  color: TrudaColors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          Text(
                            controller.detail?.nickname ?? "",
                            style: const TextStyle(
                                color: TrudaColors.white, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 15,
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Colors.transparent,
                                Colors.white12,
                                Colors.transparent,
                              ]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Obx(() => (controller.endCallEntity.value ==
                                        null)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          NewHitaBallBeatIndicator(),
                                        ],
                                      )
                                    : Builder(builder: (context) {
                                        var callTime = controller.endCallEntity
                                                .value?.callTime ??
                                            '';
                                        final usedDiamond =
                                            callTime.isNotEmpty &&
                                                callTime != '00:00' &&
                                                callTime != '00:00:00';
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (usedDiamond)
                                              Text(
                                                controller.endCallEntity.value
                                                        ?.callTime ??
                                                    '',
                                                style: TextStyle(
                                                    color: TrudaColors.white,
                                                    fontSize: 22),
                                              ),
                                            if (usedDiamond &&
                                                controller.endCallEntity.value
                                                        ?.usedProp ==
                                                    true)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                      color:
                                                          TrudaColors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            if (controller.endCallEntity.value
                                                    ?.usedProp ==
                                                true)
                                              Image.asset(
                                                  'assets/images/newhita_call_card.png'),
                                          ],
                                        );
                                      })),
                                const SizedBox(
                                  width: 10,
                                  height: 10,
                                ),
                                Text(
                                  TrudaLanguageKey
                                      .newhita_video_chat_duration.tr,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(() => Text(
                                                  "${controller.endCallEntity.value?.callAmount ?? "--"}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          TrudaColors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Image.asset(
                                              "assets/images/newhita_diamond_small.png",
                                              // width: 30,
                                              // height: 30,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                          height: 10,
                                        ),
                                        Text(
                                          TrudaLanguageKey
                                              .newhita_call_cast.tr,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                  height: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(() => Text(
                                                  "${controller.endCallEntity.value?.giftAmount ?? "--"}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          TrudaColors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Image.asset(
                                              "assets/images/newhita_diamond_small.png",
                                              // width: 30,
                                              // height: 30,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                          height: 10,
                                        ),
                                        Text(
                                          TrudaLanguageKey
                                              .newhita_present_consumption.tr,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          if (controller.detail != null)
                            Builder(builder: (context) {
                              final detail = controller.detail!;
                              var herOn = detail.isShowOnline;
                              return GestureDetector(
                                onTap: () {
                                  if (herOn) {
                                    TrudaLocalController.startMe(
                                        detail.userId!, detail.portrait,
                                        closeSelf: true);
                                  } else {
                                    NewHitaChatController.startMe(
                                        detail.userId!);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      end: 15, start: 15),
                                  height: 52,
                                  decoration: herOn
                                      ? BoxDecoration(
                                          gradient:
                                              const LinearGradient(colors: [
                                            TrudaColors.baseColorGradient1,
                                            TrudaColors.baseColorGradient2,
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        )
                                      : const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          gradient:
                                              const LinearGradient(colors: [
                                            TrudaColors.baseColorGradient1,
                                            TrudaColors.baseColorGradient2,
                                          ]),
                                        ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: herOn
                                            ? Image.asset(
                                                "assets/images_ani/newhita_host_call.webp",
                                                width: 34,
                                                height: 34,
                                              )
                                            : Image.asset(
                                                "assets/images/newhita_host_msg.png",
                                                width: 34,
                                                height: 34,
                                              ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      herOn
                                          ? Text(
                                              TrudaLanguageKey
                                                  .newhita_grade_video_chat.tr,
                                              style: const TextStyle(
                                                  color: TrudaColors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              TrudaLanguageKey
                                                  .newhita_message_title.tr,
                                              style: const TextStyle(
                                                  color: TrudaColors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          const SizedBox(
                            height: 15,
                          ),
                          NewHitaClickWidget(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsetsDirectional.only(
                                  end: 15, start: 15),
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                TrudaLanguageKey.newhita_base_confirm.tr,
                                style: TextStyle(
                                    color: TrudaColors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 160,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
