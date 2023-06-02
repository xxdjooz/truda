import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:truda/truda_utils/newhita_some_extension.dart';
import 'package:intl/intl.dart';

import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_dialogs/truda_dialog_invite_for_diamond.dart';
import '../../../truda_dialogs/truda_dialog_service.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_utils/ai/newhita_ai_logic_utils.dart';
import '../../../truda_widget/newhita_avatar_with_bg.dart';
import '../../chat/truda_chat_controller.dart';
import '../../vip/newhita_vip_controller.dart';
import 'truda_me_controller.dart';

class TrudaMePage extends StatelessWidget {
  TrudaMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TrudaMeController meController = Get.put(TrudaMeController());
    return GetBuilder<TrudaMeController>(
      initState: (c) {
        NewHitaLog.debug('NewHitaMePage initState()');
      },
      dispose: (c) {
        NewHitaLog.debug('NewHitaMePage dispose()');
      },
      builder: (controller) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/newhita_me_bg.png'),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth),
                ),
                child: RefreshIndicator(
                  onRefresh: controller.refreshMe,
                  child: CustomScrollView(slivers: [
                    const SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      leadingWidth: 100,
                      leading: SizedBox(),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 15),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    NewHitaAvatarWithBg(
                                      url: controller.myDetail?.portrait ?? '',
                                      width: 66,
                                      height: 66,
                                      padding: 2,
                                      placeholderAsset:
                                          'assets/images_sized/newhita_base_avatar.webp',
                                      isVip: controller.myDetail?.isVip == 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          LimitedBox(
                                            maxWidth: 150,
                                            child: Text(
                                              (controller.myDetail?.nickname ??
                                                      "")
                                                  .replaceNumByStar(),
                                              style: const TextStyle(
                                                color: TrudaColors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'ID:' +
                                                (controller
                                                        .myDetail?.username ??
                                                    ""),
                                            style: const TextStyle(
                                              color: TrudaColors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  child: Image.asset(
                                      'assets/images/newhita_me_edit.png'),
                                  onTap: () {
                                    Get.toNamed(NewHitaAppPages.myInfo);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Stack(
                              children: [
                                if (TrudaConstants.appMode != 2)
                                  PositionedDirectional(
                                    top: 0,
                                    start: 15,
                                    end: 15,
                                    child: GestureDetector(
                                      onTap: () {
                                        // NewHitaVipController.openMe();
                                        Get.toNamed(NewHitaAppPages.vip);
                                      },
                                      child: Builder(builder: (context) {
                                        bool isVipNow =
                                            controller.myDetail?.isVip == 1;
                                        String title = '';
                                        String btnText = TrudaLanguageKey
                                            .newhita_vip_active.tr;
                                        if (isVipNow) {
                                          btnText = TrudaLanguageKey
                                              .newhita_mine_to_charge.tr;
                                          int time =
                                              controller.myDetail!.vipEndTime!;
                                          var date = DateTime
                                              .fromMillisecondsSinceEpoch(time);
                                          var str = DateFormat('yyyy.MM.dd')
                                              .format(date);
                                          title = TrudaLanguageKey
                                              .newhita_vip_expire
                                              .trArgs([str]);
                                        }
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              top: 15,
                                              left: 15,
                                              right: 15,
                                              bottom: 35),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isVipNow
                                                  ? [
                                                      Color(0xffE07DE6),
                                                      Color(0xff8F62FB),
                                                    ]
                                                  : [
                                                      Color(0xff545784),
                                                      Color(0xff8F97A6),
                                                    ],
                                              begin: AlignmentDirectional
                                                  .centerStart,
                                              end: AlignmentDirectional
                                                  .centerEnd,
                                            ),
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                              topStart: Radius.circular(20),
                                              topEnd: Radius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Image.asset(isVipNow
                                                  ? 'assets/images/newhita_me_vip_yes.png'
                                                  : 'assets/images/newhita_me_vip_not.png'),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: isVipNow
                                                          ? [
                                                              Colors.white,
                                                              Colors.white,
                                                            ]
                                                          : [
                                                              Color(0xffFFDEB0),
                                                              Color(0xffFFA733),
                                                            ],
                                                      begin:
                                                          AlignmentDirectional
                                                              .centerStart,
                                                      end: AlignmentDirectional
                                                          .centerEnd,
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          TrudaColors.white,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Text(
                                                  btnText,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xffAF502E)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed((GetPlatform.isAndroid &&
                                                TrudaConstants.appMode != 2)
                                            ? NewHitaAppPages.googleCharge
                                            : NewHitaAppPages.iosCharge)
                                        ?.then((value) {});
                                    // Get.toNamed(NewHitaAppPages.iosCharge);
                                  },
                                  child: Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          top: 65),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25, horizontal: 15),
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/newhita_me_charge_bg.png'),
                                            //背景图片
                                            fit: BoxFit.fill,
                                            matchTextDirection: true),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        height: 80,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    TrudaLanguageKey
                                                        .newhita_mine_diamond
                                                        .tr,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Color(0xffA965F5)
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                      (controller
                                                                  .myDetail
                                                                  ?.userBalance
                                                                  ?.remainDiamonds ??
                                                              0)
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xffA965F5),
                                                          fontSize: 24),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.asset(
                                                'assets/images_ani/newhita_me_shop.webp',
                                                width: 100,
                                                height: 40,
                                              ),
                                            ),
                                            // Image.asset(
                                            //   'assets/images/newhita_me_charge_go.png',
                                            //   matchTextDirection: true,
                                            // ),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            // if (NewHitaAdsUtils.isShowAd(NewHitaAdsUtils.REWARD_PROFILE) &&
                            //     controller.rewardedUtils.isReady)
                            //   GestureDetector(
                            //     onTap: () =>
                            //         controller.rewardedUtils.showRewardAd(),
                            //     child: Container(
                            //         margin: EdgeInsets.only(
                            //             left: 20, right: 20, top: 10, bottom: 0),
                            //         height: 60,
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 5, horizontal: 10),
                            //         decoration: const BoxDecoration(
                            //           image: DecorationImage(
                            //             image: AssetImage(
                            //                 'assets/images/newhita_charge_quick_circle.png'),
                            //             //背景图片
                            //             fit: BoxFit.fill,
                            //           ),
                            //         ),
                            //         child: Row(
                            //           children: [
                            //             Image.asset(
                            //               "assets/images/newhita_ad_free_diamond.png",
                            //               width: 32,
                            //               height: 32,
                            //             ),
                            //             const SizedBox(
                            //               width: 10,
                            //             ),
                            //             Expanded(
                            //                 child: Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               mainAxisSize: MainAxisSize.max,
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               children: [
                            //                 Text(
                            //                   TrudaLanguageKey
                            //                       .gora_message_free_coins.tr,
                            //                   style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: 14,
                            //                       fontWeight: FontWeight.bold),
                            //                 ),
                            //                 SizedBox(
                            //                   height: 5,
                            //                 ),
                            //                 Text(
                            //                   TrudaLanguageKey
                            //                       .gora_message_free_coins_value.tr,
                            //                   maxLines: 1,
                            //                   overflow: TextOverflow.ellipsis,
                            //                   style: TextStyle(color: Colors.white),
                            //                 ),
                            //               ],
                            //             )),
                            //             Image.asset(
                            //               'assets/images/newhita_ad_go.png',
                            //               width: 24,
                            //               height: 24,
                            //               fit: BoxFit.fill,
                            //             ),
                            //           ],
                            //         )),
                            //   ),
                            if (!TrudaConstants.isFakeMode)
                              Obx(() {
                                var times = NewHitaMyInfoService
                                    .to.haveLotteryTimes.value;
                                if (times <= -1) {
                                  return const SizedBox();
                                } else {
                                  return ColoredBox(
                                    color: Colors.white,
                                    child: GestureDetector(
                                      onTap: () => Get.toNamed(
                                          NewHitaAppPages.lotteryPage,
                                          arguments: times),
                                      child: AspectRatio(
                                        aspectRatio: 345 / 56,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                // image: DecorationImage(
                                                //     image: AssetImage(
                                                //         'assets/images/newhita_lottery_last.png'),
                                                //     //背景图片
                                                //     fit: BoxFit.fill,
                                                //     matchTextDirection: true),
                                                // 渐变色
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xffFFEBA0),
                                                      Color(0xffFF8C6C),
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Image.asset(
                                                  'assets/images_sized/newhita_lottery_last.png',
                                                  height: 54,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Center(
                                                      child: Text(
                                                        TrudaLanguageKey
                                                            .newhita_lottery_times_last
                                                            .trArgs([
                                                          times.toString()
                                                        ]),
                                                        style: const TextStyle(
                                                            color: TrudaColors
                                                                .textColorTitle,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Image.asset(
                                                  'assets/images/newhita_arrow_right.png',
                                                  matchTextDirection: true,
                                                  color: Color(0xff9D4226),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  );
                                }
                              }),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: Container(
                          color: TrudaColors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (!TrudaConstants.isFakeMode)
                                _wItem(
                                  icon: 'assets/images/newhita_me_cards.png',
                                  title: TrudaLanguageKey
                                      .newhita_prop_package.tr,
                                  text: (controller.myDetail?.propCount !=
                                              null &&
                                          controller.myDetail?.propCount != 0)
                                      ? "×${controller.myDetail?.propCount}"
                                      : null,
                                  onTap: () {
                                    Get.toNamed(NewHitaAppPages.cardList);
                                  },
                                ),
                              if (!TrudaConstants.isFakeMode &&
                                  controller.myDetail?.boundGoogle == 0)
                                _wItem(
                                    icon: 'assets/images/newhita_me_google.png',
                                    title: TrudaLanguageKey
                                        .newhita_visitor_bind_google.tr,
                                    onTap: () {
                                      TrudaCommonDialog.dialog(
                                          TrudaDialogConfirm(
                                        title: TrudaLanguageKey
                                            .newhita_visitor_bind_google.tr,
                                        content: TrudaConstants.isFakeMode
                                            ? null
                                            : TrudaLanguageKey
                                                .newhita_card_send.tr,
                                        callback: (i) {
                                          controller.googleSignIn();
                                        },
                                      ));
                                    },
                                    endWidget: Image.asset(
                                      'assets/images_ani/newhita_bind_google_gift.webp',
                                      height: 30,
                                    )),
                              _wItem(
                                icon: 'assets/images/newhita_me_calls.png',
                                title: TrudaLanguageKey
                                    .newhita_conver_history.tr,
                                onTap: () {
                                  Get.toNamed(NewHitaAppPages.callList);
                                },
                              ),
                              _wItem(
                                icon: 'assets/images/newhita_me_circle.png',
                                title: TrudaLanguageKey.newhita_story_mine.tr,
                                text: null,
                                onTap: () {
                                  Get.toNamed(NewHitaAppPages.myMoment);
                                },
                              ),
                              // if (!NewHitaConstants.isFakeMode)
                              //   _wItem(
                              //     icon:
                              //         'assets/images/newhita_me_call_records.png',
                              //     title: TrudaLanguageKey
                              //         .newhita_conver_history.tr,
                              //     text: null,
                              //     onTap: () {
                              //       Get.toNamed(NewHitaAppPages.callList);
                              //     },
                              //   ),
                              if (TrudaConstants.appMode != 2)
                                _wItem(
                                  icon: 'assets/images/newhita_me_services.png',
                                  title: TrudaLanguageKey
                                      .newhita_mine_customer_service.tr,
                                  text: null,
                                  onTap: () {
                                    if (TrudaConstants.appMode > 0) {
                                      TrudaChatController.startMe(
                                          TrudaConstants.systemId);
                                      return;
                                    }
                                    TrudaShowService.checkToShow();
                                  },
                                ),
                              if (GetPlatform.isAndroid &&
                                  TrudaConstants.appMode != 2)
                                Builder(builder: (context) {
                                  final code =
                                      controller.myDetail?.inviterCode ?? '';
                                  return _wItem(
                                    icon: 'assets/images/newhita_me_code.png',
                                    title: TrudaLanguageKey
                                        .newhita_invite_bind.tr,
                                    text: code.isEmpty
                                        ? TrudaLanguageKey
                                            .newhita_invite_unbind.tr
                                        : code,
                                    onTap: () {
                                      if (code.isEmpty) {
                                        Get.toNamed(
                                                NewHitaAppPages.inviteBindPage)
                                            ?.then((value) {
                                          if (value == 1) {
                                            controller.refreshMe();
                                          }
                                        });
                                      } else {
                                        NewHitaLoading.toast(TrudaLanguageKey
                                            .newhita_invite_bound.tr);
                                      }
                                    },
                                  );
                                }),
                              if (GetPlatform.isAndroid &&
                                  TrudaConstants.appMode != 2)
                                _wItem(
                                  icon: 'assets/images/newhita_me_invite.png',
                                  title:
                                      TrudaLanguageKey.newhita_invite_code.tr,
                                  text: null,
                                  onTap: () =>
                                      Get.toNamed(NewHitaAppPages.invitePage),
                                ),
                              if (TrudaConstants.appMode != 2)
                                _wItem(
                                  icon: 'assets/images/newhita_me_setting.png',
                                  title: TrudaLanguageKey
                                      .newhita_mine_setting.tr,
                                  text: null,
                                  onTap: () =>
                                      Get.toNamed(NewHitaAppPages.setting),
                                )
                              else
                                ...getIosFakeList(),
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            getAi(),
            if (TrudaConstants.appMode != 2)
              PositionedDirectional(
                end: 15,
                bottom: 150,
                child: GestureDetector(
                  onTap: meController.getVipDiamond,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        'assets/images_ani/newhita_get_diamond.webp',
                        width: 60,
                        height: 60,
                      ),
                      Positioned(
                        bottom: -10,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffE07DE6),
                                Color(0xff8F62FB),
                              ],
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          constraints: BoxConstraints(maxWidth: 80),
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          child: AutoSizeText(
                            TrudaLanguageKey.newhita_vip_diamond.tr,
                            maxLines: 1,
                            minFontSize: 4,
                            maxFontSize: 14,
                            style: TextStyle(
                              color: TrudaColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  // ios 审核模式显示的
  List<Widget> getIosFakeList() {
    return [
      _wItem(
        icon: 'assets/images/newhita_me_about.png',
        title: TrudaLanguageKey.newhita_setting_about_us.tr,
        text: null,
        onTap: () => Get.toNamed(NewHitaAppPages.aboutUs),
      ),
      _wItem(
        icon: 'assets/images/newhita_me_black.png',
        title: TrudaLanguageKey.newhita_setting_black_list.tr,
        text: null,
        onTap: () => Get.toNamed(NewHitaAppPages.blackList),
      ),
      _wItem(
        icon: 'assets/images/newhita_me_cancel.png',
        title: TrudaLanguageKey.newhita_cancellation.tr,
        text: null,
        onTap: () {
          TrudaHttpUtil()
              .post(
            TrudaHttpUrls.delete_current_account,
            showLoading: true,
          )
              .then((value) {
            NewHitaAppPages.logout();
          });
        },
      ),
      _wItem(
        icon: 'assets/images/newhita_me_logout.png',
        title: TrudaLanguageKey.newhita_setting_logout.tr,
        text: null,
        onTap: () {
          TrudaCommonDialog.dialog(TrudaDialogConfirm(
            title: TrudaLanguageKey.newhita_login_logout.tr,
            callback: (i) {
              NewHitaAppPages.logout();
            },
          ));
        },
      ),
    ];
  }

  // 封装列表项目
  Widget _wItem({
    required String icon,
    required String title,
    String? text,
    Widget? endWidget,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(icon),
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: const TextStyle(color: TrudaColors.textColor333),
            ),
            const Spacer(),
            if (text != null)
              Text(
                text,
                style: const TextStyle(
                    color: TrudaColors.textColor999, fontSize: 12),
              ),
            if (endWidget != null) endWidget,
            const SizedBox(
              width: 4,
            ),
            Image.asset(
              'assets/images/newhita_arrow_right.png',
              matchTextDirection: true,
            ),
          ],
        ),
      ),
    );
  }

  var showAiInformation = false.obs;

  Widget getAi() {
    return (!TrudaConstants.haveTestLogin)
        ? const SizedBox()
        : Positioned(
            top: 60,
            right: 10,
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showAiInformation.toggle();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadiusDirectional.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'AI信息',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            showAiInformation.value
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  showAiInformation.value
                      ? IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius:
                                  BorderRadiusDirectional.circular(20),
                            ),
                            constraints: BoxConstraints(maxWidth: 200),
                            child: Text(
                              NewHitaAiLogicUtils().information.value,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              );
            }),
          );
  }
}
