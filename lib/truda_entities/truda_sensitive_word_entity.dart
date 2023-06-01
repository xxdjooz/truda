import '../generated/json/base/json_field.dart';
import '../generated/json/truda_sensitive_word_entity.g.dart';

@JsonSerializable()
class TrudaSensitiveWordBean {
  TrudaSensitiveWordBean();

  factory TrudaSensitiveWordBean.fromJson(Map<String, dynamic> json) =>
      $TrudaSensitiveWordBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaSensitiveWordBeanToJson(this);

  String? areaCode;
  String? words;
}
