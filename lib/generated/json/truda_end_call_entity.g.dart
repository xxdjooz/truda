import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_end_call_entity.dart';

TrudaEndCallEntity $TrudaEndCallEntityFromJson(Map<String, dynamic> json) {
	final TrudaEndCallEntity trudaEndCallEntity = TrudaEndCallEntity();
	final String? channelId = jsonConvert.convert<String>(json['channelId']);
	if (channelId != null) {
		trudaEndCallEntity.channelId = channelId;
	}
	final bool? usedProp = jsonConvert.convert<bool>(json['usedProp']);
	if (usedProp != null) {
		trudaEndCallEntity.usedProp = usedProp;
	}
	final String? callTime = jsonConvert.convert<String>(json['callTime']);
	if (callTime != null) {
		trudaEndCallEntity.callTime = callTime;
	}
	final String? totalCallTime = jsonConvert.convert<String>(json['totalCallTime']);
	if (totalCallTime != null) {
		trudaEndCallEntity.totalCallTime = totalCallTime;
	}
	final int? callAmount = jsonConvert.convert<int>(json['callAmount']);
	if (callAmount != null) {
		trudaEndCallEntity.callAmount = callAmount;
	}
	final int? giftAmount = jsonConvert.convert<int>(json['giftAmount']);
	if (giftAmount != null) {
		trudaEndCallEntity.giftAmount = giftAmount;
	}
	final int? remainAmount = jsonConvert.convert<int>(json['remainAmount']);
	if (remainAmount != null) {
		trudaEndCallEntity.remainAmount = remainAmount;
	}
	final int? callCardCount = jsonConvert.convert<int>(json['callCardCount']);
	if (callCardCount != null) {
		trudaEndCallEntity.callCardCount = callCardCount;
	}
	final bool? ratedApp = jsonConvert.convert<bool>(json['ratedApp']);
	if (ratedApp != null) {
		trudaEndCallEntity.ratedApp = ratedApp;
	}
	return trudaEndCallEntity;
}

Map<String, dynamic> $TrudaEndCallEntityToJson(TrudaEndCallEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['channelId'] = entity.channelId;
	data['usedProp'] = entity.usedProp;
	data['callTime'] = entity.callTime;
	data['totalCallTime'] = entity.totalCallTime;
	data['callAmount'] = entity.callAmount;
	data['giftAmount'] = entity.giftAmount;
	data['remainAmount'] = entity.remainAmount;
	data['callCardCount'] = entity.callCardCount;
	data['ratedApp'] = entity.ratedApp;
	return data;
}