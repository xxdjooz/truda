import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:truda/truda_entities/truda_hot_entity.dart';

import '../generated/json/base/json_field.dart';
import '../generated/json/truda_host_entity.g.dart';

@JsonSerializable()
class TrudaHostDetail {
  TrudaHostDetail();

  factory TrudaHostDetail.fromJson(Map<String, dynamic> json) =>
      $TrudaHostDetailFromJson(json);

  Map<String, dynamic> toJson() => $TrudaHostDetailToJson(this);

  String? userId;
  String? username;
  int? auth;
  String? intro;
  String? portrait;
  String? nickname;
  int? areaCode;
  // 0,是否免打扰
  int? isDoNotDisturb;
  int? createdAt;
  // 0离线 1在线 2忙线
  int? isOnline;

  //用于匹配 自定义离线状态 0 为视频播放完毕 主播显示为离线
  int? customOnline;

  //用于匹配 标识这个播放器归属
  String? customVideoId;

  int? gender;
  int? country;
  int? charge;
  int? followed;
  int? followCount;
  int? connectRate;
  String? video;
  int? birthday;
  int? expLevel;

  //拉黑主播时间
  int? updatedAt;

  List<TrudaHostMedia>? medias;
  List<TrudaHostMedia>? videos;
  TrudaAreaData? area;

  bool get isShowOnline => realOnlineState == 1;
  int get realOnlineState {
    if (isDoNotDisturb == 0) {
      return isOnline ?? 0;
    } else {
      return 0;
    }
  }

  Color get realOnlineColor {
    switch (realOnlineState) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  // 默认Object的==是利用hashCode进行比较，跟Java一样，
  // 然后如果要实现dart对象的比较，可以重写==和hashCode
  @override
  bool operator ==(Object other) {
    // return super == other;
    if (identical(this, other)) return true;
    if (other is TrudaHostDetail) {
      return runtimeType == other.runtimeType && userId == other.userId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + userId.hashCode;
    // result = 37 * result + age.hashCode;
    return result;
  }
}

@JsonSerializable()
class TrudaHostMedia {
  TrudaHostMedia();

  factory TrudaHostMedia.fromJson(Map<String, dynamic> json) =>
      $TrudaHostMediaFromJson(json);

  Map<String, dynamic> toJson() => $TrudaHostMediaToJson(this);

  int? mid;
  int? userId;
  String? path;
  //类型  图片 0  视频1
  int? type;
  int? selected;
  String? cover;
  int? locked;
  int? diamonds;
  int? likeCount;
  int? unlockCount;
  int? playCount;
  int? status;
  int? createdAt;
  int? updatedAt;
  dynamic? isPay;
  // 是否vip可见，0.否，1.是
  int? vipVisible;
}
