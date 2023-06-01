import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_aiv_entity.dart';

TrudaAivBean $TrudaAivBeanFromJson(Map<String, dynamic> json) {
	final TrudaAivBean trudaAivBean = TrudaAivBean();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaAivBean.userId = userId;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		trudaAivBean.username = username;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaAivBean.portrait = portrait;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaAivBean.nickname = nickname;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaAivBean.isOnline = isOnline;
	}
	final String? filename = jsonConvert.convert<String>(json['filename']);
	if (filename != null) {
		trudaAivBean.filename = filename;
	}
	final int? muteStatus = jsonConvert.convert<int>(json['muteStatus']);
	if (muteStatus != null) {
		trudaAivBean.muteStatus = muteStatus;
	}
	final int? isCard = jsonConvert.convert<int>(json['isCard']);
	if (isCard != null) {
		trudaAivBean.isCard = isCard;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		trudaAivBean.propDuration = propDuration;
	}
	final int? callCardCount = jsonConvert.convert<int>(json['callCardCount']);
	if (callCardCount != null) {
		trudaAivBean.callCardCount = callCardCount;
	}
	return trudaAivBean;
}

Map<String, dynamic> $TrudaAivBeanToJson(TrudaAivBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['username'] = entity.username;
	data['portrait'] = entity.portrait;
	data['nickname'] = entity.nickname;
	data['isOnline'] = entity.isOnline;
	data['filename'] = entity.filename;
	data['muteStatus'] = entity.muteStatus;
	data['isCard'] = entity.isCard;
	data['propDuration'] = entity.propDuration;
	data['callCardCount'] = entity.callCardCount;
	return data;
}