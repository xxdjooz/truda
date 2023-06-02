import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_rtm/newhita_rtm_call_handler.dart';
import 'package:truda/truda_rtm/newhita_rtm_msg_handler.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';

class NewHitaRtmManager {
  // 0未连接，1已连接，2连接中
  static var loginState = 0;
  static AgoraRtmClient? _client;

  static Future init() async {
    var id = NewHitaMyInfoService.to.config?.agoraAppId;
    if (id == null || id.isEmpty) return;
    if (TrudaConstants.appMode > 0) return;
    _client = await AgoraRtmClient.createInstance(id);
    //state
    // 1:CONNECTION_STATE_DISCONNECTED  初始状态。SDK 未连接到 Agora RTM 系统。
    // App 调用 loginByToken 方法后，SDK 开始登录 Agora RTM 系统，触发 connectionStateChanged 回调，连接状态变为 AgoraRtmConnectionStateConnecting。
    // 2:CONNECTION_STATE_CONNECTING  SDK 正在登录 Agora RTM 系统。
    // 如果 SDK 登录成功，会触发 connectionStateChanged 回调，连接状态变为 AgoraRtmConnectionStateConnected。
    // 3:CONNECTION_STATE_CONNECTED  SDK 已登录 Agora RTM 系统。
    // 如果 SDK 由于网络原因断开与 Agora RTM 系统的连接，SDK 触发 connectionStateChanged 回调，连接状态变为 AgoraRtmConnectionStateReconnecting。
    // 如果 SDK 由于重复登录而被服务器踢出，SDK 触发 connectionStateChanged 回调，连接状态变为 AgoraRtmConnectionStateAborted。
    // 如果 App 调用 logoutWithCompletion 方法成功登出系统，SDK 触发 connectionStateChanged 回调，连接状态变为 AgoraRtmConnectionStateDisConnected。
    // 4:CONNECTION_STATE_RECONNECTING  SDK 与 Agora RTM 系统连接由于网络原因出现中断，SDK 正在尝试自动重连 Agora RTM 系统。
    // 如果 SDK 登录成功，SDK 触发 connectionStateChanged 回调，连接状态变为 AgoraRtmConnectionStateConnected。SDK 会自动加入中断时用户所在频道，并自动将本地用户属性同步到服务端。
    // 如果 SDK 登录失败，SDK 会保持 AgoraRtmConnectionStateReConnecting 状态，继续自动重连。
    // 5:CONNECTION_STATE_ABORTED  SDK 放弃登录 Agora RTM 系统。
    // 可能原因：另一实例已经以同一用户 ID 登录 Agora RTM 系统。
    //
    // 在此之后，SDK 需要调用 logoutWithCompletion 方法退出登录，再视情况调用 loginByToken 方法重新登录系统。
    _client?.onConnectionStateChanged = (int state, int reason) {
      var str = 'unknown';
      switch (state) {
        case 1:
          str = "state 1:CONNECTION_STATE_DISCONNECTED";
          break;
        case 2:
          str = "state 2:CONNECTION_STATE_CONNECTING";
          break;
        case 3:
          str = "state 3:CONNECTION_STATE_CONNECTED";
          break;
        case 4:
          str = "state 4:CONNECTION_STATE_RECONNECTING";
          break;
        case 5:
          str = "state 5:CONNECTION_STATE_ABORTED";
          break;
      }
      NewHitaLog.debug("rtm connect $str reason=$reason");
      switch (state) {
        case 2:
        case 4:
          loginState = 2;
          break;
        case 3:
          NewHitaLog.debug("rtm connected!!!!! 😁");
          loginState = 1;
          break;
        default:
          loginState = 0;
          break;
      }
    };

    _client?.onTokenExpired = () {
      _getRtmTokenToLog();
    };

    _client?.onMessageReceived = handleMsg;
    _client?.onLocalInvitationAccepted =
        NewHitaRtmCallHandler.onLocalInvitationAccepted;
    _client?.onLocalInvitationReceivedByPeer =
        NewHitaRtmCallHandler.onLocalInvitationReceivedByPeer;
    _client?.onLocalInvitationRefused =
        NewHitaRtmCallHandler.onLocalInvitationRefused;
    _client?.onLocalInvitationCanceled =
        NewHitaRtmCallHandler.onLocalInvitationCanceled;
    _client?.onLocalInvitationFailure =
        NewHitaRtmCallHandler.onLocalInvitationFailure;

    _client?.onRemoteInvitationAccepted =
        NewHitaRtmCallHandler.onRemoteInvitationAccepted;
    _client?.onRemoteInvitationCanceled =
        NewHitaRtmCallHandler.onRemoteInvitationCanceled;
    _client?.onRemoteInvitationFailure =
        NewHitaRtmCallHandler.onRemoteInvitationFailure;
    _client?.onRemoteInvitationReceivedByPeer =
        NewHitaRtmCallHandler.onRemoteInvitationReceivedByPeer;
    _client?.onRemoteInvitationRefused =
        NewHitaRtmCallHandler.onRemoteInvitationRefused;
  }

  /// 三次连接不上就刷RtmToken
  static int _connetTimes = 0;

  /// 登录rtm
  static void connectRTM() async {
    if (loginState == 0) {
      if (_connetTimes < 3) {
        _connetTimes++;
        await _client?.login(NewHitaMyInfoService.to.token?.rtmToken,
            NewHitaMyInfoService.to.userLogin?.userId ?? "");
      } else {
        _connetTimes = 0;
        print('genRtmToken');
        _getRtmTokenToLog();
      }
    }
  }

  /// 刷新rtmToken再登录
  static void _getRtmTokenToLog() {
    TrudaHttpUtil()
        .post<String>(
      TrudaHttpUrls.genRtmToken,
    )
        .then((value) {
      NewHitaMyInfoService.to.token?.rtmToken = value;
      connectRTM();
    });
  }

  //用户接受主播通话邀请
  static acceptInvitation(AgoraRtmRemoteInvitation remoteInvitation,
      NewHitaInvitationCallBack callBack) async {
    try {
      await _client?.acceptRemoteInvitation(remoteInvitation.toJson());
      callBack.call(true);
    } catch (e) {
      callBack.call(false);
    }
  }

  //拒绝主播通话邀请
  static rejectInvitation(AgoraRtmRemoteInvitation remoteInvitation,
      NewHitaInvitationCallBack successCallBack) async {
    try {
      await _client?.refuseRemoteInvitation(remoteInvitation.toJson());
      successCallBack.call(true);
    } catch (e) {
      successCallBack.call(false);
    }
  }

  //向主播发送通话邀请
  static sendInvitation(
      String calleeId, String channelId, NewHitaInvitationCallBack callBack,
      {int aiType = -1}) async {
    try {
      AgoraRtmLocalInvitation localInvitation =
          AgoraRtmLocalInvitation(calleeId, channelId: channelId);
      var me = NewHitaMyInfoService.to.myDetail!.toJson();
      // 25 aib
      me['aiType'] = aiType;
      String sendUserInfo = const JsonEncoder().convert(me);
      localInvitation.content = sendUserInfo;
      var theJson = localInvitation.toJson();

      await _client?.sendLocalInvitation(theJson);
      callBack.call(true);
    } catch (e) {
      callBack.call(false);
    }
  }

  //用户取消自己的通话邀请
  static cancelLocalInvitation(String calleeId, String channelId,
      NewHitaInvitationCallBack successCallBack) async {
    try {
      AgoraRtmLocalInvitation localInvitation =
          AgoraRtmLocalInvitation(calleeId, channelId: channelId);
      await _client?.cancelLocalInvitation(localInvitation.toJson());
      successCallBack.call(true);
    } catch (e) {
      successCallBack.call(false);
    }
  }

  //rtm 发消息
  static sendRtmMsg(String herId, AgoraRtmMessage msg,
      NewHitaInvitationCallBack successCallBack) async {
    try {
      await _client?.sendMessageToPeer(herId, msg, true, false);
      successCallBack.call(true);
    } catch (e) {
      successCallBack.call(false);
    }
  }

  static closeRtm() {
    _client?.logout();
    _client == null;
  }
}

typedef NewHitaInvitationCallBack = Function(bool success);
