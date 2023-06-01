import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_contribute_entity.dart';

TrudaContributeBean $TrudaContributeBeanFromJson(Map<String, dynamic> json) {
	final TrudaContributeBean trudaContributeBean = TrudaContributeBean();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaContributeBean.userId = userId;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		trudaContributeBean.username = username;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaContributeBean.nickname = nickname;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaContributeBean.portrait = portrait;
	}
	final int? isDoNotDisturb = jsonConvert.convert<int>(json['isDoNotDisturb']);
	if (isDoNotDisturb != null) {
		trudaContributeBean.isDoNotDisturb = isDoNotDisturb;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaContributeBean.isOnline = isOnline;
	}
	final int? offlineAt = jsonConvert.convert<int>(json['offlineAt']);
	if (offlineAt != null) {
		trudaContributeBean.offlineAt = offlineAt;
	}
	final int? amount = jsonConvert.convert<int>(json['amount']);
	if (amount != null) {
		trudaContributeBean.amount = amount;
	}
	final int? expLevel = jsonConvert.convert<int>(json['expLevel']);
	if (expLevel != null) {
		trudaContributeBean.expLevel = expLevel;
	}
	return trudaContributeBean;
}

Map<String, dynamic> $TrudaContributeBeanToJson(TrudaContributeBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['username'] = entity.username;
	data['nickname'] = entity.nickname;
	data['portrait'] = entity.portrait;
	data['isDoNotDisturb'] = entity.isDoNotDisturb;
	data['isOnline'] = entity.isOnline;
	data['offlineAt'] = entity.offlineAt;
	data['amount'] = entity.amount;
	data['expLevel'] = entity.expLevel;
	return data;
}