import '../generated/json/base/json_field.dart';
import '../generated/json/truda_leval_entity.g.dart';

@JsonSerializable()
class TrudaLevalBean {
  TrudaLevalBean();

  factory TrudaLevalBean.fromJson(Map<String, dynamic> json) =>
      $TrudaLevalBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaLevalBeanToJson(this);

  int? rid;
  int? grade;
  int? areaCode;
  int? howExp;
  int? awardType;
  int? awardVal;
  String? awardName;
  String? awardIcon;
  String? awardBackground;
}
