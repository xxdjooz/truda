import '../generated/json/base/json_field.dart';
import '../generated/json/newhita_rtm_msg_entity.g.dart';

@JsonSerializable()
class NewHitaRTMText {
  NewHitaRTMText();

  factory NewHitaRTMText.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMTextFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMTextToJson(this);

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
  NewHitaRTMUser? userInfo;
}

@JsonSerializable()
class NewHitaRTMUser {
  NewHitaRTMUser();

  factory NewHitaRTMUser.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMUserFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMUserToJson(this);

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
class NewHitaRTMMsgText {
  static const int typeCode = 10;
  NewHitaRTMMsgText();

  factory NewHitaRTMMsgText.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgTextFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgTextToJson(this);

  String? extra;
  String? text;
}

@JsonSerializable()
class NewHitaRTMMsgVoice {
  // type voice = 14
  // type severVoice = 21 //服务器语音消息
  static const List<int> typeCodes = [14, 21];
  NewHitaRTMMsgVoice();

  factory NewHitaRTMMsgVoice.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgVoiceFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgVoiceToJson(this);
  String? extra;
  String? voiceUrl;
  int? duration;
}

@JsonSerializable()
class NewHitaRTMMsgPhoto {
  // type imge = 13
  // type severImge = 20//服务器图片消息
  static const List<int> typeCodes = [13, 20];
  NewHitaRTMMsgPhoto();

  factory NewHitaRTMMsgPhoto.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgPhotoFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgPhotoToJson(this);
  String? extra;
  String? thumbnailUrl;
  String? imageUrl;
}

@JsonSerializable()
class NewHitaRTMMsgCallState {
  static const int typeCode = 12;
  NewHitaRTMMsgCallState();

  factory NewHitaRTMMsgCallState.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgCallStateFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgCallStateToJson(this);
  String? extra;
  String? duration;
  int? statusType;
}

@JsonSerializable()
class NewHitaRTMMsgGift {
  static const int typeCode = 11;
  NewHitaRTMMsgGift();

  factory NewHitaRTMMsgGift.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgGiftFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgGiftToJson(this);
  String? extra;
  String? giftId;
  int? quantity;
  int? cost;
  String? sendGiftRecordId;
  String? giftName;
  String? giftImageUrl;
}

@JsonSerializable()
class NewHitaRTMMsgBeginCall {
  static const int typeCode = 23;
  NewHitaRTMMsgBeginCall();

  factory NewHitaRTMMsgBeginCall.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgBeginCallFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgBeginCallToJson(this);
  String? channelId;
  int? chargePrice;
  int? propDuration;
  int? remainDiamonds;
  String? extra;
  bool? usedProp;
}

@JsonSerializable()
class NewHitaRTMMsgAIB {
  static const int typeCode = 25;
  NewHitaRTMMsgAIB();

  factory NewHitaRTMMsgAIB.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgAIBFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgAIBToJson(this);
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
class NewHitaRTMMsgAIC {
  static const int typeCode = 24;
  NewHitaRTMMsgAIC();

  factory NewHitaRTMMsgAIC.fromJson(Map<String, dynamic> json) =>
      $NewHitaRTMMsgAICFromJson(json);

  Map<String, dynamic> toJson() => $NewHitaRTMMsgAICToJson(this);
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
