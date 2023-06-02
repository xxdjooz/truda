import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_utils/ad/truda_ads_spots_entity.dart';

TrudaAdsSpotsEntity $TrudaAdsSpotsEntityFromJson(Map<String, dynamic> json) {
	final TrudaAdsSpotsEntity trudaAdsSpotsEntity = TrudaAdsSpotsEntity();
	final String? adId = jsonConvert.convert<String>(json['adId']);
	if (adId != null) {
		trudaAdsSpotsEntity.adId = adId;
	}
	final String? adTitle = jsonConvert.convert<String>(json['adTitle']);
	if (adTitle != null) {
		trudaAdsSpotsEntity.adTitle = adTitle;
	}
	final String? keyCode = jsonConvert.convert<String>(json['keyCode']);
	if (keyCode != null) {
		trudaAdsSpotsEntity.keyCode = keyCode;
	}
	final String? adCode = jsonConvert.convert<String>(json['adCode']);
	if (adCode != null) {
		trudaAdsSpotsEntity.adCode = adCode;
	}
	final int? adType = jsonConvert.convert<int>(json['adType']);
	if (adType != null) {
		trudaAdsSpotsEntity.adType = adType;
	}
	final int? adStatus = jsonConvert.convert<int>(json['adStatus']);
	if (adStatus != null) {
		trudaAdsSpotsEntity.adStatus = adStatus;
	}
	final int? adPosition = jsonConvert.convert<int>(json['adPosition']);
	if (adPosition != null) {
		trudaAdsSpotsEntity.adPosition = adPosition;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		trudaAdsSpotsEntity.diamonds = diamonds;
	}
	return trudaAdsSpotsEntity;
}

Map<String, dynamic> $TrudaAdsSpotsEntityToJson(TrudaAdsSpotsEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['adId'] = entity.adId;
	data['adTitle'] = entity.adTitle;
	data['keyCode'] = entity.keyCode;
	data['adCode'] = entity.adCode;
	data['adType'] = entity.adType;
	data['adStatus'] = entity.adStatus;
	data['adPosition'] = entity.adPosition;
	data['diamonds'] = entity.diamonds;
	return data;
}