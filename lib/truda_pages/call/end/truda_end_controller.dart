import 'dart:async';

import 'package:get/get.dart';
import 'package:truda/truda_common/truda_call_status.dart';
import 'package:truda/truda_common/truda_charge_path.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_pages/chargedialog/truda_charge_dialog_manager.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_sender.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/ai/truda_ai_logic_utils.dart';
import 'package:truda/truda_utils/newhita_format_util.dart';

import '../../../truda_entities/truda_end_call_entity.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_http/truda_common_api.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_services/truda_event_bus_bean.dart';
import '../../../truda_socket/truda_socket_entity.dart';
import '../../../truda_utils/newhita_log.dart';

/// 这个页面是有可能出现多个的，Controller要注意处理！！！
class TrudaEndController extends GetxController {
  static startMeAndOff({
    required String herId,
    required String channelId,
    required String portrait,
    required int endType,
    required int callType,
    required int callTime,
    TrudaHostDetail? detail,
    bool? useCard,
    bool? callHadShowCount20,
  }) {
    NewHitaLog.debug('TrudaEndController startMeAndOff');
    Map<String, dynamic> map = {};
    map['herId'] = herId;
    map['channelId'] = channelId;
    map['portrait'] = portrait;
    map['endType'] = endType;
    map['callType'] = callType;
    map['callTime'] = callTime;
    map['detail'] = detail;
    map['useCard'] = useCard;
    map['callHadShowCount20'] = callHadShowCount20;
    // 要退出聊天页面到结算
    // final noDialog = Get.currentRoute == NewHitaAppPages.call &&
    //     Get.isDialogOpen != true &&
    //     Get.isBottomSheetOpen != true &&
    //     Get.isOverlaysOpen != true &&
    //     Get.isSnackbarOpen != true;
    // final notCalling = Get.currentRoute != NewHitaAppPages.call;
    // Navigator.popUntil(Get.context!, (route) => noDialog || notCalling);
    // if (notCalling) {
    //   Get.toNamed(NewHitaAppPages.callEnd, arguments: map);
    // } else {
    //   Get.offAndToNamed(NewHitaAppPages.callEnd, arguments: map);
    // }
    /// 关闭弹窗
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    navigator?.popUntil((route) {
      return (Get.isOverlaysClosed && Get.currentRoute != TrudaAppPages.reportPageNew);
    });
    Get.offAndToNamed(TrudaAppPages.callEnd, arguments: map);
  }

  late String herId;
  late String portrait;
  late String channelId;
  late int endType;
  late bool useCard;
  late bool callHadShowCount20;

  // 0拨打，1被叫，2aib拨打(aib是被叫页面，实际是要去拨打)
  late int callType;
  late int callTime;
  TrudaHostDetail? detail;
  Rx<TrudaEndCallEntity?> endCallEntity = Rx(null);

  /// event bus 监听
  late final StreamSubscription<TrudaSocketHostState> sub;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    herId = arguments['herId']!;
    channelId = arguments['channelId'] ?? '';
    portrait = arguments['portrait'] ?? '';
    endType = arguments['endType'] ?? 0;
    callType = arguments['callType'] ?? 0;
    callTime = arguments['callTime'] ?? 0;
    detail = arguments['detail'];
    useCard = arguments['useCard'] ?? false;
    callHadShowCount20 = arguments['callHadShowCount20'] ?? false;

    // _createCall();

    TrudaAiLogicUtils().setNextTimer();

    /// event bus 监听主播在线状态
    sub = TrudaStorageService.to.eventBus
        .on<TrudaSocketHostState>()
        .listen((event) {
      if (herId == event.userId) {
        detail?.isOnline = event.isOnline;
        detail?.isDoNotDisturb = event.isDoNotDisturb;
        update();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _endCall();
    final remain =
        TrudaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    final callCost = TrudaMyInfoService.to.config?.chargePrice ?? 60;
    if (remain < callCost && !callHadShowCount20) {
      TrudaChargeDialogManager.showChargeDialog(
          TrudaChargePath.chating_end_showrecharge,
          upid: herId);
    }
  }

  /// 结束通话
  void _endCall() {
    NewHitaLog.debug('TrudaEndController _endCall');
    // aic没有 channelId
    if (channelId.isEmpty) {
      var entity = TrudaEndCallEntity();
      // 这个1为了触发页面显示时间
      entity.callAmount = 0;
      entity.giftAmount = 0;
      entity.callTime = NewHitaFormatUtil.getTimeStrFromSecond(callTime);
      entity.usedProp = useCard;
      endCallEntity.value = entity;

      TrudaStorageService.to.objectBoxCall.savaCallHistory(
          herId: herId,
          herVirtualId: detail?.username ?? '',
          channelId: channelId,
          callType: callType,
          callStatus: TrudaCallStatus.PICK_UP,
          dateInsert: DateTime.now().millisecondsSinceEpoch,
          duration: NewHitaFormatUtil.getTimeStrFromSecond(callTime));
      return;
    }
    TrudaHttpUtil()
        .post<TrudaEndCallEntity>(TrudaHttpUrls.endCallApi,
            data: {
              "channelId": channelId,
              "endType": endType,
              "clientEndAt": DateTime.now().millisecondsSinceEpoch,
              "clientDuration": callTime * 1000
            },
            doneCallback: (success, msg) {},
            showLoading: true)
        .then((value) {
      endCallEntity.value = value;
      // 拨打方发消息 aib在拨打时如果传了aiType,主播端会发消息
      if (callType == 0) {
        NewHitaLog.debug('TrudaEndController _endCall endCallApi');
        TrudaRtmMsgSender.sendCallState(
            herId, TrudaCallStatus.PICK_UP, value.totalCallTime);

        TrudaStorageService.to.objectBoxCall.savaCallHistory(
            herId: herId,
            herVirtualId: detail?.username ?? '',
            channelId: channelId,
            callType: callType,
            callStatus: TrudaCallStatus.PICK_UP,
            dateInsert: DateTime.now().millisecondsSinceEpoch,
            duration: value.totalCallTime ?? '00:00');
      }
      TrudaStorageService.to.eventBus.fire(eventBusRefreshMe);
      if (value.usedProp == true && value.callCardCount == 0) {
        // 使用了体验卡并且使体验卡变成0
        TrudaMyInfoService.to.myDetail?.callCardCount = 0;
        TrudaAiLogicUtils().setNextTimer();
      }
    });
  }

  void handleFollow() {
    // NewHitaHttpUtil().post<int>(NewHitaHttpUrls.followUpApi + herId,
    //     errCallback: (err) {
    //   NewHitaLoading.toast(err.message);
    // }, showLoading: true).then((value) {
    //   detail?.followed = value;
    //   update();
    // });
    TrudaCommonApi.followHostOrCancel(herId).then((value) {
      detail?.followed = value;
      update();
    });
  }
  @override
  void onClose() {
    super.onClose();
    sub.cancel();
  }
}
