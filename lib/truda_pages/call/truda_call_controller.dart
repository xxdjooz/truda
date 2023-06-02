import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:disable_screenshots/disable_screenshots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_end_type_2.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_pages/chargedialog/truda_charge_dialog_manager.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_socket/truda_socket_manager.dart';
import 'package:truda/truda_utils/newhita_format_util.dart';
import 'package:wakelock/wakelock.dart';

import '../../truda_common/truda_call_status.dart';
import '../../truda_common/truda_charge_path.dart';
import '../../truda_common/truda_colors.dart';
import '../../truda_common/truda_common_dialog.dart';
import '../../truda_common/truda_common_type.dart';
import '../../truda_common/truda_language_key.dart';
import '../../truda_database/entity/truda_msg_entity.dart';
import '../../truda_dialogs/truda_dialog_call_sexy.dart';
import '../../truda_dialogs/truda_dialog_confirm.dart';
import '../../truda_entities/truda_contribute_entity.dart';
import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_entities/truda_host_entity.dart';
import '../../truda_entities/truda_info_entity.dart';
import '../../truda_entities/truda_join_call_entity.dart';
import '../../truda_entities/truda_send_gift_result.dart';
import '../../truda_http/truda_common_api.dart';
import '../../truda_routes/truda_pages.dart';
import '../../truda_rtm/truda_rtm_manager.dart';
import '../../truda_rtm/truda_rtm_msg_entity.dart';
import '../../truda_rtm/truda_rtm_msg_sender.dart';
import '../../truda_services/truda_event_bus_bean.dart';
import '../../truda_services/truda_storage_service.dart';
import '../../truda_socket/truda_socket_entity.dart';
import '../../truda_utils/newhita_gift_follow_tip.dart';
import '../../truda_utils/newhita_loading.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_widget/gift/newhita_gift_data_helper.dart';
import '../../truda_widget/gift/newhita_gift_list_view.dart';
import '../../truda_widget/gift/newhita_vap_player.dart';
import '../vip/truda_vip_controller.dart';
import 'end/truda_end_controller.dart';
import 'truda_count_20.dart';

class TrudaCallController extends GetxController {
  static const String idAgora = 'idAgora';
  static const String idSwitch = 'idSwitch';
  late String herId;
  String? channelId;
  late String content;
  late String token;
  late TrudaJoinCall _joinCall;

  // 0拨打，1被叫，2aib拨打(aib是被叫页面，实际是要去拨打)
  late int callType;
  TrudaHostDetail? detail;
  RtcEngine? _engine;
  var connecting = true;

  // 通话计时器
  Timer? _timer;
  Timer? _timerLink;

  // aib的呼叫时间
  final aibLinkTime = 30;

  // 一般的连接中时间
  final otherLinkTime = 20;

  // 对方进入频道后的等begincall超时时间
  final joinLinkTime = 10;

  int linkTime = 20;

  // 通话时长
  var callTime = 0;
  var callTimeStr = ''.obs;

  // 显示在使用体验卡
  var callTimeShowCard = false.obs;

  // 显示在语音模式
  var audioMode = false.obs;

  // 显示两分钟倒计时 1.60s倒计时 2.120s倒计时
  var showCount2Min = 0.obs;
  var count2MinLeft = 0.obs;

  // 默认主播是大屏，我小屏
  var switchView = false;
  late String myId;

  // 已经关注
  RxnInt followed = RxnInt(null);
  var myMoney = RxnInt(null);

  // double toTop = Get.height - 400;
  double toTop = 120;
  double toRight = 15;
  double toLeft = Get.width - 135;
  double maxToTop = Get.height - 300;
  double maxToRight = Get.width - 135;
  double maxToLeft = Get.width - 135;

  // 已经收到begincall
  bool hadBeginCall = false;

  // 本次电话用了体验卡
  bool thisCallUseCard = false;

  // 体验卡可以用的时长 s
  int callCardDurationSecond = 0;

  // 充值中，这个时候不要因为电话的挂断而关闭
  bool chargeing = false;

  // 本次电话结束
  bool thisCallFinish = false;

  // 已经进入结算页
  bool alreadyGotoEnd = false;

  bool callHadShowCount20 = false;

  // 显示鉴黄警告，这个socket消息可能多次触发，所以只显示一次
  bool hadShowSexy = false;
  var showWelcome = false.obs;
  var cleanScreen = false.obs;
  var welcomeText = '';

  /// event bus 监听
  late final StreamSubscription<TrudaEventRtmCall> sub;
  late final StreamSubscription<TrudaEventCommon> subCommon;
  late final StreamSubscription<TrudaRTMMsgBeginCall> subBeginCall;
  late final StreamSubscription<TrudaRTMMsgGift> giftSub;

  var myVapController = NewHitaVapController();
  late final TrudaCallback<TrudaSocketBalance> _balanceListener;

  Rx<TrudaGiftEntity> giftToQuickSend = TrudaGiftEntity().obs;
  Rx<TrudaGiftEntity?> askGift = Rx(null);

  late TrudaInfoDetail myInfo;

  // 初始化禁止截屏插件
  final DisableScreenshots _plugin = DisableScreenshots();
  StreamSubscription<void>? _screenshotsSubscription;

  late NewHitaGiftFollowTipController tipController;
  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    herId = arguments['herId']!;
    // AIB时还没有channelId
    channelId = arguments['channelId'] ?? '';
    content = arguments['content']!;
    callType = arguments['callType'] ?? 0;
    myInfo = TrudaMyInfoService.to.myDetail!;
    myId = myInfo.userId ?? "";
    myMoney.value = myInfo.userBalance?.remainDiamonds;
    if (content.isNotEmpty) {
      detail = TrudaHostDetail.fromJson(json.decode(content));
    }
    followed.value = detail?.followed;

    if (callType == 2) {
      // _getHostDetail();
      TrudaRtmManager.sendInvitation(herId, channelId!, (success) {},
          aiType: 25);
    }
    _getTokenV2();

    /// event bus 监听
    sub = TrudaStorageService.to.eventBus.on<TrudaEventRtmCall>().listen((event) {
      if (event.invite?.channelId != channelId) return;
      // 1 我的呼叫被接受 2 我的呼叫被拒绝 3对方呼叫取消
      if (event.type == 2) {
        _endCall(TrudaEndType2.callingRefused);
      }
    });
    subCommon =
        TrudaStorageService.to.eventBus.on<TrudaEventCommon>().listen((event) {
      // 0电话涉黄
      if (event.eventType == 0) {
        if (hadShowSexy) return;
        hadShowSexy = true;
        TrudaDialogCallSexy.checkToShow((i) {
          clickHangUp();
        });
      }
    });
    // 收到begincall，开始计时
    subBeginCall = TrudaStorageService.to.eventBus
        .on<TrudaRTMMsgBeginCall>()
        .listen((event) {
      NewHitaLog.debug('subBeginCall hadBeginCall=$hadBeginCall');
      if (event.channelId != channelId) return;
      if (hadBeginCall) return;
      hadBeginCall = true;
      _timerLink?.cancel();
      _timerLink = null;
      _beginTimer();
    });
    // 余额变动socket消息
    _balanceListener = (balance) {
      myMoney.value = balance.diamonds;
      var callDuration = balance.callDuration;
      if (callDuration == null) return;
      // 扣费导致还能打60s,说明现在还有120s.
      if (callDuration == 60 * 1000) {
        // 两分钟倒计时不显示了
        // showCount2Min.value = 2;
      } else if (callDuration == 0) {
        // 扣费导致还能打0s,说明现在还有60s.
        showCount2Min.value = 1;
      } else {
        showCount2Min.value = 0;
      }
    };
    TrudaSocketManager.to.addBalanceListener(_balanceListener);

    /// 主播索要礼物
    giftSub =
        TrudaStorageService.to.eventBus.on<TrudaRTMMsgGift>().listen((event) {
      _askGift(event);
    });
    Wakelock.enable();

    tipController = NewHitaGiftFollowTipController()
      ..listen((callback) {
        if (callback == 1) {
          handleFollow();
        } else if (callback == 2) {
          sendGift(tipController.gift!);
        }
      });
  }

  @override
  void onReady() {
    super.onReady();
    NewHitaGiftDataHelper.getGifts().then((value) {
      if (value != null && value.isNotEmpty) {
        giftToQuickSend.value = value.first;
      }
    });

    if (GetPlatform.isIOS) {
      _screenshotsSubscription = _plugin.onScreenShots.listen((event) {
        NewHitaLog.debug("用户进行了截屏");
        TrudaSocketManager.to.sendScreenshots(channelId ?? "");
      });
    } else {
      _plugin.disableScreenshots(true);
    }
  }

  /// 获取进入频道的token
  @Deprecated("_getTokenV2")
  void _getToken() {
    _startLinkTimer();
    TrudaHttpUtil().post<String>(TrudaHttpUrls.agoraTokenApi + channelId!,
        data: {}, errCallback: (err) {
      NewHitaLog.debug(err);
      NewHitaLoading.toast(err.message);
      _errBeforeCall(TrudaEndType2.linkErr);
    }).then((value) {
      token = value;
      if (thisCallFinish) return;
      try {
        _createEngine();
      } catch (e) {
        print(e);
        _errBeforeCall(TrudaEndType2.linkErr);
      }
    });
  }

  /// 获取进入频道的token
  void _getTokenV2() {
    _startLinkTimer();
    TrudaHttpUtil().post<TrudaJoinCall>(TrudaHttpUrls.joinCall + channelId!,
        data: {}, errCallback: (err) {
      NewHitaLog.debug(err);
      NewHitaLoading.toast(err.message);
      _errBeforeCall(TrudaEndType2.linkErr);
    }).then((value) {
      token = value.rtcToken!;
      _joinCall = value;
      if (thisCallFinish) return;
      try {
        _createEngine();
      } catch (e) {
        print(e);
        _errBeforeCall(TrudaEndType2.linkErr);
      }
    });
  }

  /// ready call
  void _readyCall() {
    // 对方加入后调整10s的beginCall时间
    linkTime = joinLinkTime;
    // 显示视频
    connecting = false;
    update();
    // NewHitaHttpUtil().post<void>(NewHitaHttpUrls.callReadyApi + channelId!);
    _refreshCallV2(first: true);

    _getContributeList();
  }

  // 创建 RTC 客户端实例
  void _createEngine() async {
    RtcEngineContext context =
        RtcEngineContext(TrudaMyInfoService.to.config?.agoraAppId ?? '');
    _engine = await RtcEngine.createWithContext(context);
    _engine?.setEventHandler(RtcEngineEventHandler(
        userJoined: _userJoined,
        userOffline: _userOffline,
        connectionLost: _connectionLost,
        remoteVideoStats: _remoteVideoStats,
        connectionBanned: () {
          _endCall(TrudaEndType2.hostBan);
          NewHitaLog.debug('connectionBanned');
        }));
    await _engine?.setVideoEncoderConfiguration(
      VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 360, height: 480),
        degradationPreference: DegradationPreference.MaintainFramerate,
        orientationMode: VideoOutputOrientationMode.FixedPortrait,
      ),
    );
    // 开启视频
    await _engine?.enableVideo();
    // 这里为了和主播保持一致
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine?.setClientRole(ClientRole.Broadcaster);
    // await _engine?.leaveChannel();
    // 加入频道
    await _engine?.startPreview();

    _engine?.joinChannel(token, channelId!, null,
        int.parse(TrudaMyInfoService.to.userLogin?.userId ?? '-999'));
  }

  void switchCamera() {
    _engine?.switchCamera();
  }

  var abandVolume = false.obs;

  void switchVoice() {
    if (abandVolume.value == true) {
      _engine?.adjustRecordingSignalVolume(100);
      abandVolume.value = false;
    } else {
      _engine?.adjustRecordingSignalVolume(0);
      abandVolume.value = true;
    }
  }

  // 打电话的计时器
  void _beginTimer() {
    thisCallUseCard = _joinCall.usedProp == true;
    // 如果用了体验卡，计时从负数开始
    if (thisCallUseCard) {
      callCardDurationSecond = (_joinCall.propDuration ?? 0) ~/ 1000;
      callTime = -callCardDurationSecond;
    } else {
      callTime = 0;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callTime++;
      if (callTime == 3) {
        // 延时设置一次常亮
        Wakelock.enable();
      }
      if (callTime > 0 && callTime % 60 == 0) {
        // 正常电话到了60s
        _refreshCallV2();
      } else if (callTime == 0 && thisCallUseCard) {
        // 体验卡结束
        _refreshCallV2();
      }
      // 2分钟倒计时
      if (showCount2Min.value == 2) {
        count2MinLeft.value = 120 - callTime % 60;
      } else if (showCount2Min.value == 1) {
        count2MinLeft.value = 60 - callTime % 60;
        if (count2MinLeft.value == 1) {
          showCount2Min.value = 0;
        }
      }
      // 20s倒计时
      if (showCount2Min.value > 0 && count2MinLeft.value == 20) {
        chargeing = true;
        callHadShowCount20 = true;
        Get.bottomSheet(TrudaCount20(
          leftSecond: 20,
          callback: (go) {
            if (go) {
              chargeing = true;
              clickCharge();
            } else {
              chargeing = false;
            }
          },
        ));
      }

      callTimeShowCard.value = callTime < 0;
      callTimeStr.value = NewHitaFormatUtil.getTimeStrFromSecond(callTime.abs());
    });
  }

  void handleFollow() {
    TrudaCommonApi.followHostOrCancel(herId).then((value) {
      detail?.followed = value;
      followed.value = value;
      update();
    });
  }

  /// 对方进入
  void _userJoined(int uid, int elapsed) {
    // 这个判断是为了监控端可能进入
    if (uid.toString() != herId) return;
    _readyCall();
    TrudaAppPages.closeDialog();
  }

  /// 对方挂断
  void _userOffline(int uid, UserOfflineReason reason) {
    // 这个判断是为了监控端可能进入
    if (uid.toString() != herId) return;
    Future.delayed(const Duration(seconds: 2), (){
      NewHitaLoading.toast(TrudaLanguageKey.newhita_video_hang_up_tip.tr,);
    });

    _endCall(reason == UserOfflineReason.Quit
        ? TrudaEndType2.otherHang
        : TrudaEndType2.otherOff);
  }

  /// 对方视频状态
  void _remoteVideoStats(RemoteVideoStats stats) {
    // 这个判断是为了监控端可能进入
    if (stats.uid.toString() != herId) return;
    NewHitaLog.debug('_remoteVideoStats ${stats.decoderOutputFrameRate}');
    if (stats.decoderOutputFrameRate <= 0) {
      audioMode.value = true;
      update();
    } else {
      audioMode.value = false;
      update();
    }
  }

  /// 连接中断
  void _connectionLost() {
    _endCall(TrudaEndType2.netErr);
  }

  // 点击了挂断
  void clickHangUp() {
    _endCall(connecting ? TrudaEndType2.linkCancel : TrudaEndType2.userHang);
    if (callType == 2 && !hadBeginCall) {
      TrudaStorageService.to.objectBoxCall.savaCallHistory(
          herId: herId,
          herVirtualId: detail?.username ?? '',
          channelId: '',
          callType: 0,
          callStatus: TrudaCallStatus.MY_HANG_UP,
          dateInsert: DateTime.now().millisecondsSinceEpoch,
          duration: '00:00');
    }
  }

  // 点击了礼物
  void clickGift() {
    Get.bottomSheet(
      NewHitaLianGiftListView(
        choose: (TrudaGiftEntity gift) {
          sendGift(gift);
        },
        herId: herId,
      ),
      backgroundColor: TrudaColors.baseColorBlackBg,
    );
  }

  void quickSendGift() {
    if (giftToQuickSend.value.gid == null) {
      clickGift();
    } else {
      sendGift(giftToQuickSend.value);
    }
  }

  // 点击了充值
  void clickCharge() {
    chargeing = true;
    TrudaChargeDialogManager.showChargeDialog(
        TrudaChargePath.chating_click_recharge,
        upid: herId, closeCallBack: () {
      chargeing = false;
      // if (thisCallFinish) {
      //   Future.delayed(
      //       const Duration(milliseconds: 60), () => _endCall(endType));
      // }
    });
  }

  void sendGift(TrudaGiftEntity gift) {
    TrudaHttpUtil().post<TrudaSendGiftResult>(TrudaHttpUrls.sendGiftApi,
        data: {"receiverId": herId, "quantity": 1, "gid": gift.gid},
        showLoading: true, errCallback: (err) {
      if (err.code == 8) {
        TrudaChargeDialogManager.showChargeDialog(
          TrudaChargePath.chating_send_gift_no_money,
          upid: herId,
          noMoneyShow: true,
        );
      } else if (err.code == 25) {
        TrudaCommonDialog.dialog(TrudaDialogConfirm(
          callback: (i) {
            TrudaVipController.openDialog(
                createPath: TrudaChargePath.recharge_send_vip_gift);
          },
          title: TrudaLanguageKey.newhita_vip_for_gift.tr,
          rightText: TrudaLanguageKey.newhita_vip_active_now.tr,
        ));
        return;
      }
      NewHitaLoading.toast(err.message, duration: const Duration(seconds: 3));
    }).then((value) {
      myVapController.playGift(gift);
      var json =
          TrudaRtmMsgSender.makeRTMMsgGift(herId, gift, value.gid.toString());
      var msg = TrudaMsgEntity(myId, herId, 0, 'gift',
          DateTime.now().millisecondsSinceEpoch, json, TrudaRTMMsgGift.typeCode,
          msgEventType: NewHitaMsgEventType.sending, sendState: 1);
      TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
        ..msgEventType = NewHitaMsgEventType.sendDone
        ..sendState = 0);
      tipController.hadSendGift();
    });
  }

  /// 用户端每计时一分钟时通知扣用户钻石
  @Deprecated("message")
  void _refreshCall() {
    TrudaHttpUtil().post<void>(
      TrudaHttpUrls.refreshCallApi + channelId!,

      /// 续费失败
      errCallback: (err) {
        if (err.code == 8) {
          _endCall(TrudaEndType2.keyNoMoney);
        } else {
          _endCall(TrudaEndType2.keyErr);
        }
      },
    );
  }

  /// 用户端每计时一分钟时通知扣用户钻石
  void _refreshCallV2({bool first = false}) {
    TrudaHttpUtil().post<String>(
      TrudaHttpUrls.refreshCallV2 + channelId!,

      /// 续费失败
      errCallback: (err) {
        if (err.code == 8) {
          _endCall(TrudaEndType2.keyNoMoney);
        } else {
          _endCall(TrudaEndType2.keyErr);
        }
      },
    ).then((value) {
      _engine?.renewToken(value);

      if (first) {
        if (hadBeginCall) return;
        hadBeginCall = true;
        _timerLink?.cancel();
        _timerLink = null;
        _beginTimer();
      }
    });
  }

  /// 结束通话
  void _endCall(int endType, {bool pop = false}) {
    this.endType = endType;
    thisCallFinish = true;
    _engine?.leaveChannel();
    _timer?.cancel();
    if (chargeing) {
      // 充值中，先不关页面
      return;
    }
    if (callTime == 0 && !thisCallUseCard) {
      _closeMe();
      return;
    }
    if (alreadyGotoEnd) {
      return;
    }
    alreadyGotoEnd = true;
    TrudaEndController.startMeAndOff(
      herId: herId,
      channelId: channelId ?? '',
      portrait: detail?.portrait ?? '',
      endType: endType,
      callTime: thisCallUseCard ? callTime + callCardDurationSecond : callTime,
      callType: callType,
      detail: detail,
      useCard: thisCallUseCard,
      callHadShowCount20: callHadShowCount20,
    );
  }

  int endType = 0;

  // 充值弹窗导致的返回页面，要关闭页面
  void didPopNext() {
    chargeing = false;
    if (thisCallFinish) {
      // 这里要加个延时，不然会崩溃。报的错是重复调用pop等方法
      Future.delayed(
        Duration(milliseconds: 60),
        () => _endCall(endType, pop: true),
      );
    }
  }

  void switchBig() {
    switchView = !switchView;
    update([idAgora]);
  }

  /// 拖动小窗口
  void onPanUpdate(DragUpdateDetails tapInfo) {
    toTop += tapInfo.delta.dy;
    // toRight -= tapInfo.delta.dx;
    toLeft += tapInfo.delta.dx;
    if (toTop < 98) {
      toTop = 98;
    } else if (toTop > maxToTop) {
      toTop = maxToTop;
    }
    if (toLeft < 15) {
      toLeft = 15;
    } else if (toLeft > maxToLeft) {
      toLeft = maxToLeft;
    }
    update([idAgora]);
  }

  void _errBeforeCall(int endType) {
    if (callType == 2) {
      _cancelCall(endType);
    }
    TrudaStorageService.to.objectBoxCall.savaCallHistory(
        herId: herId,
        herVirtualId: detail?.username ?? '',
        channelId: channelId ?? '',
        callType: callType == 0 ? 1 : 0,
        callStatus: TrudaCallStatus.MY_HANG_UP,
        dateInsert: DateTime.now().millisecondsSinceEpoch,
        duration: '00:00');
    _closeMe();
  }

  /// 开始一个连接计时器
  void _startLinkTimer() {
    // callTime = 0;
    linkTime = callType == 2 ? aibLinkTime : otherLinkTime;
    _timerLink = Timer.periodic(const Duration(seconds: 1), (timer) {
      linkTime--;
      if (linkTime == 15) {
        // 延时设置一次常亮
        Wakelock.enable();
      }
      if (linkTime <= 0) {
        NewHitaLog.debug('linkTime > 15');
        _timerLink?.cancel();
        _timerLink = null;
        // hangUp();
        _errBeforeCall(connecting
            ? TrudaEndType2.otherJoinTimeOut
            : TrudaEndType2.beginTimeOut);
      }
    });
  }

  void _cancelCall(int endType) {
    // _startTimer();
    if (channelId == null || channelId!.isEmpty) {
      return;
    }
    TrudaHttpUtil().post<void>(TrudaHttpUrls.cancelCallApi,
        data: {'channelId': channelId, 'endType': endType});
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

  void _askGift(TrudaRTMMsgGift msgGift) {
    TrudaHttpUtil()
        .post<TrudaGiftEntity>(TrudaHttpUrls.giftGetOne + (msgGift.giftId ?? ''),
            errCallback: (err) {})
        .then((value) {
      askGift.value = value;
      Future.delayed(const Duration(seconds: 5), () {
        askGift.value = null;
      });
    });
  }

  @override
  void onClose() {
    super.onClose();
    NewHitaLog.debug('TrudaCallController onClose()');
    _engine?.stopPreview();
    _engine?.leaveChannel();
    _engine?.destroy();
    sub.cancel();
    subCommon.cancel();
    subBeginCall.cancel();
    giftSub.cancel();
    _timer?.cancel();
    _timerLink?.cancel();
    TrudaSocketManager.to.removeBalanceListener(_balanceListener);
    _plugin.disableScreenshots(false);
    Wakelock.disable();
    _screenshotsSubscription?.cancel();
  }

  Future _getContributeList() async {
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await TrudaHttpUtil().post<List<TrudaContributeBean>>(
        TrudaHttpUrls.getExpendRanking + herId, errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }).then((value) {
      for (var index = 0; index < value.length; index++) {
        if (value[index].userId == TrudaMyInfoService.to.myDetail?.userId &&
            index < 3) {
          welcomeText =
              TrudaLanguageKey.newhita_contribute_welcome.trArgs(['${index + 1}']);
          showWelcome.value = true;
          Future.delayed(const Duration(seconds: 8), () {
            showWelcome.value = false;
          });
        }
      }
    });
  }
}
