import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_pages/vip/newhita_vip_controller.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_common/truda_constants.dart';
import '../../truda_common/truda_language_key.dart';
import '../../truda_services/newhita_my_info_service.dart';
import '../../truda_widget/newhita_gradient_button.dart';
import '../../truda_widget/newhita_net_image.dart';

class NewHitaVipDialog extends GetView<NewHitaVipController> {
  static bool showing = false;

  NewHitaVipDialog({Key? key, this.createPath = ''}) : super(key: key);
  final currentIndex = 0.obs;
  final currentChargeIndex = 0.obs;
  final String createPath;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<NewHitaVipController>(
        () => NewHitaVipController()..createPath = createPath);
    return GetBuilder<NewHitaVipController>(
      initState: (state) {
        showing = true;
      },
      dispose: (state) {
        showing = false;
      },
      builder: (contr) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images_sized/newhita_charge_quick_pic.png',
                  height: 50,
                ),
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xffD3ABFF),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                    // border: Border.all(
                    //   color: const Color(0xffD3ABFF),
                    //   width: 2,
                    // ),
                  ),
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xffA965F5),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                      // border: Border.all(
                      //   color: const Color(0xffD3ABFF),
                      //   width: 2,
                      // ),
                    ),
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xff7942B5),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50)),
                      ),
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Color(0xff301C40),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                ),
                // 解决列里面两个同色块会有缝隙问题
                Container(
                  height: 0,
                  decoration: BoxDecoration(
                    color: const Color(0xff301C40),
                    border:
                        Border.all(width: 0, color: const Color(0xff301C40)),
                  ),
                ),
                Container(
                  color: const Color(0xff301C40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 22,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              TrudaLanguageKey.newhita_vip_buy.tr,
                              style: const TextStyle(
                                color: TrudaColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsetsDirectional.all(5),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Image.asset(
                                    'assets/images/newhita_base_close.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      _getBanner(),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              TrudaConstants.appMode != 2 ? 7 : 6,
                              (index) => index).map((entry) {
                            return Container(
                              width: currentIndex.value == entry ? 12 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white.withOpacity(
                                      currentIndex.value == entry ? 0.8 : 0.2)),
                            );
                          }).toList(),
                        );
                      }),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 10,
                          childAspectRatio: 105 / 115,
                          crossAxisCount: 3,
                        ),
                        itemCount:
                            NewHitaVipController.payQuickData?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return _getVipItem(index);
                        },
                      ),
                      NewHitaGradientButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        onTap: () {
                          final bean = NewHitaVipController
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getBanner() {
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
      TrudaLanguageKey.newhita_vip_welfare_diamond.trArgs([
        (NewHitaMyInfoService.to.config?.vipDailyDiamonds ?? 10).toString()
      ]),
      TrudaLanguageKey.newhita_vip_welfare_message.tr,
      TrudaLanguageKey.newhita_vip_welfare_match.tr,
      TrudaLanguageKey.newhita_vip_welfare_country.tr,
      TrudaLanguageKey.newhita_vip_welfare_gift.tr,
      TrudaLanguageKey.newhita_vip_welfare_logo.tr,
      if (TrudaConstants.appMode != 2)
        TrudaLanguageKey.newhita_vip_welfare_albums.tr,
    ];
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1,
          aspectRatio: 346 / 122.0,
          enableInfiniteScroll: true,
          autoPlay: true,
          onPageChanged: (int index, CarouselPageChangedReason reason) {
            // upListController.indicatorIndex.value = index;
            currentIndex.value = index;
          }),
      items: List.generate(
        picGroup.length,
        (index) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              picGroup[index],
              width: 75,
            ),
            AutoSizeText(
              TrudaLanguageKey.newhita_vip_welfare.trArgs(['${index + 1}']),
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
    );
  }

  Widget _getVipItem(int index) {
    return Obx(() {
      final isChoosed = index == currentChargeIndex.value;
      var list = NewHitaVipController.payQuickData!;
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
