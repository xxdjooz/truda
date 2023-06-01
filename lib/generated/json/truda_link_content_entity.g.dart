import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_link_content_entity.dart';

TrudaLinkContent $TrudaLinkContentFromJson(Map<String, dynamic> json) {
	final TrudaLinkContent trudaLinkContent = TrudaLinkContent();
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaLinkContent.createdAt = createdAt;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaLinkContent.updatedAt = updatedAt;
	}
	final String? rid = jsonConvert.convert<String>(json['rid']);
	if (rid != null) {
		trudaLinkContent.rid = rid;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		trudaLinkContent.userId = userId;
	}
	final int? classifyId = jsonConvert.convert<int>(json['classifyId']);
	if (classifyId != null) {
		trudaLinkContent.classifyId = classifyId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		trudaLinkContent.status = status;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		trudaLinkContent.title = title;
	}
	final String? tag = jsonConvert.convert<String>(json['tag']);
	if (tag != null) {
		trudaLinkContent.tag = tag;
	}
	final int? favoritesCount = jsonConvert.convert<int>(json['favoritesCount']);
	if (favoritesCount != null) {
		trudaLinkContent.favoritesCount = favoritesCount;
	}
	final int? likesCount = jsonConvert.convert<int>(json['likesCount']);
	if (likesCount != null) {
		trudaLinkContent.likesCount = likesCount;
	}
	final String? paths = jsonConvert.convert<String>(json['paths']);
	if (paths != null) {
		trudaLinkContent.paths = paths;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		trudaLinkContent.content = content;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		trudaLinkContent.nickname = nickname;
	}
	final int? gender = jsonConvert.convert<int>(json['gender']);
	if (gender != null) {
		trudaLinkContent.gender = gender;
	}
	final String? intro = jsonConvert.convert<String>(json['intro']);
	if (intro != null) {
		trudaLinkContent.intro = intro;
	}
	final String? portrait = jsonConvert.convert<String>(json['portrait']);
	if (portrait != null) {
		trudaLinkContent.portrait = portrait;
	}
	final int? fansCount = jsonConvert.convert<int>(json['fansCount']);
	if (fansCount != null) {
		trudaLinkContent.fansCount = fansCount;
	}
	final int? followCount = jsonConvert.convert<int>(json['followCount']);
	if (followCount != null) {
		trudaLinkContent.followCount = followCount;
	}
	final int? collectCount = jsonConvert.convert<int>(json['collectCount']);
	if (collectCount != null) {
		trudaLinkContent.collectCount = collectCount;
	}
	final int? isCollect = jsonConvert.convert<int>(json['isCollect']);
	if (isCollect != null) {
		trudaLinkContent.isCollect = isCollect;
	}
	final int? isLike = jsonConvert.convert<int>(json['isLike']);
	if (isLike != null) {
		trudaLinkContent.isLike = isLike;
	}
	final List<String>? pathArray = jsonConvert.convertListNotNull<String>(json['pathArray']);
	if (pathArray != null) {
		trudaLinkContent.pathArray = pathArray;
	}
	return trudaLinkContent;
}

Map<String, dynamic> $TrudaLinkContentToJson(TrudaLinkContent entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['rid'] = entity.rid;
	data['userId'] = entity.userId;
	data['classifyId'] = entity.classifyId;
	data['status'] = entity.status;
	data['title'] = entity.title;
	data['tag'] = entity.tag;
	data['favoritesCount'] = entity.favoritesCount;
	data['likesCount'] = entity.likesCount;
	data['paths'] = entity.paths;
	data['content'] = entity.content;
	data['nickname'] = entity.nickname;
	data['gender'] = entity.gender;
	data['intro'] = entity.intro;
	data['portrait'] = entity.portrait;
	data['fansCount'] = entity.fansCount;
	data['followCount'] = entity.followCount;
	data['collectCount'] = entity.collectCount;
	data['isCollect'] = entity.isCollect;
	data['isLike'] = entity.isLike;
	data['pathArray'] =  entity.pathArray;
	return data;
}