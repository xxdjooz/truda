import 'package:truda/generated/json/truda_send_gift_result.g.dart';

import '../generated/json/base/json_field.dart';

@JsonSerializable()
class TrudaSendGiftResult {
  TrudaSendGiftResult();

  factory TrudaSendGiftResult.fromJson(Map<String, dynamic> json) =>
      $TrudaSendGiftResultFromJson(json);

  Map<String, dynamic> toJson() => $TrudaSendGiftResultToJson(this);

  int? gid;
  int? deposit;
  int? time;
}
