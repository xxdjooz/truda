import '../generated/json/base/json_field.dart';
import '../generated/json/truda_lottery_user_entity.g.dart';

@JsonSerializable()
class TrudaLotteryUser {
  TrudaLotteryUser();

  factory TrudaLotteryUser.fromJson(Map<String, dynamic> json) =>
      $TrudaLotteryUserFromJson(json);

  Map<String, dynamic> toJson() => $TrudaLotteryUserToJson(this);
  // "userId": 123,
  // "nickname": "123",
  // "portrait": "头像",
  // "configId": 7,//奖品id
  // "name": "5点经验",//奖品名称
  // "icon": "",// 奖品图标
  // "value": 1,// 奖品数值
  String? userId;
  String? nickname;
  String? portrait;
  int? configId;
  String? name;
  String? icon;
  int? value;
}
