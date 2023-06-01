import 'dart:convert';

import '../generated/json/base/json_field.dart';
import '../generated/json/truda_ai_config_entity.g.dart';

@JsonSerializable()
class TrudaAiConfigEntity {
  ///用户登录首次aib的延时时间，单位秒
  int? loginDelay;

  ///低余额钻石阈值
  int? floorDiamondsThreshold;

  ///体验卡阈值
  int? floorCallCardThreshold;

  ///aib配置组
  TrudaAiConfigGroups? groups;

  TrudaAiConfigEntity();

  factory TrudaAiConfigEntity.fromJson(Map<String, dynamic> json) =>
      $TrudaAiConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $TrudaAiConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TrudaAiConfigGroups {
  ///未充值用户无接听能力(else 其他)
  @JSONField(name: "AIB_LACK_BALANCE")
  TrudaAiConfigGroupsItem? aibLackBalance;

  ///付费用户无接听能力(用户余额>0)
  @JSONField(name: "AIB_PAID_LACK_BALANCE")
  TrudaAiConfigGroupsItem? aibPaidLackBalance;

  ///用户有接听能力 用户有体验卡 （体验卡>=floorCallCardThreshold)、
  @JSONField(name: "AIB_ENOUGH_CALL_CARD")
  TrudaAiConfigGroupsItem? aibEnoughCallCard;

  ///用户有接听能力 用户余额足够(用户余额>=floorDiamondsThreshold）
  @JSONField(name: "AIB_ENOUGH_BALANCE")
  TrudaAiConfigGroupsItem? aibEnoughBalance;

  TrudaAiConfigGroups();

  factory TrudaAiConfigGroups.fromJson(Map<String, dynamic> json) =>
      $TrudaAiConfigGroupsFromJson(json);

  Map<String, dynamic> toJson() => $TrudaAiConfigGroupsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

// loginDelay	int	用户登录首次aib的延时时间，单位秒
// floorDiamondsThreshold	int	低余额阈值
// floorCallCardThreshold	int	体验卡阈值
// groups	[]	aib配置组
// —configGroup	string	AIB_ENOUGH_BALANCE：有钻石、
// AIB_ENOUGH_CALL_CARD：有体验卡、
// AIB_PAID_LACK_BALANCE：无钻石、
// AIB_LACK_BALANCE：无体验卡
// —nextAibTime	int	aib间隔(下一个aib的触发时间，单位秒)
// —rejectDelay	int	拒接延时(拒接之后下次aib延时时间，单位秒)
// —sendFlag	int	aib开关，0关，1开
// —aivSendFlag	int	aiv开关，0关，1开
// —aivFirstLoginCount	int	aiv首次登录发送次数
// —aivNextLoginCount	int	aiv非首次登录发送次数
// —aivLoginInterval	int	aiv登录间隔时间，单位分钟
// —minAivDelaySeconds	int	aiv发送间隔时间，单位秒
// —maxAivDelaySeconds	int	aiv发送间隔时间，单位秒
@JsonSerializable()
class TrudaAiConfigGroupsItem {
  String? configGroup;

  ///aib间隔(下一个aib的触发时间，单位秒)
  int? nextAibTime;

  ///拒接延时(拒接之后下次aib延时时间，单位秒)
  int? rejectDelay;

  /// 是否去触发 aib 0:不触发，1:触发
  int? sendFlag;

  ///aiv 的最小间隔时间
  int? minAivDelaySeconds;

  /// aiv 的最大间隔时间
  int? maxAivDelaySeconds;

  ///  aiv开关，0关，1开
  int? aivSendFlag;
  // aiv首次登录发送次数
  int? aivFirstLoginCount;
  // aiv非首次登录发送次数
  int? aivNextLoginCount;
  // aiv登录间隔时间，单位分钟
  int? aivLoginInterval;
  // 第一个aiv
  int? aivFirstDelay;
  // aiv首次登录间隔
  int? aivMinFirstLoginSeconds;
  int? aivMaxFirstLoginSeconds;

  TrudaAiConfigGroupsItem();

  factory TrudaAiConfigGroupsItem.fromJson(Map<String, dynamic> json) =>
      $TrudaAiConfigGroupsItemFromJson(json);

  Map<String, dynamic> toJson() => $TrudaAiConfigGroupsItemToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
