import 'package:truda/truda_utils/truda_loading.dart';

class TrudaThirdUtil {
  static void askReview() {
    TrudaLoading.toast('test');
  }
  static void facebookSetAdvertiserTracking(bool enabled) {}
  static void facebookLog(
      double amount, String currency, Map<String, dynamic> map) {}

  static Future<String> installReference() async {
    return '';
  }
}

/// 这个注释上下是打包时要切换注释的，下面的是线上的
// import 'package:android_play_install_referrer/android_play_install_referrer.dart';
// import 'package:facebook_app_events/facebook_app_events.dart';
// import 'package:in_app_review/in_app_review.dart';
//
// class TrudaThirdUtil {
//   static FacebookAppEvents facebookAppEvents = FacebookAppEvents();
//
//   static void askReview() {
//     InAppReview.instance.requestReview();
//   }
//
//   static void facebookSetAdvertiserTracking(bool enabled) {
//     facebookAppEvents.setAdvertiserTracking(enabled: enabled);
//   }
//
//   static void facebookLog(
//       double money, String currency, Map<String, dynamic> map) {
//     facebookAppEvents.logPurchase(
//         amount: money, currency: currency, parameters: map);
//   }
//
//   static Future<String> installReference() async {
//     ReferrerDetails referrerDetails;
//     // 这个api在ios是不行的
//     try {
//       referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
//     } catch (e) {
//       print(e);
//       return '';
//     }
//     var referrer = referrerDetails.installReferrer;
//     return referrer ?? '';
//   }
// }
