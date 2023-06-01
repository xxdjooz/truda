import '../generated/json/base/json_field.dart';
import '../generated/json/truda_end_call_entity.g.dart';

@JsonSerializable()
class TrudaEndCallEntity {
  TrudaEndCallEntity();

  factory TrudaEndCallEntity.fromJson(Map<String, dynamic> json) =>
      $TrudaEndCallEntityFromJson(json);

  Map<String, dynamic> toJson() => $TrudaEndCallEntityToJson(this);

  String? channelId;
  bool? usedProp;
  String? callTime;
  String? totalCallTime;
  int? callAmount;
  int? giftAmount;
  int? remainAmount;
  int? callCardCount;
  bool? ratedApp;
}
