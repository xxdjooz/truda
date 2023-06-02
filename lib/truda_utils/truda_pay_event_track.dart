import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_database/entity/truda_order_entity.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/truda_log.dart';
import 'package:truda/truda_utils/truda_third_util.dart';

import '../truda_entities/truda_config_entity.dart';

class TrudaPayEventTrack {
  factory TrudaPayEventTrack() => _getInstance();

  static TrudaPayEventTrack get instance => _getInstance();

  static TrudaPayEventTrack? _instance;

  TrudaPayEventTrack._internal();
  static TrudaPayEventTrack _getInstance() {
    _instance ??= TrudaPayEventTrack._internal();
    return _instance!;
  }

  void trackPay(NewHitaOrderEntity order) {
    double fbScale = 1.0;
    double adScale = 1.0;
    if (TrudaMyInfoService.to.config?.payScale?.isNotEmpty == true) {
      TrudaPayScale? payScale;
      try {
        payScale = TrudaPayScale.fromJson(
            json.decode(TrudaMyInfoService.to.config!.payScale!));
      } catch (e) {
        print(e);
      }
      if (payScale != null) {
        fbScale = payScale.facebookScale ?? 1.0;
        adScale = payScale.adjustScale ?? 1.0;
      }
    }
    TrudaLog.debug(
        "trackPay order=${order.price} ${order.currency} ${order.orderNo}");
    double price = double.parse(order.price ?? "0") / 100; // yuan
    // double scale = double.parse(NewHitaMyInfoService.to.config?.scale ?? "1");
    // double money = price * scale;
    String currency = order.currency ?? "USD";
    if (currency == "USD" && price > 1000) {
      // 肯定是搞错了
      return;
    }

    var stopFbPurchase = TrudaMyInfoService.to.config?.stopFbPurchase ?? false;
    if (!stopFbPurchase) {
      Map<String, dynamic> map = {};
      map["fb_currency"] = currency;
      // // 这里有个坑，传null进去会导致上传失败
      // map["fb_content_type"] = order.payType ?? 1;
      // map["fb_content_id"] = order.productId ?? "1";
      // map["fb_search_string"] = order.orderNo ?? "1";
      map["fb_search_string"] =
      "${order.orderNo ?? '1'};${order.productId ?? '1'};${order.payType ?? 1}";
      TrudaThirdUtil.facebookLog(price * fbScale, currency, map);
    }

    // adjust
    AdjustEvent adjustEvent = AdjustEvent(GetPlatform.isIOS == true
        ? TrudaConstants.adjustEventKeyIos
        : TrudaConstants.adjustEventKey);
    adjustEvent.setRevenue(price * adScale, currency);
    adjustEvent.transactionId = order.orderNo;
    Adjust.trackEvent(adjustEvent);
  }
}
