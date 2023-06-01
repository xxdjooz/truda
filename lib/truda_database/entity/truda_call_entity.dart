import 'package:objectbox/objectbox.dart';

// {
//     "text":{
//         "destructTime":1652528470842,
//         "extra":"",
//         "messageContent":"{\"duration\":\"00:01:12\",\"statusType\":1004,\"extra\":\"\"}",
//         "msgId":"1652528470842_107780488_12",
//         "type":12,
//         "userInfo":{
//             "name":"Hdhdgd",
//             "portrait":"https://oss.hanilink.com/users_test/107780488/upload/media/2022_03_25_15_13_56/cropped2523421620286357387.jpg!avatar_abbreviation",
//             "uid":"107780488",
//             "virtualId":"1057644"
//         }
//     },
//     "ts":1652528473477,
//     "offline":false
// }

@Entity()
class TrudaCallEntity {
  int id;

  // 消息插入库时间
  int dateInsert;

  // 唯一id
  // @Unique()
  String channelId;

  // 自己的id
  String myId;

  // 主播的id
  String herId;

  // 主播的短id
  String herVirtualId;

  // 自己的id与主播的id形成的组合 555_666
  String groupId;

  // 类型，0我打的，1被叫的
  @Property(type: PropertyType.byte)
  int callType;

  // TrudaCallStatus
  int callStatus;

  // 01:20
  String duration;

  //
  String extra;

  // Not persisted: 不入库的字段
  @Transient()
  int tempUsageCount = 0;

  TrudaCallEntity({
    required this.myId,
    required this.herId,
    required this.herVirtualId,
    required this.channelId,
    required this.callType,
    required this.callStatus,
    required this.dateInsert,
    required this.duration,
    this.id = 0,
    this.extra = '',
  }) : groupId = "${myId}_$herId";
}
