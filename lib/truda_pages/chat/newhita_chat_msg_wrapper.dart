import 'package:truda/truda_database/entity/truda_her_entity.dart';

import '../../truda_database/entity/truda_msg_entity.dart';

/// 用于显示消息的bean的封装
class NewHitaChatMsgWrapper {
  TrudaMsgEntity msgEntity;

  // 时间
  int date;

  // 要显示时间？
  bool showTime = false;

  // 是收到的？
  bool herSend;

  TrudaHerEntity? her;
  String herId;

  NewHitaChatMsgWrapper(this.msgEntity, this.herSend, this.date,
      {this.her, this.showTime = false, required this.herId});
}
