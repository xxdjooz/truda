import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_charge_path.dart';
import 'package:truda/truda_pages/vip/truda_vip_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../truda_database/entity/truda_order_entity.dart';
import '../../truda_entities/truda_charge_entity.dart';
import '../../truda_entities/truda_charge_quick_entity.dart';
import '../../truda_entities/truda_info_entity.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_services/truda_storage_service.dart';
import '../../truda_utils/truda_loading.dart';
import '../charge/truda_charge_new_channel_dialog.dart';
import '../charge/truda_google_billing.dart';
import '../some/truda_web_page.dart';
import 'truda_vip_page.dart';

class TrudaVipController extends GetxController {
  static void openDialog({String createPath = ''}) {
    Get.bottomSheet(
      TrudaVipDialog(
        createPath: createPath,
      ),
      // 不加这个默认最高屏幕一半
      isScrollControlled: true,
    );
  }

  static const idMoreList = 'idMoreList';
  bool googleOnly = true;
  static List<TrudaPayQuickCommodite>? payQuickData;

  // NewHitaPayQuickCommodite? cutCommodite;
  // List<NewHitaPayQuickCommodite>? normalProducts;
  TrudaPayQuickCommodite? choosedCommodite;
  int left_time_inter = 0;
  var showMore = false;
  var createPath = TrudaChargePath.recharge_vip;
  String? upId;
  TrudaInfoDetail? myDetail;
  final googlePayType = 1;

  // 缓存这个数据，2分钟内且没有点击支付用缓存，否则重新加载数据
  static const cacheTime = 2 * 60 * 1000;
  static int lastLoadTime = 0;
  static bool clickPay = false;

  @override
  void onInit() {
    super.onInit();
  }
  Future refreshMe() async {
    await TrudaHttpUtil()
        .post<TrudaInfoDetail>(
      TrudaHttpUrls.userInfoApi,
    )
        .then((value) {
      myDetail = value;
      TrudaMyInfoService.to.setMyDetail = value;
      update();
    });
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
        (payQuickData?.length ?? 0) > 0) {
      setData(payQuickData!);
    } else {
      getDatas();
    }

    // if (!kReleaseMode){
    //   mockData();
    // }
    refreshMe();
  }

  void mockData() {
    var data = TrudaPayQuickCommodite();
    payQuickData = [];
    payQuickData?.add(data);
    payQuickData?.add(data);
    payQuickData?.add(data);
    update();
  }

  void getDatas() {
    TrudaHttpUtil().post<List<TrudaPayQuickCommodite>>(
      TrudaHttpUrls.getVipProduct,
      errCallback: (err) {
        TrudaLoading.toast(err.message);
      },
    ).then((value) {
      setData(value);
      clickPay = false;
      lastLoadTime = DateTime.now().millisecondsSinceEpoch;
    });
  }

  void setData(List<TrudaPayQuickCommodite> newData) {
    payQuickData = newData;
    update();
    _tryCorrectGooglePrice();
  }

  // 修正一下Google渠道的显示价格
  void _tryCorrectGooglePrice() {
    List<TrudaPayQuickCommodite> allList = [];

    if (payQuickData != null) {
      allList.addAll(payQuickData!);
    }
    for (var comm in allList) {
      if (comm.channelPays != null) {
        for (var channel in comm.channelPays!) {
          if (channel.payType == googlePayType) {
            TrudaGoogleBilling.correctQuickGooglePrice(channel).then((value) {
              // 正在选择渠道的时候刷新页面
              if (value && choosedCommodite != null) {
                update();
              }
            });
            continue;
          }
        }
      }
    }
  }

  // 选择了一个商品，如果只有一个渠道直接支付，否则弹出渠道列表
  void chooseCommdite(TrudaPayQuickCommodite choosedCommodite) {
    this.choosedCommodite = choosedCommodite;
    if (choosedCommodite.channelPays?.length == 1) {
      doCharge(choosedCommodite.channelPays![0]);
      return;
    }
    // update();
    Get.bottomSheet(TrudaChargeChannelDialog(
      isVip: true,
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
      TrudaStorageService.to.objectBoxOrder
          .putOrUpdateOrder(NewHitaOrderEntity(
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
