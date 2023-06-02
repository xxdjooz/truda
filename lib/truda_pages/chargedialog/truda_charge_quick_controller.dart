import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_charge_entity.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../truda_database/entity/truda_order_entity.dart';
import '../../truda_entities/truda_charge_quick_entity.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_services/truda_storage_service.dart';
import '../../truda_utils/truda_loading.dart';
import '../charge/truda_charge_new_channel_dialog.dart';
import '../charge/truda_google_billing.dart';
import '../charge/truda_in_app_purchase_apple.dart';
import '../some/truda_web_page.dart';

class TrudaChargeQuickController extends GetxController {
  static const idMoreList = 'idMoreList';
  bool googleOnly = true;
  static TrudaPayQuickData? payQuickData;
  TrudaPayQuickCommodite? cutCommodite;
  List<TrudaPayQuickCommodite>? normalProducts;
  TrudaPayQuickCommodite? choosedCommodite;
  int left_time_inter = 0;
  var showMore = false;
  var createPath = '';
  String? upId;

  final googlePayType = 1;
  final applePayType = 2;

  // 缓存这个数据，2分钟内且没有点击支付用缓存，否则重新加载数据
  static const cacheTime = 2 * 60 * 1000;
  static int lastLoadTime = 0;
  static bool clickPay = false;

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
  }

  static void cleanCacheData() {
    clickPay = true;
  }

  @override
  void onReady() {
    super.onReady();
    // NewHitaGoogleBilling.correctCutGooglePrice(cutCommodite!)
    //     .then((value) => update());
    // 有缓存用缓存
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    if (nowTime - lastLoadTime < cacheTime &&
        !clickPay &&
        payQuickData != null &&
        (payQuickData?.normalProducts?.length ?? 0) > 0) {
      setData(payQuickData!);
    } else {
      getDatas();
    }
  }

  void getDatas() {
    TrudaHttpUtil().post<TrudaPayQuickData>(
      TrudaHttpUrls.getCompositeProduct + '1',
      errCallback: (err) {
        TrudaLoading.toast(err.message);
      },
    ).then((value) {
      setData(value);
      clickPay = false;
      lastLoadTime = DateTime.now().millisecondsSinceEpoch;
    });
  }

  void setData(TrudaPayQuickData newData) {
    payQuickData = newData;
    cutCommodite = newData.discountProduct;
    normalProducts = newData.normalProducts;
    update();
    _tryCorrectGooglePrice();
  }

  // 修正一下Google渠道的显示价格
  void _tryCorrectGooglePrice() {
    List<TrudaPayQuickCommodite> allList = [];

    if (normalProducts != null) {
      allList.addAll(normalProducts!);
    }
    if (cutCommodite != null) {
      allList.add(cutCommodite!);
    }
    TrudaGoogleBilling.correctShopGooglePrice(allList).then((value) => update());
    // for (var comm in allList) {
    //   if (comm.channelPays != null) {
    //     for (var channel in comm.channelPays!) {
    //       if (channel.payType == 1) {
    //         NewHitaGoogleBilling.correctQuickGooglePrice(channel).then((value) {
    //           // 正在选择渠道的时候刷新页面
    //           if (value && choosedCommodite != null) {
    //             update();
    //           }
    //         });
    //         continue;
    //       }
    //     }
    //   }
    // }
  }

  // String getMoneyOld() {
  //   if (cutCommodite == null) {
  //     return '';
  //   }
  //   var commdi = cutCommodite!;
  //   return "${commdi.realCurrencySymbol}${(commdi.realPrice != null && commdi.discount != null) ? (commdi.realPrice! / (100.0 - commdi.discount!)).toStringAsFixed(2) : '--'}";
  // }
  //
  // String getMoney() {
  //   if (cutCommodite == null) {
  //     return '';
  //   }
  //   var commdi = cutCommodite!;
  //   return "${commdi.realCurrencySymbol}${(commdi.realPrice != null) ? (commdi.realPrice! / 100).toStringAsFixed(2) : '--'}";
  // }
  //
  // 选择了一个商品，如果只有一个渠道直接支付，否则弹出渠道列表
  void chooseCommdite(TrudaPayQuickCommodite choosedCommodite) {
    this.choosedCommodite = choosedCommodite;
    if (choosedCommodite.channelPays?.length == 1) {
      doCharge(choosedCommodite.channelPays![0]);
      return;
    }
    // update();
    Get.bottomSheet(TrudaChargeChannelDialog(
      payCommodite: choosedCommodite,
      callback: (comm, channel, countryCode) {
        doCharge(channel, countryCode: countryCode);
      },
    ));
  }

  // 支付
  void doCharge(TrudaPayQuickChannel channel, {int? countryCode}) {
    clickPay = true;
    var commdi = choosedCommodite!;
    TrudaHttpUtil()
        .post<TrudaCreateOrderBean>(
      TrudaHttpUrls.createOrderApi,
      data: {
        "productCode": channel.productCode ?? "",
        "storeCode": channel.storeCode ?? "",
        "channelType": channel.channelType ?? "",
        "payType": channel.payType ?? "",
        "currencyCode": channel.currency ?? "",
        "currencyFee": channel.currencyPrice ?? "",
        "refereeUserId": upId ?? "",
        "createPath": createPath,
        if (countryCode != null) "countryCode": countryCode,
      },
      showLoading: true,
    )
        .then((value) {
      // 放进数据库
      TrudaStorageService.to.objectBoxOrder.putOrUpdateOrder(NewHitaOrderEntity(
        userId: TrudaMyInfoService.to.myDetail?.userId ?? '',
        orderNo: value.orderNo,
        productId: channel.productCode ?? "",
        price: channel.uploadUsd == 1
            ? (channel.price ?? 0).toString()
            : (channel.currencyPrice ?? 0).toString(),
        currency: channel.uploadUsd == 1 ? "USD" : channel.currency,
        payType: (channel.payType ?? 0).toString(),
        type: 'Diamond',
        payTime: '',
        orderCreateTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ));
      if (channel.payType == googlePayType) {
        TrudaGoogleBilling.callPay(channel.productCode, value.orderNo);
      } else if (channel.payType == applePayType) {
        TrudaAppleInAppPurchase.checkPurchaseAndPay(
            value.productCode!, value.orderNo!, (success) {});
      } else if (channel.browserOpen == 1) {
        openInOutBrowser(value.payUrl!);
      } else {
        TrudaWebPage.startMe(value.payUrl!, false);
      }
    });
  }

  void openInOutBrowser(String url) async {
    if (await canLaunch(url)) {
      launch((url));
    }
  }
}
