import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_socket/truda_socket_entity.dart';

TrudaSocketEntity $TrudaSocketEntityFromJson(Map<String, dynamic> json) {
	final TrudaSocketEntity trudaSocketEntity = TrudaSocketEntity();
	final String? data = jsonConvert.convert<String>(json['data']);
	if (data != null) {
		trudaSocketEntity.data = data;
	}
	final int? timestamp = jsonConvert.convert<int>(json['timestamp']);
	if (timestamp != null) {
		trudaSocketEntity.timestamp = timestamp;
	}
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		trudaSocketEntity.userId = userId;
	}
	final String? optType = jsonConvert.convert<String>(json['optType']);
	if (optType != null) {
		trudaSocketEntity.optType = optType;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		trudaSocketEntity.remark = remark;
	}
	return trudaSocketEntity;
}

Map<String, dynamic> $TrudaSocketEntityToJson(TrudaSocketEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] = entity.data;
	data['timestamp'] = entity.timestamp;
	data['userId'] = entity.userId;
	data['optType'] = entity.optType;
	data['remark'] = entity.remark;
	return data;
}

TrudaSocketHostState $TrudaSocketHostStateFromJson(Map<String, dynamic> json) {
	final TrudaSocketHostState trudaSocketHostState = TrudaSocketHostState();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaSocketHostState.userId = userId;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaSocketHostState.isOnline = isOnline;
	}
	final int? isDoNotDisturb = jsonConvert.convert<int>(json['isDoNotDisturb']);
	if (isDoNotDisturb != null) {
		trudaSocketHostState.isDoNotDisturb = isDoNotDisturb;
	}
	return trudaSocketHostState;
}

Map<String, dynamic> $TrudaSocketHostStateToJson(TrudaSocketHostState entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['isOnline'] = entity.isOnline;
	data['isDoNotDisturb'] = entity.isDoNotDisturb;
	return data;
}

TrudaSocketBalance $TrudaSocketBalanceFromJson(Map<String, dynamic> json) {
	final TrudaSocketBalance trudaSocketBalance = TrudaSocketBalance();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaSocketBalance.userId = userId;
	}
	final int? depletionType = jsonConvert.convert<int>(json['depletionType']);
	if (depletionType != null) {
		trudaSocketBalance.depletionType = depletionType;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		trudaSocketBalance.diamonds = diamonds;
	}
	final int? expLevel = jsonConvert.convert<int>(json['expLevel']);
	if (expLevel != null) {
		trudaSocketBalance.expLevel = expLevel;
	}
	final int? callDuration = jsonConvert.convert<int>(json['callDuration']);
	if (callDuration != null) {
		trudaSocketBalance.callDuration = callDuration;
	}
	final String? inviterCode = jsonConvert.convert<String>(json['inviterCode']);
	if (inviterCode != null) {
		trudaSocketBalance.inviterCode = inviterCode;
	}
	return trudaSocketBalance;
}

Map<String, dynamic> $TrudaSocketBalanceToJson(TrudaSocketBalance entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['depletionType'] = entity.depletionType;
	data['diamonds'] = entity.diamonds;
	data['expLevel'] = entity.expLevel;
	data['callDuration'] = entity.callDuration;
	data['inviterCode'] = entity.inviterCode;
	return data;
}