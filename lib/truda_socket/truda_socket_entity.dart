import '../generated/json/base/json_field.dart';
import '../generated/json/truda_socket_entity.g.dart';

@JsonSerializable()
class TrudaSocketEntity {
  // {"data":"{\"isDoNotDisturb\":0,\"isOnline\":1,\"userId\":107780488}",
  // "optType":"anchorStatusChange","remark":"",
  // "timestamp":1649663757215,"userId":107781256}
  TrudaSocketEntity();

  factory TrudaSocketEntity.fromJson(Map<String, dynamic> json) =>
      $TrudaSocketEntityFromJson(json);

  Map<String, dynamic> toJson() => $TrudaSocketEntityToJson(this);

  // CblSocketContentEntity? data_Entity;
  String? data;
  int? timestamp;
  int? userId;
  String? optType;
  String? remark;
}

@JsonSerializable()
class TrudaSocketHostState {
  static const String typeCode = 'anchorStatusChange';

  TrudaSocketHostState();

  factory TrudaSocketHostState.fromJson(Map<String, dynamic> json) =>
      $TrudaSocketHostStateFromJson(json);

  Map<String, dynamic> toJson() => $TrudaSocketHostStateToJson(this);

  String userId = '';
  int isOnline = 0;
  int isDoNotDisturb = 0;
}

@JsonSerializable()
class TrudaSocketBalance {
  static const String typeCode = 'balanceChanged';

  TrudaSocketBalance();

  factory TrudaSocketBalance.fromJson(Map<String, dynamic> json) =>
      $TrudaSocketBalanceFromJson(json);

  Map<String, dynamic> toJson() => $TrudaSocketBalanceToJson(this);

  String userId = '';
  int depletionType = 0;
  int diamonds = 0;
  int expLevel = 0;
  int? callDuration;
  // 邀请人的邀请码
  String? inviterCode;

  @override
  String toString() {
    return 'TrudaSocketBalance{userId: $userId, depletionType: $depletionType, diamonds: $diamonds, expLevel: $expLevel, callDuration: $callDuration}';
  }
}
