import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:truda/truda_common/truda_call_status.dart';
import 'package:truda/truda_common/truda_end_type_2.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_pages/chargedialog/truda_charge_dialog_manager.dart';
import 'package:truda/truda_services/truda_event_bus_bean.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_rtm/truda_rtm_manager.dart';
import '../../../truda_rtm/truda_rtm_msg_sender.dart';
import '../../../truda_services/truda_my_info_service.dart';
import '../../../truda_services/truda_storage_service.dart';
import '../../../truda_utils/newhita_log.dart';
import '../../../truda_utils/newhita_permission_handler.dart';
import '../../../truda_utils/newhita_voice_player.dart';

class TrudaLocalController extends GetxController {
  static startMe(String herId, String? portrait, {bool closeSelf = false}) {
    //获取到权限再去拨打页面
    NewHitaPermissionHandler.checkCallPermission().then((value) {
      if (!value) return;
      Map<String, dynamic> map = {};
      map['herId'] = herId;
      map['portrait'] = portrait;
      if (closeSelf) {
        Get.offNamed(TrudaAppPages.callOut, arguments: map);
      } else {
        Get.toNamed(TrudaAppPages.callOut, arguments: map);
      }
    });
  }

  late String herId;
  late String portrait;
  String channelId = '';
  TrudaHostDetail? detail;
  late String content;

  /// event bus 监听
  late final StreamSubscription<TrudaEventRtmCall> sub;

  // 通话计时器
  Timer? _timer;

  // 时长
  var callTime = 0;
  var waitingStr = ''.obs;
  bool hadCancelCall = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    herId = arguments['herId']!;
    portrait = arguments['portrait'] ?? '';

    askPermission();

    _getHostDetail();

    /// event bus 监听
    sub = TrudaStorageService.to.eventBus.on<TrudaEventRtmCall>().listen((event) {
      // 1 我的呼叫被接受 2 我的呼叫被拒绝 3对方呼叫取消
      if (event.type == 1) {
        if (event.invite?.channelId != channelId) return;
        _timer?.cancel();
        _timer = null;
        pickUp();
      } else if (event.type == 2) {
        _timer?.cancel();
        _timer = null;
        NewHitaAudioCenter2.stopPlayRing();
        TrudaCommonDialog.dialog(TrudaDialogConfirm(
          title: TrudaLanguageKey.newhita_video_hang_up_tip.tr,
          onlyConfirm: true,
          callback: (int callback) {},
        )).then((value) {
          hangUp(TrudaEndType2.callingRefused);
        });
      }
    });
  }

  void askPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
    }

    // You can can also directly ask the permission about its status.
    // if (await Permission.location.isRestricted) {
    // The OS restricts access, for example because of parental controls.
    // }
  }

  void _getHostDetail() {
    TrudaHttpUtil().post<TrudaHostDetail>(
      TrudaHttpUrls.upDetailApi + herId,
      errCallback: (err) {
        NewHitaLog.debug(err);
        NewHitaLoading.toast(err.message);
        _closeMe();
      },
      showLoading: true,
    ).then((value) {
      detail = value;
      portrait = value.portrait ?? '';
      update();
      content = json.encode(value);
      if (!value.isShowOnline) {
        TrudaStorageService.to.objectBoxCall.savaCallHistory(
            herId: herId,
            herVirtualId: detail?.username ?? '',
            channelId: '',
            callType: 0,
            callStatus: TrudaCallStatus.USER_OFF,
            dateInsert: DateTime.now().millisecondsSinceEpoch,
            duration: '00:00');

        int myDiamond =
            TrudaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
        int callDiamond = TrudaMyInfoService.to.config?.chargePrice ?? 60;
        int myCard = TrudaMyInfoService.to.myDetail?.callCardCount ?? 0;
        // 没有钱也没有体验卡
        if (myDiamond < callDiamond && myCard < 1) {
          Future.delayed(Duration(milliseconds: 100), () {
            _showChargeAndStopMusic();
          });
          return;
        }
        String str;
        if (value.isOnline == 2) {
          str = TrudaLanguageKey.newhita_message_video_chat_state_user_busy.tr;
        } else {
          str = TrudaLanguageKey.newhita_video_hang_up_tip_3.tr;
        }
        NewHitaAudioCenter2.stopPlayRing();
        callStatistics(0, 2);
        Get.dialog(TrudaDialogConfirm(
          title: str,
          onlyConfirm: true,
          callback: (int callback) {},
        )).then((value) {
          _closeMe();
        });
        return;
      }
      if (hadCancelCall) {
        return;
      }
      _createCall();
    });
  }

  void _createCall() {
    _startTimer();
    TrudaHttpUtil().post<int>(TrudaHttpUrls.createCallApi + herId,
        errCallback: (err) {
      NewHitaLog.debug(err);
      NewHitaLoading.toast(err.message);

      int callStatus = TrudaCallStatus.USER_NOT_DIAMONDS;
      if (err.code == 8) {
        _showChargeAndStopMusic();
        callStatistics(0, 5);
      } else {
        TrudaRtmMsgSender.sendCallState(
            herId, TrudaCallStatus.MY_HANG_UP, '00:00');
        _closeMe();
        callStatistics(0, 7);
        callStatus = TrudaCallStatus.NET_ERR;
      }
      TrudaStorageService.to.objectBoxCall.savaCallHistory(
          herId: herId,
          herVirtualId: detail?.username ?? '',
          channelId: '',
          callType: 0,
          callStatus: callStatus,
          dateInsert: DateTime.now().millisecondsSinceEpoch,
          duration: '00:00');
    }).then((value) {
      if (hadCancelCall) {
        return;
      }
      channelId = value.toString();
      TrudaRtmManager.sendInvitation(herId, channelId, (success) {});
    });
  }

  // raiseType 0.正常唤起 1.AI唤起
  // statisticsType 1 呼叫 2 客户端忙线 3 用户被叫拒绝 4 用户被叫超时
  // 5 用户余额不足 6 用户被叫对方取消 7 用户连接异常
  void callStatistics(int isAib, int entType) {
    TrudaHttpUtil().post<void>(
      TrudaHttpUrls.appCallStatistics + '/$isAib/$entType',
    );
  }

  void _showChargeAndStopMusic() {
    _timer?.cancel();
    _timer = null;
    NewHitaAudioCenter2.stopPlayRing();
    TrudaChargeDialogManager.showChargeDialog(
      TrudaChargePath.create_call_no_money,
      upid: herId,
      noMoneyShow: true,
      closeCallBack: () {},
    ).then((value) {
      _closeMe();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callTime++;
      var temp = callTime % 3;
      var waiting = TrudaLanguageKey.newhita_video_call_wait.tr;
      if (temp == 0) {
        waitingStr.value = waiting;
      } else if (temp == 1) {
        waitingStr.value = waiting + '.';
      } else if (temp == 2) {
        waitingStr.value = waiting + '..';
      }

      if (callTime > 18) {
        _timer?.cancel();
        _timer = null;
        hangUp(TrudaEndType2.callingTimeOut);
      }
    });
    NewHitaAudioCenter2.playRing();
  }

  void hangUp(int endType) {
    hadCancelCall = true;
    if (channelId.isNotEmpty) {
      TrudaRtmManager.cancelLocalInvitation(herId, channelId, (success) {});
      TrudaRtmMsgSender.sendCallState(herId, TrudaCallStatus.MY_HANG_UP, '00:00');
      TrudaStorageService.to.objectBoxCall.savaCallHistory(
          herId: herId,
          herVirtualId: detail?.username ?? '',
          channelId: channelId,
          callType: 0,
          callStatus: TrudaCallStatus.MY_HANG_UP,
          dateInsert: DateTime.now().millisecondsSinceEpoch,
          duration: '00:00');
      TrudaHttpUtil().post<void>(TrudaHttpUrls.cancelCallApi,
          data: {'channelId': channelId, 'endType': endType});
    }
    _closeMe();
  }

  void pickUp() {
    /// 关闭弹窗
    if (Get.isOverlaysOpen) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      navigator?.popUntil((route) {
        return (!Get.isDialogOpen! && !Get.isBottomSheetOpen!);
      });
    }
    Map<String, dynamic> map = {};
    map['herId'] = herId;
    map['content'] = content;
    map['channelId'] = channelId;
    Get.offAndToNamed(TrudaAppPages.call, arguments: map);
  }

  void _closeMe() {
    /// 关闭弹窗
    if (Get.isOverlaysOpen) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      navigator?.popUntil((route) {
        return (!Get.isDialogOpen! && !Get.isBottomSheetOpen!);
      });
    }
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
    sub.cancel();
    _timer?.cancel();
    NewHitaAudioCenter2.stopPlayRing();
  }
}
