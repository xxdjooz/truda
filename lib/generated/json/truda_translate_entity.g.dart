import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_translate_entity.dart';

TrudaTranslateData $TrudaTranslateDataFromJson(Map<String, dynamic> json) {
	final TrudaTranslateData trudaTranslateData = TrudaTranslateData();
	final String? appChannel = jsonConvert.convert<String>(json['appChannel']);
	if (appChannel != null) {
		trudaTranslateData.appChannel = appChannel;
	}
	final String? appVersion = jsonConvert.convert<String>(json['appVersion']);
	if (appVersion != null) {
		trudaTranslateData.appVersion = appVersion;
	}
	final String? language = jsonConvert.convert<String>(json['language']);
	if (language != null) {
		trudaTranslateData.language = language;
	}
	final int? configVersion = jsonConvert.convert<int>(json['configVersion']);
	if (configVersion != null) {
		trudaTranslateData.configVersion = configVersion;
	}
	final int? appNumber = jsonConvert.convert<int>(json['appNumber']);
	if (appNumber != null) {
		trudaTranslateData.appNumber = appNumber;
	}
	final String? configUrl = jsonConvert.convert<String>(json['configUrl']);
	if (configUrl != null) {
		trudaTranslateData.configUrl = configUrl;
	}
	final List<TrudaTranslateDataConfigs>? configs = jsonConvert.convertListNotNull<TrudaTranslateDataConfigs>(json['configs']);
	if (configs != null) {
		trudaTranslateData.configs = configs;
	}
	return trudaTranslateData;
}

Map<String, dynamic> $TrudaTranslateDataToJson(TrudaTranslateData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['appChannel'] = entity.appChannel;
	data['appVersion'] = entity.appVersion;
	data['language'] = entity.language;
	data['configVersion'] = entity.configVersion;
	data['appNumber'] = entity.appNumber;
	data['configUrl'] = entity.configUrl;
	data['configs'] =  entity.configs?.map((v) => v.toJson()).toList();
	return data;
}

TrudaTranslateDataConfigs $TrudaTranslateDataConfigsFromJson(Map<String, dynamic> json) {
	final TrudaTranslateDataConfigs trudaTranslateDataConfigs = TrudaTranslateDataConfigs();
	final String? configKey = jsonConvert.convert<String>(json['configKey']);
	if (configKey != null) {
		trudaTranslateDataConfigs.configKey = configKey;
	}
	final String? configValue = jsonConvert.convert<String>(json['configValue']);
	if (configValue != null) {
		trudaTranslateDataConfigs.configValue = configValue;
	}
	final String? language = jsonConvert.convert<String>(json['language']);
	if (language != null) {
		trudaTranslateDataConfigs.language = language;
	}
	return trudaTranslateDataConfigs;
}

Map<String, dynamic> $TrudaTranslateDataConfigsToJson(TrudaTranslateDataConfigs entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['configKey'] = entity.configKey;
	data['configValue'] = entity.configValue;
	data['language'] = entity.language;
	return data;
}