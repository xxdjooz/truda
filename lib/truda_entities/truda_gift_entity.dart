import '../generated/json/base/json_field.dart';
import '../generated/json/truda_gift_entity.g.dart';

@JsonSerializable()
class TrudaGiftEntity {
  TrudaGiftEntity();

  factory TrudaGiftEntity.fromJson(Map<String, dynamic> json) =>
      $TrudaGiftEntityFromJson(json);

  Map<String, dynamic> toJson() => $TrudaGiftEntityToJson(this);

  int? createdAt;
  int? updatedAt;
  int? gid;
  String? name;
  int? diamonds;
  int? type;
  String? icon;
  String? animEffectUrl;
  int? areaCode;
  int? online;
  int? rankBy;
  bool? choose;

  //本地使用 用于传值 表示用户送了几个礼物
  int? quantity;
  // 是否vip专属，0.否，1.是
  int? vipVisible;

  //本地使用 赠送了这个礼物的这条记录的id
  String? sendGiftRecordId;
}
