import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_lottery_user_entity.dart';

TrudaLotteryUser $TrudaLotteryUserFromJson(Map<String, dynamic> json) {
	final TrudaLotteryUser trudaLotteryUser = TrudaLotteryUser();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaLotteryUser.userId = userId;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaLotteryUser.nickname = nickname;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaLotteryUser.portrait = portrait;
	}
	final int? configId = jsonConvert.convert<int>(json['configId']);
	if (configId != null) {
		trudaLotteryUser.configId = configId;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		trudaLotteryUser.name = name;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		trudaLotteryUser.icon = icon;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		trudaLotteryUser.value = value;
	}
	return trudaLotteryUser;
}

Map<String, dynamic> $TrudaLotteryUserToJson(TrudaLotteryUser entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['nickname'] = entity.nickname;
	data['portrait'] = entity.portrait;
	data['configId'] = entity.configId;
	data['name'] = entity.name;
	data['icon'] = entity.icon;
	data['value'] = entity.value;
	return data;
}