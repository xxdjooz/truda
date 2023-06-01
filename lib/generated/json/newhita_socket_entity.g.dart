import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_socket/newhita_socket_entity.dart';

NewHitaSocketEntity $NewHitaSocketEntityFromJson(Map<String, dynamic> json) {
	final NewHitaSocketEntity newHitaSocketEntity = NewHitaSocketEntity();
	final String? data = jsonConvert.convert<String>(json['data']);
	if (data != null) {
		newHitaSocketEntity.data = data;
	}
	final int? timestamp = jsonConvert.convert<int>(json['timestamp']);
	if (timestamp != null) {
		newHitaSocketEntity.timestamp = timestamp;
	}
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		newHitaSocketEntity.userId = userId;
	}
	final String? optType = jsonConvert.convert<String>(json['optType']);
	if (optType != null) {
		newHitaSocketEntity.optType = optType;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		newHitaSocketEntity.remark = remark;
	}
	return newHitaSocketEntity;
}

Map<String, dynamic> $NewHitaSocketEntityToJson(NewHitaSocketEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] = entity.data;
	data['timestamp'] = entity.timestamp;
	data['userId'] = entity.userId;
	data['optType'] = entity.optType;
	data['remark'] = entity.remark;
	return data;
}

NewHitaSocketHostState $NewHitaSocketHostStateFromJson(Map<String, dynamic> json) {
	final NewHitaSocketHostState newHitaSocketHostState = NewHitaSocketHostState();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		newHitaSocketHostState.userId = userId;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		newHitaSocketHostState.isOnline = isOnline;
	}
	final int? isDoNotDisturb = jsonConvert.convert<int>(json['isDoNotDisturb']);
	if (isDoNotDisturb != null) {
		newHitaSocketHostState.isDoNotDisturb = isDoNotDisturb;
	}
	return newHitaSocketHostState;
}

Map<String, dynamic> $NewHitaSocketHostStateToJson(NewHitaSocketHostState entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['isOnline'] = entity.isOnline;
	data['isDoNotDisturb'] = entity.isDoNotDisturb;
	return data;
}

NewHitaSocketBalance $NewHitaSocketBalanceFromJson(Map<String, dynamic> json) {
	final NewHitaSocketBalance newHitaSocketBalance = NewHitaSocketBalance();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		newHitaSocketBalance.userId = userId;
	}
	final int? depletionType = jsonConvert.convert<int>(json['depletionType']);
	if (depletionType != null) {
		newHitaSocketBalance.depletionType = depletionType;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		newHitaSocketBalance.diamonds = diamonds;
	}
	final int? expLevel = jsonConvert.convert<int>(json['expLevel']);
	if (expLevel != null) {
		newHitaSocketBalance.expLevel = expLevel;
	}
	final int? callDuration = jsonConvert.convert<int>(json['callDuration']);
	if (callDuration != null) {
		newHitaSocketBalance.callDuration = callDuration;
	}
	final String? inviterCode = jsonConvert.convert<String>(json['inviterCode']);
	if (inviterCode != null) {
		newHitaSocketBalance.inviterCode = inviterCode;
	}
	return newHitaSocketBalance;
}

Map<String, dynamic> $NewHitaSocketBalanceToJson(NewHitaSocketBalance entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['depletionType'] = entity.depletionType;
	data['diamonds'] = entity.diamonds;
	data['expLevel'] = entity.expLevel;
	data['callDuration'] = entity.callDuration;
	data['inviterCode'] = entity.inviterCode;
	return data;
}