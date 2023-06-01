import '../generated/json/base/json_field.dart';
import '../generated/json/truda_login_entity.g.dart';

@JsonSerializable()
class TrudaLogin {
  TrudaLogin();

  factory TrudaLogin.fromJson(Map<String, dynamic> json) =>
      $TrudaLoginFromJson(json);

  Map<String, dynamic> toJson() => $TrudaLoginToJson(this);

  TrudaLoginToken? token;
  String? enterTheSystem;
  TrudaLoginUser? user;
}

@JsonSerializable()
class TrudaLoginToken {
  TrudaLoginToken();

  factory TrudaLoginToken.fromJson(Map<String, dynamic> json) =>
      $TrudaLoginTokenFromJson(json);

  Map<String, dynamic> toJson() => $TrudaLoginTokenToJson(this);

  int? expire;
  String? agoraToken;
  String? authorization;
  String? rtmToken;
  String? userId;
  String? jpushAlias;
}

@JsonSerializable()
class TrudaLoginUser {
  TrudaLoginUser();

  factory TrudaLoginUser.fromJson(Map<String, dynamic> json) =>
      $TrudaLoginUserFromJson(json);

  Map<String, dynamic> toJson() => $TrudaLoginUserToJson(this);

  bool? accountNonExpired;
  bool? accountNonLocked;
  List<dynamic>? authorities;
  int? auth;
  bool? credentialsNonExpired;
  String? userId;
  String? portrait;
  bool? enabled;
  int? created;
  String? username;
  String? nickname;
  int? gender;
  String? status;
  String? areaCode;
}
