import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:truda/truda_pages/call/remote/truda_remote_controller.dart';
import 'package:truda/truda_rtm/truda_rtm_manager.dart';
import 'package:truda/truda_services/truda_event_bus_bean.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/newhita_check_calling_util.dart';

import '../truda_common/truda_constants.dart';
import '../generated/json/base/json_convert_content.dart';
import '../truda_routes/truda_pages.dart';
import '../truda_utils/newhita_log.dart';

class TrudaRtmCallHandler {
  /// 我的呼叫被接受
  static void onLocalInvitationAccepted(AgoraRtmLocalInvitation invite) {
    // Map upMap = const JsonDecoder().convert(invite.response ?? "");
    // DetailData upDetailData = JsonConvert.fromJsonAsT<>(upMap)!;
    NewHitaLog.debug(invite);
    TrudaStorageService.to.eventBus.fire(TrudaEventRtmCall(1, invite: invite));
  }

  static void onLocalInvitationReceivedByPeer(AgoraRtmLocalInvitation invite) {}

  static void onLocalInvitationRefused(AgoraRtmLocalInvitation invite) {
    TrudaStorageService.to.eventBus.fire(TrudaEventRtmCall(2, invite: invite));
  }

  static void onLocalInvitationCanceled(AgoraRtmLocalInvitation invite) {}

  static void onLocalInvitationFailure(
      AgoraRtmLocalInvitation invite, int errorCode) {}

  static void onRemoteInvitationAccepted(AgoraRtmRemoteInvitation invite) {}

  /// 对方呼叫取消掉了
  static void onRemoteInvitationCanceled(AgoraRtmRemoteInvitation invite) {
    TrudaStorageService.to.eventBus.fire(TrudaEventRtmCall(3, herInvite: invite));
  }

  static void onRemoteInvitationFailure(
      AgoraRtmRemoteInvitation invite, int errorCode) {}

  /// 收到呼叫
  static void onRemoteInvitationReceivedByPeer(
      AgoraRtmRemoteInvitation invite) {
    NewHitaLog.debug(invite);
    if (TrudaConstants.isFakeMode) {
      return;
    }
    // todo
    if (!NewHitaCheckCallingUtil.checkCanBeCalled()) {
      TrudaRtmManager.rejectInvitation(
          // AgoraRtmRemoteInvitation(herId,
          //     content: content, channelId: channelId, response: ''),
          invite..response = '',
          (sucdess) {});
      return;
    }
    // if (Get.currentRoute == NewHitaAppPages.callEnd) {
    //   Get.offNamed(NewHitaAppPages.callEnd);
    // }
    TrudaRemoteController.startMe(
        invite.callerId, invite.channelId!, invite.content ?? '');
  }

  static void onRemoteInvitationRefused(AgoraRtmRemoteInvitation invite) {}
}
