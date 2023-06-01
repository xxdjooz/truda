import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_sensitive_word_entity.dart';

TrudaSensitiveWordBean $TrudaSensitiveWordBeanFromJson(Map<String, dynamic> json) {
	final TrudaSensitiveWordBean trudaSensitiveWordBean = TrudaSensitiveWordBean();
	final String? areaCode = jsonConvert.convert<String>(json['areaCode']);
	if (areaCode != null) {
		trudaSensitiveWordBean.areaCode = areaCode;
	}
	final String? words = jsonConvert.convert<String>(json['words']);
	if (words != null) {
		trudaSensitiveWordBean.words = words;
	}
	return trudaSensitiveWordBean;
}

Map<String, dynamic> $TrudaSensitiveWordBeanToJson(TrudaSensitiveWordBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['areaCode'] = entity.areaCode;
	data['words'] = entity.words;
	return data;
}