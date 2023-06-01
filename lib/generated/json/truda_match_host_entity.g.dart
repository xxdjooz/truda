import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_match_host_entity.dart';
import 'package:truda/truda_entities/truda_hot_entity.dart';


TrudaMatchHostLimit $TrudaMatchHostLimitFromJson(Map<String, dynamic> json) {
	final TrudaMatchHostLimit trudaMatchHostLimit = TrudaMatchHostLimit();
	final int? matchCount = jsonConvert.convert<int>(json['matchCount']);
	if (matchCount != null) {
		trudaMatchHostLimit.matchCount = matchCount;
	}
	final TrudaMatchHost? anchor = jsonConvert.convert<TrudaMatchHost>(json['anchor']);
	if (anchor != null) {
		trudaMatchHostLimit.anchor = anchor;
	}
	return trudaMatchHostLimit;
}

Map<String, dynamic> $TrudaMatchHostLimitToJson(TrudaMatchHostLimit entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['matchCount'] = entity.matchCount;
	data['anchor'] = entity.anchor?.toJson();
	return data;
}

TrudaMatchHost $TrudaMatchHostFromJson(Map<String, dynamic> json) {
	final TrudaMatchHost trudaMatchHost = TrudaMatchHost();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaMatchHost.userId = userId;
	}
	final String? nickName = jsonConvert.convert<String>(json['nickName']);
	if (nickName != null) {
		trudaMatchHost.nickName = nickName;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaMatchHost.portrait = portrait;
	}
	final int? isDoNotDisturb = jsonConvert.convert<int>(json['isDoNotDisturb']);
	if (isDoNotDisturb != null) {
		trudaMatchHost.isDoNotDisturb = isDoNotDisturb;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaMatchHost.isOnline = isOnline;
	}
	final int? muteStatus = jsonConvert.convert<int>(json['muteStatus']);
	if (muteStatus != null) {
		trudaMatchHost.muteStatus = muteStatus;
	}
	final int? charge = jsonConvert.convert<int>(json['charge']);
	if (charge != null) {
		trudaMatchHost.charge = charge;
	}
	final TrudaAreaData? area = jsonConvert.convert<TrudaAreaData>(json['area']);
	if (area != null) {
		trudaMatchHost.area = area;
	}
	final int? birthday = jsonConvert.convert<int>(json['birthday']);
	if (birthday != null) {
		trudaMatchHost.birthday = birthday;
	}
	final int? followed = jsonConvert.convert<int>(json['followed']);
	if (followed != null) {
		trudaMatchHost.followed = followed;
	}
	final String? video = jsonConvert.convert<String>(json['video']);
	if (video != null) {
		trudaMatchHost.video = video;
	}
	return trudaMatchHost;
}

Map<String, dynamic> $TrudaMatchHostToJson(TrudaMatchHost entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['nickName'] = entity.nickName;
	data['portrait'] = entity.portrait;
	data['isDoNotDisturb'] = entity.isDoNotDisturb;
	data['isOnline'] = entity.isOnline;
	data['muteStatus'] = entity.muteStatus;
	data['charge'] = entity.charge;
	data['area'] = entity.area?.toJson();
	data['birthday'] = entity.birthday;
	data['followed'] = entity.followed;
	data['video'] = entity.video;
	return data;
}