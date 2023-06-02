import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_common/truda_constants.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import 'truda_black_list_controller.dart';

class TrudaBlackListPage extends GetView<TrudaBlackListController> {
  TrudaBlackListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaBlackListController>(builder: (contro) {
      return Scaffold(
        appBar: NewHitaAppBar(
          title: Text(
            TrudaLanguageKey.newhita_setting_black_list.tr,
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: GetBuilder<TrudaBlackListController>(builder: (controller) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: controller.enablePullUp,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
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
                      String? updateTime;
                      var time = DateTime.fromMillisecondsSinceEpoch(
                          bean.updatedAt ?? 0);
                      updateTime = DateFormat('yyyy.MM.dd HH:mm').format(time);
                      return Container(
                        margin: EdgeInsetsDirectional.only(bottom: 10),
                        padding: EdgeInsetsDirectional.all(10),
                        decoration: BoxDecoration(
                          color: TrudaColors.white,
                          borderRadius: BorderRadius.circular(20),
                          // border: Border(
                          //     top: BorderSide(color: Colors.white24, width: 1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                    child: bean.userId == TrudaConstants.systemId ||
                                        bean.userId == TrudaConstants.serviceId
                                        ? Image.asset(
                                      'assets/images/newhita_conver_system.png',
                                      width: 64,
                                      height: 64,
                                    )
                                        : NewHitaNetImage(
                                      bean.portrait ?? "",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 10, end: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((bean.nickname ?? "--"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: TrudaColors.textColor333,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    height: 5,
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                      TrudaLanguageKey.newhita_black_time
                                          .trArgs([updateTime]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: TrudaColors.textColor666,
                                          fontSize: 12))
                                ],
                              ),
                            )),
                            GestureDetector(
                              onTap: () {
                                controller.removeBlack(bean.userId!);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  // 渐变色
                                    gradient: const LinearGradient(colors: [
                                      TrudaColors.baseColorGradient1,
                                      TrudaColors.baseColorGradient2,
                                    ]),
                                    borderRadius: BorderRadius.circular(50)),
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                                child: Text(
                                  TrudaLanguageKey.newhita_dialog_remove_black.tr,
                                  style: TextStyle(
                                      color: TrudaColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     controller.removeBlack(bean.userId!);
                            //   },
                            //   child: Image.asset(
                            //     'assets/images/newhita_black_remove.png',
                            //     width: 42,
                            //     height: 42,
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }),
          );
        }),
      );
    });
  }
}
