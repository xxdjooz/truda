import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_oss_entity.dart';

TrudaOssConfig $TrudaOssConfigFromJson(Map<String, dynamic> json) {
	final TrudaOssConfig trudaOssConfig = TrudaOssConfig();
	final String? endpoint = jsonConvert.convert<String>(json['endpoint']);
	if (endpoint != null) {
		trudaOssConfig.endpoint = endpoint;
	}
	final String? bucket = jsonConvert.convert<String>(json['bucket']);
	if (bucket != null) {
		trudaOssConfig.bucket = bucket;
	}
	final String? path = jsonConvert.convert<String>(json['path']);
	if (path != null) {
		trudaOssConfig.path = path;
	}
	final String? key = jsonConvert.convert<String>(json['key']);
	if (key != null) {
		trudaOssConfig.key = key;
	}
	final String? secret = jsonConvert.convert<String>(json['secret']);
	if (secret != null) {
		trudaOssConfig.secret = secret;
	}
	final String? token = jsonConvert.convert<String>(json['token']);
	if (token != null) {
		trudaOssConfig.token = token;
	}
	final int? expire = jsonConvert.convert<int>(json['expire']);
	if (expire != null) {
		trudaOssConfig.expire = expire;
	}
	return trudaOssConfig;
}

Map<String, dynamic> $TrudaOssConfigToJson(TrudaOssConfig entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['endpoint'] = entity.endpoint;
	data['bucket'] = entity.bucket;
	data['path'] = entity.path;
	data['key'] = entity.key;
	data['secret'] = entity.secret;
	data['token'] = entity.token;
	data['expire'] = entity.expire;
	return data;
}