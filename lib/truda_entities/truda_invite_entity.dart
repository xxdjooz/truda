import 'package:truda/generated/json/base/json_field.dart';

import '../generated/json/truda_invite_entity.g.dart';

@JsonSerializable()
class TrudaInviteBean {
  TrudaInviteBean();

  factory TrudaInviteBean.fromJson(Map<String, dynamic> json) =>
      $TrudaInviteBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaInviteBeanToJson(this);
  // "inviteCode":"jsjgn54",// 邀请码
  // "inviteCount":12,// 邀请人数
  // "awardIncome":123,// 奖励收益
  // "inviteAward":20,// 每邀请一个用户，邀请人获得的钻石数
  // "rechargeAward":5,// 邀请用户每次充值，邀请人获得钻石的百分比
  // "inviteeCardCount":1// 被邀请用户获得的体验卡数量
  // "shareContent":分享文案,
  // "shareUrl":分享链接,
  // "portraits":[受邀者头像
  // "123","123"
  // ]
  String? inviteCode;
  int? inviteCount;
  int? awardIncome;
  int? inviteAward;
  int? rechargeAward;
  int? inviteeCardCount;
  String? shareContent;
  String? shareUrl;
  List<String>? portraits;
}
