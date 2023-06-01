import 'dart:convert';

import 'package:truda/generated/json/base/json_field.dart';
import 'package:truda/generated/json/truda_call_record_entity.g.dart';

@JsonSerializable()
class TrudaCallRecordEntity {
  int? callId;
  int? channelId;
  int? currUserId;
  int? peerUserId;
  int? callRole;
  int? chargePrice;
  int? chargeCount;
  int? endAt;
  // 挂断原因，-1.电话未接通，0.正常挂断，1.对方离线，2.声网连接失败，3.对方挂断，
  // 4.续key失败，5.创建通话记录失败，6.余额不足，7.被封禁，8.连接超时
  int? endType;
  int? clientEndAt;
  int? clientDuration;
  int? createdAt;
  int? updatedAt;
  String? currUsername;
  String? peerUsername;
  String? peerNickname;
  String? peerPortrait;
  //频道状态，0.拨号中，1.已接通，2.被叫拒绝，3.主叫方取消，4.通话完成，5.异常结束
  int? channelStatus;
  int? startAt;
  int? peerIsOnline;
  int? peerIsDoNotDisturb;

  TrudaCallRecordEntity();

  factory TrudaCallRecordEntity.fromJson(Map<String, dynamic> json) =>
      $TrudaCallRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => $TrudaCallRecordEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  bool get isShowOnline => realOnlineState == 1;
  int get realOnlineState {
    if (peerIsDoNotDisturb == 0) {
      return peerIsOnline ?? 0;
    } else {
      return 0;
    }
  }
}
