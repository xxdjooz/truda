import 'package:objectbox/objectbox.dart';

@Entity()
class TrudaConversationEntity {
  int id;

  // 消息插入库时间
  int dateInsert;

  // 消息唯一id
  @Unique()
  String msgId;

  // 自己的id
  String myId;

  // 主播的id
  String herId;

  // 自己的id与主播的id形成的组合 555_666
  @Unique()
  String groupId;

  // 发送类型，0我发的，1收到的，2本地插入我发的，3本地插入收到的
  @Property(type: PropertyType.byte)
  int sendType;

  // 0发送成功，1发送中，2发送失败
  @Property(type: PropertyType.byte)
  int sendState;

  // 未读数量
  int unReadQuality;

  // 置顶
  int top;

  // 内容
  String content;

  // 消息类型
  int lastMsgType;

  // 原本json
  String rawData;

  // Not persisted:
  @Transient()
  int tempUsageCount = 0;

  TrudaConversationEntity(this.myId, this.herId, this.sendType, this.content,
      this.dateInsert, this.rawData,
      {this.id = 0, required this.lastMsgType, this.sendState = 0, this.unReadQuality = 0, this.top = 0})
      : groupId = "${myId}_$herId",
        msgId = "${myId}_${herId}_${dateInsert}";
}
