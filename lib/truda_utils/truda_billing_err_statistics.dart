import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import 'truda_log.dart';

/// 上报统计一下Google支付的错误
class TrudaBillingErrStatistics {
  static const billingErr = 100;

  static err(int err) {
    TrudaLog.debug('NewHitaBillingErrStatistics $err');
    TrudaHttpUtil().post<void>(
      TrudaHttpUrls.appCallStatistics + '/$billingErr/$err',
      errCallback: (e) {},
    );
  }

  static const connectErr = 101;
  static const productIdNull = 102;
  static const orderNoNull = 103;
  static const productNotFound = 104;
  static const googleNotifyErr = 105;
  static const launchBillingErr = 106;
  static const consumeErr = 107;
  // 还有下面的类型
  // const _$BillingResponseEnumMap = {
  //   BillingResponse.serviceTimeout: -3,
  //   BillingResponse.featureNotSupported: -2,
  //   BillingResponse.serviceDisconnected: -1,
  //   BillingResponse.ok: 0,
  //   BillingResponse.userCanceled: 1,
  //   BillingResponse.serviceUnavailable: 2,
  //   BillingResponse.billingUnavailable: 3,
  //   BillingResponse.itemUnavailable: 4,
  //   BillingResponse.developerError: 5,
  //   BillingResponse.error: 6,
  //   BillingResponse.itemAlreadyOwned: 7,
  //   BillingResponse.itemNotOwned: 8,
  // };
}
