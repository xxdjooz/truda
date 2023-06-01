import 'package:truda/generated/json/truda_link_content_entity.g.dart';

import '../generated/json/base/json_field.dart';

@JsonSerializable()
class TrudaLinkContent {
  TrudaLinkContent();

  factory TrudaLinkContent.fromJson(Map<String, dynamic> json) =>
      $TrudaLinkContentFromJson(json);

  Map<String, dynamic> toJson() => $TrudaLinkContentToJson(this);
  //  "createdAt":1665457419925,
  //  "updatedAt":1665457419925,
  //  "rid":1579669028683915265,
  //  "userId":107805636,
  //  "classifyId":0,
  //  "status":0,
  //  "title":"",
  //  "tag":"",
  //  "favoritesCount":0,
  //  "likesCount":0,
  //  "paths":"https://s3-hanilink-com.s3.ap-southeast-1.amazonaws.com/users/test/awss3/107805636/upload/6accf0e4756b0a6023a0739067d1c02c.jpg",
  //  "content":"fddfghkkl",
  //  "nickname":"hdhdh",
  //  "gender":1,
  //  "intro":"滴哦pls匿名了哦or匿名ing哦哦or明明哦OMG你弟弟心狠哦破给你您给我你定名额你摸",
  //  "portrait":"https://oss.hanilink.com/assets/images/default1.png",
  //  "fansCount":null,
  //  "followCount":null,
  //  "collectCount":null,
  //  "isCollect":0,
  //  "isLike":0,
  //  "pathArray":[
  //      "https://s3-hanilink-com.s3.ap-southeast-1.amazonaws.com/users/test/awss3/107805636/upload/6accf0e4756b0a6023a0739067d1c02c.jpg"
  //  ]
  int? createdAt;
  int? updatedAt;
  String? rid;
  String? userId;
  int? classifyId;
  int? status;
  String? title;
  String? tag;
  int? favoritesCount;
  int? likesCount;
  String? paths;
  String? content;
  String? nickname;
  int? gender;
  String? intro;
  String? portrait;
  int? fansCount;
  int? followCount;
  int? collectCount;
  int? isCollect;
  int? isLike;
  List<String>? pathArray;
}
