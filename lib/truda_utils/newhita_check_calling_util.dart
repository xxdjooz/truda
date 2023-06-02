import 'package:get/get.dart';
import 'package:truda/truda_dialogs/truda_dialog_match_one.dart';
import 'package:truda/truda_pages/vip/truda_vip_dialog.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';

import '../truda_pages/chargedialog/truda_charge_dialog_manager.dart';
import '../truda_routes/newhita_pages.dart';

class NewHitaCheckCallingUtil {
  // 刚给这个主播打完电话，就不弹出她的aib了
  // static String? herIdRecently;
  // static int herIdTime = 0;

  // 刚给这个主播打完电话，设置一下这个结束的时间
  // static setCallRecently(String herId) {
  //   herIdRecently = herId + '';
  //   herIdTime = DateTime.now().millisecondsSinceEpoch;
  // }

  // 给这个主播打过电话，15s内不要她的aib
  // static bool checkCallHerRecently(String herId) {
  //   var passTime = DateTime.now().millisecondsSinceEpoch - herIdTime;
  //   return herId == herIdRecently && passTime < 15 * 1000;
  // }

  // 打过电话，30s内不要aic
  // static bool _checkCallRecently() {
  //   var passTime = DateTime.now().millisecondsSinceEpoch - herIdTime;
  //   return passTime < 30 * 1000;
  // }

  // 能被叫？
  static bool checkCanBeCalled() {
    // 拨打接听，电话，虚拟视频
    if (checkCalling()) return false;
    if (NewHitaAppPages.isAppBackground) return false;
    // 登录页
    if (Get.currentRoute == NewHitaAppPages.login) return false;
    if (NewHitaMyInfoService.to.myDetail?.isDoNotDisturb == 1) {
      return false;
    }
    if (TrudaDialogMatchOne.matching) {
      return false;
    }
    // if (NewHitaBowlingPage.matching) {
    //   return false;
    // }
    // 充值中 ？
    return true;
  }

  // 能被叫aic?
  static bool checkCanAic() {
    // if (_checkCallRecently()) return false;
    if (!checkCanBeCalled()) return false;
    // 登录页
    if (Get.currentRoute == NewHitaAppPages.login) return false;
    final pages = NewHitaAppPages.history;
    if (TrudaDialogMatchOne.matching) {
      return false;
    }
    // if (NewHitaBowlingPage.matching) {
    //   return false;
    // }
    // 充值中
    if (pages.contains(NewHitaAppPages.googleCharge)) {
      return false;
    }
    if (pages.contains(NewHitaAppPages.webPage)) {
      return false;
    }
    // 主播封面视频中
    // if (pages.contains(NewHitaAppPages.herVideo)) {
    //   return false;
    // }
    // 聊天中
    if (Get.currentRoute == NewHitaAppPages.chatPage) {
      return false;
    }
    //用户打开了充值弹窗
    if (TrudaChargeDialogManager.isShowingChargeDialog) {
      return false;
    }
    //用户打开了Vip弹窗
    if (TrudaVipDialog.showing) {
      return false;
    }
    if (pages.contains(NewHitaAppPages.vip)) {
      return false;
    }
    return true;
  }

  // 能被叫aib?
  static bool checkCanAib() {
    if (!checkCanBeCalled()) return false;
    // 登录页
    if (Get.currentRoute == NewHitaAppPages.login) return false;
    final pages = NewHitaAppPages.history;
    // 聊天中
    if (Get.currentRoute == NewHitaAppPages.chatPage) {
      return false;
    }
    // 匹配中
    // 充值中
    if (pages.contains(NewHitaAppPages.googleCharge)) {
      return false;
    }
    if (pages.contains(NewHitaAppPages.webPage)) {
      return false;
    }
    if (TrudaDialogMatchOne.matching) {
      return false;
    }
    // if (NewHitaBowlingPage.matching) {
    //   return false;
    // }
    //用户打开了充值弹窗
    if (TrudaChargeDialogManager.isShowingChargeDialog) {
      return false;
    }
    if (pages.contains(NewHitaAppPages.vip)) {
      return false;
    }
    return true;
  }

  /// 检查当前是否正在通话，来屏蔽某些操作
  static bool checkCalling() {
    if (NewHitaAppPages.history.contains(NewHitaAppPages.call) ||
        NewHitaAppPages.history.contains(NewHitaAppPages.callOut) ||
        NewHitaAppPages.history.contains(NewHitaAppPages.aicPage) ||
        NewHitaAppPages.history.contains(NewHitaAppPages.aivPage) ||
        NewHitaAppPages.history.contains(NewHitaAppPages.callCome)) {
      return true;
    }
    return false;
  }
//
// /// 检查当前是否正在通话,或者自己在勿扰模式，来屏蔽某些操作
// static bool checkCallingOrDnd() {
//   if (NewHitaAppPages.history.contains(NewHitaAppPages.call) ||
//       NewHitaAppPages.history.contains(NewHitaAppPages.callOut) ||
//       NewHitaAppPages.history.contains(NewHitaAppPages.aicPage) ||
//       NewHitaAppPages.history
//           .contains(NewHitaAppPages.googleCharge) ||
//       NewHitaAppPages.history.contains(NewHitaAppPages.callCome)) {
//     return true;
//   }
//   if (LindaMyInfoService.to.myDetail?.isDoNotDisturb == 1) {
//     return true;
//   }
//   return false;
// }

  /// 检查当前是否正在通话,或者匹配
// static bool checkCallingAndMatching() {
//   if (NewHitaAppPages.history
//           .contains(NewHitaAppPages.matchingPage) ||
//       NewHitaAppPages.history.contains(NewHitaAppPages.call) ||
//       NewHitaAppPages.history.contains(NewHitaAppPages.aicPage) ||
//       NewHitaAppPages.history.contains(NewHitaAppPages.callOut) ||
//       NewHitaAppPages.history.contains(NewHitaAppPages.callCome)) {
//     return true;
//   }
//   return false;
// }
}
