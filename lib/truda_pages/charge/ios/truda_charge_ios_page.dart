import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_entities/truda_charge_quick_entity.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_services/truda_my_info_service.dart';
import '../../../truda_widget/newhita_app_bar.dart';
import '../../../truda_widget/newhita_click_widget.dart';
import '../../../truda_widget/lottery_winner/newhita_lottery_show_player.dart';
import 'truda_charge_ios_controller.dart';

class TrudaChargeIosPage extends GetView<TrudaChargeIosController> {
  TrudaChargeIosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaChargeIosController>(builder: (contro) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            appBar: NewHitaAppBar(
              title: Text(TrudaLanguageKey.newhita_recharge.tr),
              actions: [
                if (!TrudaConstants.isFakeMode)
                  GestureDetector(
                    child: Image.asset('assets/images/newhita_charge_history.png'),
                    onTap: () async {
                      Get.toNamed(TrudaAppPages.orderTab);
                    },
                  ),
              ],
              bottom: TrudaConstants.isFakeMode ? null : PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                      color: TrudaColors.baseColorRedLight.withOpacity(0.1)),
                  child: Center(
                    child: Text(
                      TrudaLanguageKey.newhita_lottery_charge_tip.tr,
                      // TrudaLanguageKey.newhita_base_confirm.tr,
                      style: TextStyle(
                          color: TrudaColors.baseColorRed, fontSize: 12),
                    ),
                  ),
                ),
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),

            extendBodyBehindAppBar: false,
            backgroundColor: TrudaColors.baseColorBlackBg,
            body: contro.allProducts?.isNotEmpty != true
                ? ListView(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 300,
                        child: contro.firstIn
                            ? const CircularProgressIndicator()
                            : Image.asset(
                                'assets/images/newhita_base_empty.png',
                                height: 100,
                                width: 100,
                              ),
                      )
                    ],
                  )
                : Container(
              height: double.infinity,
              padding: EdgeInsetsDirectional.only(
                top: 10,
              ),
              // child: NewHitaChargeItem(chargeController: controller),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _top(),
                  ),
                  if (!TrudaConstants.isFakeMode)
                  SliverToBoxAdapter(
                    child: _cutProduct(contro),
                  ),
                  //卡片样式的item，意思就是一行可以排列多个
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    sliver: SliverGrid(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        crossAxisCount: 1,
                        childAspectRatio: 5 / 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          var products = contro.allProducts!;
                          return getGoogleItem(products[index], contro);
                        },
                        //item条数
                        childCount: contro.allProducts!.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          NewHitaLotteryWinnerPlayer(
            vapController: controller.lotteryController,
          )
        ],
      );
    });
  }

  // 折扣商品的展示
  Widget _cutProduct(TrudaChargeIosController controller) {
    if (controller.cutCommodite == null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () => controller.chooseCommodite(controller.cutCommodite!),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: TrudaColors.white,
              // border: Border.all(
              //   color: const Color(0xFF722425),
              //   width: 1,
              // ),
              borderRadius: BorderRadius.circular(52),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/images_ani/newhita_home_charge.webp",
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                  height: 10,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${controller.cutCommodite?.value ?? '--'}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: TrudaColors.textColor333),
                        ),
                        Padding(
                          // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  TrudaColors.baseColorRed,
                                  TrudaColors.baseColorOrange,
                                ]),
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(12),
                                  bottomEnd: Radius.circular(12),
                                )),
                            padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            child: Text(
                              "${TrudaLanguageKey.newhita_base_percent_location.trArgs([
                                controller.cutCommodite?.discount?.toString() ??
                                    '--'
                              ])} ${TrudaLanguageKey.newhita_base_off.tr}",
                              textAlign: TextAlign.start,
                              style:
                              TextStyle(color: TrudaColors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    )),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 62,
                  ),
                  child: Container(
                    padding: EdgeInsetsDirectional.only(start: 9, end: 9),
                    alignment: Alignment.center,
                    height: 36,
                    decoration: BoxDecoration(
                        color: TrudaColors.baseColorPink,
                        borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(20))),
                    child: Text(
                      // "${element.realCurrencySymbol} ${element.realPrice != null ? element.realPrice! / 100 : "--"}",
                      controller.cutCommodite?.showPrice ?? '',
                      style: TextStyle(
                          color: TrudaColors.textColor333,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getGoogleItem(
      TrudaPayQuickCommodite commodite, TrudaChargeIosController controller) {
    return NewHitaClickWidget(
      onTap: () async {
        // bool hasNotCompleteTransactions =
        // await CblGlInAppPurchase.hasNotCompleteTransactions();
        // if (hasNotCompleteTransactions) {
        //   return;
        // }
        // chargeController.createOrder(element, payData);
        controller.chooseCommodite(commodite);
      },
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       TrudaColors.baseColorGradient1,
          //       TrudaColors.baseColorGradient2,
          //     ]),
          color: TrudaColors.white,
          borderRadius: BorderRadiusDirectional.all(Radius.circular(52)),
        ),
        // margin: EdgeInsetsDirectional.only(bottom: 10.h),
        padding: EdgeInsetsDirectional.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 5),
              width: 44,
              height: 44,
              child: Image.asset(
                "assets/images_sized/newhita_diamond_big.png",
                // "assets/newhita_me_charge.webp",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${commodite.value ?? "--"}",
                  style: TextStyle(
                      color: TrudaColors.textColor333,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                  width: 5,
                ),
                if (!TrudaConstants.isFakeMode)
                Text.rich(TextSpan(
                    text: "",
                    style: TextStyle(
                        color: TrudaColors.baseColorYellow, fontSize: 12),
                    children: [
                      TextSpan(text: "+"),
                      TextSpan(
                        text: "${commodite.bonus}",
                      ),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Image.asset(
                            "assets/images/newhita_diamond_small.png",
                            width: 14,
                            height: 14,
                          )),
                    ])),
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                  width: 10,
                ),
              ],
            ),
            Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 62,
              ),
              child: Container(
                padding: EdgeInsetsDirectional.only(start: 9, end: 9),
                alignment: Alignment.center,
                height: 36,
                decoration: BoxDecoration(
                    color: TrudaColors.baseColorPink,
                    borderRadius:
                    BorderRadiusDirectional.all(Radius.circular(20))),
                child: Text(
                  // "${element.realCurrencySymbol} ${element.realPrice != null ? element.realPrice! / 100 : "--"}",
                  commodite.showPrice,
                  style: TextStyle(
                      color: TrudaColors.textColor333,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //
  Widget _top() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 345 / 108,
        child: Container(
          // padding: EdgeInsets.symmetric(
          //     vertical: 10, horizontal: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/newhita_charge_head.png'),
                  //背景图片
                  fit: BoxFit.fill,
                  matchTextDirection: true),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TrudaLanguageKey.newhita_mine_diamond.tr,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      (TrudaMyInfoService
                          .to.myDetail?.userBalance?.remainDiamonds ??
                          0)
                          .toString(),
                      style: const TextStyle(
                          color: TrudaColors.white, fontSize: 24),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
