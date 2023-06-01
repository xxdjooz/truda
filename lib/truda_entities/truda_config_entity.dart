// @JsonSerializable()
// class NewHitaCblConfigEntity {
//
// 	NewHitaCblConfigEntity();
//
// 	factory NewHitaCblConfigEntity.fromJson(Map<String, dynamic> json) => $NewHitaCblConfigEntityFromJson(json);
//
// 	Map<String, dynamic> toJson() => $NewHitaCblConfigEntityToJson(this);
//
//   int? code;
//   String? message;
//   CblConfigData? data;
//   dynamic? page;
// }

import '../generated/json/base/json_field.dart';
import '../generated/json/truda_config_entity.g.dart';

@JsonSerializable()
class TrudaConfigData {
  TrudaConfigData();

  factory TrudaConfigData.fromJson(Map<String, dynamic> json) =>
      $TrudaConfigDataFromJson(json);

  Map<String, dynamic> toJson() => $TrudaConfigDataToJson(this);

  String? aiHelp;
  int? sendMsgDiamondsPrice;
  String? appStoreWriteLink;
  @JSONField(name: "free_message_count")
  int? freeMessageCount;
  String? email;
  String? promotionTime;
  String? whatsapp;
  String? agoraAppId;
  int? chargePrice;
  // 1的时候支付数据不上报fb
  bool? stopFbPurchase;
  bool? showFbLogin;
  String? fbPermission;
  String? scale;
  String? payScale;
  String? adjust;
  String? publicKey;
  String? leveldetailurl;
  String? discountvideourl;
  String? appUpdate;
  int? vipDailyDiamonds;
  int? matchTimes;
}

//  {"isShow":false,"content":" 因为... ","url":"https://baidu.com ","title":" 产品变更","type":2}
@JsonSerializable()
class TrudaAppUpdate {
  TrudaAppUpdate();

  factory TrudaAppUpdate.fromJson(Map<String, dynamic> json) =>
      $TrudaAppUpdateFromJson(json);

  Map<String, dynamic> toJson() => $TrudaAppUpdateToJson(this);
  bool? isShow;
  // 1 google, 2 url
  int? type;
  String? title;
  String? content;
  String? url;
}

@JsonSerializable()
class TrudaPayScale {
  TrudaPayScale();

  factory TrudaPayScale.fromJson(Map<String, dynamic> json) =>
      $TrudaPayScaleFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayScaleToJson(this);
  double? adjustScale;
  double? facebookScale;
  double? defaultScale;
}