import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_hot_entity.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';


TrudaUpListData $TrudaUpListDataFromJson(Map<String, dynamic> json) {
	final TrudaUpListData trudaUpListData = TrudaUpListData();
	final List<TrudaHostDetail>? anchorLists = jsonConvert.convertListNotNull<TrudaHostDetail>(json['anchorLists']);
	if (anchorLists != null) {
		trudaUpListData.anchorLists = anchorLists;
	}
	final List<TrudaAreaData>? areaList = jsonConvert.convertListNotNull<TrudaAreaData>(json['areaList']);
	if (areaList != null) {
		trudaUpListData.areaList = areaList;
	}
	final int? curAreaCode = jsonConvert.convert<int>(json['curAreaCode']);
	if (curAreaCode != null) {
		trudaUpListData.curAreaCode = curAreaCode;
	}
	return trudaUpListData;
}

Map<String, dynamic> $TrudaUpListDataToJson(TrudaUpListData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['anchorLists'] =  entity.anchorLists?.map((v) => v.toJson()).toList();
	data['areaList'] =  entity.areaList?.map((v) => v.toJson()).toList();
	data['curAreaCode'] = entity.curAreaCode;
	return data;
}

TrudaAreaData $TrudaAreaDataFromJson(Map<String, dynamic> json) {
	final TrudaAreaData trudaAreaData = TrudaAreaData();
	final int? canChoose = jsonConvert.convert<int>(json['canChoose']);
	if (canChoose != null) {
		trudaAreaData.canChoose = canChoose;
	}
	final int? areaCode = jsonConvert.convert<int>(json['areaCode']);
	if (areaCode != null) {
		trudaAreaData.areaCode = areaCode;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		trudaAreaData.title = title;
	}
	final String? path = jsonConvert.convert<String>(json['path']);
	if (path != null) {
		trudaAreaData.path = path;
	}
	final int? countryCode = jsonConvert.convert<int>(json['countryCode']);
	if (countryCode != null) {
		trudaAreaData.countryCode = countryCode;
	}
	return trudaAreaData;
}

Map<String, dynamic> $TrudaAreaDataToJson(TrudaAreaData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['canChoose'] = entity.canChoose;
	data['areaCode'] = entity.areaCode;
	data['title'] = entity.title;
	data['path'] = entity.path;
	data['countryCode'] = entity.countryCode;
	return data;
}