import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_info_entity.dart';

TrudaInfoDetail $TrudaInfoDetailFromJson(Map<String, dynamic> json) {
	final TrudaInfoDetail trudaInfoDetail = TrudaInfoDetail();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaInfoDetail.userId = userId;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		trudaInfoDetail.username = username;
	}
	final int? auth = jsonConvert.convert<int>(json['auth']);
	if (auth != null) {
		trudaInfoDetail.auth = auth;
	}
	final String? intro = jsonConvert.convert<String>(json['intro']);
	if (intro != null) {
		trudaInfoDetail.intro = intro;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaInfoDetail.portrait = portrait;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaInfoDetail.nickname = nickname;
	}
	final int? areaCode = jsonConvert.convert<int>(json['areaCode']);
	if (areaCode != null) {
		trudaInfoDetail.areaCode = areaCode;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		trudaInfoDetail.status = status;
	}
	final int? isDoNotDisturb = jsonConvert.convert<int>(json['isDoNotDisturb']);
	if (isDoNotDisturb != null) {
		trudaInfoDetail.isDoNotDisturb = isDoNotDisturb;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaInfoDetail.createdAt = createdAt;
	}
	final int? created = jsonConvert.convert<int>(json['created']);
	if (created != null) {
		trudaInfoDetail.created = created;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaInfoDetail.isOnline = isOnline;
	}
	final int? isSignIn = jsonConvert.convert<int>(json['isSignIn']);
	if (isSignIn != null) {
		trudaInfoDetail.isSignIn = isSignIn;
	}
	final int? propCount = jsonConvert.convert<int>(json['propCount']);
	if (propCount != null) {
		trudaInfoDetail.propCount = propCount;
	}
	final int? callCardCount = jsonConvert.convert<int>(json['callCardCount']);
	if (callCardCount != null) {
		trudaInfoDetail.callCardCount = callCardCount;
	}
	final int? callCardUsedCount = jsonConvert.convert<int>(json['callCardUsedCount']);
	if (callCardUsedCount != null) {
		trudaInfoDetail.callCardUsedCount = callCardUsedCount;
	}
	final int? callCardDuration = jsonConvert.convert<int>(json['callCardDuration']);
	if (callCardDuration != null) {
		trudaInfoDetail.callCardDuration = callCardDuration;
	}
	final int? releaseTime = jsonConvert.convert<int>(json['releaseTime']);
	if (releaseTime != null) {
		trudaInfoDetail.releaseTime = releaseTime;
	}
	final int? gender = jsonConvert.convert<int>(json['gender']);
	if (gender != null) {
		trudaInfoDetail.gender = gender;
	}
	final int? country = jsonConvert.convert<int>(json['country']);
	if (country != null) {
		trudaInfoDetail.country = country;
	}
	final int? connectRate = jsonConvert.convert<int>(json['connectRate']);
	if (connectRate != null) {
		trudaInfoDetail.connectRate = connectRate;
	}
	final int? birthday = jsonConvert.convert<int>(json['birthday']);
	if (birthday != null) {
		trudaInfoDetail.birthday = birthday;
	}
	final int? expLevel = jsonConvert.convert<int>(json['expLevel']);
	if (expLevel != null) {
		trudaInfoDetail.expLevel = expLevel;
	}
	final TrudaBalanceBean? userBalance = jsonConvert.convert<TrudaBalanceBean>(json['userBalance']);
	if (userBalance != null) {
		trudaInfoDetail.userBalance = userBalance;
	}
	final String? startBirthday = jsonConvert.convert<String>(json['startBirthday']);
	if (startBirthday != null) {
		trudaInfoDetail.startBirthday = startBirthday;
	}
	final bool? timeBirthday = jsonConvert.convert<bool>(json['timeBirthday']);
	if (timeBirthday != null) {
		trudaInfoDetail.timeBirthday = timeBirthday;
	}
	final int? stateGender = jsonConvert.convert<int>(json['stateGender']);
	if (stateGender != null) {
		trudaInfoDetail.stateGender = stateGender;
	}
	final int? isVip = jsonConvert.convert<int>(json['isVip']);
	if (isVip != null) {
		trudaInfoDetail.isVip = isVip;
	}
	final int? vipSignIn = jsonConvert.convert<int>(json['vipSignIn']);
	if (vipSignIn != null) {
		trudaInfoDetail.vipSignIn = vipSignIn;
	}
	final int? vipEndTime = jsonConvert.convert<int>(json['vipEndTime']);
	if (vipEndTime != null) {
		trudaInfoDetail.vipEndTime = vipEndTime;
	}
	final int? vipSupport = jsonConvert.convert<int>(json['vipSupport']);
	if (vipSupport != null) {
		trudaInfoDetail.vipSupport = vipSupport;
	}
	final int? begging = jsonConvert.convert<int>(json['begging']);
	if (begging != null) {
		trudaInfoDetail.begging = begging;
	}
	final int? rechargeDrawCount = jsonConvert.convert<int>(json['rechargeDrawCount']);
	if (rechargeDrawCount != null) {
		trudaInfoDetail.rechargeDrawCount = rechargeDrawCount;
	}
	final String? inviterCode = jsonConvert.convert<String>(json['inviterCode']);
	if (inviterCode != null) {
		trudaInfoDetail.inviterCode = inviterCode;
	}
	final int? boundGoogle = jsonConvert.convert<int>(json['boundGoogle']);
	if (boundGoogle != null) {
		trudaInfoDetail.boundGoogle = boundGoogle;
	}
	return trudaInfoDetail;
}

Map<String, dynamic> $TrudaInfoDetailToJson(TrudaInfoDetail entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['username'] = entity.username;
	data['auth'] = entity.auth;
	data['intro'] = entity.intro;
	data['portrait'] = entity.portrait;
	data['nickname'] = entity.nickname;
	data['areaCode'] = entity.areaCode;
	data['status'] = entity.status;
	data['isDoNotDisturb'] = entity.isDoNotDisturb;
	data['createdAt'] = entity.createdAt;
	data['created'] = entity.created;
	data['isOnline'] = entity.isOnline;
	data['isSignIn'] = entity.isSignIn;
	data['propCount'] = entity.propCount;
	data['callCardCount'] = entity.callCardCount;
	data['callCardUsedCount'] = entity.callCardUsedCount;
	data['callCardDuration'] = entity.callCardDuration;
	data['releaseTime'] = entity.releaseTime;
	data['gender'] = entity.gender;
	data['country'] = entity.country;
	data['connectRate'] = entity.connectRate;
	data['birthday'] = entity.birthday;
	data['expLevel'] = entity.expLevel;
	data['userBalance'] = entity.userBalance?.toJson();
	data['startBirthday'] = entity.startBirthday;
	data['timeBirthday'] = entity.timeBirthday;
	data['stateGender'] = entity.stateGender;
	data['isVip'] = entity.isVip;
	data['vipSignIn'] = entity.vipSignIn;
	data['vipEndTime'] = entity.vipEndTime;
	data['vipSupport'] = entity.vipSupport;
	data['begging'] = entity.begging;
	data['rechargeDrawCount'] = entity.rechargeDrawCount;
	data['inviterCode'] = entity.inviterCode;
	data['boundGoogle'] = entity.boundGoogle;
	return data;
}

TrudaBalanceBean $TrudaBalanceBeanFromJson(Map<String, dynamic> json) {
	final TrudaBalanceBean trudaBalanceBean = TrudaBalanceBean();
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		trudaBalanceBean.userId = userId;
	}
	final int? totalRecharge = jsonConvert.convert<int>(json['totalRecharge']);
	if (totalRecharge != null) {
		trudaBalanceBean.totalRecharge = totalRecharge;
	}
	final int? totalDiamonds = jsonConvert.convert<int>(json['totalDiamonds']);
	if (totalDiamonds != null) {
		trudaBalanceBean.totalDiamonds = totalDiamonds;
	}
	final int? remainDiamonds = jsonConvert.convert<int>(json['remainDiamonds']);
	if (remainDiamonds != null) {
		trudaBalanceBean.remainDiamonds = remainDiamonds;
	}
	final int? freeDiamonds = jsonConvert.convert<int>(json['freeDiamonds']);
	if (freeDiamonds != null) {
		trudaBalanceBean.freeDiamonds = freeDiamonds;
	}
	final int? freeMsgCount = jsonConvert.convert<int>(json['freeMsgCount']);
	if (freeMsgCount != null) {
		trudaBalanceBean.freeMsgCount = freeMsgCount;
	}
	final int? expLevel = jsonConvert.convert<int>(json['expLevel']);
	if (expLevel != null) {
		trudaBalanceBean.expLevel = expLevel;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaBalanceBean.createdAt = createdAt;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaBalanceBean.updatedAt = updatedAt;
	}
	return trudaBalanceBean;
}

Map<String, dynamic> $TrudaBalanceBeanToJson(TrudaBalanceBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['totalRecharge'] = entity.totalRecharge;
	data['totalDiamonds'] = entity.totalDiamonds;
	data['remainDiamonds'] = entity.remainDiamonds;
	data['freeDiamonds'] = entity.freeDiamonds;
	data['freeMsgCount'] = entity.freeMsgCount;
	data['expLevel'] = entity.expLevel;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}