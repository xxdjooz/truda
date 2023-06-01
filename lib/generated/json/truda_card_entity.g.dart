import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_card_entity.dart';

TrudaCardBean $TrudaCardBeanFromJson(Map<String, dynamic> json) {
	final TrudaCardBean trudaCardBean = TrudaCardBean();
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		trudaCardBean.userId = userId;
	}
	final int? propType = jsonConvert.convert<int>(json['propType']);
	if (propType != null) {
		trudaCardBean.propType = propType;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		trudaCardBean.propDuration = propDuration;
	}
	final int? propNum = jsonConvert.convert<int>(json['propNum']);
	if (propNum != null) {
		trudaCardBean.propNum = propNum;
	}
	return trudaCardBean;
}

Map<String, dynamic> $TrudaCardBeanToJson(TrudaCardBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['propType'] = entity.propType;
	data['propDuration'] = entity.propDuration;
	data['propNum'] = entity.propNum;
	return data;
}