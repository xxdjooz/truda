import '../generated/json/base/json_field.dart';
import '../generated/json/truda_lottery_entity.g.dart';

@JsonSerializable()
class TrudaLotteryBean {
  TrudaLotteryBean();

  factory TrudaLotteryBean.fromJson(Map<String, dynamic> json) =>
      $TrudaLotteryBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaLotteryBeanToJson(this);
  //  "configId": 7,//奖品id
  //  "name": "5点经验",//奖品名称
  //  "icon": "",// 奖品图标
  //  "areaCode": 0,// 地区
  //  "probability": 10,// 中奖概率
  //  "drawMode": 1,// 抽奖模式，1.充值抽奖
  //  "drawType": 1,// 奖品类型，0.谢谢参与，1.送钻石，2.送会员天数，3.送钻石加成卡
  //  "value": 1,// 值
  int? configId;
  String? name;
  String? icon;
  int? areaCode;
  int? probability;
  int? drawMode;
  int? drawType;
  int? value;
}
