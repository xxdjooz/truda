import 'package:truda/truda_entities/truda_hot_entity.dart';

import '../generated/json/base/json_field.dart';
import '../generated/json/truda_match_host_entity.g.dart';

@JsonSerializable()
class TrudaMatchHostLimit {
  TrudaMatchHostLimit();

  factory TrudaMatchHostLimit.fromJson(Map<String, dynamic> json) =>
      $TrudaMatchHostLimitFromJson(json);

  Map<String, dynamic> toJson() => $TrudaMatchHostLimitToJson(this);
  int? matchCount;
  TrudaMatchHost? anchor;
}

@JsonSerializable()
class TrudaMatchHost {
  TrudaMatchHost();

  factory TrudaMatchHost.fromJson(Map<String, dynamic> json) =>
      $TrudaMatchHostFromJson(json);

  Map<String, dynamic> toJson() => $TrudaMatchHostToJson(this);
  // {userId: 107780487, nickName: Mary,
  // portrait: https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG,
  // charge: 60,
  // video: https://oss.hanilink.com/users_test/107780487/upload/anchor/upload/video/1507254915417100289.mp4,
  // muteStatus: 0,
  // isOnline: 0,
  // isDoNotDisturb: 0}
  String? userId;

  /// 注意这个name是大写的
  String? nickName;
  String? portrait;
  // 0,是否免打扰
  int? isDoNotDisturb;
  // 0离线 1在线 2忙线
  int? isOnline;
  int? muteStatus;
  int? charge;
  TrudaAreaData? area;
  int? birthday;
  int? followed;

  String? video;

  bool get isShowOnline => realOnlineState == 1;
  int get realOnlineState {
    if (isDoNotDisturb == 0) {
      return isOnline ?? 0;
    } else {
      return 0;
    }
  }
}
