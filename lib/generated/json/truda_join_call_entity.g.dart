import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_join_call_entity.dart';

TrudaJoinCall $TrudaJoinCallFromJson(Map<String, dynamic> json) {
	final TrudaJoinCall trudaJoinCall = TrudaJoinCall();
	final String? channelId = jsonConvert.convert<String>(json['channelId']);
	if (channelId != null) {
		trudaJoinCall.channelId = channelId;
	}
	final int? chargePrice = jsonConvert.convert<int>(json['chargePrice']);
	if (chargePrice != null) {
		trudaJoinCall.chargePrice = chargePrice;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		trudaJoinCall.propDuration = propDuration;
	}
	final int? remainDiamonds = jsonConvert.convert<int>(json['remainDiamonds']);
	if (remainDiamonds != null) {
		trudaJoinCall.remainDiamonds = remainDiamonds;
	}
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaJoinCall.extra = extra;
	}
	final bool? usedProp = jsonConvert.convert<bool>(json['usedProp']);
	if (usedProp != null) {
		trudaJoinCall.usedProp = usedProp;
	}
	final bool? newVersion = jsonConvert.convert<bool>(json['newVersion']);
	if (newVersion != null) {
		trudaJoinCall.newVersion = newVersion;
	}
	final String? rtcToken = jsonConvert.convert<String>(json['rtcToken']);
	if (rtcToken != null) {
		trudaJoinCall.rtcToken = rtcToken;
	}
	final int? isShowDiamondRechargeGuide = jsonConvert.convert<int>(json['isShowDiamondRechargeGuide']);
	if (isShowDiamondRechargeGuide != null) {
		trudaJoinCall.isShowDiamondRechargeGuide = isShowDiamondRechargeGuide;
	}
	final int? isShowCardRechargeGuide = jsonConvert.convert<int>(json['isShowCardRechargeGuide']);
	if (isShowCardRechargeGuide != null) {
		trudaJoinCall.isShowCardRechargeGuide = isShowCardRechargeGuide;
	}
	return trudaJoinCall;
}

Map<String, dynamic> $TrudaJoinCallToJson(TrudaJoinCall entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['channelId'] = entity.channelId;
	data['chargePrice'] = entity.chargePrice;
	data['propDuration'] = entity.propDuration;
	data['remainDiamonds'] = entity.remainDiamonds;
	data['extra'] = entity.extra;
	data['usedProp'] = entity.usedProp;
	data['newVersion'] = entity.newVersion;
	data['rtcToken'] = entity.rtcToken;
	data['isShowDiamondRechargeGuide'] = entity.isShowDiamondRechargeGuide;
	data['isShowCardRechargeGuide'] = entity.isShowCardRechargeGuide;
	return data;
}