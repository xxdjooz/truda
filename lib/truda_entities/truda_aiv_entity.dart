import '../generated/json/base/json_field.dart';
import '../generated/json/truda_aiv_entity.g.dart';

@JsonSerializable()
class TrudaAivBean {
  TrudaAivBean();

  factory TrudaAivBean.fromJson(Map<String, dynamic> json) =>
      $TrudaAivBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaAivBeanToJson(this);

  String? userId;
  String? username;
  String? portrait;
  String? nickname;
  int? isOnline;
  String? filename;
  // 消音状态，0.消音，1.开启
  int? muteStatus;
  // 是否需要体验卡，0.不需要，1.需要
  int? isCard;
  // 体验卡时长
  int? propDuration;
  // 体验卡数量
  int? callCardCount;
}
