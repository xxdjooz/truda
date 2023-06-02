import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_entities/truda_order_entity.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_utils/newhita_format_util.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_colors.dart';
import 'truda_order_list_controller.dart';

class TrudaOrderListPage extends GetView<TrudaOrderListController> {
  TrudaOrderListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TrudaOrderListController());
    return GetBuilder<TrudaOrderListController>(builder: (contro) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const SizedBox(),
            centerTitle: true,
            leadingWidth: 0,
            titleSpacing: 0,
            elevation: 0,
            title: TabBar(
              onTap: (index) {
                controller.onRefresh(index: index);
              },
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const BoxDecoration(),
              tabs: [
                Tab(
                  text: TrudaLanguageKey.newhita_all_order.tr,
                ),
                Tab(
                  text: TrudaLanguageKey.newhita_obligation.tr,
                ),
                Tab(
                  text: TrudaLanguageKey.newhita_order_completion.tr,
                ),
                Tab(
                  text: TrudaLanguageKey.newhita_order_failed.tr,
                ),
              ],
              labelStyle: const TextStyle(
                  fontSize: 18,
                  color: TrudaColors.white,
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 16, color: Colors.white38),
              labelColor: TrudaColors.textColor333,
              unselectedLabelColor: TrudaColors.textColor666,
            ),
          ),
          extendBodyBehindAppBar: false,
          backgroundColor: TrudaColors.baseColorBlackBg,
          body: GetBuilder<TrudaOrderListController>(builder: (controller) {
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
                        updateTime =
                            DateFormat('yyyy.MM.dd HH:mm').format(time);
                        return TrudaOrderItem(bean);
                      }),
            );
          }),
        ),
      );
    });
  }
}

class TrudaOrderItem extends StatelessWidget {
  TrudaOrderData data;

  TrudaOrderItem(this.data);

  @override
  Widget build(BuildContext context) {
    String title_str = "";
    switch (data.orderStatus) {
      case 0:
        {
          title_str = TrudaLanguageKey.newhita_obligation.tr;
        }
        break;
      case 1:
        {
          title_str = TrudaLanguageKey.newhita_order_completion.tr;
        }
        break;
      case 2:
        {
          title_str = TrudaLanguageKey.newhita_order_failed.tr;
        }
        break;
      case 3:
        {
          title_str = TrudaLanguageKey.newhita_order_status_failure.tr;
        }
        break;
    }

    return GestureDetector(
      onTap: () {
        // CblRouterManager.pushNamed(OrderDetailRouter, data);
        Get.toNamed(NewHitaAppPages.orderDetail, arguments: data);
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 15, start: 15, end: 15),
        padding: EdgeInsetsDirectional.all(15),
        decoration: BoxDecoration(
            color: TrudaColors.white,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 180),
                  child: Text(
                    title_str,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(data.orderStatus == 0
                            ? 0xFF883FFF
                            : (data.orderStatus == 2
                                ? 0xFFFF7BA9
                                : (data.orderStatus == 3
                                    ? 0xFFFF7BA9
                                    : 0xFFFFFFFF)))),
                  ),
                ),
                Text(
                  DateFormat('yyyy.MM.dd HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          ((data.orderStatus == 1)
                                  ? data.paidAt
                                  : data.createdAt) ??
                              0)),
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                )
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  "assets/images/newhita_diamond_small.png",
                  fit: BoxFit.contain,
                ),
                Text(
                  "${data.diamonds ?? '--'}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TrudaColors.textColor333),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Text(
                  "${NewHitaFormatUtil.currencyToSymbol(data.currencyCode)} ${data.currencyFee != null ? data.currencyFee! / 100.0 : '--'}",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  TrudaLanguageKey.newhita_order_channelName.tr,
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
                Text(
                  ": ",
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
                Text(
                  "${data.channelName}",
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Text(
              TrudaLanguageKey.newhita_order_pay_orderno
                  .trArgs([": ${data.orderNo}"]),
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: 20, bottom: 15),
              color: TrudaColors.baseColorBg,
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TrudaLanguageKey.newhita_order_one_details.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: TrudaColors.textColor333,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
