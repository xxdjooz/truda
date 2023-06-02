import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';

import '../../truda_entities/truda_charge_quick_entity.dart';
import '../../truda_entities/truda_hot_entity.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_widget/newhita_click_widget.dart';
import '../../truda_widget/newhita_net_image.dart';
import 'truda_dialog_pay_country_choose.dart';
import 'truda_pay_countries_util.dart';

typedef TrudaChannelDialogCallback = Function(
    TrudaPayQuickCommodite comm, TrudaPayQuickChannel channel, int? countryCode);

/// 选择钻石后可以选择渠道去充值
class TrudaChargeChannelDialog extends StatefulWidget {
  Function? closeCallBack;
  TrudaPayQuickCommodite payCommodite;
  TrudaChannelDialogCallback callback;
  bool isVip;

  TrudaChargeChannelDialog({
    Key? key,
    this.closeCallBack,
    required this.payCommodite,
    required this.callback,
    this.isVip = false,
  }) : super(key: key);

  @override
  State<TrudaChargeChannelDialog> createState() =>
      _TrudaChargeChannelDialogState();
}

class _TrudaChargeChannelDialogState extends State<TrudaChargeChannelDialog> {
  var countryChoosed = Rx<TrudaAreaData?>(null);
  List<TrudaAreaData>? areaList;

  // 选择国家后得到的
  TrudaPayQuickCommodite? countryCommodite;

  @override
  void initState() {
    super.initState();
    TrudaPayCountriesUtil.getCountries().then((value) {
      setState(() {
        areaList = value;
      });
    }).catchError((e) {
      NewHitaLog.debug(e);
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.closeCallBack?.call();
  }

  @override
  Widget build(BuildContext context) {
    final TrudaPayQuickCommodite commodite =
        countryCommodite ?? widget.payCommodite;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(minHeight: 300, maxHeight: 800),
      decoration: const BoxDecoration(
          color: TrudaColors.white,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(20),
            topEnd: Radius.circular(20),
          )),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                widget.isVip
                    ? 'assets/images_sized/newhita_me_vip.png'
                    : "assets/images_ani/newhita_home_charge.webp",
                width: 78,
                height: 78,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.isVip
                          ? TrudaLanguageKey.newhita_vip_days
                              .trArgs([(commodite.vipDays ?? 0).toString()])
                          : (commodite.value ?? 0).toString() +
                              ' ' +
                              TrudaLanguageKey.newhita_diamond.tr,
                      style: const TextStyle(
                          color: TrudaColors.textColor333, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (((widget.isVip ? commodite.value : commodite.bonus) ?? 0) > 0)
                    Text.rich(TextSpan(
                        style: TextStyle(
                            color: TrudaColors.baseColorTheme, fontSize: 12),
                        children: [
                          TextSpan(text: "+"),
                          TextSpan(
                              text:
                                  " ${widget.isVip ? commodite.value : commodite.bonus}",
                              style: TextStyle(
                                color: TrudaColors.baseColorTheme,
                              )),
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
              ),
              GestureDetector(onTap: () {
                var curArea = countryChoosed.value?.countryCode ?? -1;
                Get.bottomSheet(
                  TrudaDialogPayCountryChoose(
                    areaList: areaList!,
                    curArea: curArea,
                    callback: (area) {
                      countryChoosed.value = area;
                      TrudaPayCountriesUtil.getCountryProduct(
                              commodite.productId!,
                              (area.countryCode ?? -1).toString())
                          .then((value) {
                        setState(() {
                          countryCommodite = value;
                        });
                      }).catchError((e) {});
                    },
                  ),
                  isScrollControlled: true,
                );
              }, child: Center(
                child: Obx(() {
                  var area = countryChoosed.value;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        if (area == null)
                          // Image.asset(
                          //   'assets/images/newhita_home_country.png',
                          //   width: 15,
                          //   height: 15,
                          // ),
                          const Icon(
                            Icons.language,
                            size: 15,
                            color: Colors.white,
                          ),
                        Visibility(
                          visible: area != null,
                          child: Row(
                            children: [
                              NewHitaNetImage(
                                area?.path ?? "",
                                // radius: 9,
                                width: 15,
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  area?.title ?? "",
                                  // "aa aa aa aa",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: TrudaColors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            mainAxisSize: MainAxisSize.min,
                          ),
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          'assets/images/newhita_home_arrow_down.png',
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ),
                  );
                }),
              )),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          if (commodite.diamondCard != null &&
              commodite.diamondCard?.increaseDiamonds != null)
            Builder(builder: (context) {
              final bean = commodite.diamondCard!;
              var percent = TrudaLanguageKey.newhita_base_percent_location
                  .trArgs([(bean.propDuration ?? 0).toString()]);
              var name =
                  TrudaLanguageKey.newhita_card_diamond_bonus.trArgs([percent]);
              return ColoredBox(
                color: TrudaColors.textColor333,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/newhita_lottery_upgrade.png",
                    ),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: TextStyle(
                        color: TrudaColors.white,
                        fontSize: 12,
                      ),
                    ),
                    if ((bean.increaseDiamonds ?? 0) > 0)
                    Text.rich(TextSpan(
                        style: TextStyle(
                            color: TrudaColors.baseColorTheme, fontSize: 12),
                        children: [
                          TextSpan(text: " +"),
                          TextSpan(
                              text: "${bean.increaseDiamonds}",
                              style: TextStyle(
                                color: TrudaColors.baseColorTheme,
                              )),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(
                                "assets/images/newhita_diamond_small.png",
                                width: 14,
                                height: 14,
                              )),
                        ])),
                    const Spacer(),
                    const ColoredBox(
                      color: TrudaColors.white,
                      child: SizedBox(
                        width: 1,
                        height: 14,
                      ),
                    ),
                    Text.rich(TextSpan(
                        style: TextStyle(color: TrudaColors.white, fontSize: 12),
                        children: [
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(text: TrudaLanguageKey.newhita_words_total.tr),
                          TextSpan(
                              text: " ${bean.totalDiamonds}",
                              style: TextStyle(
                                color: TrudaColors.white,
                              )),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(
                                "assets/images/newhita_diamond_small.png",
                                width: 14,
                                height: 14,
                              )),
                        ])),
                    const SizedBox(width: 10),
                  ],
                ),
              );
            }),
          Expanded(child: buildPayChannel(commodite, widget.callback)),
        ],
      ),
    );
  }

  /// 渠道列表
  Widget buildPayChannel(
    TrudaPayQuickCommodite payCommodite,
    TrudaChannelDialogCallback callback,
  ) {
    // if (channelsAll.length > 0) {
    List<TrudaPayQuickChannel> channelsAll = payCommodite.channelPays ?? [];
    return SingleChildScrollView(
      child: Column(
        children: channelsAll.map((e) {
          TrudaPayQuickChannel channelData = e;
          //优惠充值的渠道中commodities不会返回商品信息
          // if (choosePayData == null) {
          //   choosePayData = payListDataCommodities;
          // }
          return NewHitaClickWidget(
            onTap: () async {
              Get.back();
              callback.call(
                  payCommodite, channelData, countryChoosed.value?.countryCode);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(12))),
              padding: EdgeInsetsDirectional.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 38,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(4))),
                        margin: EdgeInsetsDirectional.only(end: 10),
                        child: NewHitaNetImage(
                          channelData.nationalFlagPath ?? "",
                          //本地占位图
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                          child: AutoSizeText(
                        channelData.channelName ?? "--",
                        maxLines: 1,
                        minFontSize: 10,
                        style: TextStyle(
                            color: TrudaColors.textColor333,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(start: 9, end: 9),
                        alignment: Alignment.center,
                        height: 40,
                        // child: Text(
                        //   "${CblDataConvert.currencyToSymbol(payListDataCommodities.currency)} ${payListDataCommodities.currencyPrice != null ? payListDataCommodities.currencyPrice! / 100 : "--"}",
                        //   style: TextStyle(
                        //       color: TrudaColors.white,
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 62,
                        ),
                        child: Container(
                          padding: EdgeInsetsDirectional.only(start: 9, end: 9),
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                              color: TrudaColors.baseColorPink,
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(20))),
                          child: Row(
                            children: [
                              // Text(
                              //   TrudaLanguageKey.newhita_recharge.tr,
                              //   style: TextStyle(
                              //       color: TrudaColors.white,
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              Text(
                                // "${channelData.realCurrencySymbol} ${channelData.currencyPrice != null ? channelData.currencyPrice! / 100 : "--"}",
                                channelData.showPrice,
                                style: TextStyle(
                                  color: TrudaColors.textColor333,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
