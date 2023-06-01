import '../generated/json/base/json_field.dart';
import '../generated/json/newhita_socket_entity.g.dart';

@JsonSerializable()
class NewHitaSocketEntity {
  // {"data":"{\"isDoNotDisturb\":0,\"isOnline\":1,\"userId\":107780488}",
  // "optType":"anchorStatusChange","remark":"",
  // "timestamp":1649663757215,"userId":107781256}
  NewHitaSocketEntity();

  factory NewHitaSocketEntity.fromJson(Map<String, dynamic> json) =>
      $NewHitaSocketEntityFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaSocketEntityToJson(this);

  // CblSocketContentEntity? data_Entity;
  String? data;
  int? timestamp;
  int? userId;
  String? optType;
  String? remark;
}

@JsonSerializable()
class NewHitaSocketHostState {
  static const String typeCode = 'anchorStatusChange';

  NewHitaSocketHostState();

  factory NewHitaSocketHostState.fromJson(Map<String, dynamic> json) =>
      $NewHitaSocketHostStateFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaSocketHostStateToJson(this);

  String userId = '';
  int isOnline = 0;
  int isDoNotDisturb = 0;
}

@JsonSerializable()
class NewHitaSocketBalance {
  static const String typeCode = 'balanceChanged';

  NewHitaSocketBalance();

  factory NewHitaSocketBalance.fromJson(Map<String, dynamic> json) =>
      $NewHitaSocketBalanceFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaSocketBalanceToJson(this);

  String userId = '';
  int depletionType = 0;
  int diamonds = 0;
  int expLevel = 0;
  int? callDuration;
  // 邀请人的邀请码
  String? inviterCode;

  @override
  String toString() {
    return 'NewHitaSocketBalance{userId: $userId, depletionType: $depletionType, diamonds: $diamonds, expLevel: $expLevel, callDuration: $callDuration}';
  }
}
