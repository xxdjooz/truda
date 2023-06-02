import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/truda_log.dart';
import 'package:truda/truda_utils/truda_third_util.dart';

import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import '../truda_pages/chargedialog/truda_charge_quick_controller.dart';

class TrudaAdjustManager {
  static AdjustAttribution? attributionChangedData; // adjust的归因数据
  static bool canUploadAdjust = false;
  static bool hadUploadAdjust = false;
  static Timer? _timer;
  static String id = GetPlatform.isIOS == true
      ? TrudaConstants.adjustIdIos
      : TrudaConstants.adjustId;
  static String event = GetPlatform.isIOS == true
      ? TrudaConstants.adjustEventKeyIos
      : TrudaConstants.adjustEventKey;

  static initAdjust() {
    AdjustConfig config = AdjustConfig(
        id,
        // AdjustEnvironment.production
        kReleaseMode ? AdjustEnvironment.production : AdjustEnvironment.sandbox,
        );
    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      // 每次安装有这个回调
      TrudaLog.debug('[Adjust]: Attribution changed!');
      if (attributionChangedData.adid != null) {
        TrudaLog.debug('[Adjust]: Adid: ${attributionChangedData.adid!}');
      }
      setAdjustInfo(attributionChangedData);
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      TrudaLog.debug('[Adjust]: Event tracking success!');

      if (eventSuccessData.eventToken != null) {
        TrudaLog.debug('[Adjust]: Event token: ${eventSuccessData.eventToken!}');
      }
      if (eventSuccessData.message != null) {
        TrudaLog.debug('[Adjust]: Message: ${eventSuccessData.message!}');
      }
      if (eventSuccessData.timestamp != null) {
        TrudaLog.debug('[Adjust]: Timestamp: ${eventSuccessData.timestamp!}');
      }
      if (eventSuccessData.adid != null) {
        TrudaLog.debug('[Adjust]: Adid: ${eventSuccessData.adid!}');
      }
      if (eventSuccessData.callbackId != null) {
        TrudaLog.debug('[Adjust]: Callback ID: ${eventSuccessData.callbackId!}');
      }
      if (eventSuccessData.jsonResponse != null) {
        TrudaLog.debug(
            '[Adjust]: JSON response: ${eventSuccessData.jsonResponse!}');
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      TrudaLog.debug('[Adjust]: Event tracking failure!');

      if (eventFailureData.eventToken != null) {
        TrudaLog.debug('[Adjust]: Event token: ${eventFailureData.eventToken!}');
      }
      if (eventFailureData.message != null) {
        TrudaLog.debug('[Adjust]: Message: ${eventFailureData.message!}');
      }
      if (eventFailureData.timestamp != null) {
        TrudaLog.debug('[Adjust]: Timestamp: ${eventFailureData.timestamp!}');
      }
      if (eventFailureData.adid != null) {
        TrudaLog.debug('[Adjust]: Adid: ${eventFailureData.adid!}');
      }
      if (eventFailureData.callbackId != null) {
        TrudaLog.debug('[Adjust]: Callback ID: ${eventFailureData.callbackId!}');
      }
      if (eventFailureData.willRetry != null) {
        TrudaLog.debug(
            '[Adjust]: Will retry: ${eventFailureData.willRetry}');
      }
      if (eventFailureData.jsonResponse != null) {
        TrudaLog.debug(
            '[Adjust]: JSON response: ${eventFailureData.jsonResponse!}');
      }
    };

    Adjust.start(config);
  }

  /// 获取Google的安装来源数据
  static getGoolgeReferrer() async {
    if (TrudaConstants.isTestMode) {
      return;
    }
    var referrer = await TrudaThirdUtil.installReference();
    if (referrer == null || referrer.isEmpty) return;
    // 拿到Google的安装来源数据，如果是organic就不用管了
    if (referrer.contains('organic')) return;
    // 否则认为是广告的来源，调adjust的上传接口
    TrudaHttpUtil().post<void>(TrudaHttpUrls.attributionData, errCallback: (e) {
      TrudaLog.debug("upload adjust attribution  failed");
    }, data: {
      "trackerToken": "",
      "trackerName": "",
      "network": "googleplay",
      "campaign": "",
      "adgroup": "",
      "creative": "",
      "clickLabel": "",
      "adid": "",
      "costType": "",
      "costAmount": '',
      "costCurrency": "",
    }).then((value) {
      TrudaChargeQuickController.cleanCacheData();
    });
  }

  // ios去获取追踪权限
  static requestTracking() {
    // Ask for tracking consent.
    Adjust.requestTrackingAuthorizationWithCompletionHandler().then((status) {
      TrudaLog.debug('[Adjust]: Authorization status update!');
      switch (status) {
        case 0:
          TrudaLog.debug(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusNotDetermined');
          break;
        case 1:
          TrudaLog.debug(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusRestricted');
          break;
        case 2:
          TrudaLog.debug(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusDenied');
          // ios要的
          TrudaThirdUtil.facebookSetAdvertiserTracking(false);
          break;
        case 3:
          TrudaLog.debug(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusAuthorized');
          // ios要的
          TrudaThirdUtil.facebookSetAdvertiserTracking(true);
          break;
      }

      initAdjust();
    });
  }

  // adjust有接口可以查归因数据，
  static checkAdjustUploadAttr() {
    if (attributionChangedData != null) {
      checkAdjustToUpload();
      return;
    }
    try {
      Adjust.getAttribution().then((value) => setAdjustInfo(value));
    } catch (e) {
      print(e);
    }
    // 开启个定时器检查
    _timer = Timer.periodic(const Duration(milliseconds: 20000), (timer) async {
      checkAdjustUploadAttr();
    });
  }

  // 拿到了归因数据去处理
  static void setAdjustInfo(AdjustAttribution attr) {
    attributionChangedData = attr;
    checkAdjustToUpload();
  }

  // 在登录和有归因数据后，上传归因数据到后端
  // 尽量做到每次打开都上传一次
  static void checkAdjustToUpload() {
    if (TrudaMyInfoService.to.myDetail == null) return;
    if (attributionChangedData == null) return;
    if (hadUploadAdjust) return;
    TrudaLog.debug("upload adjust attribution");
    // 有上传了数据，但是network是空的情况, 不懂为啥，再次获取上传
    bool isNetworkNull = attributionChangedData?.network?.isNotEmpty != true;
    num cost = attributionChangedData!.costAmount ?? 0;
    if (cost.isNaN) {
      cost = 0;
    }
    TrudaHttpUtil().post<void>(TrudaHttpUrls.attributionData, errCallback: (e) {
      TrudaLog.debug("upload adjust attribution  failed");
    }, data: {
      "trackerToken": attributionChangedData!.trackerToken ?? "",
      "trackerName": attributionChangedData!.trackerName ?? "",
      "network": attributionChangedData!.network ?? "",
      "campaign": attributionChangedData!.campaign ?? "",
      "adgroup": attributionChangedData!.adgroup ?? "",
      "creative": attributionChangedData!.creative ?? "",
      "clickLabel": attributionChangedData!.clickLabel ?? "",
      "adid": attributionChangedData!.adid ?? "",
      "costType": attributionChangedData!.costType ?? "",
      "costAmount": cost,
      "costCurrency": attributionChangedData!.costCurrency ?? "",
    }).then((value) {
      if (!isNetworkNull) {
        hadUploadAdjust = true;
        _timer?.cancel();
        _timer == null;
      }
      TrudaLog.debug("upload adjust attribution   success");
      TrudaChargeQuickController.cleanCacheData();
    });
  }
}
