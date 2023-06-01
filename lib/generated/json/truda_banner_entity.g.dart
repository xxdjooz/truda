import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_banner_entity.dart';

TrudaBannerBean $TrudaBannerBeanFromJson(Map<String, dynamic> json) {
	final TrudaBannerBean trudaBannerBean = TrudaBannerBean();
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaBannerBean.updatedAt = updatedAt;
	}
	final int? category = jsonConvert.convert<int>(json['category']);
	if (category != null) {
		trudaBannerBean.category = category;
	}
	final int? bid = jsonConvert.convert<int>(json['bid']);
	if (bid != null) {
		trudaBannerBean.bid = bid;
	}
	final String? link = jsonConvert.convert<String>(json['link']);
	if (link != null) {
		trudaBannerBean.link = link;
	}
	final int? ranking = jsonConvert.convert<int>(json['ranking']);
	if (ranking != null) {
		trudaBannerBean.ranking = ranking;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		trudaBannerBean.type = type;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		trudaBannerBean.title = title;
	}
	final String? appName = jsonConvert.convert<String>(json['appName']);
	if (appName != null) {
		trudaBannerBean.appName = appName;
	}
	final String? cover = jsonConvert.convert<String>(json['cover']);
	if (cover != null) {
		trudaBannerBean.cover = cover;
	}
	final int? target = jsonConvert.convert<int>(json['target']);
	if (target != null) {
		trudaBannerBean.target = target;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaBannerBean.createdAt = createdAt;
	}
	final int? areaCode = jsonConvert.convert<int>(json['areaCode']);
	if (areaCode != null) {
		trudaBannerBean.areaCode = areaCode;
	}
	return trudaBannerBean;
}

Map<String, dynamic> $TrudaBannerBeanToJson(TrudaBannerBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['updatedAt'] = entity.updatedAt;
	data['category'] = entity.category;
	data['bid'] = entity.bid;
	data['link'] = entity.link;
	data['ranking'] = entity.ranking;
	data['type'] = entity.type;
	data['title'] = entity.title;
	data['appName'] = entity.appName;
	data['cover'] = entity.cover;
	data['target'] = entity.target;
	data['createdAt'] = entity.createdAt;
	data['areaCode'] = entity.areaCode;
	return data;
}