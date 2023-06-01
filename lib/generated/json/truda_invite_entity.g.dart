import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_invite_entity.dart';

TrudaInviteBean $TrudaInviteBeanFromJson(Map<String, dynamic> json) {
	final TrudaInviteBean trudaInviteBean = TrudaInviteBean();
	final String? inviteCode = jsonConvert.convert<String>(json['inviteCode']);
	if (inviteCode != null) {
		trudaInviteBean.inviteCode = inviteCode;
	}
	final int? inviteCount = jsonConvert.convert<int>(json['inviteCount']);
	if (inviteCount != null) {
		trudaInviteBean.inviteCount = inviteCount;
	}
	final int? awardIncome = jsonConvert.convert<int>(json['awardIncome']);
	if (awardIncome != null) {
		trudaInviteBean.awardIncome = awardIncome;
	}
	final int? inviteAward = jsonConvert.convert<int>(json['inviteAward']);
	if (inviteAward != null) {
		trudaInviteBean.inviteAward = inviteAward;
	}
	final int? rechargeAward = jsonConvert.convert<int>(json['rechargeAward']);
	if (rechargeAward != null) {
		trudaInviteBean.rechargeAward = rechargeAward;
	}
	final int? inviteeCardCount = jsonConvert.convert<int>(json['inviteeCardCount']);
	if (inviteeCardCount != null) {
		trudaInviteBean.inviteeCardCount = inviteeCardCount;
	}
	final String? shareContent = jsonConvert.convert<String>(json['shareContent']);
	if (shareContent != null) {
		trudaInviteBean.shareContent = shareContent;
	}
	final String? shareUrl = jsonConvert.convert<String>(json['shareUrl']);
	if (shareUrl != null) {
		trudaInviteBean.shareUrl = shareUrl;
	}
	final List<String>? portraits = jsonConvert.convertListNotNull<String>(json['portraits']);
	if (portraits != null) {
		trudaInviteBean.portraits = portraits;
	}
	return trudaInviteBean;
}

Map<String, dynamic> $TrudaInviteBeanToJson(TrudaInviteBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['inviteCode'] = entity.inviteCode;
	data['inviteCount'] = entity.inviteCount;
	data['awardIncome'] = entity.awardIncome;
	data['inviteAward'] = entity.inviteAward;
	data['rechargeAward'] = entity.rechargeAward;
	data['inviteeCardCount'] = entity.inviteeCardCount;
	data['shareContent'] = entity.shareContent;
	data['shareUrl'] = entity.shareUrl;
	data['portraits'] =  entity.portraits;
	return data;
}