import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:truda/truda_entities/truda_hot_entity.dart';


TrudaHostDetail $TrudaHostDetailFromJson(Map<String, dynamic> json) {
	final TrudaHostDetail trudaHostDetail = TrudaHostDetail();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaHostDetail.userId = userId;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		trudaHostDetail.username = username;
	}
	final int? auth = jsonConvert.convert<int>(json['auth']);
	if (auth != null) {
		trudaHostDetail.auth = auth;
	}
	final String? intro = jsonConvert.convert<String>(json['intro']);
	if (intro != null) {
		trudaHostDetail.intro = intro;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaHostDetail.portrait = portrait;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaHostDetail.nickname = nickname;
	}
	final int? areaCode = jsonConvert.convert<int>(json['areaCode']);
	if (areaCode != null) {
		trudaHostDetail.areaCode = areaCode;
	}
	final int? isDoNotDisturb = jsonConvert.convert<int>(json['isDoNotDisturb']);
	if (isDoNotDisturb != null) {
		trudaHostDetail.isDoNotDisturb = isDoNotDisturb;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaHostDetail.createdAt = createdAt;
	}
	final int? isOnline = jsonConvert.convert<int>(json['isOnline']);
	if (isOnline != null) {
		trudaHostDetail.isOnline = isOnline;
	}
	final int? customOnline = jsonConvert.convert<int>(json['customOnline']);
	if (customOnline != null) {
		trudaHostDetail.customOnline = customOnline;
	}
	final String? customVideoId = jsonConvert.convert<String>(json['customVideoId']);
	if (customVideoId != null) {
		trudaHostDetail.customVideoId = customVideoId;
	}
	final int? gender = jsonConvert.convert<int>(json['gender']);
	if (gender != null) {
		trudaHostDetail.gender = gender;
	}
	final int? country = jsonConvert.convert<int>(json['country']);
	if (country != null) {
		trudaHostDetail.country = country;
	}
	final int? charge = jsonConvert.convert<int>(json['charge']);
	if (charge != null) {
		trudaHostDetail.charge = charge;
	}
	final int? followed = jsonConvert.convert<int>(json['followed']);
	if (followed != null) {
		trudaHostDetail.followed = followed;
	}
	final int? followCount = jsonConvert.convert<int>(json['followCount']);
	if (followCount != null) {
		trudaHostDetail.followCount = followCount;
	}
	final int? connectRate = jsonConvert.convert<int>(json['connectRate']);
	if (connectRate != null) {
		trudaHostDetail.connectRate = connectRate;
	}
	final String? video = jsonConvert.convert<String>(json['video']);
	if (video != null) {
		trudaHostDetail.video = video;
	}
	final int? birthday = jsonConvert.convert<int>(json['birthday']);
	if (birthday != null) {
		trudaHostDetail.birthday = birthday;
	}
	final int? expLevel = jsonConvert.convert<int>(json['expLevel']);
	if (expLevel != null) {
		trudaHostDetail.expLevel = expLevel;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaHostDetail.updatedAt = updatedAt;
	}
	final List<TrudaHostMedia>? medias = jsonConvert.convertListNotNull<TrudaHostMedia>(json['medias']);
	if (medias != null) {
		trudaHostDetail.medias = medias;
	}
	final List<TrudaHostMedia>? videos = jsonConvert.convertListNotNull<TrudaHostMedia>(json['videos']);
	if (videos != null) {
		trudaHostDetail.videos = videos;
	}
	final TrudaAreaData? area = jsonConvert.convert<TrudaAreaData>(json['area']);
	if (area != null) {
		trudaHostDetail.area = area;
	}
	return trudaHostDetail;
}

Map<String, dynamic> $TrudaHostDetailToJson(TrudaHostDetail entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['username'] = entity.username;
	data['auth'] = entity.auth;
	data['intro'] = entity.intro;
	data['portrait'] = entity.portrait;
	data['nickname'] = entity.nickname;
	data['areaCode'] = entity.areaCode;
	data['isDoNotDisturb'] = entity.isDoNotDisturb;
	data['createdAt'] = entity.createdAt;
	data['isOnline'] = entity.isOnline;
	data['customOnline'] = entity.customOnline;
	data['customVideoId'] = entity.customVideoId;
	data['gender'] = entity.gender;
	data['country'] = entity.country;
	data['charge'] = entity.charge;
	data['followed'] = entity.followed;
	data['followCount'] = entity.followCount;
	data['connectRate'] = entity.connectRate;
	data['video'] = entity.video;
	data['birthday'] = entity.birthday;
	data['expLevel'] = entity.expLevel;
	data['updatedAt'] = entity.updatedAt;
	data['medias'] =  entity.medias?.map((v) => v.toJson()).toList();
	data['videos'] =  entity.videos?.map((v) => v.toJson()).toList();
	data['area'] = entity.area?.toJson();
	return data;
}

TrudaHostMedia $TrudaHostMediaFromJson(Map<String, dynamic> json) {
	final TrudaHostMedia trudaHostMedia = TrudaHostMedia();
	final int? mid = jsonConvert.convert<int>(json['mid']);
	if (mid != null) {
		trudaHostMedia.mid = mid;
	}
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		trudaHostMedia.userId = userId;
	}
	final String? path = jsonConvert.convert<String>(json['path']);
	if (path != null) {
		trudaHostMedia.path = path;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		trudaHostMedia.type = type;
	}
	final int? selected = jsonConvert.convert<int>(json['selected']);
	if (selected != null) {
		trudaHostMedia.selected = selected;
	}
	final String? cover = jsonConvert.convert<String>(json['cover']);
	if (cover != null) {
		trudaHostMedia.cover = cover;
	}
	final int? locked = jsonConvert.convert<int>(json['locked']);
	if (locked != null) {
		trudaHostMedia.locked = locked;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		trudaHostMedia.diamonds = diamonds;
	}
	final int? likeCount = jsonConvert.convert<int>(json['likeCount']);
	if (likeCount != null) {
		trudaHostMedia.likeCount = likeCount;
	}
	final int? unlockCount = jsonConvert.convert<int>(json['unlockCount']);
	if (unlockCount != null) {
		trudaHostMedia.unlockCount = unlockCount;
	}
	final int? playCount = jsonConvert.convert<int>(json['playCount']);
	if (playCount != null) {
		trudaHostMedia.playCount = playCount;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		trudaHostMedia.status = status;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaHostMedia.createdAt = createdAt;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaHostMedia.updatedAt = updatedAt;
	}
	final dynamic isPay = jsonConvert.convert<dynamic>(json['isPay']);
	if (isPay != null) {
		trudaHostMedia.isPay = isPay;
	}
	final int? vipVisible = jsonConvert.convert<int>(json['vipVisible']);
	if (vipVisible != null) {
		trudaHostMedia.vipVisible = vipVisible;
	}
	return trudaHostMedia;
}

Map<String, dynamic> $TrudaHostMediaToJson(TrudaHostMedia entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['mid'] = entity.mid;
	data['userId'] = entity.userId;
	data['path'] = entity.path;
	data['type'] = entity.type;
	data['selected'] = entity.selected;
	data['cover'] = entity.cover;
	data['locked'] = entity.locked;
	data['diamonds'] = entity.diamonds;
	data['likeCount'] = entity.likeCount;
	data['unlockCount'] = entity.unlockCount;
	data['playCount'] = entity.playCount;
	data['status'] = entity.status;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['isPay'] = entity.isPay;
	data['vipVisible'] = entity.vipVisible;
	return data;
}