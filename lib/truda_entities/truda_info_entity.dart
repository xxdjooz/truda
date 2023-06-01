import '../generated/json/base/json_field.dart';
import '../generated/json/truda_info_entity.g.dart';

@JsonSerializable()
class TrudaInfoDetail {
  TrudaInfoDetail();

  factory TrudaInfoDetail.fromJson(Map<String, dynamic> json) =>
      $TrudaInfoDetailFromJson(json);

  Map<String, dynamic> toJson() => $TrudaInfoDetailToJson(this);

  String? userId;
  String? username;
  int? auth;
  String? intro;
  String? portrait;
  String? nickname;
  int? areaCode;
  String? status;
  // 0,是否免打扰
  int? isDoNotDisturb;
  int? createdAt;
  int? created;
  // 0离线 1在线 2忙线
  int? isOnline;
  int? isSignIn;
  // 1 所有道具数量,
  int? propCount;
  // 1 未使用的体验卡数量,
  int? callCardCount;
  // 已使用的体验卡数量,
  int? callCardUsedCount;
  // 体验卡时长,
  int? callCardDuration;
  int? releaseTime;
  // 1,性别1男2女
  int? gender;
  int? country;
  int? connectRate;
  int? birthday;
  int? expLevel;

  TrudaBalanceBean? userBalance;
  // fail false 0 的情况下才是
  String? startBirthday;
  bool? timeBirthday;
  int? stateGender;

  // 1,是否vip用户
  int? isVip;
  // 1,vip是否已签到
  int? vipSignIn;
  // vip到期时间
  int? vipEndTime;
  //
  int? vipSupport;
  // 是否支持一键乞讨，0.不支持，1.支持
  int? begging;
  // 充值抽奖次数
  int? rechargeDrawCount;
  // 邀请人的邀请码
  String? inviterCode;
  // 0是游客登录或账号登录，1绑定了Google
  int? boundGoogle;
}

@JsonSerializable()
class TrudaBalanceBean {
  TrudaBalanceBean();

  factory TrudaBalanceBean.fromJson(Map<String, dynamic> json) =>
      $TrudaBalanceBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaBalanceBeanToJson(this);

  int? userId;
  int? totalRecharge;
  int? totalDiamonds;
  int? remainDiamonds;
  int? freeDiamonds;
  int? freeMsgCount;
  int? expLevel;
  int? createdAt;
  int? updatedAt;
}
