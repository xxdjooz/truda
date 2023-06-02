import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_entity.dart';

TrudaRTMText $TrudaRTMTextFromJson(Map<String, dynamic> json) {
	final TrudaRTMText trudaRTMText = TrudaRTMText();
	final int? destructTime = jsonConvert.convert<int>(json['destructTime']);
	if (destructTime != null) {
		trudaRTMText.destructTime = destructTime;
	}
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMText.extra = extra;
	}
	final String? messageContent = jsonConvert.convert<String>(json['messageContent']);
	if (messageContent != null) {
		trudaRTMText.messageContent = messageContent;
	}
	final String? msgId = jsonConvert.convert<String>(json['msgId']);
	if (msgId != null) {
		trudaRTMText.msgId = msgId;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		trudaRTMText.type = type;
	}
	final TrudaRTMUser? userInfo = jsonConvert.convert<TrudaRTMUser>(json['userInfo']);
	if (userInfo != null) {
		trudaRTMText.userInfo = userInfo;
	}
	return trudaRTMText;
}

Map<String, dynamic> $TrudaRTMTextToJson(TrudaRTMText entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['destructTime'] = entity.destructTime;
	data['extra'] = entity.extra;
	data['messageContent'] = entity.messageContent;
	data['msgId'] = entity.msgId;
	data['type'] = entity.type;
	data['userInfo'] = entity.userInfo?.toJson();
	return data;
}

TrudaRTMUser $TrudaRTMUserFromJson(Map<String, dynamic> json) {
	final TrudaRTMUser trudaRTMUser = TrudaRTMUser();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		trudaRTMUser.name = name;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaRTMUser.portrait = portrait;
	}
	final String? uid = jsonConvert.convert<String>(json['uid']);
	if (uid != null) {
		trudaRTMUser.uid = uid;
	}
	final String? virtualId = jsonConvert.convert<String>(json['virtualId']);
	if (virtualId != null) {
		trudaRTMUser.virtualId = virtualId;
	}
	final int? auth = jsonConvert.convert<int>(json['auth']);
	if (auth != null) {
		trudaRTMUser.auth = auth;
	}
	return trudaRTMUser;
}

Map<String, dynamic> $TrudaRTMUserToJson(TrudaRTMUser entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['portrait'] = entity.portrait;
	data['uid'] = entity.uid;
	data['virtualId'] = entity.virtualId;
	data['auth'] = entity.auth;
	return data;
}

TrudaRTMMsgText $TrudaRTMMsgTextFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgText trudaRTMMsgText = TrudaRTMMsgText();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgText.extra = extra;
	}
	final String? text = jsonConvert.convert<String>(json['text']);
	if (text != null) {
		trudaRTMMsgText.text = text;
	}
	return trudaRTMMsgText;
}

Map<String, dynamic> $TrudaRTMMsgTextToJson(TrudaRTMMsgText entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['text'] = entity.text;
	return data;
}

TrudaRTMMsgVoice $TrudaRTMMsgVoiceFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgVoice trudaRTMMsgVoice = TrudaRTMMsgVoice();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgVoice.extra = extra;
	}
	final String? voiceUrl = jsonConvert.convert<String>(json['voiceUrl']);
	if (voiceUrl != null) {
		trudaRTMMsgVoice.voiceUrl = voiceUrl;
	}
	final int? duration = jsonConvert.convert<int>(json['duration']);
	if (duration != null) {
		trudaRTMMsgVoice.duration = duration;
	}
	return trudaRTMMsgVoice;
}

Map<String, dynamic> $TrudaRTMMsgVoiceToJson(TrudaRTMMsgVoice entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['voiceUrl'] = entity.voiceUrl;
	data['duration'] = entity.duration;
	return data;
}

TrudaRTMMsgPhoto $TrudaRTMMsgPhotoFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgPhoto trudaRTMMsgPhoto = TrudaRTMMsgPhoto();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgPhoto.extra = extra;
	}
	final String? thumbnailUrl = jsonConvert.convert<String>(json['thumbnailUrl']);
	if (thumbnailUrl != null) {
		trudaRTMMsgPhoto.thumbnailUrl = thumbnailUrl;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
	if (imageUrl != null) {
		trudaRTMMsgPhoto.imageUrl = imageUrl;
	}
	return trudaRTMMsgPhoto;
}

Map<String, dynamic> $TrudaRTMMsgPhotoToJson(TrudaRTMMsgPhoto entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['thumbnailUrl'] = entity.thumbnailUrl;
	data['imageUrl'] = entity.imageUrl;
	return data;
}

TrudaRTMMsgCallState $TrudaRTMMsgCallStateFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgCallState trudaRTMMsgCallState = TrudaRTMMsgCallState();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgCallState.extra = extra;
	}
	final String? duration = jsonConvert.convert<String>(json['duration']);
	if (duration != null) {
		trudaRTMMsgCallState.duration = duration;
	}
	final int? statusType = jsonConvert.convert<int>(json['statusType']);
	if (statusType != null) {
		trudaRTMMsgCallState.statusType = statusType;
	}
	return trudaRTMMsgCallState;
}

Map<String, dynamic> $TrudaRTMMsgCallStateToJson(TrudaRTMMsgCallState entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['duration'] = entity.duration;
	data['statusType'] = entity.statusType;
	return data;
}

TrudaRTMMsgGift $TrudaRTMMsgGiftFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgGift trudaRTMMsgGift = TrudaRTMMsgGift();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgGift.extra = extra;
	}
	final String? giftId = jsonConvert.convert<String>(json['giftId']);
	if (giftId != null) {
		trudaRTMMsgGift.giftId = giftId;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		trudaRTMMsgGift.quantity = quantity;
	}
	final int? cost = jsonConvert.convert<int>(json['cost']);
	if (cost != null) {
		trudaRTMMsgGift.cost = cost;
	}
	final String? sendGiftRecordId = jsonConvert.convert<String>(json['sendGiftRecordId']);
	if (sendGiftRecordId != null) {
		trudaRTMMsgGift.sendGiftRecordId = sendGiftRecordId;
	}
	final String? giftName = jsonConvert.convert<String>(json['giftName']);
	if (giftName != null) {
		trudaRTMMsgGift.giftName = giftName;
	}
	final String? giftImageUrl = jsonConvert.convert<String>(json['giftImageUrl']);
	if (giftImageUrl != null) {
		trudaRTMMsgGift.giftImageUrl = giftImageUrl;
	}
	return trudaRTMMsgGift;
}

Map<String, dynamic> $TrudaRTMMsgGiftToJson(TrudaRTMMsgGift entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['giftId'] = entity.giftId;
	data['quantity'] = entity.quantity;
	data['cost'] = entity.cost;
	data['sendGiftRecordId'] = entity.sendGiftRecordId;
	data['giftName'] = entity.giftName;
	data['giftImageUrl'] = entity.giftImageUrl;
	return data;
}

TrudaRTMMsgBeginCall $TrudaRTMMsgBeginCallFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgBeginCall trudaRTMMsgBeginCall = TrudaRTMMsgBeginCall();
	final String? channelId = jsonConvert.convert<String>(json['channelId']);
	if (channelId != null) {
		trudaRTMMsgBeginCall.channelId = channelId;
	}
	final int? chargePrice = jsonConvert.convert<int>(json['chargePrice']);
	if (chargePrice != null) {
		trudaRTMMsgBeginCall.chargePrice = chargePrice;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		trudaRTMMsgBeginCall.propDuration = propDuration;
	}
	final int? remainDiamonds = jsonConvert.convert<int>(json['remainDiamonds']);
	if (remainDiamonds != null) {
		trudaRTMMsgBeginCall.remainDiamonds = remainDiamonds;
	}
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgBeginCall.extra = extra;
	}
	final bool? usedProp = jsonConvert.convert<bool>(json['usedProp']);
	if (usedProp != null) {
		trudaRTMMsgBeginCall.usedProp = usedProp;
	}
	return trudaRTMMsgBeginCall;
}

Map<String, dynamic> $TrudaRTMMsgBeginCallToJson(TrudaRTMMsgBeginCall entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['channelId'] = entity.channelId;
	data['chargePrice'] = entity.chargePrice;
	data['propDuration'] = entity.propDuration;
	data['remainDiamonds'] = entity.remainDiamonds;
	data['extra'] = entity.extra;
	data['usedProp'] = entity.usedProp;
	return data;
}

TrudaRTMMsgAIB $TrudaRTMMsgAIBFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgAIB trudaRTMMsgAIB = TrudaRTMMsgAIB();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgAIB.extra = extra;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaRTMMsgAIB.id = id;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaRTMMsgAIB.isOnline = isOnline;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaRTMMsgAIB.nickname = nickname;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaRTMMsgAIB.portrait = portrait;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaRTMMsgAIB.userId = userId;
	}
	return trudaRTMMsgAIB;
}

Map<String, dynamic> $TrudaRTMMsgAIBToJson(TrudaRTMMsgAIB entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['id'] = entity.id;
	data['isOnline'] = entity.isOnline;
	data['nickname'] = entity.nickname;
	data['portrait'] = entity.portrait;
	data['userId'] = entity.userId;
	return data;
}

TrudaRTMMsgAIC $TrudaRTMMsgAICFromJson(Map<String, dynamic> json) {
	final TrudaRTMMsgAIC trudaRTMMsgAIC = TrudaRTMMsgAIC();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		trudaRTMMsgAIC.extra = extra;
	}
	final int? callCardCount = jsonConvert.convert<int>(json['callCardCount']);
	if (callCardCount != null) {
		trudaRTMMsgAIC.callCardCount = callCardCount;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaRTMMsgAIC.id = id;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaRTMMsgAIC.isOnline = isOnline;
	}
	final int? muteStatus = jsonConvert.convert<int>(json['muteStatus']);
	if (muteStatus != null) {
		trudaRTMMsgAIC.muteStatus = muteStatus;
	}
	final int? isCard = jsonConvert.convert<int>(json['isCard']);
	if (isCard != null) {
		trudaRTMMsgAIC.isCard = isCard;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		trudaRTMMsgAIC.propDuration = propDuration;
	}
	final bool? isFollowed = jsonConvert.convert<bool>(json['isFollowed']);
	if (isFollowed != null) {
		trudaRTMMsgAIC.isFollowed = isFollowed;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaRTMMsgAIC.nickname = nickname;
	}
	final String? filename = jsonConvert.convert<String>(json['filename']);
	if (filename != null) {
		trudaRTMMsgAIC.filename = filename;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaRTMMsgAIC.portrait = portrait;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaRTMMsgAIC.userId = userId;
	}
	return trudaRTMMsgAIC;
}

Map<String, dynamic> $TrudaRTMMsgAICToJson(TrudaRTMMsgAIC entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['callCardCount'] = entity.callCardCount;
	data['id'] = entity.id;
	data['isOnline'] = entity.isOnline;
	data['muteStatus'] = entity.muteStatus;
	data['isCard'] = entity.isCard;
	data['propDuration'] = entity.propDuration;
	data['isFollowed'] = entity.isFollowed;
	data['nickname'] = entity.nickname;
	data['filename'] = entity.filename;
	data['portrait'] = entity.portrait;
	data['userId'] = entity.userId;
	return data;
}