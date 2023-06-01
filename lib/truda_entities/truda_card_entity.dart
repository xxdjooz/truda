import '../generated/json/base/json_field.dart';
import '../generated/json/truda_card_entity.g.dart';

@JsonSerializable()
class TrudaCardBean {
  TrudaCardBean();

  factory TrudaCardBean.fromJson(Map<String, dynamic> json) =>
      $TrudaCardBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaCardBeanToJson(this);

  int? userId;
  int? propType;
  int? propDuration;
  int? propNum;
}
