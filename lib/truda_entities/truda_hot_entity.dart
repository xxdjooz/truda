import '../generated/json/base/json_field.dart';
import '../generated/json/truda_hot_entity.g.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';

/// 发现了一个问题这里导包了NewHitaHostDetail
/// 如果写成 import 'truda_host_entity.dart';生成的.g.dart文件也这样导包产生错误
/// 改用 import 'package:truda/truda_entities/truda_host_entity.dart';
/// 才没有问题，说明这个插件需要全路径
@JsonSerializable()
class TrudaUpListData {
  TrudaUpListData();

  factory TrudaUpListData.fromJson(Map<String, dynamic> json) =>
      $TrudaUpListDataFromJson(json);

  Map<String, dynamic> toJson() => $TrudaUpListDataToJson(this);

  List<TrudaHostDetail>? anchorLists;
  List<TrudaAreaData>? areaList;
  int? curAreaCode;
}

@JsonSerializable()
class TrudaAreaData {
  TrudaAreaData();

  factory TrudaAreaData.fromJson(Map<String, dynamic> json) =>
      $TrudaAreaDataFromJson(json);

  Map<String, dynamic> toJson() => $TrudaAreaDataToJson(this);
  int? canChoose; // 1可以选择换区
  int? areaCode;
  String? title;
  String? path;
  int? countryCode;
}
