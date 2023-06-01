import 'dart:ui';

import 'package:flutter/material.dart';

import '../generated/json/base/json_field.dart';
import '../generated/json/truda_moment_entity.g.dart';

@JsonSerializable()
class TrudaMomentDetail {
  TrudaMomentDetail();

  factory TrudaMomentDetail.fromJson(Map<String, dynamic> json) =>
      $TrudaMomentDetailFromJson(json);

  Map<String, dynamic> toJson() => $TrudaMomentDetailToJson(this);
  // "momentId": 1559453194816651265,// 动态id
  // "userId": 107780487,// 主播id
  // "content": "abc",// 内容
  // "createdAt": 1660637589534,// 创建时间
  // "username": "1057684",// 主播短id
  // "nickname": "Mima",// 昵称
  // "portrait": "https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG",// 头像
  // "isOnline": 0,// 是否在线，0.离线，1.在线，2.忙线
  // "isDoNotDisturb": 0,// 是否勿扰，0.否，1.勿扰
  // "followed": 0,// 是否关注，0.未关注，1.已关注
  // "praised": 0,// 是否点赞，0.未点赞，1.已点赞
  // "praiseCount": 0,// 点赞数
  // "charge": 60,// 主播视频收费
  // "medias": [// 资源列表
  //     {
  //         "mediaId": 1559453200571236353,// 资源id
  //         "mediaType": 0,// 资源类型，0.图片，1.视频
  //         "mediaUrl": "https://oss.hanilink.com/1.png",// 资源链接
  //         "screenshotUrl": null// 第一帧链接
  //     }
  // ]
  String? momentId;
  String? userId;
  String? content;
  String? username;
  int? createdAt;
  String? portrait;
  String? nickname;
  // 0,是否免打扰
  int? isDoNotDisturb;
  // 0离线 1在线 2忙线
  int? isOnline;

  int? gender;
  int? birthday;
  int? charge;
  int? followed;
  int? followCount;
  int? praised;
  int? praiseCount;

  List<TrudaMomentMedia>? medias;

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
    if (other is TrudaMomentDetail) {
      return runtimeType == other.runtimeType && momentId == other.momentId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + momentId.hashCode;
    // result = 37 * result + age.hashCode;
    return result;
  }
}

@JsonSerializable()
class TrudaMomentMedia {
  TrudaMomentMedia();

  factory TrudaMomentMedia.fromJson(Map<String, dynamic> json) =>
      $TrudaMomentMediaFromJson(json);

  Map<String, dynamic> toJson() => $TrudaMomentMediaToJson(this);

  String? mediaId;
  String? mediaUrl;
  String? screenshotUrl;
  //类型  图片 0  视频1
  int? mediaType;

  @JSONField(serialize: false, deserialize: false)
  String? localPath;
  // 0上传中，1上传完成，2失败
  @JSONField(serialize: false, deserialize: false)
  int? uploadState;
}
