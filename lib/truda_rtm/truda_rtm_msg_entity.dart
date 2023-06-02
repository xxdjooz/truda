import '../generated/json/base/json_field.dart';
import '../generated/json/truda_rtm_msg_entity.g.dart';

@JsonSerializable()
class TrudaRTMText {
  TrudaRTMText();

  factory TrudaRTMText.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMTextFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMTextToJson(this);

  int? destructTime;
  String? extra;
  String? messageContent;
  String? msgId;
  // type text = 10
  // type gift = 11
  // type call = 12
  // type imge = 13
  // type voice = 14
  // type video = 15
  // type severImge = 20//服务器图片消息
  // type severVoice = 21 //服务器语音消息
  // type  = 24 //AIA下发的视频
  // type  = 25 //AIB
  // type = 23    服务器会发送begincall
  int? type;
  TrudaRTMUser? userInfo;
}

@JsonSerializable()
class TrudaRTMUser {
  TrudaRTMUser();

  factory TrudaRTMUser.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMUserFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMUserToJson(this);

  String? name;
  String? portrait;
  String? uid;
  String? virtualId;
  int? auth;

  /**
   * 真实uid
   */
  // @SerializedName("uid") var uid:String,
  /**
   * 展示给用户看的uid
   */
  // @SerializedName("virtualId") var virtualId:String = "",
  /**
   * 头像地址
   */
  // @SerializedName("portrait") var portrait:String,
  /**
   * 名称
   */
  // @SerializedName("name") var name:String
}

@JsonSerializable()
class TrudaRTMMsgText {
  static const int typeCode = 10;
  TrudaRTMMsgText();

  factory TrudaRTMMsgText.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgTextFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgTextToJson(this);

  String? extra;
  String? text;
}

@JsonSerializable()
class TrudaRTMMsgVoice {
  // type voice = 14
  // type severVoice = 21 //服务器语音消息
  static const List<int> typeCodes = [14, 21];
  TrudaRTMMsgVoice();

  factory TrudaRTMMsgVoice.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgVoiceFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgVoiceToJson(this);
  String? extra;
  String? voiceUrl;
  int? duration;
}

@JsonSerializable()
class TrudaRTMMsgPhoto {
  // type imge = 13
  // type severImge = 20//服务器图片消息
  static const List<int> typeCodes = [13, 20];
  TrudaRTMMsgPhoto();

  factory TrudaRTMMsgPhoto.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgPhotoFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgPhotoToJson(this);
  String? extra;
  String? thumbnailUrl;
  String? imageUrl;
}

@JsonSerializable()
class TrudaRTMMsgCallState {
  static const int typeCode = 12;
  TrudaRTMMsgCallState();

  factory TrudaRTMMsgCallState.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgCallStateFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgCallStateToJson(this);
  String? extra;
  String? duration;
  int? statusType;
}

@JsonSerializable()
class TrudaRTMMsgGift {
  static const int typeCode = 11;
  TrudaRTMMsgGift();

  factory TrudaRTMMsgGift.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgGiftFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgGiftToJson(this);
  String? extra;
  String? giftId;
  int? quantity;
  int? cost;
  String? sendGiftRecordId;
  String? giftName;
  String? giftImageUrl;
}

@JsonSerializable()
class TrudaRTMMsgBeginCall {
  static const int typeCode = 23;
  TrudaRTMMsgBeginCall();

  factory TrudaRTMMsgBeginCall.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgBeginCallFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgBeginCallToJson(this);
  String? channelId;
  int? chargePrice;
  int? propDuration;
  int? remainDiamonds;
  String? extra;
  bool? usedProp;
}

@JsonSerializable()
class TrudaRTMMsgAIB {
  static const int typeCode = 25;
  TrudaRTMMsgAIB();

  factory TrudaRTMMsgAIB.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgAIBFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgAIBToJson(this);
  String? extra;
  int? id;
  int? isOnline;
  String? nickname;
  String? portrait;
  String? userId;
}

//{\"callCardCount\":0,\"extra\":\"624ff55eebcc317144526180\",
// \"filename\":\"https://oss.hanilink.com/users/107012498/upload/anchor/upload/video/1505217394515206145.mp4\",
// \"id\":107781256,\"isFollowed\":false,\"isOnline\":1,\"muteStatus\":1,\"nickname\":\"Mary\",
// \"portrait\":\"https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG\",
// \"propDuration\":70000,\"userId\":107780487}
@JsonSerializable()
class TrudaRTMMsgAIC {
  static const int typeCode = 24;
  TrudaRTMMsgAIC();

  factory TrudaRTMMsgAIC.fromJson(Map<String, dynamic> json) =>
      $TrudaRTMMsgAICFromJson(json);

  Map<String, dynamic> toJson() => $TrudaRTMMsgAICToJson(this);
  String? extra;
  int? callCardCount;
  int? id;
  int? isOnline;
  int? muteStatus;
  int? isCard;
  int? propDuration;
  bool? isFollowed;
  String? nickname;
  String? filename;
  String? portrait;
  String? userId;
}
