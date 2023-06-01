import 'dart:convert';

import '../../generated/json/base/json_field.dart';
import '../../generated/json/newhita_ads_spots_entity.g.dart';

@JsonSerializable()
class NewHitaAdsSpotsEntity {
// 广告id
  late String adId;
  // 广告标题
  late String adTitle;
  // app广告编码
  late String keyCode;
  // 平台广告编码
  late String adCode;
  // 广告类型，1.普通广告，2.激励广告
  late int adType;
  // 配置状态，0.停用，1.启用"
  late int adStatus;
  // 广告位置，1.首页hot，2.消息会话，3.个人中心，4.私聊界面"
  late int adPosition;
  // 奖励钻石数
  late int diamonds;

  NewHitaAdsSpotsEntity();

  factory NewHitaAdsSpotsEntity.fromJson(Map<String, dynamic> json) =>
      $NewHitaAdsSpotsEntityFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaAdsSpotsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
