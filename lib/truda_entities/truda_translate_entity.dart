import 'dart:convert';
import '../generated/json/base/json_field.dart';
import '../generated/json/truda_translate_entity.g.dart';

@JsonSerializable()
class TrudaTranslateData {
  String? appChannel;
  String? appVersion;
  String? language;
  int? configVersion;
  int? appNumber;
  String? configUrl;
  List<TrudaTranslateDataConfigs>? configs;

  TrudaTranslateData();

  factory TrudaTranslateData.fromJson(Map<String, dynamic> json) =>
      $TrudaTranslateDataFromJson(json);

  Map<String, dynamic> toJson() => $TrudaTranslateDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TrudaTranslateDataConfigs {
  String? configKey;
  String? configValue;
  String? language;

  TrudaTranslateDataConfigs();

  factory TrudaTranslateDataConfigs.fromJson(Map<String, dynamic> json) =>
      $TrudaTranslateDataConfigsFromJson(json);

  Map<String, dynamic> toJson() => $TrudaTranslateDataConfigsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
