import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/charge/truda_charge_new_controller.dart';
import 'package:truda/truda_routes/truda_pages.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_entities/truda_charge_quick_entity.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_widget/newhita_app_bar.dart';
import '../../truda_widget/newhita_click_widget.dart';
import '../../truda_widget/lottery_winner/truda_lottery_show_player.dart';
import '../../truda_widget/newhita_net_image.dart';

class TrudaChargeNewPage extends GetView<TrudaChargeNewController> {
  TrudaChargeNewPage({Key? key}) : super(key: key);
  final itemColor = const Color(0x33A965F5);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaChargeNewController>(builder: (contro) {
      final topPicH = context.width * 627 / 1125;
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            color: Colors.white,
            // child: NewHitaChargeItem(chargeController: controller),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leadingWidth: 100,
                  leading: GestureDetector(
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(start: 15),
                      alignment: AlignmentDirectional.centerStart,
                      child: Image.asset('assets/images/newhita_base_back.png',
                        matchTextDirection: true,),
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  actions: [
                    if (!TrudaConstants.isFakeMode)
                      GestureDetector(
                        child: Image.asset(
                            'assets/images/newhita_charge_history.png'),
                        onTap: () async {
                          Get.toNamed(TrudaAppPages.orderTab);
                        },
                      ),
                  ],
                  expandedHeight: topPicH,
                  backgroundColor: TrudaColors.white,
                  // foregroundColor: TrudaColors.white,
                  shadowColor: Colors.transparent,
                  // title: const Text('CustomScrollView 测试'),
                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SizedBox(
                        height: topPicH,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images_sized/newhita_charge_top.webp',
                              fit: BoxFit.fill,
                              matchTextDirection: true,
                            ),
                            // PositionedDirectional(
                            //     start: 0,
                            //     end: 0,
                            //     bottom: 30,
                            //     child: _top(contro)),
                          ],
                        ),
                      )),
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: TrudaColors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(20),
                          topEnd: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: _top(contro),
                // ),
                if (!TrudaConstants.isFakeMode)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 0),
                      child: AspectRatio(
                        aspectRatio: 1035 / 315,
                        child: Container(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              14,10, 100, 10),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images_sized/newhita_charge_lottery.webp'),
                              fit: BoxFit.fill,
                              matchTextDirection: true,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              TrudaLanguageKey.newhita_lottery_charge_tip.tr,
                              // TrudaLanguageKey.newhita_base_confirm.tr,
                              style: TextStyle(
                                  color: TrudaColors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: _cutProduct(contro),
                ),
                //卡片样式的item，意思就是一行可以排列多个
                contro.allProducts?.isNotEmpty != true
                    ? SliverToBoxAdapter(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: 300,
                          child: contro.firstIn
                              ? const CircularProgressIndicator()
                              : Image.asset(
                                  'assets/images/newhita_base_empty.png',
                                  height: 100,
                                  width: 100,
                                ),
                        ),
                      )
                    : SliverPadding(
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
          TrudaLotteryWinnerPlayer(
            vapController: controller.lotteryController,
          )
        ],
      );
    });
  }

  //
  Widget _top(TrudaChargeNewController controller) {
    return Padding(
      padding: EdgeInsets.all(14),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TrudaLanguageKey.newhita_mine_diamond.tr,
                  style: const TextStyle(color: TrudaColors.white, fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  decoration: BoxDecoration(
                      color: TrudaColors.baseColorTheme,
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
            )),
      ),
    );
  }

  // 折扣商品的展示
  Widget _cutProduct(TrudaChargeNewController controller) {
    if (controller.cutCommodite == null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () => controller.chooseCommodite(controller.cutCommodite!),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: itemColor,
              // border: Border.all(
              //   color: const Color(0xFF722425),
              //   width: 1,
              // ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/images_sized/newhita_diamond_big.png",
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
                    Row(
                      children: [
                        Text(
                          "${controller.cutCommodite?.value ?? '--'}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: TrudaColors.textColor333),
                        ),
                        if ((controller.cutCommodite?.bonus ?? 0) > 0)
                          Text.rich(
                            TextSpan(
                              text: "",
                              style: TextStyle(
                                  color: TrudaColors.baseColorTheme, fontSize: 12),
                              children: [
                                TextSpan(text: " +"),
                                TextSpan(
                                  text: "${controller.cutCommodite?.bonus ?? '--'}",
                                ),
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Image.asset(
                                      "assets/images/newhita_diamond_small.png",
                                      width: 12,
                                      height: 12,
                                    )),
                              ],
                            ),
                          )
                      ],
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
                          style: TextStyle(
                              color: TrudaColors.white, fontSize: 10),
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
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              TrudaColors.baseColorGradient1,
                              TrudaColors.baseColorGradient2,
                            ]),
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(20))),
                    child: Text(
                      // "${element.realCurrencySymbol} ${element.realPrice != null ? element.realPrice! / 100 : "--"}",
                      controller.cutCommodite?.showPrice ?? '',
                      style: TextStyle(
                          color: TrudaColors.white,
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

  Widget getGoogleItem(TrudaPayQuickCommodite commodite,
      TrudaChargeNewController controller) {
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
          color: itemColor,
          borderRadius: BorderRadiusDirectional.all(Radius.circular(15)),
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
                if ((commodite.bonus ?? 0) > 0)
                Text.rich(TextSpan(
                    text: "",
                    style: TextStyle(
                        color: TrudaColors.baseColorTheme, fontSize: 12),
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
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          TrudaColors.baseColorGradient1,
                          TrudaColors.baseColorGradient2,
                        ]),
                    borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(20))),
                child: Text(
                  // "${element.realCurrencySymbol} ${element.realPrice != null ? element.realPrice! / 100 : "--"}",
                  commodite.showPrice,
                  style: TextStyle(
                      color: TrudaColors.white,
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
}
