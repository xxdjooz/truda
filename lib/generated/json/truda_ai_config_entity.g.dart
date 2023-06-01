import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_ai_config_entity.dart';

TrudaAiConfigEntity $TrudaAiConfigEntityFromJson(Map<String, dynamic> json) {
	final TrudaAiConfigEntity trudaAiConfigEntity = TrudaAiConfigEntity();
	final int? loginDelay = jsonConvert.convert<int>(json['loginDelay']);
	if (loginDelay != null) {
		trudaAiConfigEntity.loginDelay = loginDelay;
	}
	final int? floorDiamondsThreshold = jsonConvert.convert<int>(json['floorDiamondsThreshold']);
	if (floorDiamondsThreshold != null) {
		trudaAiConfigEntity.floorDiamondsThreshold = floorDiamondsThreshold;
	}
	final int? floorCallCardThreshold = jsonConvert.convert<int>(json['floorCallCardThreshold']);
	if (floorCallCardThreshold != null) {
		trudaAiConfigEntity.floorCallCardThreshold = floorCallCardThreshold;
	}
	final TrudaAiConfigGroups? groups = jsonConvert.convert<TrudaAiConfigGroups>(json['groups']);
	if (groups != null) {
		trudaAiConfigEntity.groups = groups;
	}
	return trudaAiConfigEntity;
}

Map<String, dynamic> $TrudaAiConfigEntityToJson(TrudaAiConfigEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['loginDelay'] = entity.loginDelay;
	data['floorDiamondsThreshold'] = entity.floorDiamondsThreshold;
	data['floorCallCardThreshold'] = entity.floorCallCardThreshold;
	data['groups'] = entity.groups?.toJson();
	return data;
}

TrudaAiConfigGroups $TrudaAiConfigGroupsFromJson(Map<String, dynamic> json) {
	final TrudaAiConfigGroups trudaAiConfigGroups = TrudaAiConfigGroups();
	final TrudaAiConfigGroupsItem? aibLackBalance = jsonConvert.convert<TrudaAiConfigGroupsItem>(json['AIB_LACK_BALANCE']);
	if (aibLackBalance != null) {
		trudaAiConfigGroups.aibLackBalance = aibLackBalance;
	}
	final TrudaAiConfigGroupsItem? aibPaidLackBalance = jsonConvert.convert<TrudaAiConfigGroupsItem>(json['AIB_PAID_LACK_BALANCE']);
	if (aibPaidLackBalance != null) {
		trudaAiConfigGroups.aibPaidLackBalance = aibPaidLackBalance;
	}
	final TrudaAiConfigGroupsItem? aibEnoughCallCard = jsonConvert.convert<TrudaAiConfigGroupsItem>(json['AIB_ENOUGH_CALL_CARD']);
	if (aibEnoughCallCard != null) {
		trudaAiConfigGroups.aibEnoughCallCard = aibEnoughCallCard;
	}
	final TrudaAiConfigGroupsItem? aibEnoughBalance = jsonConvert.convert<TrudaAiConfigGroupsItem>(json['AIB_ENOUGH_BALANCE']);
	if (aibEnoughBalance != null) {
		trudaAiConfigGroups.aibEnoughBalance = aibEnoughBalance;
	}
	return trudaAiConfigGroups;
}

Map<String, dynamic> $TrudaAiConfigGroupsToJson(TrudaAiConfigGroups entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['AIB_LACK_BALANCE'] = entity.aibLackBalance?.toJson();
	data['AIB_PAID_LACK_BALANCE'] = entity.aibPaidLackBalance?.toJson();
	data['AIB_ENOUGH_CALL_CARD'] = entity.aibEnoughCallCard?.toJson();
	data['AIB_ENOUGH_BALANCE'] = entity.aibEnoughBalance?.toJson();
	return data;
}

TrudaAiConfigGroupsItem $TrudaAiConfigGroupsItemFromJson(Map<String, dynamic> json) {
	final TrudaAiConfigGroupsItem trudaAiConfigGroupsItem = TrudaAiConfigGroupsItem();
	final String? configGroup = jsonConvert.convert<String>(json['configGroup']);
	if (configGroup != null) {
		trudaAiConfigGroupsItem.configGroup = configGroup;
	}
	final int? nextAibTime = jsonConvert.convert<int>(json['nextAibTime']);
	if (nextAibTime != null) {
		trudaAiConfigGroupsItem.nextAibTime = nextAibTime;
	}
	final int? rejectDelay = jsonConvert.convert<int>(json['rejectDelay']);
	if (rejectDelay != null) {
		trudaAiConfigGroupsItem.rejectDelay = rejectDelay;
	}
	final int? sendFlag = jsonConvert.convert<int>(json['sendFlag']);
	if (sendFlag != null) {
		trudaAiConfigGroupsItem.sendFlag = sendFlag;
	}
	final int? minAivDelaySeconds = jsonConvert.convert<int>(json['minAivDelaySeconds']);
	if (minAivDelaySeconds != null) {
		trudaAiConfigGroupsItem.minAivDelaySeconds = minAivDelaySeconds;
	}
	final int? maxAivDelaySeconds = jsonConvert.convert<int>(json['maxAivDelaySeconds']);
	if (maxAivDelaySeconds != null) {
		trudaAiConfigGroupsItem.maxAivDelaySeconds = maxAivDelaySeconds;
	}
	final int? aivSendFlag = jsonConvert.convert<int>(json['aivSendFlag']);
	if (aivSendFlag != null) {
		trudaAiConfigGroupsItem.aivSendFlag = aivSendFlag;
	}
	final int? aivFirstLoginCount = jsonConvert.convert<int>(json['aivFirstLoginCount']);
	if (aivFirstLoginCount != null) {
		trudaAiConfigGroupsItem.aivFirstLoginCount = aivFirstLoginCount;
	}
	final int? aivNextLoginCount = jsonConvert.convert<int>(json['aivNextLoginCount']);
	if (aivNextLoginCount != null) {
		trudaAiConfigGroupsItem.aivNextLoginCount = aivNextLoginCount;
	}
	final int? aivLoginInterval = jsonConvert.convert<int>(json['aivLoginInterval']);
	if (aivLoginInterval != null) {
		trudaAiConfigGroupsItem.aivLoginInterval = aivLoginInterval;
	}
	final int? aivFirstDelay = jsonConvert.convert<int>(json['aivFirstDelay']);
	if (aivFirstDelay != null) {
		trudaAiConfigGroupsItem.aivFirstDelay = aivFirstDelay;
	}
	final int? aivMinFirstLoginSeconds = jsonConvert.convert<int>(json['aivMinFirstLoginSeconds']);
	if (aivMinFirstLoginSeconds != null) {
		trudaAiConfigGroupsItem.aivMinFirstLoginSeconds = aivMinFirstLoginSeconds;
	}
	final int? aivMaxFirstLoginSeconds = jsonConvert.convert<int>(json['aivMaxFirstLoginSeconds']);
	if (aivMaxFirstLoginSeconds != null) {
		trudaAiConfigGroupsItem.aivMaxFirstLoginSeconds = aivMaxFirstLoginSeconds;
	}
	return trudaAiConfigGroupsItem;
}

Map<String, dynamic> $TrudaAiConfigGroupsItemToJson(TrudaAiConfigGroupsItem entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['configGroup'] = entity.configGroup;
	data['nextAibTime'] = entity.nextAibTime;
	data['rejectDelay'] = entity.rejectDelay;
	data['sendFlag'] = entity.sendFlag;
	data['minAivDelaySeconds'] = entity.minAivDelaySeconds;
	data['maxAivDelaySeconds'] = entity.maxAivDelaySeconds;
	data['aivSendFlag'] = entity.aivSendFlag;
	data['aivFirstLoginCount'] = entity.aivFirstLoginCount;
	data['aivNextLoginCount'] = entity.aivNextLoginCount;
	data['aivLoginInterval'] = entity.aivLoginInterval;
	data['aivFirstDelay'] = entity.aivFirstDelay;
	data['aivMinFirstLoginSeconds'] = entity.aivMinFirstLoginSeconds;
	data['aivMaxFirstLoginSeconds'] = entity.aivMaxFirstLoginSeconds;
	return data;
}