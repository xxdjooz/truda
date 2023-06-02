import 'dart:async';

import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_entities/truda_info_entity.dart';
import 'package:truda/truda_services/truda_event_bus_bean.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_common/truda_common_type.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_dialogs/truda_dialog_vip_diamond_get.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_services/truda_storage_service.dart';
import '../../../truda_socket/truda_socket_entity.dart';
import '../../../truda_socket/truda_socket_manager.dart';
import '../../login/truda_login_util.dart';
import '../../vip/truda_vip_controller.dart';

class TrudaMeController extends GetxController {
  /// 加载会话列表时的最下面一条的时间戳，根据这个分页加载
  var time = DateTime.now().millisecondsSinceEpoch;
  TrudaInfoDetail? myDetail;

  late final TrudaCallback<TrudaSocketBalance> _balanceListener;

  /// event bus 监听
  late final StreamSubscription<String> sub;

  ///激励广告工具类
  // late NewHitaAdsRewardedUtils rewardedUtils;
  @override
  void onInit() {
    super.onInit();
    myDetail = TrudaMyInfoService.to.myDetail;
    _balanceListener = (balance) {
      NewHitaLog.debug(balance);
      myDetail?.userBalance?.remainDiamonds = balance.diamonds;
      // 邀请码
      if (balance.inviterCode?.isNotEmpty == true) {
        myDetail?.inviterCode = balance.inviterCode;
      }
      update();
    };
    TrudaSocketManager.to.addBalanceListener(_balanceListener);

    /// event bus 监听
    sub = TrudaStorageService.to.eventBus.on<String>().listen((event) {
      if (event == eventBusRefreshMe) {
        NewHitaLog.debug('eventBus eventBusRefreshMe');
        refreshMe();
      }
      if (event == eventBusUpdateMe) {
        NewHitaLog.debug('eventBus eventBusUpdateMe');
        myDetail = TrudaMyInfoService.to.myDetail;
        update();
      }
    });

    // 个人中心先不显示广告
    // rewardedUtils =
    //     NewHitaAdsRewardedUtils(NewHitaAdsUtils.getAdCode(NewHitaAdsUtils.REWARD_PROFILE), () {
    //   update();
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future refreshMe() async {
    NewHitaLog.debug('NewHitaMeController refreshMe()');
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
  void onClose() {
    sub.cancel();
    super.onClose();
    TrudaSocketManager.to.removeBalanceListener(_balanceListener);
    // rewardedUtils.closeSub();
  }

  void getVipDiamond() {
    if (myDetail?.isVip != 1) {
      TrudaCommonDialog.dialog(TrudaDialogConfirm(
        title: TrudaLanguageKey.newhita_vip_upgrade_ask.tr,
        callback: (i) {
          TrudaVipController.openDialog(
              createPath: TrudaChargePath.recharge_vip_dialog_user_center);
        },
      ));
      return;
    }
    // if (getTodayYet()) {
    //   TrudaCommonDialog.dialog(NewHitaDialogConfirm(
    //     title: TrudaLanguageKey.newhita_vip_diamond_already.tr,
    //     callback: (i) {},
    //     onlyConfirm: true,
    //   ));
    //   return;
    // } else {
    //
    // }
    TrudaHttpUtil().post<void>(TrudaHttpUrls.vipSignIn, errCallback: (err) {
      if (err.code == 71) {
        TrudaCommonDialog.dialog(TrudaDialogConfirm(
          title: TrudaLanguageKey.newhita_vip_diamond_already.tr,
          callback: (i) {},
          onlyConfirm: true,
        ));
      } else {
        NewHitaLoading.toast(err.message);
      }
    }).then((value) {
      // NewHitaStorageService.to.prefs
      //     .setBool('$keyEveryDay${_getTodayStr()}', true);
      int vipD = TrudaMyInfoService.to.config?.vipDailyDiamonds ?? 10;
      refreshMe();
      TrudaCommonDialog.dialog(
        TrudaDialogVipDiamondGet(
          diamond: vipD,
        ),
      );
      // Get.dialog(NewHitaDialogConfirm(
      //   title: TrudaLanguageKey.newhita_vip_diamond_get.trArgs([vipD.toString()]),
      //   callback: (i) {},
      //   onlyConfirm: true,
      // ));
    });
  }

  String _getTodayStr() {
    final today = DateTime.now();
    return "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
  }

  final String keyEveryDay = "keyVipDiamond-";

  // 获取今天使用了几次
  bool getTodayYet() {
    return TrudaStorageService.to.prefs
            .getBool('$keyEveryDay${_getTodayStr()}') ??
        false;
  }

  bool _logining = false;
  TrudaLoginUtil loginUtil = TrudaLoginUtil();
  void googleSignIn() {
    if (_logining) {
      return;
    }
    _logining = true;
    loginUtil.googleSignIn((callback) {
      if (callback.success) {
        _loginGoogle(
            callback.token, callback.id, callback.nickname, callback.cover);
      } else {
        NewHitaLoading.toast(TrudaLanguageKey.newhita_err_unknown.tr);
      }
      _logining = false;
    });
  }

  /// google登录
  void _loginGoogle(String? token, String id, String? nickname, String? cover) {
    var config =
    TrudaHttpUtil().post<void>(TrudaHttpUrls.bindGoogle, data: {
      "id": id,
      "cover": cover ?? '',
      "token": token ?? '',
      "nickname": nickname ?? '',
    }, errCallback: (err) {
      NewHitaLoading.toast(err.toString());
    }, doneCallback: (success, re) {
      _logining = false;
    }, showLoading: true);
    config.then((value) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
    });
  }
}
