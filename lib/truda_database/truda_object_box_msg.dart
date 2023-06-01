import 'package:truda/truda_database/entity/truda_msg_entity.dart';
import 'package:truda/truda_services/newhita_event_bus_bean.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';

import '../truda_common/truda_constants.dart';
import '../truda_rtm/newhita_rtm_msg_entity.dart';
import '../objectbox.g.dart';
import 'entity/truda_conversation_entity.dart';
import 'entity/truda_her_entity.dart';

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
/// 有数据模型更新要执行下面语句 =>>
/// flutter pub run build_runner build
/// flutter pub run build_runner build --delete-conflicting-outputs
class TrudaObjectBoxMsg {
  /// The Store of this app.
  late final Store store;

  /// A Box of notes.
  late final Box<TrudaHerEntity> herBox;
  late final Box<TrudaMsgEntity> msgBox;
  late final Box<TrudaConversationEntity> conversationBox;

  /// A stream of all notes ordered by date.
  late final Stream<Query<TrudaHerEntity>> queryStream;

  String get _getMyId => (NewHitaMyInfoService.to.userLogin?.userId) ?? "emptyId";

  TrudaObjectBoxMsg._create(this.store) {
    herBox = Box<TrudaHerEntity>(store);
    msgBox = Box<TrudaMsgEntity>(store);
    conversationBox = Box<TrudaConversationEntity>(store);

    final qBuilder = herBox.query()
      ..order(TrudaHerEntity_.date, flags: Order.descending);
    queryStream = qBuilder.watch(triggerImmediately: true);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static TrudaObjectBoxMsg create(Store store) {
    // Future<Store> openStore() {...} is defined in the generated newhitaobjectbox.g.dart
    return TrudaObjectBoxMsg._create(store);
  }

  TrudaHerEntity? queryHer(String uid) {
    var queryBuilder = herBox.query(TrudaHerEntity_.uid.equals(uid));
    var query = queryBuilder.build();
    TrudaHerEntity? her = query.findUnique();
    query.close();
    return her;
  }

  void putOrUpdateHer(TrudaHerEntity her) {
    var queryBuilder = herBox.query(TrudaHerEntity_.uid.equals(her.uid));
    var query = queryBuilder.build();
    TrudaHerEntity? herOld = query.findUnique();
    query.close();
    if (herOld != null) {
      her.id = herOld.id;
    }
    // 有则更新，无则插入
    herBox.put(her);
  }

  /// 获取和主播聊天记录
  List<TrudaMsgEntity> queryHostMsgs(String herId, int time) {
    var queryBuilder = msgBox.query(TrudaMsgEntity_.myId.equals(_getMyId) &
        TrudaMsgEntity_.herId.equals(herId) &
        TrudaMsgEntity_.dateInsert.lessThan(time))
      ..order(TrudaMsgEntity_.dateInsert, flags: Order.descending);

    // offset偏移 limit限制
    var query = queryBuilder.build()
      // ..offset = 10
      ..limit = 10;
    List<TrudaMsgEntity> list = query.find();
    query.close();
    return list;
  }

  /// 获取和主播会话记录
  List<TrudaConversationEntity> queryHostCon(int time) {
    var queryBuilder = conversationBox.query(
        TrudaConversationEntity_.myId.equals(_getMyId) &
            TrudaConversationEntity_.dateInsert.lessThan(time))
      ..order(TrudaConversationEntity_.top, flags: Order.descending)
      ..order(TrudaConversationEntity_.dateInsert, flags: Order.descending);

    // offset偏移 limit限制
    var query = queryBuilder.build()
      // ..offset = 10
      ..limit = 100;
    List<TrudaConversationEntity> list = query.find();

    query.close();
    return list;
  }

  /// 把主播聊天设为已读
  void setRead(String herId) {
    var queryBuilder = msgBox.query(TrudaMsgEntity_.myId.equals(_getMyId) &
        TrudaMsgEntity_.herId.equals(herId));

    // offset偏移 limit限制
    var query = queryBuilder.build();
    // ..offset = 10
    //   ..limit = 10;
    List<TrudaMsgEntity> list = query.find();
    query.close();
    if (list.isEmpty) return;
    list = list.map((e) => e..readState = 0).toList();
    msgBox.putMany(list);

    // 更新会话
    var queryBuilder2 = conversationBox.query(
        TrudaConversationEntity_.myId.equals(_getMyId) &
            TrudaConversationEntity_.herId.equals(herId));
    var query2 = queryBuilder2.build();
    TrudaConversationEntity? con = query2.findUnique();
    query2.close();
    if (con != null) {
      NewHitaMyInfoService.to.msgUnreadNum.value -= con.unReadQuality;
      con.unReadQuality = 0;
      conversationBox.put(con);
    }
    NewHitaStorageService.to.eventBus.fire(NewHitaEventMsgClear(0));
  }

  /// 把所有主播聊天设为已读
  void setAllRead() {
    var queryBuilder = msgBox.query(TrudaMsgEntity_.myId.equals(_getMyId));

    // offset偏移 limit限制
    var query = queryBuilder.build();
    // ..offset = 10
    //   ..limit = 10;
    List<TrudaMsgEntity> list = query.find();
    query.close();
    if (list.isEmpty) return;
    list = list.map((e) => e..readState = 0).toList();
    msgBox.putMany(list);

    // 更新会话
    var queryBuilder2 =
        conversationBox.query(TrudaConversationEntity_.myId.equals(_getMyId));
    var query2 = queryBuilder2.build();
    List<TrudaConversationEntity> cons = query2.find();
    query2.close();
    if (cons.isNotEmpty) {
      for (var con in cons) {
        con.unReadQuality = 0;
      }
      conversationBox.putMany(cons);
    }
    NewHitaStorageService.to.eventBus.fire(NewHitaEventMsgClear(0));
    NewHitaMyInfoService.to.msgUnreadNum.value = 0;
  }

  ///
  void refreshUnreadNum() {
    // 更新会话
    var queryBuilder2 =
        conversationBox.query(TrudaConversationEntity_.myId.equals(_getMyId));
    var query2 = queryBuilder2.build();
    List<TrudaConversationEntity> cons = query2.find();
    query2.close();
    var num = 0;
    if (cons.isNotEmpty) {
      for (var con in cons) {
        num += con.unReadQuality;
      }
    }
    NewHitaMyInfoService.to.msgUnreadNum.value = num;
  }

  /// 清空所有聊天记录
  void clearAllMsg() {
    msgBox.removeAll();
    conversationBox.removeAll();
    NewHitaStorageService.to.eventBus.fire(NewHitaEventMsgClear(1));
    NewHitaMyInfoService.to.msgUnreadNum.value = 0;
  }

  /// 插入或更新聊天消息
  int insertOrUpdateMsg(TrudaMsgEntity msg, {bool setRead = false}) {
    // 当前是否在和她聊天，和她聊天当前消息已读，
    final bool chattingWithHer =
        NewHitaMyInfoService.to.chattingWithHer == msg.herId;
    // 收到的消息并且不在和她聊天，未读
    if (!setRead && msg.sendType == 1 && !chattingWithHer) {
      msg.readState = 1;
      NewHitaMyInfoService.to.msgUnreadNum.value += 1;
    } else {
      msg.readState = 0;
    }
    var id = msgBox.put(msg);
    // 插入了消息要更新会话
    var queryBuilder = conversationBox
        .query(TrudaConversationEntity_.groupId.equals(msg.groupId));
    var query = queryBuilder.build();
    List<int> ids = query.findIds();
    query.close();
    // 没有会话就新建一个
    TrudaConversationEntity con =
        _makeCon(msg, ids.isEmpty ? 0 : ids.first, chattingWithHer);
    // 根据id有则更新，无则插入
    conversationBox.putAsync(con, mode: PutMode.put).then((value) {
      // 事件总线发送有消息插入的事件
      NewHitaStorageService.to.eventBus.fire(msg);
    });
    return id;
  }

  /// id有值说明是更新，无值设为0会插入一条
  TrudaConversationEntity _makeCon(
      TrudaMsgEntity msg, int id, bool chattingWithHer) {
    TrudaConversationEntity con = TrudaConversationEntity(msg.myId, msg.herId,
        msg.sendType, msg.content, msg.dateInsert, msg.rawData,
        id: id,
        top: msg.herId == TrudaConstants.systemId ? 1 : 0,
        lastMsgType: msg.msgType);
    // 不是在和她聊天，就把未读消息更新
    if (!chattingWithHer) {
      var queryBuilder = msgBox.query(
          TrudaMsgEntity_.groupId.equals(msg.groupId) &
              TrudaMsgEntity_.readState.equals(1));
      var query = queryBuilder.build();
      // List<int> list = query.findIds();
      int size = query.count();
      query.close();
      con.unReadQuality = size;
    }
    return con;
  }

  /// 删除主播聊天记录
  void removeHer(String herId) {
    var queryBuilder = msgBox.query(TrudaMsgEntity_.myId.equals(_getMyId) &
        TrudaMsgEntity_.herId.equals(herId));
    var query = queryBuilder.build();
    List<int> list = query.findIds();
    query.close();
    msgBox.removeMany(list);

    var queryBuilder2 = conversationBox.query(
        TrudaConversationEntity_.myId.equals(_getMyId) &
            TrudaConversationEntity_.herId.equals(herId));
    var query2 = queryBuilder2.build();
    List<int> ids = query2.findIds();
    query2.close();
    conversationBox.removeMany(ids);
    NewHitaStorageService.to.eventBus.fire(NewHitaEventMsgClear(3));
    refreshUnreadNum();
  }


  /// 插入一个10000号的会话，给审核模式看
  Future<int> make10000() async {
    String myId = NewHitaMyInfoService.to.myDetail!.userId!;
    var queryBuilder = conversationBox
        .query(TrudaConversationEntity_.groupId.equals("${myId}_${TrudaConstants.serviceId}"));
    var query = queryBuilder.build();
    List<int> ids = query.findIds();
    query.close();
    bool black = NewHitaStorageService.to.checkBlackList(TrudaConstants.serviceId);
    // 被拉黑了就删除
    if (black) {
      if (ids.isNotEmpty) {
        conversationBox.removeMany(ids);
      }
      return 0;
    }
    // 插入一个
    if (ids.isNotEmpty) return 0;
    TrudaConversationEntity con = TrudaConversationEntity(myId, TrudaConstants.serviceId,
        1, '', DateTime.now().millisecondsSinceEpoch, '',
        id: 0,
        top: 2,
        lastMsgType: NewHitaRTMMsgText.typeCode);
    return await conversationBox.putAsync(con, mode: PutMode.put);
  }

}
