import '../generated/json/base/json_field.dart';
import '../generated/json/truda_contribute_entity.g.dart';

@JsonSerializable()
class TrudaContributeBean {
  TrudaContributeBean();

  factory TrudaContributeBean.fromJson(Map<String, dynamic> json) =>
      $TrudaContributeBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaContributeBeanToJson(this);

  String? userId;
  String? username;
  String? nickname;
  String? portrait;
  int? isDoNotDisturb;
  int? isOnline;
  int? offlineAt;
  int? amount;
  int? expLevel;
}
