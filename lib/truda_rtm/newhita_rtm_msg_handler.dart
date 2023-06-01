import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_database/entity/truda_her_entity.dart';
import 'package:truda/truda_rtm/newhita_rtm_msg_entity.dart';
import 'package:truda/truda_services/newhita_event_bus_bean.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_app_rate.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../truda_common/truda_call_status.dart';
import '../truda_database/entity/truda_msg_entity.dart';
import '../truda_entities/truda_host_entity.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';
import '../truda_socket/newhita_socket_entity.dart';

void handleMsg(AgoraRtmMessage message, String peerId) {
  final String myId = NewHitaMyInfoService.to.userLogin?.userId ?? "emptyId";
  final int milliseconds = DateTime.now().millisecondsSinceEpoch;
  NewHitaLog.debug('rtm message come !! \npeerId: $peerId \n$message');
  final String text = message.text;
  final int ts = message.ts;
  final bool offline = message.offline;

  /// text字符窜有我们定义的消息
  NewHitaRTMText msg = NewHitaRTMText.fromJson(json.decode(text));
  var her = msg.userInfo;

  /// 缓存主播信息用于聊天页面 -1是aic 9999是系统消息
  if (her != null && her.uid != null && her.uid != '-1' && her.uid != '9999') {
    if (her.portrait != null && her.name != null) {
      var entity =
          TrudaHerEntity(her.name ?? '', her.uid!, portrait: her.portrait);
      NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(entity);
      NewHitaStorageService.to.eventBus.fire(entity);
    } else {
      // 发现服务端下发的话术消息只有id,"userInfo":{"auth":2,"uid":"108172243"}
      NewHitaHttpUtil().post<TrudaHostDetail>(NewHitaHttpUrls.upDetailApi + her.uid!,
          errCallback: (err) {
        NewHitaLog.debug(err);
      }).then((value) {
        var entity = TrudaHerEntity(value.nickname ?? '', her.uid!,
            portrait: value.portrait);
        NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(entity);
        NewHitaStorageService.to.eventBus.fire(entity);
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
    NewHitaAppRate.rateApp(messageContent);
    return;
  }
  if (msgType == 29) {
    if (TrudaConstants.isFakeMode) {
      // 审核模式
      return;
    }
    // 电话涉黄警告
    NewHitaStorageService.to.eventBus.fire(NewHitaEventCommon(0, ""));
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
  if (msgType == NewHitaRTMMsgBeginCall.typeCode) {
    NewHitaRTMMsgBeginCall beginCall = NewHitaRTMMsgBeginCall.fromJson(jsonMap);
    NewHitaStorageService.to.eventBus.fire(beginCall);
    return;
  } else if (msgType == NewHitaRTMMsgAIB.typeCode) {
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
    // NewHitaRemoteController.startMeAib(aib.userId!, messageContent);
    return;
  } else if (msgType == NewHitaRTMMsgAIC.typeCode) {
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
    NewHitaSocketEntity entity = NewHitaSocketEntity.fromJson(jsonMap);
    NewHitaSocketBalance socketBalance =
        NewHitaSocketBalance.fromJson(json.decode(entity.data!));
    var changeState = -1;
    var myDiamonds =
        NewHitaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    var newDiamonds = socketBalance.diamonds;
    var price = NewHitaMyInfoService.to.config?.chargePrice ?? 60;
    if (myDiamonds >= price && newDiamonds < price) {
      // 我的钻石从60以上掉到60以下的情况
      // NewHitaHttpUtil().post(NewHitaHttpUrls.initRobotApi);
      changeState = 1;
    } else if (myDiamonds < price && newDiamonds >= price) {
      // 我的钻石从60以下升高到到60以上的情况
      changeState = 0;
    }
    // 更新缓存信息
    NewHitaMyInfoService.to.handleBalanceChange(socketBalance);

    if (changeState > -1) {
      NewHitaStorageService.to.eventBus
          .fire(NewHitaEventCanCallStateChange(changeState));
    }

    NewHitaMyInfoService.to.handleBalanceChange(socketBalance);
    // TrudaUserLevelUpdate.checkToShow(socketBalance.expLevel);
    return;
  } else if (msgType == NewHitaRTMMsgCallState.typeCode) {
    if (TrudaConstants.isFakeMode) {
      // 审核模式
      return;
    }

    /// 发来的通话记录
    NewHitaRTMMsgCallState callState = NewHitaRTMMsgCallState.fromJson(jsonMap);
    if (her != null && her.uid != null) {
      NewHitaStorageService.to.objectBoxCall.savaCallHistory(
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

    NewHitaRTMMsgGift msgGift = NewHitaRTMMsgGift.fromJson(jsonMap);
    NewHitaStorageService.to.eventBus.fire(msgGift);
    return;
  }
  // 下面是聊天消息各类型
  final typeList = [
    // 收到电话状态
    NewHitaRTMMsgCallState.typeCode,
    // 收到文字
    NewHitaRTMMsgText.typeCode,
    // 收到图片
    ...NewHitaRTMMsgPhoto.typeCodes,
    // 收到声音
    ...NewHitaRTMMsgVoice.typeCodes
  ];
  TrudaMsgEntity msgEntity;
  if (typeList.contains(msgType)) {
    msgEntity = TrudaMsgEntity(
        myId, peerId, 1, "", milliseconds, messageContent, msgType);
    if (msgType == NewHitaRTMMsgText.typeCode) {
      NewHitaRTMMsgText textMsg = NewHitaRTMMsgText.fromJson(jsonMap);
      msgEntity.content = textMsg.text ?? "";
    }
    if (NewHitaRTMMsgVoice.typeCodes.contains(msgType)) {
      NewHitaRTMMsgVoice textMsg = NewHitaRTMMsgVoice.fromJson(jsonMap);
      msgEntity.content = (textMsg.duration ?? 0).toString();
    }
    NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msgEntity);
  }
}
