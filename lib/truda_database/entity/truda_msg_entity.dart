import 'package:objectbox/objectbox.dart';

@Entity()
class TrudaMsgEntity {
  // 主键索引
  int id;

  // 消息插入库时间
  int dateInsert;

  // 消息唯一id
  // 唯一索引
  @Unique()
  String msgId;

  // 自己的id
  // 普通索引
  @Index()
  String myId;

  // 主播的id
  String herId;

  // 自己的id与主播的id形成的组合 555_666
  String groupId;

  // 发送类型，0我发的，1收到的，2本地插入我发的，3本地插入收到的
  @Property(type: PropertyType.byte)
  int sendType;

  // 0发送成功，1发送中，2发送失败
  @Property(type: PropertyType.byte)
  int sendState;

  // 0已读，1未读
  @Property(type: PropertyType.byte)
  int readState;

  // 消息类型
  int msgType;

  // 内容
  String content;
  // 内容
  String? extra;

  // 原本json
  String rawData;

  // 把这个消息当作eventbus参数发送时的类型
  @Transient()
  NewHitaMsgEventType msgEventType;

  TrudaMsgEntity(this.myId, this.herId, this.sendType, this.content,
      this.dateInsert, this.rawData, this.msgType,
      {this.id = 0,
      this.sendState = 0,
      this.readState = 0,
      this.msgEventType = NewHitaMsgEventType.none})
      : groupId = "${myId}_$herId",
        msgId = "${myId}_${herId}_${dateInsert}";
}

/// 把这个消息当作eventbus参数发送时的类型
enum NewHitaMsgEventType { none, received, uploading, sending, sendDone, sendErr }
