import 'package:truda/generated/json/base/json_field.dart';
import 'package:truda/generated/json/truda_banner_entity.g.dart';

@JsonSerializable()
class TrudaBannerBean {
  TrudaBannerBean();

  factory TrudaBannerBean.fromJson(Map<String, dynamic> json) =>
      $TrudaBannerBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaBannerBeanToJson(this);

  int? updatedAt;
  int? category;
  int? bid;
  String? link;
  int? ranking;
  int? type;
  String? title;
  String? appName;
  String? cover;
  int? target;
  int? createdAt;
  int? areaCode;
}
