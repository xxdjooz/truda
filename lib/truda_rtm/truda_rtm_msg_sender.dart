import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:truda/truda_entities/truda_gift_entity.dart';
import 'package:truda/truda_rtm/truda_rtm_manager.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_entity.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:truda/truda_utils/newhita_log.dart';

class TrudaRtmMsgSender {
  // meHangup, // 1001 视频谁申请谁发消息 自己挂断自己的视频申请
  // otherHangup, // 1002 自己的视频申请被对面挂断
  // noPickup, // 1003 未接起
  // pickup, // 1004 接通
  // userBusy, // 1005 忙碌中
  // userOffline, // 1006 用户离线
  // netError, // 1007 网络错误
  // videocard, // 1008 视频卡
  // userNoMoney, // 1020 用户余额不足
  // userNoVIP, // 1021 用户不是vip
  // placeholder, // 占位 不代表任何意义
  static sendCallState(String herId, int statusType, String? duration) {
    var msg = TrudaRTMMsgCallState()
      ..statusType = statusType
      ..duration = duration;
    var text = _getRtmText(
        type: TrudaRTMMsgCallState.typeCode,
        content: json.encode(msg),
        herId: herId);
    var agoraRtm = AgoraRtmMessage.fromText(json.encode(text));
    TrudaRtmManager.sendRtmMsg(herId, agoraRtm, (success) {
      NewHitaLog.debug('sendRtmMsg success = $success');
    });
  }

  static String makeRTMMsgText(String herId, String str) {
    var msg = TrudaRTMMsgText()..text = str;
    var text = _getRtmText(
        type: TrudaRTMMsgText.typeCode, content: json.encode(msg), herId: herId);
    return json.encode(text);
  }

  static String makeRTMMsgGift(
      String herId, TrudaGiftEntity gift, String recordId) {
    var msg = TrudaRTMMsgGift()
      ..sendGiftRecordId = recordId
      ..giftImageUrl = gift.icon
      ..giftName = gift.name
      ..quantity = gift.quantity ?? 1
      ..giftId = gift.gid.toString()
      ..cost = gift.diamonds;
    return json.encode(msg);
  }

  static String makeRTMMsgImage(String herId, String url) {
    var msg = TrudaRTMMsgPhoto()
      ..imageUrl = url
      ..thumbnailUrl = url;
    var text = _getRtmText(
        type: TrudaRTMMsgPhoto.typeCodes[0],
        content: json.encode(msg),
        herId: herId);
    return json.encode(text);
  }

  static String makeRTMMsgVoice(String herId, String url, int duration) {
    var msg = TrudaRTMMsgVoice()
      ..voiceUrl = url
      ..duration = duration;
    // var text = _getRtmText(
    //     type: NewHitaRTMMsgVoice.typeCodes[0],
    //     content: json.encode(msg),
    //     herId: herId);
    return json.encode(msg);
  }

  // type text = 10
  // type gift = 11
  // type call = 12
  // type imge = 13
  // type voice = 14
  // type video = 15
  // type severImge = 20//服务器图片消息
  // type severVoice = 21 //服务器语音消息
  // type severVoice = 24 //AIA下发的视频
  // type severVoice = 25 //AIB
  // type = 23    服务器会发送begincall
  static TrudaRTMText _getRtmText(
      {required String herId, required int type, required String content}) {
    // int? destructTime;
    // String? extra;
    // String? messageContent;
    // String? msgId;
    // int? type;
    // NewHitaRTMUser? userInfo;
    var myInfo = TrudaMyInfoService.to.userLogin!;
    TrudaRTMUser userInfo = TrudaRTMUser()
      ..portrait = myInfo.portrait
      ..name = myInfo.nickname
      ..virtualId = myInfo.username
      ..uid = myInfo.userId;
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    var myId = TrudaMyInfoService.to.userLogin?.userId ?? '';
    var rtmText = TrudaRTMText()
      ..type = type
      ..messageContent = content
      ..destructTime = nowTime
      ..userInfo = userInfo
      ..msgId = '${myId}_${herId}_${nowTime}';
    return rtmText;
  }
}
