import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_utils/ad/newhita_ads_spots_entity.dart';

NewHitaAdsSpotsEntity $NewHitaAdsSpotsEntityFromJson(Map<String, dynamic> json) {
	final NewHitaAdsSpotsEntity newHitaAdsSpotsEntity = NewHitaAdsSpotsEntity();
	final String? adId = jsonConvert.convert<String>(json['adId']);
	if (adId != null) {
		newHitaAdsSpotsEntity.adId = adId;
	}
	final String? adTitle = jsonConvert.convert<String>(json['adTitle']);
	if (adTitle != null) {
		newHitaAdsSpotsEntity.adTitle = adTitle;
	}
	final String? keyCode = jsonConvert.convert<String>(json['keyCode']);
	if (keyCode != null) {
		newHitaAdsSpotsEntity.keyCode = keyCode;
	}
	final String? adCode = jsonConvert.convert<String>(json['adCode']);
	if (adCode != null) {
		newHitaAdsSpotsEntity.adCode = adCode;
	}
	final int? adType = jsonConvert.convert<int>(json['adType']);
	if (adType != null) {
		newHitaAdsSpotsEntity.adType = adType;
	}
	final int? adStatus = jsonConvert.convert<int>(json['adStatus']);
	if (adStatus != null) {
		newHitaAdsSpotsEntity.adStatus = adStatus;
	}
	final int? adPosition = jsonConvert.convert<int>(json['adPosition']);
	if (adPosition != null) {
		newHitaAdsSpotsEntity.adPosition = adPosition;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		newHitaAdsSpotsEntity.diamonds = diamonds;
	}
	return newHitaAdsSpotsEntity;
}

Map<String, dynamic> $NewHitaAdsSpotsEntityToJson(NewHitaAdsSpotsEntity entity) {
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