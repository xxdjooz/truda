import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_rtm/newhita_rtm_msg_entity.dart';

NewHitaRTMText $NewHitaRTMTextFromJson(Map<String, dynamic> json) {
	final NewHitaRTMText newHitaRTMText = NewHitaRTMText();
	final int? destructTime = jsonConvert.convert<int>(json['destructTime']);
	if (destructTime != null) {
		newHitaRTMText.destructTime = destructTime;
	}
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMText.extra = extra;
	}
	final String? messageContent = jsonConvert.convert<String>(json['messageContent']);
	if (messageContent != null) {
		newHitaRTMText.messageContent = messageContent;
	}
	final String? msgId = jsonConvert.convert<String>(json['msgId']);
	if (msgId != null) {
		newHitaRTMText.msgId = msgId;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		newHitaRTMText.type = type;
	}
	final NewHitaRTMUser? userInfo = jsonConvert.convert<NewHitaRTMUser>(json['userInfo']);
	if (userInfo != null) {
		newHitaRTMText.userInfo = userInfo;
	}
	return newHitaRTMText;
}

Map<String, dynamic> $NewHitaRTMTextToJson(NewHitaRTMText entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['destructTime'] = entity.destructTime;
	data['extra'] = entity.extra;
	data['messageContent'] = entity.messageContent;
	data['msgId'] = entity.msgId;
	data['type'] = entity.type;
	data['userInfo'] = entity.userInfo?.toJson();
	return data;
}

NewHitaRTMUser $NewHitaRTMUserFromJson(Map<String, dynamic> json) {
	final NewHitaRTMUser newHitaRTMUser = NewHitaRTMUser();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		newHitaRTMUser.name = name;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		newHitaRTMUser.portrait = portrait;
	}
	final String? uid = jsonConvert.convert<String>(json['uid']);
	if (uid != null) {
		newHitaRTMUser.uid = uid;
	}
	final String? virtualId = jsonConvert.convert<String>(json['virtualId']);
	if (virtualId != null) {
		newHitaRTMUser.virtualId = virtualId;
	}
	final int? auth = jsonConvert.convert<int>(json['auth']);
	if (auth != null) {
		newHitaRTMUser.auth = auth;
	}
	return newHitaRTMUser;
}

Map<String, dynamic> $NewHitaRTMUserToJson(NewHitaRTMUser entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['portrait'] = entity.portrait;
	data['uid'] = entity.uid;
	data['virtualId'] = entity.virtualId;
	data['auth'] = entity.auth;
	return data;
}

NewHitaRTMMsgText $NewHitaRTMMsgTextFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgText newHitaRTMMsgText = NewHitaRTMMsgText();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgText.extra = extra;
	}
	final String? text = jsonConvert.convert<String>(json['text']);
	if (text != null) {
		newHitaRTMMsgText.text = text;
	}
	return newHitaRTMMsgText;
}

Map<String, dynamic> $NewHitaRTMMsgTextToJson(NewHitaRTMMsgText entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['text'] = entity.text;
	return data;
}

NewHitaRTMMsgVoice $NewHitaRTMMsgVoiceFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgVoice newHitaRTMMsgVoice = NewHitaRTMMsgVoice();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgVoice.extra = extra;
	}
	final String? voiceUrl = jsonConvert.convert<String>(json['voiceUrl']);
	if (voiceUrl != null) {
		newHitaRTMMsgVoice.voiceUrl = voiceUrl;
	}
	final int? duration = jsonConvert.convert<int>(json['duration']);
	if (duration != null) {
		newHitaRTMMsgVoice.duration = duration;
	}
	return newHitaRTMMsgVoice;
}

Map<String, dynamic> $NewHitaRTMMsgVoiceToJson(NewHitaRTMMsgVoice entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['voiceUrl'] = entity.voiceUrl;
	data['duration'] = entity.duration;
	return data;
}

NewHitaRTMMsgPhoto $NewHitaRTMMsgPhotoFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgPhoto newHitaRTMMsgPhoto = NewHitaRTMMsgPhoto();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgPhoto.extra = extra;
	}
	final String? thumbnailUrl = jsonConvert.convert<String>(json['thumbnailUrl']);
	if (thumbnailUrl != null) {
		newHitaRTMMsgPhoto.thumbnailUrl = thumbnailUrl;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
	if (imageUrl != null) {
		newHitaRTMMsgPhoto.imageUrl = imageUrl;
	}
	return newHitaRTMMsgPhoto;
}

Map<String, dynamic> $NewHitaRTMMsgPhotoToJson(NewHitaRTMMsgPhoto entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['thumbnailUrl'] = entity.thumbnailUrl;
	data['imageUrl'] = entity.imageUrl;
	return data;
}

NewHitaRTMMsgCallState $NewHitaRTMMsgCallStateFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgCallState newHitaRTMMsgCallState = NewHitaRTMMsgCallState();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgCallState.extra = extra;
	}
	final String? duration = jsonConvert.convert<String>(json['duration']);
	if (duration != null) {
		newHitaRTMMsgCallState.duration = duration;
	}
	final int? statusType = jsonConvert.convert<int>(json['statusType']);
	if (statusType != null) {
		newHitaRTMMsgCallState.statusType = statusType;
	}
	return newHitaRTMMsgCallState;
}

Map<String, dynamic> $NewHitaRTMMsgCallStateToJson(NewHitaRTMMsgCallState entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['duration'] = entity.duration;
	data['statusType'] = entity.statusType;
	return data;
}

NewHitaRTMMsgGift $NewHitaRTMMsgGiftFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgGift newHitaRTMMsgGift = NewHitaRTMMsgGift();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgGift.extra = extra;
	}
	final String? giftId = jsonConvert.convert<String>(json['giftId']);
	if (giftId != null) {
		newHitaRTMMsgGift.giftId = giftId;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		newHitaRTMMsgGift.quantity = quantity;
	}
	final int? cost = jsonConvert.convert<int>(json['cost']);
	if (cost != null) {
		newHitaRTMMsgGift.cost = cost;
	}
	final String? sendGiftRecordId = jsonConvert.convert<String>(json['sendGiftRecordId']);
	if (sendGiftRecordId != null) {
		newHitaRTMMsgGift.sendGiftRecordId = sendGiftRecordId;
	}
	final String? giftName = jsonConvert.convert<String>(json['giftName']);
	if (giftName != null) {
		newHitaRTMMsgGift.giftName = giftName;
	}
	final String? giftImageUrl = jsonConvert.convert<String>(json['giftImageUrl']);
	if (giftImageUrl != null) {
		newHitaRTMMsgGift.giftImageUrl = giftImageUrl;
	}
	return newHitaRTMMsgGift;
}

Map<String, dynamic> $NewHitaRTMMsgGiftToJson(NewHitaRTMMsgGift entity) {
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

NewHitaRTMMsgBeginCall $NewHitaRTMMsgBeginCallFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgBeginCall newHitaRTMMsgBeginCall = NewHitaRTMMsgBeginCall();
	final String? channelId = jsonConvert.convert<String>(json['channelId']);
	if (channelId != null) {
		newHitaRTMMsgBeginCall.channelId = channelId;
	}
	final int? chargePrice = jsonConvert.convert<int>(json['chargePrice']);
	if (chargePrice != null) {
		newHitaRTMMsgBeginCall.chargePrice = chargePrice;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		newHitaRTMMsgBeginCall.propDuration = propDuration;
	}
	final int? remainDiamonds = jsonConvert.convert<int>(json['remainDiamonds']);
	if (remainDiamonds != null) {
		newHitaRTMMsgBeginCall.remainDiamonds = remainDiamonds;
	}
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgBeginCall.extra = extra;
	}
	final bool? usedProp = jsonConvert.convert<bool>(json['usedProp']);
	if (usedProp != null) {
		newHitaRTMMsgBeginCall.usedProp = usedProp;
	}
	return newHitaRTMMsgBeginCall;
}

Map<String, dynamic> $NewHitaRTMMsgBeginCallToJson(NewHitaRTMMsgBeginCall entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['channelId'] = entity.channelId;
	data['chargePrice'] = entity.chargePrice;
	data['propDuration'] = entity.propDuration;
	data['remainDiamonds'] = entity.remainDiamonds;
	data['extra'] = entity.extra;
	data['usedProp'] = entity.usedProp;
	return data;
}

NewHitaRTMMsgAIB $NewHitaRTMMsgAIBFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgAIB newHitaRTMMsgAIB = NewHitaRTMMsgAIB();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgAIB.extra = extra;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		newHitaRTMMsgAIB.id = id;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		newHitaRTMMsgAIB.isOnline = isOnline;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		newHitaRTMMsgAIB.nickname = nickname;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		newHitaRTMMsgAIB.portrait = portrait;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		newHitaRTMMsgAIB.userId = userId;
	}
	return newHitaRTMMsgAIB;
}

Map<String, dynamic> $NewHitaRTMMsgAIBToJson(NewHitaRTMMsgAIB entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['extra'] = entity.extra;
	data['id'] = entity.id;
	data['isOnline'] = entity.isOnline;
	data['nickname'] = entity.nickname;
	data['portrait'] = entity.portrait;
	data['userId'] = entity.userId;
	return data;
}

NewHitaRTMMsgAIC $NewHitaRTMMsgAICFromJson(Map<String, dynamic> json) {
	final NewHitaRTMMsgAIC newHitaRTMMsgAIC = NewHitaRTMMsgAIC();
	final String? extra = jsonConvert.convert<String>(json['extra']);
	if (extra != null) {
		newHitaRTMMsgAIC.extra = extra;
	}
	final int? callCardCount = jsonConvert.convert<int>(json['callCardCount']);
	if (callCardCount != null) {
		newHitaRTMMsgAIC.callCardCount = callCardCount;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		newHitaRTMMsgAIC.id = id;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		newHitaRTMMsgAIC.isOnline = isOnline;
	}
	final int? muteStatus = jsonConvert.convert<int>(json['muteStatus']);
	if (muteStatus != null) {
		newHitaRTMMsgAIC.muteStatus = muteStatus;
	}
	final int? isCard = jsonConvert.convert<int>(json['isCard']);
	if (isCard != null) {
		newHitaRTMMsgAIC.isCard = isCard;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		newHitaRTMMsgAIC.propDuration = propDuration;
	}
	final bool? isFollowed = jsonConvert.convert<bool>(json['isFollowed']);
	if (isFollowed != null) {
		newHitaRTMMsgAIC.isFollowed = isFollowed;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		newHitaRTMMsgAIC.nickname = nickname;
	}
	final String? filename = jsonConvert.convert<String>(json['filename']);
	if (filename != null) {
		newHitaRTMMsgAIC.filename = filename;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		newHitaRTMMsgAIC.portrait = portrait;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		newHitaRTMMsgAIC.userId = userId;
	}
	return newHitaRTMMsgAIC;
}

Map<String, dynamic> $NewHitaRTMMsgAICToJson(NewHitaRTMMsgAIC entity) {
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