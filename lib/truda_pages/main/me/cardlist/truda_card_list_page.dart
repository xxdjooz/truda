import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/main/truda_main_controller.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import 'truda_card_list_controller.dart';

class TrudaCardListPage extends GetView<TrudaCardListController> {
  TrudaCardListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaCardListController>(builder: (contro) {
      return Scaffold(
        appBar: NewHitaAppBar(
          title: Text(
            TrudaLanguageKey.newhita_prop_package.tr,
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: GetBuilder<TrudaCardListController>(builder: (controller) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: controller.dataList.isEmpty
                ? ListView(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 300,
                        child: Image.asset(
                          'assets/images/newhita_base_empty.png',
                          height: 100,
                          width: 100,
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: controller.dataList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var bean = controller.dataList[index];
                      // 1.通话体验卡，2.钻石加成卡
                      var isDiamondCard = bean.propType == 2;
                      var percent = isDiamondCard
                          ? TrudaLanguageKey.newhita_base_percent_location
                              .trArgs([(bean.propDuration ?? 0).toString()])
                          : '';
                      var name = isDiamondCard
                          ? TrudaLanguageKey.newhita_card_diamond_bonus
                              .trArgs([percent])
                          : TrudaLanguageKey.newhita_vido_tx.tr;
                      var content = isDiamondCard
                          ? TrudaLanguageKey.newhita_card_diamond_bonus_intro
                              .trArgs([percent])
                          : TrudaLanguageKey.newhita_vido_info.trArgs(
                              ["${(bean.propDuration ?? 1500) ~/ 1000.0}"]);

                      String? updateTime;
                      var time = DateTime.fromMillisecondsSinceEpoch(0);
                      updateTime = DateFormat('yyyy.MM.dd HH:mm').format(time);
                      return GestureDetector(
                        onTap: () {
                          if (isDiamondCard) {
                            Get.offNamed(TrudaAppPages.googleCharge);
                          } else {
                            navigator?.popUntil((route) {
                              return (!Get.isDialogOpen! &&
                                  !Get.isBottomSheetOpen! &&
                                  Get.currentRoute == TrudaAppPages.main);
                            });
                            Get.find<TrudaMainController>()
                                .handleNavBarTap(0);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: AspectRatio(
                            aspectRatio: 67 / 21,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    isDiamondCard
                                        ? "assets/images_sized/newhita_card_diamond.png"
                                        : "assets/images_sized/newhita_card_video.png",
                                  ),
                                  fit: BoxFit.fill,
                                  matchTextDirection: true,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const AspectRatio(
                                    aspectRatio: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                            color: TrudaColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        content,
                                        style: const TextStyle(
                                          color: TrudaColors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: const BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadiusDirectional.only(
                                          topEnd: Radius.circular(10),
                                          bottomStart: Radius.circular(10),
                                        ),
                                      ),
                                      child: Text("x${bean.propNum}",
                                          style: const TextStyle(
                                              color: TrudaColors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
          );
        }),
      );
    });
  }
}
