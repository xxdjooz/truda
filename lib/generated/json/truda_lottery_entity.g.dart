import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_lottery_entity.dart';

TrudaLotteryBean $TrudaLotteryBeanFromJson(Map<String, dynamic> json) {
	final TrudaLotteryBean trudaLotteryBean = TrudaLotteryBean();
	final int? configId = jsonConvert.convert<int>(json['configId']);
	if (configId != null) {
		trudaLotteryBean.configId = configId;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		trudaLotteryBean.name = name;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		trudaLotteryBean.icon = icon;
	}
	final int? areaCode = jsonConvert.convert<int>(json['areaCode']);
	if (areaCode != null) {
		trudaLotteryBean.areaCode = areaCode;
	}
	final int? probability = jsonConvert.convert<int>(json['probability']);
	if (probability != null) {
		trudaLotteryBean.probability = probability;
	}
	final int? drawMode = jsonConvert.convert<int>(json['drawMode']);
	if (drawMode != null) {
		trudaLotteryBean.drawMode = drawMode;
	}
	final int? drawType = jsonConvert.convert<int>(json['drawType']);
	if (drawType != null) {
		trudaLotteryBean.drawType = drawType;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		trudaLotteryBean.value = value;
	}
	return trudaLotteryBean;
}

Map<String, dynamic> $TrudaLotteryBeanToJson(TrudaLotteryBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['configId'] = entity.configId;
	data['name'] = entity.name;
	data['icon'] = entity.icon;
	data['areaCode'] = entity.areaCode;
	data['probability'] = entity.probability;
	data['drawMode'] = entity.drawMode;
	data['drawType'] = entity.drawType;
	data['value'] = entity.value;
	return data;
}