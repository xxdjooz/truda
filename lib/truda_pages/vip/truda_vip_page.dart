import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:truda/truda_common/truda_charge_path.dart';
import 'package:truda/truda_pages/vip/truda_vip_controller.dart';
import 'package:truda/truda_widget/newhita_app_bar.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_common/truda_constants.dart';
import '../../truda_common/truda_language_key.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_widget/newhita_gradient_button.dart';

class TrudaVipPage extends GetView<TrudaVipController> {
  TrudaVipPage({Key? key}) : super(key: key);
  final currentIndex = 0.obs;
  final currentChargeIndex = 0.obs;
  final String createPath = TrudaChargePath.recharge_vip;
  final picGroup = [
    'assets/images/newhita_vip_right_diamond.png',
    'assets/images/newhita_vip_right_msg.png',
    'assets/images/newhita_vip_right_match.png',
    'assets/images/newhita_vip_right_country.png',
    'assets/images/newhita_vip_right_gift.png',
    'assets/images/newhita_vip_right_logo.png',
    if (TrudaConstants.appMode != 2)
      'assets/images/newhita_vip_right_album.png',
  ];
  final textGroup = [
    TrudaLanguageKey.newhita_vip_welfare_diamond.trArgs(
        [(TrudaMyInfoService.to.config?.vipDailyDiamonds ?? 10).toString()]),
    TrudaLanguageKey.newhita_vip_welfare_message.tr,
    TrudaLanguageKey.newhita_vip_welfare_match.tr,
    TrudaLanguageKey.newhita_vip_welfare_country.tr,
    TrudaLanguageKey.newhita_vip_welfare_gift.tr,
    TrudaLanguageKey.newhita_vip_welfare_logo.tr,
    if (TrudaConstants.appMode != 2)
      TrudaLanguageKey.newhita_vip_welfare_albums.tr,
  ];

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<TrudaVipController>(
        () => TrudaVipController()..createPath = createPath);
    return GetBuilder<TrudaVipController>(builder: (contr) {
      return Scaffold(
        appBar: NewHitaAppBar(
          leading: GestureDetector(
            onTap: () => Navigator.maybePop(Get.context!),
            child: Container(
              padding: const EdgeInsetsDirectional.only(start: 15),
              alignment: AlignmentDirectional.centerStart,
              child: Image.asset(
                'assets/images/newhita_base_back.png',
                matchTextDirection: true,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            TrudaLanguageKey.newhita_vip_buy.tr,
            style: const TextStyle(
              color: TrudaColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xff301C40),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Builder(builder: (context) {
                      bool isVipNow = controller.myDetail?.isVip == 1;
                      String title = TrudaLanguageKey.newhita_vip.tr;
                      String btnText = TrudaLanguageKey.newhita_vip_active.tr;
                      if (isVipNow) {
                        btnText = TrudaLanguageKey.newhita_mine_to_charge.tr;
                        int time = controller.myDetail!.vipEndTime!;
                        var date = DateTime.fromMillisecondsSinceEpoch(time);
                        var str = DateFormat('yyyy.MM.dd').format(date);
                        btnText =
                            TrudaLanguageKey.newhita_vip_expire.trArgs([str]);
                      }
                      return isVipNow
                          ? AspectRatio(
                              aspectRatio: 75 / 29,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images_sized/newhita_vip_center_head.png',
                                  ),
                                  Positioned(
                                    left: Get.width * 30 / 375,
                                    top: Get.width * 50 / 375,
                                    child: Text(
                                      btnText,
                                      style: TextStyle(
                                        color: TrudaColors.textColor333,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: 75 / 29,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images_sized/newhita_vip_center_head_gray.png',
                                  ),
                                  Positioned(
                                    left: Get.width * 30 / 375,
                                    top: Get.width * 50 / 375,
                                    child: Text(
                                      btnText,
                                      style: TextStyle(
                                        color: TrudaColors.textColor333,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    }),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AspectRatio(
                        aspectRatio: 75 / 21,
                        child: SizedBox(width: double.infinity),
                      ),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 10,
                          childAspectRatio: 105 / 115,
                          crossAxisCount: 3,
                        ),
                        itemCount:
                            TrudaVipController.payQuickData?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return _getVipItem(index);
                        },
                      ),
                      NewHitaGradientButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        onTap: () {
                          final bean = TrudaVipController
                              .payQuickData![currentChargeIndex.value];
                          controller.chooseCommdite(bean);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            TrudaLanguageKey.newhita_base_confirm.tr,
                            style: TextStyle(
                              color: TrudaColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AspectRatio(
                aspectRatio: 69 / 14,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images_sized/newhita_vip_center_right.png'))),
                  child: AutoSizeText(
                    TrudaLanguageKey.newhita_vip_rights.tr,
                    maxLines: 1,
                    maxFontSize: 14,
                    minFontSize: 8,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TrudaColors.white,
                    ),
                  ),
                ),
              ),
              ...List.generate(
                picGroup.length,
                (index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Image.asset(
                        picGroup[index],
                        width: 42,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              TrudaLanguageKey.newhita_vip_welfare
                                  .trArgs(['${index + 1}']),
                              maxLines: 1,
                              maxFontSize: 14,
                              minFontSize: 8,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: TrudaColors.white,
                              ),
                            ),
                            AutoSizeText(
                              textGroup[index],
                              maxLines: 1,
                              maxFontSize: 14,
                              minFontSize: 8,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: TrudaColors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _getVipItem(int index) {
    return Obx(() {
      final isChoosed = index == currentChargeIndex.value;
      var list = TrudaVipController.payQuickData!;
      var bean = list[index];
      return GestureDetector(
        onTap: () {
          currentChargeIndex.value = index;
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isChoosed
                        ? const Color(0xFFA965F5)
                        : const Color(0xFF643A90),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      TrudaLanguageKey.newhita_vip_days
                          .trArgs([(bean.vipDays ?? 0).toString()]),
                      maxLines: 1,
                      maxFontSize: 14,
                      minFontSize: 8,
                      style: TextStyle(
                          color: isChoosed
                              ? TrudaColors.white
                              : TrudaColors.white.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "",
                        style: TextStyle(
                            color: TrudaColors.baseColorYellow, fontSize: 12),
                        children: [
                          TextSpan(text: " +"),
                          TextSpan(
                            text: "${bean.value}",
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Image.asset(
                              "assets/images/newhita_diamond_small.png",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const AspectRatio(
                    //   aspectRatio: 210 / 84,
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AspectRatio(
                aspectRatio: 210 / 84,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        isChoosed
                            ? "assets/images_sized/newhita_vip_selected.png"
                            : "assets/images_sized/newhita_vip_select_not.png",
                      ),
                    ),
                  ),
                  alignment: Alignment(0.0, 0.2),
                  child: AutoSizeText(
                    bean.showPrice,
                    maxLines: 2,
                    maxFontSize: 14,
                    minFontSize: 8,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isChoosed
                          ? TrudaColors.white
                          : TrudaColors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
