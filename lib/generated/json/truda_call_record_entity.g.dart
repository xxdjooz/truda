import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_call_record_entity.dart';

TrudaCallRecordEntity $TrudaCallRecordEntityFromJson(Map<String, dynamic> json) {
	final TrudaCallRecordEntity trudaCallRecordEntity = TrudaCallRecordEntity();
	final int? callId = jsonConvert.convert<int>(json['callId']);
	if (callId != null) {
		trudaCallRecordEntity.callId = callId;
	}
	final int? channelId = jsonConvert.convert<int>(json['channelId']);
	if (channelId != null) {
		trudaCallRecordEntity.channelId = channelId;
	}
	final int? currUserId = jsonConvert.convert<int>(json['currUserId']);
	if (currUserId != null) {
		trudaCallRecordEntity.currUserId = currUserId;
	}
	final int? peerUserId = jsonConvert.convert<int>(json['peerUserId']);
	if (peerUserId != null) {
		trudaCallRecordEntity.peerUserId = peerUserId;
	}
	final int? callRole = jsonConvert.convert<int>(json['callRole']);
	if (callRole != null) {
		trudaCallRecordEntity.callRole = callRole;
	}
	final int? chargePrice = jsonConvert.convert<int>(json['chargePrice']);
	if (chargePrice != null) {
		trudaCallRecordEntity.chargePrice = chargePrice;
	}
	final int? chargeCount = jsonConvert.convert<int>(json['chargeCount']);
	if (chargeCount != null) {
		trudaCallRecordEntity.chargeCount = chargeCount;
	}
	final int? endAt = jsonConvert.convert<int>(json['endAt']);
	if (endAt != null) {
		trudaCallRecordEntity.endAt = endAt;
	}
	final int? endType = jsonConvert.convert<int>(json['endType']);
	if (endType != null) {
		trudaCallRecordEntity.endType = endType;
	}
	final int? clientEndAt = jsonConvert.convert<int>(json['clientEndAt']);
	if (clientEndAt != null) {
		trudaCallRecordEntity.clientEndAt = clientEndAt;
	}
	final int? clientDuration = jsonConvert.convert<int>(json['clientDuration']);
	if (clientDuration != null) {
		trudaCallRecordEntity.clientDuration = clientDuration;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaCallRecordEntity.createdAt = createdAt;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaCallRecordEntity.updatedAt = updatedAt;
	}
	final String? currUsername = jsonConvert.convert<String>(json['currUsername']);
	if (currUsername != null) {
		trudaCallRecordEntity.currUsername = currUsername;
	}
	final String? peerUsername = jsonConvert.convert<String>(json['peerUsername']);
	if (peerUsername != null) {
		trudaCallRecordEntity.peerUsername = peerUsername;
	}
	final String? peerNickname = jsonConvert.convert<String>(json['peerNickname']);
	if (peerNickname != null) {
		trudaCallRecordEntity.peerNickname = peerNickname;
	}
	final String? peerPortrait = jsonConvert.convert<String>(json['peerPortrait']);
	if (peerPortrait != null) {
		trudaCallRecordEntity.peerPortrait = peerPortrait;
	}
	final int? channelStatus = jsonConvert.convert<int>(json['channelStatus']);
	if (channelStatus != null) {
		trudaCallRecordEntity.channelStatus = channelStatus;
	}
	final int? startAt = jsonConvert.convert<int>(json['startAt']);
	if (startAt != null) {
		trudaCallRecordEntity.startAt = startAt;
	}
	final int? peerIsOnline = jsonConvert.convert<int>(json['peerIsOnline']);
	if (peerIsOnline != null) {
		trudaCallRecordEntity.peerIsOnline = peerIsOnline;
	}
	final int? peerIsDoNotDisturb = jsonConvert.convert<int>(json['peerIsDoNotDisturb']);
	if (peerIsDoNotDisturb != null) {
		trudaCallRecordEntity.peerIsDoNotDisturb = peerIsDoNotDisturb;
	}
	return trudaCallRecordEntity;
}

Map<String, dynamic> $TrudaCallRecordEntityToJson(TrudaCallRecordEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['callId'] = entity.callId;
	data['channelId'] = entity.channelId;
	data['currUserId'] = entity.currUserId;
	data['peerUserId'] = entity.peerUserId;
	data['callRole'] = entity.callRole;
	data['chargePrice'] = entity.chargePrice;
	data['chargeCount'] = entity.chargeCount;
	data['endAt'] = entity.endAt;
	data['endType'] = entity.endType;
	data['clientEndAt'] = entity.clientEndAt;
	data['clientDuration'] = entity.clientDuration;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['currUsername'] = entity.currUsername;
	data['peerUsername'] = entity.peerUsername;
	data['peerNickname'] = entity.peerNickname;
	data['peerPortrait'] = entity.peerPortrait;
	data['channelStatus'] = entity.channelStatus;
	data['startAt'] = entity.startAt;
	data['peerIsOnline'] = entity.peerIsOnline;
	data['peerIsDoNotDisturb'] = entity.peerIsDoNotDisturb;
	return data;
}