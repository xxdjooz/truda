import 'package:agora_rtm/agora_rtm.dart';

// 通过网络更新个人中心
const eventBusRefreshMe = 'eventBusRefreshMe';
// 更新个人中心页面，不用加载数据
const eventBusUpdateMe = 'eventBusUpdateMe';

class TrudaEventRtmCall {
  AgoraRtmLocalInvitation? invite;
  AgoraRtmRemoteInvitation? herInvite;
  // 1 我的呼叫被接受 2 我的呼叫被拒绝 3对方呼叫取消
  int type;
  TrudaEventRtmCall(this.type, {this.invite, this.herInvite});
}

class TrudaEventMsgClear {
  // 0 都设为已读，1清空所有,3清空某主播
  int type;
  TrudaEventMsgClear(this.type);
}

class TrudaEventCommon {
  // 0电话涉黄
  // 1拉黑
  // 2举报
  int eventType;
  String herId;
  TrudaEventCommon(this.eventType, this.herId);
}

class TrudaEventOrderResult {
  int eventType;
  TrudaEventOrderResult(this.eventType);
}

class TruaEventCanCallStateChange {
  // 0余额变成可以打电话
  // 1余额变成不能打电话
  // 2视频体验卡 有了
  // 3视频体验卡 没有了
  int eventType;
  TruaEventCanCallStateChange(this.eventType);
}
