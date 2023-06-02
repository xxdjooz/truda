import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:disable_screenshots/disable_screenshots.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_end_type.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_database/entity/truda_msg_entity.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_entities/truda_aiv_entity.dart';
import '../../../truda_entities/truda_gift_entity.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_entities/truda_info_entity.dart';
import '../../../truda_entities/truda_send_gift_result.dart';
import '../../../truda_http/truda_common_api.dart';
import '../../../truda_routes/newhita_pages.dart';
import '../../../truda_rtm/newhita_rtm_msg_entity.dart';
import '../../../truda_rtm/newhita_rtm_msg_sender.dart';
import '../../../truda_services/newhita_storage_service.dart';
import '../../../truda_utils/newhita_format_util.dart';
import '../../../truda_utils/newhita_loading.dart';
import '../../../truda_utils/newhita_log.dart';
import '../../../truda_widget/gift/newhita_gift_data_helper.dart';
import '../../../truda_widget/gift/newhita_gift_list_view.dart';
import '../../../truda_widget/gift/newhita_vap_player.dart';
import '../../chargedialog/truda_charge_dialog_manager.dart';
import '../../vip/truda_vip_controller.dart';
import '../end/truda_end_controller.dart';
import 'truda_aiv_video_controller.dart';

class TrudaAivController extends GetxController {
  static startMeAndOff(String herId, int isCard, TrudaAivBean aiv,
      TrudaAivVideoController aivVideoController) {
    Map<String, dynamic> map = {};
    map['herId'] = herId;
    map['isCard'] = isCard;
    map['aiv'] = aiv;
    map['aivVideoController'] = aivVideoController;

    /// 关闭弹窗
    if (Get.isOverlaysOpen) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      navigator?.popUntil((route) {
        return (!Get.isDialogOpen! && !Get.isBottomSheetOpen!);
      });
    }
    Get.offAndToNamed(NewHitaAppPages.aivPage, arguments: map);
  }

  static const String idAgora = 'idAgora';
  static const String idSwitch = 'idSwitch';

  late String herId;
  late String content;
  late String token;
  late TrudaAivVideoController aivVideoController;

  late TrudaAivBean aiv;

  // 0拨打，1被叫，2aib拨打(aib是被叫页面，实际是要去拨打), 3aic,4aiv
  late int callType = 4;

  // 视频要消耗体验卡
  late int isCard;
  bool haveVoice = false;
  TrudaHostDetail? detail;
  var connecting = true;
  var abandVolume = false.obs;

  // 通话计时器
  Timer? _timer;
  Timer? _timerLink;
  var linkTime = 0;

  // 通话时长
  var callTime = 0;
  var callTimeStr = ''.obs;

  // 默认主播是大屏，我小屏
  var switchView = false;

  var myMoney = RxnInt(null);

  double toTop = 120;
  double toRight = 15;
  double toLeft = Get.width - 135;
  double maxToTop = Get.height - 300;
  double maxToRight = Get.width - 135;
  double maxToLeft = Get.width - 135;
  late TrudaInfoDetail myInfo;

  /// event bus 监听
  // late final StreamSubscription<NewHitaEventRtmCall> sub;

  CameraController? cameraController;
  bool hadCameraInit = false;

  // 已经关注
  RxnInt followed = RxnInt(null);

  // 体验卡可以用的时长 s
  int callCardDurationSecond = 0;
  var myVapController = NewHitaVapController();

  // 充值中，这个时候不要因为电话的挂断而关闭
  bool chargeing = false;
  bool playFinish = false;
  bool callHadShowCount20 = false;
  bool doingShowCount20 = false;
  var playerInited = false;
  late VideoPlayerController videoController;

  // NewHitaGiftEntity? giftToQuickSend;
  Rx<TrudaGiftEntity> giftToQuickSend = TrudaGiftEntity().obs;

  // 初始化禁止截屏插件
  final DisableScreenshots _plugin = DisableScreenshots();
  var cleanScreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    herId = arguments['herId']!;
    content = arguments['content'] ?? '';
    // callType = arguments['callType'] ?? 0;
    isCard = arguments['isCard'] ?? 0;
    aiv = arguments['aiv'];
    aivVideoController = arguments['aivVideoController'];
    haveVoice = aiv.muteStatus == 1;
    myInfo = NewHitaMyInfoService.to.myDetail!;
    myMoney.value = myInfo.userBalance?.remainDiamonds;

    if (content.isNotEmpty) {
      detail = TrudaHostDetail.fromJson(json.decode(content));
      followed.value = detail?.followed;
    } else {
      _getHostDetail();
    }
    // if (callType == 2) {
    //   _getHostDetail();
    // } else {
    //   _getToken();
    // }

    /// event bus 监听
    // sub = NewHitaStorageService.to.eventBus.on<NewHitaEventRtmCall>().listen((event) {
    //   if (event.invite.channelId != channelId) return;
    //   if (event.type == 1) {}
    // });

    NewHitaLog.debug("aiv videoController  network=${aiv.filename!}");
    videoController = aivVideoController.playerController;
  }

  @override
  void onReady() {
    super.onReady();

    NewHitaGiftDataHelper.getGifts().then((value) {
      if (value != null && value.isNotEmpty) {
        giftToQuickSend.value = value.first;
      }
    });
    _plugin.disableScreenshots(true);

    Future.delayed(Duration(seconds: 3), () {
      // 这里有个坑,被叫的dispose里面有关闭的调用，加延迟防止在他之前调用这个
      Wakelock.enable();
      NewHitaLog.debug('Wakelock enable TrudaCallController');
    });
    _timerLink = Timer.periodic(const Duration(seconds: 1), (timer) {
      NewHitaLog.debug('timer -- ${timer.tick}');
      if (timer.tick > 10) {
        if (connecting) {
          _endCall(TrudaEndType.linkTimeOut);
        } else {
          _timerLink?.cancel();
        }
      }
    });
    try {
      initPlayer();
    } catch (e) {
      print(e);
    }
  }

  void initPlayer() async {
    await videoController.initialize();
    videoController.setVolume(haveVoice ? 1 : 0);
    NewHitaLog.debug(
        "aiv started()  isInitialized=${videoController.value.isInitialized}");
    videoController.addListener(() {
      if (videoController.value.isPlaying) {
        if (!playerInited) {
          playerInited = true;
          connecting = false;
          update();
          _beginTimer();
          _timerLink?.cancel();
          initCamera();
        }
      }
      if (playerInited && !videoController.value.isPlaying && videoController.value.position >= videoController.value.duration) {
        // widget.finishPlay.call();
        onPlayFinishOrTimeOut();
      }
    });
    await videoController.play().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    });
  }

  void _beginTimer() {
    callTime = 0;
    // 使用体验卡，从倒计时开始
    if (isCard == 1) {
      callCardDurationSecond = (myInfo.callCardDuration ?? 0) ~/ 1000;
      // 体验卡用一个负数
      callTime = -callCardDurationSecond;
      NewHitaLog.debug('consumeOneCard() ----->');
      consumeOneCard();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callTime++;
      // 使用体验卡倒计时结束
      if (isCard == 1 && callTime == 0) {
        // _endCall(NewHitaEndType.hangoff);
        onPlayFinishOrTimeOut();
      }
      if (callTime > 0 && callTime % 60 == 0) {

      }
      // 最长60s
      if (callTime == 60){
        onPlayFinishOrTimeOut();
      }

      callTimeStr.value = NewHitaFormatUtil.getTimeStrFromSecond(callTime.abs());
    });
  }

  var cameraFront = true;

  void initCamera({bool front = true}) async {
    // ShowLoading(null);
    await cameraController?.dispose();

    final cameras = await availableCameras();

    CameraDescription camera = cameras.last;
    cameras.forEach((element) {
      if (element.lensDirection == CameraLensDirection.front && front) {
        camera = element;
      }
      if (element.lensDirection == CameraLensDirection.back && !front) {
        camera = element;
      }
    });
    cameraController = CameraController(camera, ResolutionPreset.low);
    await cameraController?.initialize();
    // HideLoding();
    NewHitaLog.debug('initCamera');
    hadCameraInit = true;
    update();
  }

  void switchCamera() {
    // if (!haveVoice) {
    //   clickCharge();
    //   return;
    // }
    if (cameraFront == true) {
      cameraFront = false;
      initCamera(front: false);
    } else {
      cameraFront = true;
      initCamera(front: true);
    }
    update([idSwitch]);
  }

  void switchVoice() {
    abandVolume.toggle();
  }

  /// 消耗掉一张体验卡
  void consumeOneCard() {
    TrudaHttpUtil()
        .post<void>(TrudaHttpUrls.useCardByAIBApi, errCallback: (err) {});
  }

  // 视频播放结束和有体验卡的倒计时结束
  void onPlayFinishOrTimeOut() {
    // _endCall(NewHitaEndType.upHangoff);
    _timer?.cancel();
    _timer = null;
    playFinish = true;
    if (chargeing) return;
    videoController.dispose();
    update([idAgora]);
    callHadShowCount20 = true;
    // if (doingShowCount20) return;
    // doingShowCount20 = true;
    // Get.bottomSheet(TrudaCount20(
    //   leftSecond: 20,
    //   callback: (go) {
    //     if (go) {
    //       chargeing = true;
    //       clickCharge();
    //     } else {
    //       chargeing = false;
    //     }
    //   },
    // )).then((value) {
    //   doingShowCount20 = false;
    //   if (playFinish && !chargeing) {
    //     Future.delayed(const Duration(milliseconds: 60),
    //         () => _endCall(NewHitaEndType.upHangoff));
    //   }
    // });
    clickCharge();
  }

  // 点击了挂断
  void clickHangUp() {
    _endCall(TrudaEndType.hangoff);
  }

  /// 结束通话
  void _endCall(int endType) {
    cameraController?.dispose();
    bool aicUseCard = isCard == 1;
    if (callTime == 0 && !aicUseCard) {
      Get.back();
      return;
    }
    if (aicUseCard) {
      callTime = callTime + callCardDurationSecond;
      TrudaEndController.startMeAndOff(
        herId: herId,
        channelId: '',
        portrait: detail?.portrait ?? '',
        endType: endType,
        callTime: callTime,
        callType: callType,
        detail: detail,
        useCard: aicUseCard,
        callHadShowCount20: callHadShowCount20,
      );
    } else {
      TrudaEndController.startMeAndOff(
        herId: herId,
        channelId: '',
        portrait: detail?.portrait ?? '',
        endType: endType,
        callTime: callTime,
        callType: callType,
        detail: detail,
        useCard: aicUseCard,
        callHadShowCount20: callHadShowCount20,
      );
      // Get.back();
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

  // 点击了礼物
  void clickGift() {
    // showModalBottomSheet(
    //     backgroundColor: TrudaColors.baseColorBlackBg,
    //     context: context,
    //     builder: (context) {
    //       return NewHitaLianGiftListView(
    //         choose: (NewHitaGiftEntity gift) {
    //           sendGift(gift);
    //         },
    //       );
    //     });
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

  // 点击了充值
  void clickCharge() {
    chargeing = true;
    callHadShowCount20 = true;
    TrudaChargeDialogManager.showChargeDialog(
        TrudaChargePath.aib_chating_click_recharge,
        upid: herId, closeCallBack: () {
      chargeing = false;
      NewHitaLog.debug('TrudaCallController showChargeDialog() $playFinish');
      if (playFinish) {
        Future.delayed(const Duration(milliseconds: 60),
            () => _endCall(TrudaEndType.upHangoff));
      }
    }, noMoneyShow: true,);
  }

  void quickSendGift() {
    if (giftToQuickSend.value.gid == null) {
      clickGift();
    } else {
      sendGift(giftToQuickSend.value);
    }
  }

  void sendGift(TrudaGiftEntity gift) {
    /// 这里送礼物要送给9999？好像是因为不让主播有收益
    TrudaHttpUtil().post<TrudaSendGiftResult>(
      TrudaHttpUrls.sendGiftApi,
      data: {
        "receiverId": TrudaConstants.systemId,
        "quantity": 1,
        "gid": gift.gid
      },
      showLoading: true,
      errCallback: (err) {
        if (err.code == 8) {
          TrudaChargeDialogManager.showChargeDialog(
            TrudaChargePath.chating_send_gift_no_money,
            upid: herId,
            noMoneyShow: true,
          );
        } else if (err.code == 25) {
          Get.dialog(TrudaDialogConfirm(
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
      },
    ).then((value) {
      myVapController.playGift(gift);
      var json =
          NewHitaRtmMsgSender.makeRTMMsgGift(herId, gift, value.gid.toString());
      var msg = TrudaMsgEntity(myInfo.userId ?? '', herId, 0, 'gift',
          DateTime.now().millisecondsSinceEpoch, json, NewHitaRTMMsgGift.typeCode,
          msgEventType: NewHitaMsgEventType.sending, sendState: 1);
      NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
        ..msgEventType = NewHitaMsgEventType.sendDone
        ..sendState = 0);
    });
  }

  void _getHostDetail() {
    TrudaHttpUtil().post<TrudaHostDetail>(TrudaHttpUrls.upDetailApi + herId,
        errCallback: (err) {
      NewHitaLog.debug(err);
      NewHitaLoading.toast(err.message);
      // _errBeforeCall(NewHitaEndType.linkFail);
    }).then((value) {
      detail = value;
      // portrait = value.portrait ?? '';
      followed.value = value.followed;
      update();
      content = json.encode(value);
      if (!value.isShowOnline) {
        return;
      }
    });
  }

  void handleFollow() {
    TrudaCommonApi.followHostOrCancel(herId).then((value) {
      detail?.followed = value;
      followed.value = value;
      update();
    });
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
    NewHitaLog.debug('TrudaCallController onClose()');
    // sub.cancel();
    _timer?.cancel();
    _timerLink?.cancel();
    _plugin.disableScreenshots(false);
    Wakelock.disable();
    videoController.dispose();
  }
}
