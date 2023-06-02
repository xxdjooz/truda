import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_utils/truda_format_util.dart';
import 'package:intl/intl.dart';

import '../../../../truda_entities/truda_order_entity.dart';
import '../../../../truda_services/truda_my_info_service.dart';
import '../../../../truda_utils/truda_ai_help_manager.dart';
import '../../../../truda_widget/truda_app_bar.dart';

class TrudaOrderDetailPage extends StatefulWidget {
  const TrudaOrderDetailPage({Key? key}) : super(key: key);

  @override
  _TrudaOrderDetailPageState createState() => _TrudaOrderDetailPageState();
}

class _TrudaOrderDetailPageState extends State<TrudaOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    TrudaOrderData? data = Get.arguments is TrudaOrderData ? Get.arguments : null;

    String title_str = "";
    switch (data?.orderStatus) {
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

    return Scaffold(
        appBar: TrudaAppBar(
          title: Text(
            TrudaLanguageKey.newhita_order_one_details.tr,
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  clipBehavior: Clip.none,
                  padding:
                      EdgeInsetsDirectional.only(top: 10, start: 15, end: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(12)),
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: 42),
                      padding: EdgeInsetsDirectional.only(bottom: 20),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images_sized/newhita_diamond_big.png",
                            fit: BoxFit.contain,
                          ),
                          Container(
                            margin: EdgeInsetsDirectional.only(bottom: 10),
                            child: Text(
                              "${data?.diamonds ?? '--'}",
                              style: TextStyle(
                                  // color: TrudaColors.baseColorRed,
                                  color: TrudaColors.textColor333,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ),
                          Text(
                            title_str,
                            style: TextStyle(
                                color: TrudaColors.textColor333, fontSize: 12),
                          ),
                          // Container(
                          //   height: 1,
                          //   color: Colors.black12,
                          //   margin: EdgeInsetsDirectional.only(
                          //       top: 20, start: 15, end: 15),
                          // )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (index == 1) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(12)),
                  padding: const EdgeInsetsDirectional.only(
                      top: 10, bottom: 20, start: 15, end: 15),
                  margin: const EdgeInsetsDirectional.only(
                      bottom: 20, start: 15, end: 15, top: 14),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TrudaLanguageKey.newhita_order_channelName.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor999,
                                    fontSize: 14)),
                            Text(data?.channelName ?? "--",
                                style: TextStyle(
                                    color: TrudaColors.textColor333,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TrudaLanguageKey.newhita_order_price.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor999,
                                    fontSize: 14)),
                            Text(
                                "${TrudaFormatUtil.currencyToSymbol(data?.currencyCode)} ${data?.currencyFee != null ? data!.currencyFee! / 100.0 : '--'}",
                                style: TextStyle(
                                    color: TrudaColors.baseColorRed,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TrudaLanguageKey.newhita_order_product_info.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor999,
                                    fontSize: 14)),
                            Text(
                                "${data?.diamonds} ${TrudaLanguageKey.newhita_diamond.tr}",
                                style: TextStyle(
                                    color: TrudaColors.textColor333,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TrudaLanguageKey.newhita_order_createAt.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor999,
                                    fontSize: 14)),
                            Text(
                                DateFormat('yyyy.MM.dd HH:mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        data?.createdAt ?? 0)),
                                style: TextStyle(
                                    color: TrudaColors.textColor333,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TrudaLanguageKey.newhita_order_paidAt.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor999,
                                    fontSize: 14)),
                            Text(
                                data?.paidAt != null
                                    ? DateFormat('yyyy.MM.dd HH:mm').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            data?.paidAt ?? 0))
                                    : "--",
                                style: TextStyle(
                                    color: TrudaColors.textColor333,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TrudaLanguageKey.newhita_order_tradeNo.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor999,
                                    fontSize: 14)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(data?.tradeNo ?? "--",
                                  style: TextStyle(
                                      color: TrudaColors.textColor333,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TrudaLanguageKey.newhita_order_orderNo.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor999,
                                    fontSize: 14)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(data?.orderNo ?? '--',
                                  style: TextStyle(
                                      color: TrudaColors.textColor333,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (index == 2) {
                return GestureDetector(
                  onTap: () {
                    // CblHttpManager.postRequest<CblUserInfoEntity>(
                    //     CblHttpUrls.userInfoApi, (userInfo) {
                    //   if (userInfo is CblUserInfoEntity &&
                    //       userInfo.code == 0 &&
                    //       userInfo.data != null) {
                    //     int level = CblDataConvert.userLevel(
                    //         userInfo.data?.userBalance?.expLevel ?? 0);
                    //     CblAihelp.enterOrderAIHelp(level, data?.orderNo ?? "");
                    //   }
                    // }, (b) {}, null, true);
                    TrudaAihelpManager.enterOrderAIHelp(
                        TrudaMyInfoService.to.getMyLeval()?.grade ?? 1,
                        data?.orderNo ?? "");
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(12)),
                      padding: EdgeInsetsDirectional.only(
                          top: 20, bottom: 20, start: 15, end: 15),
                      margin: EdgeInsetsDirectional.only(
                          bottom: 15, start: 15, end: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/newhita_conver_service.png",
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            TrudaLanguageKey.newhita_order_customer_service.tr,
                            style: TextStyle(
                                color: TrudaColors.textColor333, fontSize: 16),
                          ),
                          Expanded(child: SizedBox()),
                          Image.asset(
                            "assets/images/newhita_arrow_right.png",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Container();
            }));
  }
}
