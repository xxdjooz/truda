import '../generated/json/base/json_field.dart';
import '../generated/json/truda_join_call_entity.g.dart';

@JsonSerializable()
class TrudaJoinCall {
  static const int typeCode = 23;
  TrudaJoinCall();

  factory TrudaJoinCall.fromJson(Map<String, dynamic> json) =>
      $TrudaJoinCallFromJson(json);

  Map<String, dynamic> toJson() => $TrudaJoinCallToJson(this);
  String? channelId;
  int? chargePrice;
  int? propDuration;
  int? remainDiamonds;
  String? extra;
  bool? usedProp;
  bool? newVersion;
  String? rtcToken;
  // 钻石通话时是否充值引导，0.不引导，1.引导
  int? isShowDiamondRechargeGuide;
  // 体验卡通话是否充值引导，0.不引导，1.引导
  int? isShowCardRechargeGuide;
}
