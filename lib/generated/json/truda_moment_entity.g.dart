import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_moment_entity.dart';
import 'dart:ui';

import 'package:flutter/material.dart';


TrudaMomentDetail $TrudaMomentDetailFromJson(Map<String, dynamic> json) {
	final TrudaMomentDetail trudaMomentDetail = TrudaMomentDetail();
	final String? momentId = jsonConvert.convert<String>(json['momentId']);
	if (momentId != null) {
		trudaMomentDetail.momentId = momentId;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaMomentDetail.userId = userId;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		trudaMomentDetail.content = content;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		trudaMomentDetail.username = username;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaMomentDetail.createdAt = createdAt;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaMomentDetail.portrait = portrait;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaMomentDetail.nickname = nickname;
	}
	final int? isDoNotDisturb = jsonConvert.convert<int>(json['isDoNotDisturb']);
	if (isDoNotDisturb != null) {
		trudaMomentDetail.isDoNotDisturb = isDoNotDisturb;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaMomentDetail.isOnline = isOnline;
	}
	final int? gender = jsonConvert.convert<int>(json['gender']);
	if (gender != null) {
		trudaMomentDetail.gender = gender;
	}
	final int? birthday = jsonConvert.convert<int>(json['birthday']);
	if (birthday != null) {
		trudaMomentDetail.birthday = birthday;
	}
	final int? charge = jsonConvert.convert<int>(json['charge']);
	if (charge != null) {
		trudaMomentDetail.charge = charge;
	}
	final int? followed = jsonConvert.convert<int>(json['followed']);
	if (followed != null) {
		trudaMomentDetail.followed = followed;
	}
	final int? followCount = jsonConvert.convert<int>(json['followCount']);
	if (followCount != null) {
		trudaMomentDetail.followCount = followCount;
	}
	final int? praised = jsonConvert.convert<int>(json['praised']);
	if (praised != null) {
		trudaMomentDetail.praised = praised;
	}
	final int? praiseCount = jsonConvert.convert<int>(json['praiseCount']);
	if (praiseCount != null) {
		trudaMomentDetail.praiseCount = praiseCount;
	}
	final List<TrudaMomentMedia>? medias = jsonConvert.convertListNotNull<TrudaMomentMedia>(json['medias']);
	if (medias != null) {
		trudaMomentDetail.medias = medias;
	}
	return trudaMomentDetail;
}

Map<String, dynamic> $TrudaMomentDetailToJson(TrudaMomentDetail entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['momentId'] = entity.momentId;
	data['userId'] = entity.userId;
	data['content'] = entity.content;
	data['username'] = entity.username;
	data['createdAt'] = entity.createdAt;
	data['portrait'] = entity.portrait;
	data['nickname'] = entity.nickname;
	data['isDoNotDisturb'] = entity.isDoNotDisturb;
	data['isOnline'] = entity.isOnline;
	data['gender'] = entity.gender;
	data['birthday'] = entity.birthday;
	data['charge'] = entity.charge;
	data['followed'] = entity.followed;
	data['followCount'] = entity.followCount;
	data['praised'] = entity.praised;
	data['praiseCount'] = entity.praiseCount;
	data['medias'] =  entity.medias?.map((v) => v.toJson()).toList();
	return data;
}

TrudaMomentMedia $TrudaMomentMediaFromJson(Map<String, dynamic> json) {
	final TrudaMomentMedia trudaMomentMedia = TrudaMomentMedia();
	final String? mediaId = jsonConvert.convert<String>(json['mediaId']);
	if (mediaId != null) {
		trudaMomentMedia.mediaId = mediaId;
	}
	final String? mediaUrl = jsonConvert.convert<String>(json['mediaUrl']);
	if (mediaUrl != null) {
		trudaMomentMedia.mediaUrl = mediaUrl;
	}
	final String? screenshotUrl = jsonConvert.convert<String>(json['screenshotUrl']);
	if (screenshotUrl != null) {
		trudaMomentMedia.screenshotUrl = screenshotUrl;
	}
	final int? mediaType = jsonConvert.convert<int>(json['mediaType']);
	if (mediaType != null) {
		trudaMomentMedia.mediaType = mediaType;
	}
	return trudaMomentMedia;
}

Map<String, dynamic> $TrudaMomentMediaToJson(TrudaMomentMedia entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['mediaId'] = entity.mediaId;
	data['mediaUrl'] = entity.mediaUrl;
	data['screenshotUrl'] = entity.screenshotUrl;
	data['mediaType'] = entity.mediaType;
	return data;
}