import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_database/entity/truda_her_entity.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_entity.dart';
import 'package:truda/truda_services/truda_event_bus_bean.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/truda_app_rate.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../truda_common/truda_call_status.dart';
import '../truda_database/entity/truda_msg_entity.dart';
import '../truda_entities/truda_host_entity.dart';
import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import '../truda_socket/truda_socket_entity.dart';

void handleMsg(AgoraRtmMessage message, String peerId) {
  final String myId = TrudaMyInfoService.to.userLogin?.userId ?? "emptyId";
  final int milliseconds = DateTime.now().millisecondsSinceEpoch;
  TrudaLog.debug('rtm message come !! \npeerId: $peerId \n$message');
  final String text = message.text;
  final int ts = message.ts;
  final bool offline = message.offline;

  /// text字符窜有我们定义的消息
  TrudaRTMText msg = TrudaRTMText.fromJson(json.decode(text));
  var her = msg.userInfo;

  /// 缓存主播信息用于聊天页面 -1是aic 9999是系统消息
  if (her != null && her.uid != null && her.uid != '-1' && her.uid != '9999') {
    if (her.portrait != null && her.name != null) {
      var entity =
          TrudaHerEntity(her.name ?? '', her.uid!, portrait: her.portrait);
      TrudaStorageService.to.objectBoxMsg.putOrUpdateHer(entity);
      TrudaStorageService.to.eventBus.fire(entity);
    } else {
      // 发现服务端下发的话术消息只有id,"userInfo":{"auth":2,"uid":"108172243"}
      TrudaHttpUtil().post<TrudaHostDetail>(TrudaHttpUrls.upDetailApi + her.uid!,
          errCallback: (err) {
        TrudaLog.debug(err);
      }).then((value) {
        var entity = TrudaHerEntity(value.nickname ?? '', her.uid!,
            portrait: value.portrait);
        TrudaStorageService.to.objectBoxMsg.putOrUpdateHer(entity);
        TrudaStorageService.to.eventBus.fire(entity);
      });
    }
  }
  if (msg.messageContent == null || msg.messageContent!.isEmpty) {
    return;
  }

  /// messageContent字符窜可以序列化成具体文字图片bean
  final String messageContent = msg.messageContent!;

  /// 消息类型
  final int msgType = msg.type!;

  if (msgType == 28) {
    if (TrudaConstants.isFakeMode) {
      // 审核模式
      return;
    }

    /// app打分
    TrudaAppRate.rateApp(messageContent);
    return;
  }
  if (msgType == 29) {
    if (TrudaConstants.isFakeMode) {
      // 审核模式
      return;
    }
    // 电话涉黄警告
    TrudaStorageService.to.eventBus.fire(TrudaEventCommon(0, ""));
    return;
  }

  // type text = 10
  // type gift = 11
  // type call = 12
  // type imge = 13 图片消息
  // type voice = 14 语音消息
  // type video = 15
  // type severImge = 20//服务器图片消息
  // type severVoice = 21 //服务器语音消息
  // type = 24 //AIA下发的视频
  // type = 25 //AIB
  // type = 23    服务器会发送begincall
  // type = 31    主播索要礼物
  Map<String, dynamic> jsonMap;
  try {
    jsonMap = json.decode(messageContent);
  } catch (e) {
    print(e);
    return;
  }

  /// begincall
  if (msgType == TrudaRTMMsgBeginCall.typeCode) {
    TrudaRTMMsgBeginCall beginCall = TrudaRTMMsgBeginCall.fromJson(jsonMap);
    TrudaStorageService.to.eventBus.fire(beginCall);
    return;
  } else if (msgType == TrudaRTMMsgAIB.typeCode) {
    // if (NewHitaConstants.isFakeMode) {
    //   // 审核模式
    //   return;
    // }
    // NewHitaRTMMsgAIB aib = NewHitaRTMMsgAIB.fromJson(jsonMap);
    //
    // /// Aib
    // if (!NewHitaCheckCallingUtil.checkCanAib() ||
    //     NewHitaCheckCallingUtil.checkCallHerRecently(aib.userId ?? '100')) {
    //   NewHitaLog.debug('stop aib --> ${NewHitaAppPages.history.last}');
    //   return;
    // }
    //
    // TrudaRemoteController.startMeAib(aib.userId!, messageContent);
    return;
  } else if (msgType == TrudaRTMMsgAIC.typeCode) {
    // if (NewHitaConstants.isFakeMode) {
    //   // 审核模式
    //   return;
    // }
    //
    // /// Aic
    // NewHitaLog.debug('receive aic -->');
    // NewHitaRTMMsgAIC aic = NewHitaRTMMsgAIC.fromJson(jsonMap);
    // NewHitaAicHandler().getAicMsg(aic);
    return;
  } else if (msgType == 29) {
    /// 鉴黄通知
    return;
  } else if (msgType == 27) {
    if (TrudaConstants.isFakeMode) {
      // 审核模式
      return;
    }

    /// 等级提升，充值加钻
    /// 只要有余额变动就会发这个，socket的balanceChanged消息也一样
    TrudaSocketEntity entity = TrudaSocketEntity.fromJson(jsonMap);
    TrudaSocketBalance socketBalance =
        TrudaSocketBalance.fromJson(json.decode(entity.data!));
    var changeState = -1;
    var myDiamonds =
        TrudaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    var newDiamonds = socketBalance.diamonds;
    var price = TrudaMyInfoService.to.config?.chargePrice ?? 60;
    if (myDiamonds >= price && newDiamonds < price) {
      // 我的钻石从60以上掉到60以下的情况
      // NewHitaHttpUtil().post(NewHitaHttpUrls.initRobotApi);
      changeState = 1;
    } else if (myDiamonds < price && newDiamonds >= price) {
      // 我的钻石从60以下升高到到60以上的情况
      changeState = 0;
    }
    // 更新缓存信息
    TrudaMyInfoService.to.handleBalanceChange(socketBalance);

    if (changeState > -1) {
      TrudaStorageService.to.eventBus
          .fire(TruaEventCanCallStateChange(changeState));
    }

    TrudaMyInfoService.to.handleBalanceChange(socketBalance);
    // TrudaUserLevelUpdate.checkToShow(socketBalance.expLevel);
    return;
  } else if (msgType == TrudaRTMMsgCallState.typeCode) {
    if (TrudaConstants.isFakeMode) {
      // 审核模式
      return;
    }

    /// 发来的通话记录
    TrudaRTMMsgCallState callState = TrudaRTMMsgCallState.fromJson(jsonMap);
    if (her != null && her.uid != null) {
      TrudaStorageService.to.objectBoxCall.savaCallHistory(
          herId: her.uid ?? '',
          herVirtualId: '',
          channelId: '',
          callType: 1,
          callStatus: callState.statusType ?? TrudaCallStatus.PICK_UP,
          dateInsert: DateTime.now().millisecondsSinceEpoch,
          duration: callState.duration ?? '00:00');
    }
    return;
  } else if (msgType == 31) {
    // 主播索要礼物
    if (TrudaConstants.isFakeMode) {
      // 审核模式
      return;
    }

    TrudaRTMMsgGift msgGift = TrudaRTMMsgGift.fromJson(jsonMap);
    TrudaStorageService.to.eventBus.fire(msgGift);
    return;
  }
  // 下面是聊天消息各类型
  final typeList = [
    // 收到电话状态
    TrudaRTMMsgCallState.typeCode,
    // 收到文字
    TrudaRTMMsgText.typeCode,
    // 收到图片
    ...TrudaRTMMsgPhoto.typeCodes,
    // 收到声音
    ...TrudaRTMMsgVoice.typeCodes
  ];
  TrudaMsgEntity msgEntity;
  if (typeList.contains(msgType)) {
    msgEntity = TrudaMsgEntity(
        myId, peerId, 1, "", milliseconds, messageContent, msgType);
    if (msgType == TrudaRTMMsgText.typeCode) {
      TrudaRTMMsgText textMsg = TrudaRTMMsgText.fromJson(jsonMap);
      msgEntity.content = textMsg.text ?? "";
    }
    if (TrudaRTMMsgVoice.typeCodes.contains(msgType)) {
      TrudaRTMMsgVoice textMsg = TrudaRTMMsgVoice.fromJson(jsonMap);
      msgEntity.content = (textMsg.duration ?? 0).toString();
    }
    TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msgEntity);
  }
}
