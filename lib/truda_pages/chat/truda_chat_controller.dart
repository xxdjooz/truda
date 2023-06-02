import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_database/entity/truda_her_entity.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';
import 'package:truda/truda_pages/chat/truda_chat_msg_wrapper.dart';
import 'package:truda/truda_pages/vip/truda_vip_controller.dart';
import 'package:truda/truda_rtm/newhita_rtm_msg_entity.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:truda/truda_widget/gift/newhita_vap_player.dart';

import '../../truda_common/truda_charge_path.dart';
import '../../truda_common/truda_common_dialog.dart';
import '../../truda_database/entity/truda_msg_entity.dart';
import '../../truda_dialogs/truda_dialog_confirm.dart';
import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_entities/truda_send_gift_result.dart';
import '../../truda_http/truda_common_api.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_routes/newhita_pages.dart';
import '../../truda_rtm/newhita_rtm_msg_sender.dart';
import '../../truda_services/newhita_event_bus_bean.dart';
import '../../truda_services/newhita_storage_service.dart';
import '../../truda_utils/ad/newhita_ads_native_utils.dart';
import '../../truda_utils/ad/newhita_ads_utils.dart';
import '../../truda_utils/newhita_gift_follow_tip.dart';
import '../../truda_utils/newhita_loading.dart';
import '../../truda_utils/newhita_voice_player.dart';
import '../chargedialog/truda_charge_dialog_manager.dart';

class TrudaChatController extends GetxController {
  // static startMe(String herId, {NewHitaHostDetail? detail}) {
  //   Get.toNamed(NewHitaAppPages.chatPage, arguments: detail ?? herId);
  // }
  static Future<T?>? startMe<T>(String herId, {TrudaHostDetail? detail}) {
    return Get.toNamed(NewHitaAppPages.chatPage, arguments: detail ?? herId);
  }

  /// event bus 监听
  late final StreamSubscription<TrudaMsgEntity> sub;

  /// 加载历史列表时的最上面一条的时间戳，根据这个分页加载
  var time = DateTime.now().millisecondsSinceEpoch;
  var scroller = ScrollController();
  var myVapController = NewHitaVapController();

  // 它等于0说明列表在底部
  double extentAfter = 0;

  // 它等于0说明列表在顶部
  double extentBefore = 0;

  /// 两个列表，分别添加下拉出来的旧数据和新发的数据
  /// 为啥这么做？实现不会跳动的双向列表
  List<TrudaChatMsgWrapper> showOldData = [];
  List<TrudaChatMsgWrapper> showNewData = [];

  late String myId;
  late String herId;
  TrudaHerEntity? her;
  TrudaHostDetail? herDetail;
  late NewHitaGiftFollowTipController tipController;

  int leftFreeMsgNum = 5;
  bool showMsgTipView = true;

  late final StreamSubscription<NewHitaEventMsgClear> subClear;

  ///本地广告工具类
  late NewHitaAdsNativeUtils nativeUtils;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is String) {
      herId = Get.arguments as String;
    } else if (Get.arguments is TrudaHostDetail) {
      var detail = Get.arguments as TrudaHostDetail;
      herId = detail.userId!;
    }
    NewHitaLog.good("NewHitaChatController userId=$herId");
    her = NewHitaStorageService.to.objectBoxMsg.queryHer(herId);
    myId = NewHitaMyInfoService.to.userLogin?.userId ?? "";
    // var firstList = NewHitaStorageService.to.objectBox.queryMsgs();
    // newData.addAll(firstList);
    // Future.delayed(const Duration(milliseconds: 200), () {
    //   scroller.jumpTo(scroller.position.maxScrollExtent);
    // });
    var allFree = NewHitaMyInfoService.to.config?.freeMessageCount ?? 5;
    var usedFree =
        NewHitaMyInfoService.to.myDetail?.userBalance?.freeMsgCount ?? 0;
    leftFreeMsgNum = allFree - usedFree;
    NewHitaLog.debug(
        'NewHitaChatController allFree=$allFree usedFree=$usedFree leftFreeMsgNum=$leftFreeMsgNum');

    NewHitaMyInfoService.to.chattingWithHer = herId;

    tipController = NewHitaGiftFollowTipController()
      ..listen((callback) {
        if (callback == 1) {
          handleFollow();
        } else if (callback == 2) {}
      });
    subClear =
        NewHitaStorageService.to.eventBus.on<NewHitaEventMsgClear>().listen((event) {
      NewHitaLog.good("NewHitaChatController subClear");
      if (event.type == 3) {
        showOldData.clear();
        showNewData.clear();
        update();
      }
    });

    // vip发消息免费
    showMsgTipView = !canSendMsg();
    nativeUtils =
        NewHitaAdsNativeUtils(NewHitaAdsUtils.getAdCode(NewHitaAdsUtils.NATIVE_CHAT), () {
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();

    /// event bus 监听
    sub = NewHitaStorageService.to.eventBus.on<TrudaMsgEntity>().listen((event) {
      if (event.herId != herId) return;
      NewHitaLog.debug(
          "NewHitaChatController eventbus listen:msgId=${event.msgId} msgEventType=${event.msgEventType}");
      if (event.msgEventType == NewHitaMsgEventType.sending ||
          event.msgEventType == NewHitaMsgEventType.none ||
          event.msgEventType == NewHitaMsgEventType.uploading) {
        addMsg(event);
      } else if (event.msgEventType == NewHitaMsgEventType.sendDone) {
        updateMsg(event, NewHitaMsgEventType.sendDone);
      } else if (event.msgEventType == NewHitaMsgEventType.sendErr) {
        updateMsg(event, NewHitaMsgEventType.sendErr);
      }
    });
    // showFreeMsgTip();
    NewHitaStorageService.to.objectBoxMsg.setRead(herId);
    _getHostDetail();
    getOldListFirst();
  }

  // vip或者ios审核模式
  bool canSendMsg() {
    return NewHitaMyInfoService.to.isVipNow ||
        TrudaConstants.systemId == herId ||
        TrudaConstants.appMode == 2;
  }

  void _getHostDetail() {
    if (herId.isEmpty || herId == TrudaConstants.systemId) {
      return;
    }
    TrudaHttpUtil().post<TrudaHostDetail>(TrudaHttpUrls.upDetailApi + herId,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }).then((value) {
      herDetail = value;
      update(['herInfo']);
      tipController.setUser(herDetail?.portrait, herDetail?.followed == 1);
      NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
          value.nickname ?? '', value.userId!,
          portrait: value.portrait));
    });
  }

  // 加入消息
  void addMsg(TrudaMsgEntity event) {
    var herSend = event.sendType == 1;
    // 有重复显示消息问题，这里做下去重
    if (herSend) {
      for (var data in showNewData) {
        if (data.msgEntity.msgId == event.msgId) return;
      }
    }
    var wrapper = TrudaChatMsgWrapper(event, herSend, event.dateInsert,
        her: her, herId: herId);
    wrapper.showTime = showNewData.isEmpty
        ? true
        : wrapper.date - showNewData.last.date > 1 * 60 * 1000;
    showNewData.add(wrapper);
    update();
    scrollWhenMsgAdd(herSend);
  }

  // 更新消息
  void updateMsg(TrudaMsgEntity event, NewHitaMsgEventType msgEventType) {
    for (var data in showNewData) {
      if (data.msgEntity.msgId == event.msgId) {
        data.msgEntity.msgEventType = msgEventType;
        update();
        break;
      }
    }
  }

  /// 进来的第一屏的数据要放到newData里面
  Future getOldListFirst() async {
    var list = NewHitaStorageService.to.objectBoxMsg.queryHostMsgs(herId, time);
    print('getOldListFirst() list=${list.length}');
    if (list.isEmpty) return;
    showNewData.addAll(_getWrapperList(list, time).reversed);
    update();
    time = showNewData.first.date;
    Future.delayed(const Duration(milliseconds: 200), () {
      scroller.jumpTo(scroller.position.maxScrollExtent);
    });
    // if (extentBefore == 0) {
    //   Future.delayed(const Duration(milliseconds: 400), () {
    //     scroller.animateTo(
    //       scroller.offset - 50,
    //       duration: const Duration(milliseconds: 500),
    //       curve: Curves.linearToEaseOut,
    //     );
    //   });
    // }
  }

  /// 下拉加载历史数据，放loadMoreData
  Future getOldList() async {
    var list = NewHitaStorageService.to.objectBoxMsg.queryHostMsgs(herId, time);
    NewHitaLog.debug('getOldList() list=${list.length}');
    if (list.isEmpty) return;
    showOldData.addAll(_getWrapperList(list, time));
    update();
    time = showOldData.last.date;
    if (extentBefore == 0) {
      Future.delayed(const Duration(milliseconds: 400), () {
        scroller.animateTo(
          scroller.offset - 50,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linearToEaseOut,
        );
      });
    }
  }

  List<TrudaChatMsgWrapper> _getWrapperList(List<TrudaMsgEntity> list, int time) {
    var newList = list
        .map((e) => TrudaChatMsgWrapper(e, e.sendType == 1, e.dateInsert,
            her: her, herId: herId))
        .toList();
    // 遍历wrapper,判断是否显示时间，5分钟
    var ite = newList.iterator;
    ite.moveNext();
    var wrapperTemp = ite.current;
    wrapperTemp.showTime = time - wrapperTemp.date > 5 * 60 * 1000;
    while (ite.moveNext()) {
      var current = ite.current;
      current.showTime = wrapperTemp.date - current.date > 5 * 60 * 1000;
      wrapperTemp = current;
    }
    return newList;
  }

  void scrollWhenMsgAdd(bool herSend) {
    // 在底部就自动滚动， 我发的也自动滚动
    if (extentAfter < 30 || !herSend) {
      // ScaffoldMessenger.of(Get.context!)
      //     .showSnackBar(const SnackBar(
      //   content: Text("你目前位于最底部，自动跳转新消息item"),
      //   duration: Duration(milliseconds: 1000),
      // ));
      Future.delayed(const Duration(milliseconds: 200), () {
        scroller.jumpTo(scroller.position.maxScrollExtent);
      });
    } else {
      // ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      //   content: InkWell(
      //     onTap: () {
      //       scroller.jumpTo(scroller.position.maxScrollExtent + 30);
      //     },
      //     child: Container(
      //       height: 50,
      //       width: 200,
      //       color: Colors.blueAccent,
      //       alignment: Alignment.centerLeft,
      //       child: const Text("点击我自动跳转新消息item"),
      //     ),
      //   ),
      //   duration: const Duration(milliseconds: 1000),
      // ));
    }
  }

  void sendGift(TrudaGiftEntity gift) {
    var json = NewHitaRtmMsgSender.makeRTMMsgGift(herId, gift, '');
    var msg = TrudaMsgEntity(myId, herId, 0, 'gift',
        DateTime.now().millisecondsSinceEpoch, json, NewHitaRTMMsgGift.typeCode,
        msgEventType: NewHitaMsgEventType.sending, sendState: 1);
    var id = NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg);
    msg.id = id;
    TrudaHttpUtil().post<TrudaSendGiftResult>(TrudaHttpUrls.sendGiftApi,
        data: {"receiverId": herId, "quantity": 1, "gid": gift.gid},
        errCallback: (err) {
      NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
        ..msgEventType = NewHitaMsgEventType.sendErr
        ..sendState = 2);
      if (err.code == 8) {
        TrudaChargeDialogManager.showChargeDialog(
          TrudaChargePath.chating_send_gift_no_money,
          upid: herId,
          noMoneyShow: true,
        );
        NewHitaLoading.toast(err.message, duration: const Duration(seconds: 3));
      } else if (err.code == 25) {
        TrudaCommonDialog.dialog(TrudaDialogConfirm(
          callback: (i) {
            TrudaVipController.openDialog(
                createPath: TrudaChargePath.recharge_send_vip_gift);
          },
          title: TrudaLanguageKey.newhita_vip_for_gift.tr,
          rightText: TrudaLanguageKey.newhita_vip_active_now.tr,
        ));
      }
    }).then((value) {
      myVapController.playGift(gift);
      var json =
          NewHitaRtmMsgSender.makeRTMMsgGift(herId, gift, value.gid.toString());
      msg.rawData = json;
      NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
        ..msgEventType = NewHitaMsgEventType.sendDone
        ..sendState = 0);
      tipController.hadSendGift();
    });
  }

  void handleFollow() {
    TrudaCommonApi.followHostOrCancel(herId).then((value) {
      herDetail?.followed = value;
      update();
    });
  }

  // void minusFreeMsg() {
  //   if (leftFreeMsgNum <= 0) {
  //     return;
  //   }
  //   var myUsedFree =
  //       NewHitaMyInfoService.to.myDetail?.userBalance?.freeMsgCount ?? 0;
  //   NewHitaMyInfoService.to.myDetail?.userBalance?.freeMsgCount = myUsedFree + 1;
  //   leftFreeMsgNum--;
  //   showFreeMsgTip();
  // }
  //
  // void showFreeMsgTip() {
  //   String tip = "";
  //   if (leftFreeMsgNum > 0) {
  //     tip =
  //         // "你有${freeMsgCount}条免费信息，如果免费信息用完每条信息将花费${LocalStore.config?.data?.sendMsgDiamondsPrice ?? "1"}钻石。";
  //         TrudaLanguageKey.newhita_message_free_tip.trArgs([
  //       "${leftFreeMsgNum}",
  //       "${NewHitaMyInfoService.to.config?.sendMsgDiamondsPrice ?? "1"}"
  //     ]);
  //   } else {
  //     tip = TrudaLanguageKey.newhita_message_deduction_tip.trArgs(
  //         ["${NewHitaMyInfoService.to.config?.sendMsgDiamondsPrice ?? "1"}"]);
  //   }
  //   Future.delayed(Duration(milliseconds: 100), () {
  //     freeMsgTip.value = tip;
  //   });
  // }

  @override
  void onClose() {
    super.onClose();
    sub.cancel();
    subClear.cancel();
    NewHitaMyInfoService.to.chattingWithHer = null;
    NewHitaAudioPlayer().stop();
    NewHitaAudioPlayer().release();

    nativeUtils.closeSub();
  }
}
