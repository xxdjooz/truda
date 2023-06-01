import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_leval_entity.dart';

TrudaLevalBean $TrudaLevalBeanFromJson(Map<String, dynamic> json) {
	final TrudaLevalBean trudaLevalBean = TrudaLevalBean();
	final int? rid = jsonConvert.convert<int>(json['rid']);
	if (rid != null) {
		trudaLevalBean.rid = rid;
	}
	final int? grade = jsonConvert.convert<int>(json['grade']);
	if (grade != null) {
		trudaLevalBean.grade = grade;
	}
	final int? areaCode = jsonConvert.convert<int>(json['areaCode']);
	if (areaCode != null) {
		trudaLevalBean.areaCode = areaCode;
	}
	final int? howExp = jsonConvert.convert<int>(json['howExp']);
	if (howExp != null) {
		trudaLevalBean.howExp = howExp;
	}
	final int? awardType = jsonConvert.convert<int>(json['awardType']);
	if (awardType != null) {
		trudaLevalBean.awardType = awardType;
	}
	final int? awardVal = jsonConvert.convert<int>(json['awardVal']);
	if (awardVal != null) {
		trudaLevalBean.awardVal = awardVal;
	}
	final String? awardName = jsonConvert.convert<String>(json['awardName']);
	if (awardName != null) {
		trudaLevalBean.awardName = awardName;
	}
	final String? awardIcon = jsonConvert.convert<String>(json['awardIcon']);
	if (awardIcon != null) {
		trudaLevalBean.awardIcon = awardIcon;
	}
	final String? awardBackground = jsonConvert.convert<String>(json['awardBackground']);
	if (awardBackground != null) {
		trudaLevalBean.awardBackground = awardBackground;
	}
	return trudaLevalBean;
}

Map<String, dynamic> $TrudaLevalBeanToJson(TrudaLevalBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['rid'] = entity.rid;
	data['grade'] = entity.grade;
	data['areaCode'] = entity.areaCode;
	data['howExp'] = entity.howExp;
	data['awardType'] = entity.awardType;
	data['awardVal'] = entity.awardVal;
	data['awardName'] = entity.awardName;
	data['awardIcon'] = entity.awardIcon;
	data['awardBackground'] = entity.awardBackground;
	return data;
}