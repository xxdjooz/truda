import '../generated/json/base/json_field.dart';
import '../generated/json/truda_order_entity.g.dart';

@JsonSerializable()
class TrudaOrderBean {
  TrudaOrderBean();

  factory TrudaOrderBean.fromJson(Map<String, dynamic> json) =>
      $TrudaOrderBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaOrderBeanToJson(this);

  int? userId;
  int? linkId;
  int? afterChange;
  int? id;
  int? beforeChange;
  int? depletionType;
  int? updatedAt;
  int? createdAt;
  int? anchorId;
  int? type;
  int? diamonds;
}

@JsonSerializable()
class TrudaOrderData {
  TrudaOrderData();

  factory TrudaOrderData.fromJson(Map<String, dynamic> json) =>
      $TrudaOrderDataFromJson(json);

  Map<String, dynamic> toJson() => $TrudaOrderDataToJson(this);

  int? currencyFee;
  int? paidAt;
  String? currencyCode;
  String? orderNo;
  String? channelName;
  String? tradeNo;
  int? orderStatus;
  int? createdAt;
  int? updatedAt;
  int? diamonds;
}

@JsonSerializable()
class TrudaCostBean {
  TrudaCostBean();

  factory TrudaCostBean.fromJson(Map<String, dynamic> json) =>
      $TrudaCostBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaCostBeanToJson(this);

  int? userId;
  int? linkId;
  int? afterChange;
  int? id;
  int? beforeChange;
  int? depletionType;
  int? updatedAt;
  int? createdAt;
  int? anchorId;
  int? type;
  int? diamonds;
  int? inviteeRepeat;
  String? inviterNickname;
}
