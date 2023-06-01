import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_login_entity.dart';

TrudaLogin $TrudaLoginFromJson(Map<String, dynamic> json) {
	final TrudaLogin trudaLogin = TrudaLogin();
	final TrudaLoginToken? token = jsonConvert.convert<TrudaLoginToken>(json['token']);
	if (token != null) {
		trudaLogin.token = token;
	}
	final String? enterTheSystem = jsonConvert.convert<String>(json['enterTheSystem']);
	if (enterTheSystem != null) {
		trudaLogin.enterTheSystem = enterTheSystem;
	}
	final TrudaLoginUser? user = jsonConvert.convert<TrudaLoginUser>(json['user']);
	if (user != null) {
		trudaLogin.user = user;
	}
	return trudaLogin;
}

Map<String, dynamic> $TrudaLoginToJson(TrudaLogin entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['token'] = entity.token?.toJson();
	data['enterTheSystem'] = entity.enterTheSystem;
	data['user'] = entity.user?.toJson();
	return data;
}

TrudaLoginToken $TrudaLoginTokenFromJson(Map<String, dynamic> json) {
	final TrudaLoginToken trudaLoginToken = TrudaLoginToken();
	final int? expire = jsonConvert.convert<int>(json['expire']);
	if (expire != null) {
		trudaLoginToken.expire = expire;
	}
	final String? agoraToken = jsonConvert.convert<String>(json['agoraToken']);
	if (agoraToken != null) {
		trudaLoginToken.agoraToken = agoraToken;
	}
	final String? authorization = jsonConvert.convert<String>(json['authorization']);
	if (authorization != null) {
		trudaLoginToken.authorization = authorization;
	}
	final String? rtmToken = jsonConvert.convert<String>(json['rtmToken']);
	if (rtmToken != null) {
		trudaLoginToken.rtmToken = rtmToken;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaLoginToken.userId = userId;
	}
	final String? jpushAlias = jsonConvert.convert<String>(json['jpushAlias']);
	if (jpushAlias != null) {
		trudaLoginToken.jpushAlias = jpushAlias;
	}
	return trudaLoginToken;
}

Map<String, dynamic> $TrudaLoginTokenToJson(TrudaLoginToken entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['expire'] = entity.expire;
	data['agoraToken'] = entity.agoraToken;
	data['authorization'] = entity.authorization;
	data['rtmToken'] = entity.rtmToken;
	data['userId'] = entity.userId;
	data['jpushAlias'] = entity.jpushAlias;
	return data;
}

TrudaLoginUser $TrudaLoginUserFromJson(Map<String, dynamic> json) {
	final TrudaLoginUser trudaLoginUser = TrudaLoginUser();
	final bool? accountNonExpired = jsonConvert.convert<bool>(json['accountNonExpired']);
	if (accountNonExpired != null) {
		trudaLoginUser.accountNonExpired = accountNonExpired;
	}
	final bool? accountNonLocked = jsonConvert.convert<bool>(json['accountNonLocked']);
	if (accountNonLocked != null) {
		trudaLoginUser.accountNonLocked = accountNonLocked;
	}
	final List<dynamic>? authorities = jsonConvert.convertListNotNull<dynamic>(json['authorities']);
	if (authorities != null) {
		trudaLoginUser.authorities = authorities;
	}
	final int? auth = jsonConvert.convert<int>(json['auth']);
	if (auth != null) {
		trudaLoginUser.auth = auth;
	}
	final bool? credentialsNonExpired = jsonConvert.convert<bool>(json['credentialsNonExpired']);
	if (credentialsNonExpired != null) {
		trudaLoginUser.credentialsNonExpired = credentialsNonExpired;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaLoginUser.userId = userId;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaLoginUser.portrait = portrait;
	}
	final bool? enabled = jsonConvert.convert<bool>(json['enabled']);
	if (enabled != null) {
		trudaLoginUser.enabled = enabled;
	}
	final int? created = jsonConvert.convert<int>(json['created']);
	if (created != null) {
		trudaLoginUser.created = created;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		trudaLoginUser.username = username;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaLoginUser.nickname = nickname;
	}
	final int? gender = jsonConvert.convert<int>(json['gender']);
	if (gender != null) {
		trudaLoginUser.gender = gender;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		trudaLoginUser.status = status;
	}
	final String? areaCode = jsonConvert.convert<String>(json['areaCode']);
	if (areaCode != null) {
		trudaLoginUser.areaCode = areaCode;
	}
	return trudaLoginUser;
}

Map<String, dynamic> $TrudaLoginUserToJson(TrudaLoginUser entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['accountNonExpired'] = entity.accountNonExpired;
	data['accountNonLocked'] = entity.accountNonLocked;
	data['authorities'] =  entity.authorities;
	data['auth'] = entity.auth;
	data['credentialsNonExpired'] = entity.credentialsNonExpired;
	data['userId'] = entity.userId;
	data['portrait'] = entity.portrait;
	data['enabled'] = entity.enabled;
	data['created'] = entity.created;
	data['username'] = entity.username;
	data['nickname'] = entity.nickname;
	data['gender'] = entity.gender;
	data['status'] = entity.status;
	data['areaCode'] = entity.areaCode;
	return data;
}