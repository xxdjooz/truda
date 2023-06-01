import '../generated/json/base/json_field.dart';
import '../generated/json/truda_oss_entity.g.dart';

@JsonSerializable()
class TrudaOssConfig {
  TrudaOssConfig();

  factory TrudaOssConfig.fromJson(Map<String, dynamic> json) =>
      $TrudaOssConfigFromJson(json);

  Map<String, dynamic> toJson() => $TrudaOssConfigToJson(this);

  String? endpoint;
  String? bucket;
  String? path;
  String? key;
  String? secret;
  String? token;
  int? expire;
}
