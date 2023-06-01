import 'dart:convert';

import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../truda_rtm/newhita_rtm_msg_entity.dart';
import '../truda_services/newhita_storage_service.dart';
import '../objectbox.g.dart';
import 'entity/truda_aic_entity.dart';
import 'entity/truda_call_entity.dart';
import 'entity/truda_msg_entity.dart';

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
/// 有数据模型更新要执行下面语句 =>>
/// flutter pub run build_runner build
/// flutter pub run build_runner build --delete-conflicting-outputs
class TrudaObjectBoxCall {
  /// The Store of this app.
  late final Store store;

  /// A Box of notes.
  late final Box<TrudaAicEntity> aicBox;
  late final Box<TrudaCallEntity> callBox;

  String get _getMyId => (NewHitaMyInfoService.to.userLogin?.userId) ?? "emptyId";

  TrudaObjectBoxCall._create(this.store) {
    aicBox = Box<TrudaAicEntity>(store);
    callBox = Box<TrudaCallEntity>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static TrudaObjectBoxCall create(Store store) {
    // Future<Store> openStore() {...} is defined in the generated newhitaobjectbox.g.dart
    return TrudaObjectBoxCall._create(store);
  }

  List<TrudaAicEntity>? queryAicList() {
    var queryBuilder = aicBox.query();
    var query = queryBuilder.build();
    List<TrudaAicEntity>? list = query.find();
    query.close();
    return list;
  }

  TrudaAicEntity? queryAic(String url) {
    var queryBuilder = aicBox.query(TrudaAicEntity_.filename.equals(url));
    var query = queryBuilder.build();
    TrudaAicEntity? aic = query.findUnique();
    query.close();
    return aic;
  }

  void deleteAicHadShow() {
    var queryBuilder = aicBox.query(TrudaAicEntity_.playState.greaterThan(1));
    var query = queryBuilder.build();
    int aic = query.remove();
    query.close();
  }

  TrudaAicEntity? queryAicCanShow() {
    var queryBuilder = aicBox.query(
        TrudaAicEntity_.playState.equals(1) & TrudaAicEntity_.localPath.notNull())
      ..order(TrudaAicEntity_.dateInsert);
    var query = queryBuilder.build();
    TrudaAicEntity? aic = query.findFirst();
    query.close();
    return aic;
  }

  TrudaAicEntity? queryAicCanShowExcept(String userId) {
    var queryBuilder = aicBox.query(TrudaAicEntity_.playState.equals(1) &
        TrudaAicEntity_.localPath.notNull() &
        //查询不等于 上一次触发的ai 的user id
        TrudaAicEntity_.userId.notEquals(userId))
      ..order(TrudaAicEntity_.dateInsert);
    var query = queryBuilder.build();
    TrudaAicEntity? aic = query.findFirst();
    query.close();
    return aic;
  }

  void putOrUpdateAic(TrudaAicEntity aic) {
    var queryBuilder =
        aicBox.query(TrudaAicEntity_.aicId.equals(aic.aicId ?? 0));
    var query = queryBuilder.build();
    TrudaAicEntity? aicOld = query.findUnique();
    query.close();
    if (aicOld != null) {
      aic.id = aicOld.id;
    }
    // 有则更新，无则插入
    aicBox.put(aic);
  }

  /// 获取和主播会话记录
  List<TrudaCallEntity> queryCallHistory(int time) {
    var queryBuilder = callBox.query(TrudaCallEntity_.myId.equals(_getMyId) &
        TrudaCallEntity_.dateInsert.lessThan(time))
      ..order(TrudaCallEntity_.dateInsert, flags: Order.descending);

    // offset偏移 limit限制
    var query = queryBuilder.build()
      // ..offset = 10
      ..limit = 20;
    List<TrudaCallEntity> list = query.find();

    query.close();
    return list;
  }

  /// callType 0拨打，1被叫，
  /// 2aib拨打(aib是被叫页面，实际是要去拨打),
  /// 3aic
  void savaCallHistory({
    required String herId,
    required String herVirtualId,
    required String channelId,
    required int callType,
    required int callStatus,
    required int dateInsert,
    required String duration,
    String extra = '',
  }) {
    // 老的存单独的数据库的通话消息
    TrudaCallEntity entity = TrudaCallEntity(
        myId: _getMyId,
        herId: herId,
        herVirtualId: herVirtualId,
        channelId: channelId,
        callType: callType,
        callStatus: callStatus,
        dateInsert: dateInsert,
        duration: duration,
        extra: extra);
    callBox.put(entity);
    // 插入消息数据库
    NewHitaLog.debug('savaCallHistory duration=$duration');
    var call = NewHitaRTMMsgCallState()
      ..statusType = callStatus
      ..duration = duration;
    TrudaMsgEntity msgEntity = TrudaMsgEntity(
      _getMyId,
      herId,
      callType > 0 ? 1 : 0,
      "",
      dateInsert,
      json.encode(call),
      NewHitaRTMMsgCallState.typeCode,
    );
    NewHitaStorageService.to.objectBoxMsg
        .insertOrUpdateMsg(msgEntity, setRead: true);
  }
}
