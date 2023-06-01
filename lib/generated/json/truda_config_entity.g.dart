import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_config_entity.dart';

TrudaConfigData $TrudaConfigDataFromJson(Map<String, dynamic> json) {
	final TrudaConfigData trudaConfigData = TrudaConfigData();
	final String? aiHelp = jsonConvert.convert<String>(json['aiHelp']);
	if (aiHelp != null) {
		trudaConfigData.aiHelp = aiHelp;
	}
	final int? sendMsgDiamondsPrice = jsonConvert.convert<int>(json['sendMsgDiamondsPrice']);
	if (sendMsgDiamondsPrice != null) {
		trudaConfigData.sendMsgDiamondsPrice = sendMsgDiamondsPrice;
	}
	final String? appStoreWriteLink = jsonConvert.convert<String>(json['appStoreWriteLink']);
	if (appStoreWriteLink != null) {
		trudaConfigData.appStoreWriteLink = appStoreWriteLink;
	}
	final int? freeMessageCount = jsonConvert.convert<int>(json['free_message_count']);
	if (freeMessageCount != null) {
		trudaConfigData.freeMessageCount = freeMessageCount;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		trudaConfigData.email = email;
	}
	final String? promotionTime = jsonConvert.convert<String>(json['promotionTime']);
	if (promotionTime != null) {
		trudaConfigData.promotionTime = promotionTime;
	}
	final String? whatsapp = jsonConvert.convert<String>(json['whatsapp']);
	if (whatsapp != null) {
		trudaConfigData.whatsapp = whatsapp;
	}
	final String? agoraAppId = jsonConvert.convert<String>(json['agoraAppId']);
	if (agoraAppId != null) {
		trudaConfigData.agoraAppId = agoraAppId;
	}
	final int? chargePrice = jsonConvert.convert<int>(json['chargePrice']);
	if (chargePrice != null) {
		trudaConfigData.chargePrice = chargePrice;
	}
	final bool? stopFbPurchase = jsonConvert.convert<bool>(json['stopFbPurchase']);
	if (stopFbPurchase != null) {
		trudaConfigData.stopFbPurchase = stopFbPurchase;
	}
	final bool? showFbLogin = jsonConvert.convert<bool>(json['showFbLogin']);
	if (showFbLogin != null) {
		trudaConfigData.showFbLogin = showFbLogin;
	}
	final String? fbPermission = jsonConvert.convert<String>(json['fbPermission']);
	if (fbPermission != null) {
		trudaConfigData.fbPermission = fbPermission;
	}
	final String? scale = jsonConvert.convert<String>(json['scale']);
	if (scale != null) {
		trudaConfigData.scale = scale;
	}
	final String? payScale = jsonConvert.convert<String>(json['payScale']);
	if (payScale != null) {
		trudaConfigData.payScale = payScale;
	}
	final String? adjust = jsonConvert.convert<String>(json['adjust']);
	if (adjust != null) {
		trudaConfigData.adjust = adjust;
	}
	final String? publicKey = jsonConvert.convert<String>(json['publicKey']);
	if (publicKey != null) {
		trudaConfigData.publicKey = publicKey;
	}
	final String? leveldetailurl = jsonConvert.convert<String>(json['leveldetailurl']);
	if (leveldetailurl != null) {
		trudaConfigData.leveldetailurl = leveldetailurl;
	}
	final String? discountvideourl = jsonConvert.convert<String>(json['discountvideourl']);
	if (discountvideourl != null) {
		trudaConfigData.discountvideourl = discountvideourl;
	}
	final String? appUpdate = jsonConvert.convert<String>(json['appUpdate']);
	if (appUpdate != null) {
		trudaConfigData.appUpdate = appUpdate;
	}
	final int? vipDailyDiamonds = jsonConvert.convert<int>(json['vipDailyDiamonds']);
	if (vipDailyDiamonds != null) {
		trudaConfigData.vipDailyDiamonds = vipDailyDiamonds;
	}
	final int? matchTimes = jsonConvert.convert<int>(json['matchTimes']);
	if (matchTimes != null) {
		trudaConfigData.matchTimes = matchTimes;
	}
	return trudaConfigData;
}

Map<String, dynamic> $TrudaConfigDataToJson(TrudaConfigData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['aiHelp'] = entity.aiHelp;
	data['sendMsgDiamondsPrice'] = entity.sendMsgDiamondsPrice;
	data['appStoreWriteLink'] = entity.appStoreWriteLink;
	data['free_message_count'] = entity.freeMessageCount;
	data['email'] = entity.email;
	data['promotionTime'] = entity.promotionTime;
	data['whatsapp'] = entity.whatsapp;
	data['agoraAppId'] = entity.agoraAppId;
	data['chargePrice'] = entity.chargePrice;
	data['stopFbPurchase'] = entity.stopFbPurchase;
	data['showFbLogin'] = entity.showFbLogin;
	data['fbPermission'] = entity.fbPermission;
	data['scale'] = entity.scale;
	data['payScale'] = entity.payScale;
	data['adjust'] = entity.adjust;
	data['publicKey'] = entity.publicKey;
	data['leveldetailurl'] = entity.leveldetailurl;
	data['discountvideourl'] = entity.discountvideourl;
	data['appUpdate'] = entity.appUpdate;
	data['vipDailyDiamonds'] = entity.vipDailyDiamonds;
	data['matchTimes'] = entity.matchTimes;
	return data;
}

TrudaAppUpdate $TrudaAppUpdateFromJson(Map<String, dynamic> json) {
	final TrudaAppUpdate trudaAppUpdate = TrudaAppUpdate();
	final bool? isShow = jsonConvert.convert<bool>(json['isShow']);
	if (isShow != null) {
		trudaAppUpdate.isShow = isShow;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		trudaAppUpdate.type = type;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		trudaAppUpdate.title = title;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		trudaAppUpdate.content = content;
	}
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		trudaAppUpdate.url = url;
	}
	return trudaAppUpdate;
}

Map<String, dynamic> $TrudaAppUpdateToJson(TrudaAppUpdate entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['isShow'] = entity.isShow;
	data['type'] = entity.type;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['url'] = entity.url;
	return data;
}

TrudaPayScale $TrudaPayScaleFromJson(Map<String, dynamic> json) {
	final TrudaPayScale trudaPayScale = TrudaPayScale();
	final double? adjustScale = jsonConvert.convert<double>(json['adjustScale']);
	if (adjustScale != null) {
		trudaPayScale.adjustScale = adjustScale;
	}
	final double? facebookScale = jsonConvert.convert<double>(json['facebookScale']);
	if (facebookScale != null) {
		trudaPayScale.facebookScale = facebookScale;
	}
	final double? defaultScale = jsonConvert.convert<double>(json['defaultScale']);
	if (defaultScale != null) {
		trudaPayScale.defaultScale = defaultScale;
	}
	return trudaPayScale;
}

Map<String, dynamic> $TrudaPayScaleToJson(TrudaPayScale entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['adjustScale'] = entity.adjustScale;
	data['facebookScale'] = entity.facebookScale;
	data['defaultScale'] = entity.defaultScale;
	return data;
}