import '../generated/json/base/json_field.dart';
import '../generated/json/truda_order_check_entity.g.dart';

@JsonSerializable()
class TrudaOrderCheckEntity {
  TrudaOrderCheckEntity();

  factory TrudaOrderCheckEntity.fromJson(Map<String, dynamic> json) =>
      $TrudaOrderCheckEntityFromJson(json);

  Map<String, dynamic> toJson() => $TrudaOrderCheckEntityToJson(this);

  String? orderNo;
  int? orderStatus;
}
