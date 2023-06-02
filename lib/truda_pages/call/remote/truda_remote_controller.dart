import 'dart:async';
import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_end_type_2.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_pages/chargedialog/truda_charge_dialog_manager.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/newhita_voice_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../truda_common/truda_call_status.dart';
import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_database/entity/truda_aic_entity.dart';
import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_entities/truda_aiv_entity.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_rtm/truda_rtm_manager.dart';
import '../../../truda_services/truda_event_bus_bean.dart';
import '../../../truda_services/truda_storage_service.dart';
import '../../../truda_utils/ai/truda_ai_logic_utils.dart';
import '../../../truda_utils/newhita_check_calling_util.dart';
import '../../../truda_utils/newhita_facebook_util.dart';
import '../../../truda_utils/newhita_loading.dart';
import '../../../truda_utils/newhita_log.dart';
import '../../../truda_utils/newhita_permission_handler.dart';
import '../aic/truda_aic_controller.dart';
import '../aiv/truda_aiv_controller.dart';
import '../aiv/truda_aiv_video_controller.dart';

class TrudaRemoteController extends GetxController {
  static startMeAic(TrudaAicEntity aic) async {
    var myDiamonds =
        TrudaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    if (myDiamonds > 60) {
      if (TrudaConstants.isTestMode &&
          TrudaHttpUrls.getConfigBaseUrl().startsWith('https://test')) {
        NewHitaLoading.toast(
          '测试时，有钱也打开aic',
          duration: Duration(seconds: 4),
        );
      } else {
        NewHitaLog.debug('TrudaRemoteController 有钱屏蔽aic');
        return;
      }
    }
    // 关闭广告
    finishExceptActivity();
    Map<String, dynamic> map = {};
    map['herId'] = aic.userId;
    map['url'] = aic.filename;
    map['localPath'] = aic.localPath;
    map['callType'] = 3;
    map['aic'] = aic;
    // 这个延时是有bug
    // Future.delayed(Duration.zero, () {
    //   // startMeAic前面已经检查过了，这里再检查一遍
    //
    // });
    if (NewHitaCheckCallingUtil.checkCanAic()) {
      await _toThisPage(map);
    } else {
      TrudaHttpUtil().post(TrudaHttpUrls.hanAIA_Api + '/${aic.userId}/0');
    }
  }

  static startMeAib(String herId, String content) {
    // 关闭广告
    finishExceptActivity();
    Map<String, dynamic> map = {};
    map['herId'] = herId;
    map['content'] = content;
    map['callType'] = 2;
    _toThisPage(map);
  }

  static bool startMeAiv(TrudaAivBean bean) {
    // 关闭广告
    finishExceptActivity();
    Map<String, dynamic> map = {};
    map['herId'] = bean.userId;
    // map['content'] = json.encode(bean);
    map['callType'] = 4;
    map['aiv'] = bean;
    if (NewHitaCheckCallingUtil.checkCanAic()) {
      _toThisPage(map);
      return true;
    } else {
      TrudaHttpUtil().post(TrudaHttpUrls.hanAIA_Api + '/${bean.userId}/0');
      return false;
    }
  }

  static startMe(String herId, String channelId, String content) {
    // 关闭广告
    finishExceptActivity();
    Map<String, dynamic> map = {};
    map['herId'] = herId;
    map['channelId'] = channelId;
    map['content'] = content;
    map['callType'] = 1;

    _toThisPage(map);
  }

  static Future _toThisPage(Map<String, dynamic> map) async {
    /// 关闭弹窗
    if (Get.isOverlaysOpen) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      navigator?.popUntil((route) {
        return (!Get.isDialogOpen! && !Get.isBottomSheetOpen!);
      });
    }
    // 上一个被叫页面关掉
    // 当前是匹配页面也关掉
    if (Get.currentRoute == TrudaAppPages.callEnd) {
      await Get.offNamed(TrudaAppPages.callCome, arguments: map);
    } else {
      await Get.toNamed(TrudaAppPages.callCome, arguments: map);
    }
  }

  late String herId;
  late String channelId;
  late String content;
  String portrait = '';

  /// 0拨打，1被叫，
  /// 2aib拨打(aib是被叫页面，实际是要去拨打),
  /// 3aic
  /// 4aiv 直接显示网络视频
  late int callType;
  TrudaHostDetail? detail;
  TrudaAicEntity? aic;
  TrudaAivBean? aiv;

  // aic 是否消耗体验卡
  int isCard = 0;

  // 通话计时器
  Timer? _timer;

  // 时长
  var callTime = 0;
  var waitingStr = ''.obs;
  var herCharge = ''.obs;

  // 1,表示是免费电话，2表示是你有一个体验卡
  var freeTip = 0;
  var iHaveCard = 0;
  var stoping = false;

  /// event bus 监听
  late final StreamSubscription<TrudaEventRtmCall> sub;
  TrudaAivVideoController? _aivVideoController;
  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    herId = arguments['herId']!;
    channelId = arguments['channelId'] ?? '';
    content = arguments['content'] ?? '';
    callType = arguments['callType'] ?? 1;
    // 0拨打，1被叫，
    // 2aib拨打(aib是被叫页面，实际是要去拨打),
    // 3aic
    // 4aiv 直接显示网络视频
    if (callType == 3) {
      aic = arguments['aic'];
      isCard = aic?.isCard ?? 0;
    } else if (callType == 4) {
      aiv = arguments['aiv'];
      isCard = aiv?.isCard ?? 0;
      _aivVideoController = TrudaAivVideoController.make(aiv!.filename!);
    }

    NewHitaLog.debug(content);
    if (content.isNotEmpty) {
      detail = TrudaHostDetail.fromJson(json.decode(content));
      portrait = detail?.portrait ?? '';
    }
    // 自己的体验卡
    iHaveCard = TrudaMyInfoService.to.myDetail?.callCardCount ?? 0;
    if (callType == 4) {
      iHaveCard = aiv?.callCardCount ?? 0;
    }

    /// 展示你有体验卡或aic免费电话
    if ((callType == 3 || callType == 4) && isCard == 0) {
      // 1,表示是免费电话，2表示是你有一个体验卡
      freeTip = 1;
    } else {
      if (iHaveCard > 0) {
        freeTip = 2;
      } else {
        freeTip = 0;
      }
    }

    /// event bus 监听
    sub = TrudaStorageService.to.eventBus.on<TrudaEventRtmCall>().listen((event) {
      if (event.type == 3) {
        if (event.herInvite?.channelId != channelId) return;
        _closeMe();
        _submitRefuseCall(channelId, TrudaEndType2.calledCanceled);
      }
    });
    Wakelock.enable();
  }

  @override
  void onReady() {
    super.onReady();
    // askPermission();
    _startTimer();
    _getHostDetail();
    NewHitaPermissionHandler.askCallPermission();
  }

  // void askPermission() async {
  //   var status = await Permission.camera.status;
  //   if (!status.isGranted) {
  //     // We didn't ask for permission yet or the permission has been denied before but not permanently.
  //     // You can request multiple permissions at once.
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.camera,
  //       Permission.microphone,
  //     ].request();
  //   }
  //
  //   // You can can also directly ask the permission about its status.
  //   // if (await Permission.location.isRestricted) {
  //   // The OS restricts access, for example because of parental controls.
  //   // }
  // }

  void _startTimer() {
    // callTime = 0;
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

      if (callTime > 15) {
        _timer?.cancel();
        _timer = null;
        hangUp(timeOut: true);
      }
    });

    NewHitaAudioCenter2.playRing();
  }

  void hangUp({bool timeOut = false}) {
    if (stoping) return;
    _aivVideoController?.playerController.dispose();
    stoping = true;
    if (callType == 2) {
      // aib拒接延时
      if (!timeOut) {
        TrudaAiLogicUtils().setNextTimer(isRejectDelay: true);
      }
    }
    // 不是虚拟视频,refuse call
    if (callType != 3 && callType != 4) {
      _submitRefuseCall(
        channelId,
        timeOut ? TrudaEndType2.calledTimeOut : TrudaEndType2.calledRefuse,
      );
    } else {
      // 是虚拟视频 被拒绝了请求一个话术
      TrudaHttpUtil().post(TrudaHttpUrls.hanAIA_Api + '/$herId/0');
    }
    if (callType > 1) {
      // 插入一个通话记录
      saveCallHis();
    } else {
      // 拒接
      TrudaRtmManager.rejectInvitation(
          AgoraRtmRemoteInvitation(herId,
              content: content, channelId: channelId, response: ''),
          (sucdess) {});
    }
    _closeMe();
  }

  // void hangUp({bool timeOut = false}) {
  //   if (stoping) return;
  //   if (callType != 3) {
  //     _submitRefuseCall(
  //       channelId,
  //       timeOut ? TrudaEndType2.calledTimeOut : TrudaEndType2.calledRefuse,
  //       callType == 2 ? 1 : 0,
  //     );
  //   }
  //   stoping = true;
  //   if (callType > 1) {
  //     _closeMe();
  //     // 插入一个通话记录
  //     if (callType == 2 || callType == 3) {
  //       saveCallHis();
  //     }
  //     return;
  //   }
  //   NewHitaRtmManager.rejectInvitation(
  //       AgoraRtmRemoteInvitation(herId,
  //           content: content, channelId: channelId, response: ''),
  //       (sucdess) {});
  //   _closeMe();
  //   saveCallHis();
  //   if (callType == 3) {
  //     NewHitaHttpUtil().post(NewHitaHttpUrls.hanAIA_Api + '/$herId/0');
  //   }
  // }

  void saveCallHis() {
    TrudaStorageService.to.objectBoxCall.savaCallHistory(
        herId: herId,
        herVirtualId: detail?.username ?? '',
        channelId: channelId,
        callType: callType,
        callStatus: TrudaCallStatus.MY_HANG_UP,
        dateInsert: DateTime.now().millisecondsSinceEpoch,
        duration: '00:00');
  }

  void pickUp() {
    TrudaAiLogicUtils().reduceRejectCount();
    int myDiamond =
        TrudaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    int callDiamond = TrudaMyInfoService.to.config?.chargePrice ?? 60;
    int myCard = TrudaMyInfoService.to.myDetail?.callCardCount ?? 0;

    if (callType == 3) {
      // aic要消耗体验卡但是没有体验卡
      if (isCard == 1 && myCard < 1) {
        Future.delayed(Duration(milliseconds: 100), () {
          _showChargeAndStopMusic();
        });
        saveCallHis();
        return;
      }
      String localPath = Get.arguments['localPath'] ?? '';
      String url = Get.arguments['url'] ?? '';
      if (localPath.isEmpty || url.isEmpty) return;
      TrudaAicController.startMeAndOff(herId, url, localPath, isCard, aic!);
      TrudaHttpUtil().post(TrudaHttpUrls.hanAIA_Api + '/$herId/1');
      return;
    }

    if (callType == 4) {
      // aic要消耗体验卡但是没有体验卡
      if (isCard == 1 && myCard < 1) {
        Future.delayed(Duration(milliseconds: 100), () {
          _showChargeAndStopMusic();
        });
        saveCallHis();
        return;
      }
      String url = aiv?.filename ?? '';
      if (url.isEmpty) return;
      TrudaAivController.startMeAndOff(
          herId, isCard, aiv!, _aivVideoController!);
      TrudaHttpUtil().post(TrudaHttpUrls.hanAIA_Api + '/$herId/1');
      return;
    }
    // 没有钱也没有体验卡
    if (myDiamond < callDiamond && myCard < 1) {

      Future.delayed(Duration(milliseconds: 100), () {
        _showChargeAndStopMusic();
      });
      if (callType == 2){
        saveCallHis();
      } else {
        TrudaRtmManager.rejectInvitation(
            AgoraRtmRemoteInvitation(herId,
                content: content, channelId: channelId, response: '8'),
                (sucdess) {});
      }
      _submitRefuseCall(channelId, TrudaEndType2.noMoney);
      return;
    }

    if (callType == 2) {
      _createCall();
      return;
    }
    if (callType == 1) {
      TrudaRtmManager.acceptInvitation(
          AgoraRtmRemoteInvitation(herId,
              content: content, channelId: channelId),
          (sucdess) {});
    }
    _toCallPage();
  }

  void _toCallPage() {
    Map<String, dynamic> map = {};
    map['herId'] = herId;
    map['content'] = content;
    map['callType'] = callType;
    map['channelId'] = channelId;
    Get.offAndToNamed(TrudaAppPages.call, arguments: map);
  }

  void _getHostDetail() {
    TrudaHttpUtil().post<TrudaHostDetail>(TrudaHttpUrls.upDetailApi + herId,
        errCallback: (err) {
      NewHitaLog.debug(err);
    }).then((value) {
      detail = value;
      portrait = value.portrait ?? '';
      // update();
      content = json.encode(value);
      herCharge.value = (detail?.charge ?? 60).toString();
      update();

      TrudaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
          value.nickname ?? '', value.userId!,
          portrait: value.portrait));
    });
  }

  /// AIB主动拨打
  void _createCall() {
    if (!_aibCheckOnline()) return;
    TrudaHttpUtil().post<int>(
      TrudaHttpUrls.createAIBCallApi + herId,
      errCallback: (err) {
        NewHitaLog.debug(err);
        NewHitaLoading.toast(err.message);
        if (err.code == 8) {
          _showChargeAndStopMusic();
          callStatistics(1, 5);
        } else {
          _closeMe();
          callStatistics(1, 7);
        }
      },
      showLoading: true,
    ).then((value) {
      channelId = value.toString();
      _toCallPage();
    });
  }

  // aib先检查下主播是否在线，一般aib时主播是在线的
  bool _aibCheckOnline() {
    if (detail == null) return false;
    if (detail?.isShowOnline == true) return true;
    TrudaStorageService.to.objectBoxCall.savaCallHistory(
        herId: herId,
        herVirtualId: detail?.username ?? '',
        channelId: '',
        callType: 1,
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
        // if (Get.isDialogOpen == true) return;
        _showChargeAndStopMusic();
      });
      return false;
    }
    String str;
    if (detail!.isOnline == 2) {
      str = TrudaLanguageKey.newhita_message_video_chat_state_user_busy.tr;
    } else {
      str = TrudaLanguageKey.newhita_video_hang_up_tip_3.tr;
    }
    NewHitaAudioCenter2.stopPlayRing();
    callStatistics(1, 1);
    Get.dialog(TrudaDialogConfirm(
      title: str,
      onlyConfirm: true,
      callback: (int callback) {},
    )).then((value) {
      _closeMe();
    });
    return false;
  }

  void _showChargeAndStopMusic() {
    NewHitaAudioCenter2.stopPlayRing();
    _timer?.cancel();
    _timer = null;
    TrudaChargeDialogManager.showChargeDialog(
      TrudaChargePath.create_call_no_money,
      upid: herId,
      noMoneyShow: true,
      closeCallBack: () {},
    ).then((value) {
      _closeMe();
    });
  }

  // raiseType 0.正常唤起 1.AI唤起
  // statisticsType 1 呼叫失败 2 客户端忙线 3 用户被叫拒绝 4 用户被叫超时
  // 5 用户余额不足 6 用户被叫对方取消 7 用户连接异常
  void callStatistics(int isAib, int statisticsType) {
    TrudaHttpUtil().post<void>(
      TrudaHttpUrls.appCallStatistics + '/$isAib/$statisticsType',
    );
  }

  // channelId
  // endType 挂断原因，
  // isRobot 是否系统自动唤起 aib唤起的拒接接听( isRobot传1 —— channelId传入主播id)
  void _submitRefuseCall(
    String channelId,
    int endType,
  ) {
    // if (channelId.isEmpty && isRobot != 1) return;
    if (callType == 2) {
      // callStatistics 里面的状态和其他的endtype不一样
      int statisticsType = 7;
      if (endType == TrudaEndType2.calledTimeOut) {
        statisticsType = 4;
      } else if (endType == TrudaEndType2.calledRefuse) {
        statisticsType = 3;
        // 手动挂掉aib，做一个延迟aib
        TrudaHttpUtil().post<void>(TrudaHttpUrls.refuseAIBCall + herId);
      } else if (endType == TrudaEndType2.noMoney) {
        statisticsType = 5;
      }
      callStatistics(1, statisticsType);
      return;
    }
    TrudaHttpUtil().post<void>(TrudaHttpUrls.refuseCallApi, data: {
      "channelId": channelId,
      "endType": endType,
      "isRobot": 0,
      // "isRobot": isRobot,
    }, errCallback: (err) {
      NewHitaLog.debug(err);
    });
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
    _timer?.cancel();
    sub.cancel();
    NewHitaAudioCenter2.stopPlayRing();
    Wakelock.disable();
  }
}
