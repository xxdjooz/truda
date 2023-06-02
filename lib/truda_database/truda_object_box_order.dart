import 'package:truda/truda_database/entity/truda_order_entity.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';

import '../objectbox.g.dart';

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
/// 有数据模型更新要执行下面语句 =>>
/// flutter pub run build_runner build
/// flutter pub run build_runner build --delete-conflicting-outputs
class TrudaObjectBoxOrder {
  /// The Store of this app.
  late final Store store;

  /// A Box of notes.
  late final Box<NewHitaOrderEntity> orderBox;

  String get _getMyId => (TrudaMyInfoService.to.userLogin?.userId) ?? "emptyId";

  TrudaObjectBoxOrder._create(this.store) {
    orderBox = Box<NewHitaOrderEntity>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static TrudaObjectBoxOrder create(Store store) {
    // Future<Store> openStore() {...} is defined in the generated newhitaobjectbox.g.dart
    return TrudaObjectBoxOrder._create(store);
  }

  List<NewHitaOrderEntity>? queryOrderList() {
    var queryBuilder = orderBox.query(NewHitaOrderEntity_.userId.equals(_getMyId));
    var query = queryBuilder.build();
    List<NewHitaOrderEntity>? list = query.find();
    query.close();
    return list;
  }

  NewHitaOrderEntity? queryOrder(String orderId) {
    var queryBuilder = orderBox.query(NewHitaOrderEntity_.orderNo.equals(orderId) &
        NewHitaOrderEntity_.userId.equals(_getMyId));
    var query = queryBuilder.build();
    NewHitaOrderEntity? order = query.findUnique();
    query.close();
    return order;
  }

  // 更新或者插入
  void putOrUpdateOrder(NewHitaOrderEntity order) {
    var queryBuilder = orderBox.query(
        NewHitaOrderEntity_.orderNo.equals(order.orderNo ?? '') &
            NewHitaOrderEntity_.userId.equals(_getMyId));
    var query = queryBuilder.build();
    NewHitaOrderEntity? orderOld = query.findUnique();
    query.close();
    if (orderOld != null) {
      order.id = orderOld.id;
    }
    // 有则更新，无则插入
    orderBox.put(order);
  }

  void updateOrderPayTime(String orderId) {
    var queryBuilder = orderBox.query(NewHitaOrderEntity_.orderNo.equals(orderId) &
        NewHitaOrderEntity_.userId.equals(_getMyId));
    var query = queryBuilder.build();
    NewHitaOrderEntity? orderOld = query.findUnique();
    query.close();
    if (orderOld != null) {
      orderOld.payTime = DateTime.now().millisecondsSinceEpoch.toString();
      orderBox.put(orderOld);
    }
  }

  void deleteOrderHadDone() {
    var queryBuilder = orderBox.query(
        NewHitaOrderEntity_.orderStatus.greaterThan(1) |
            NewHitaOrderEntity_.isUploadServer.equals(true));
    var query = queryBuilder.build();
    int aic = query.remove();
    query.close();
  }

  // ios 查找最近的一单
  void updateOrderPayTimeIos(String productId) {
    var queryBuilder = orderBox.query(
        NewHitaOrderEntity_.productId.equals(productId) &
            NewHitaOrderEntity_.userId.equals(_getMyId))
      ..order(NewHitaOrderEntity_.dateInsert);
    var query = queryBuilder.build();
    NewHitaOrderEntity? orderOld = query.findFirst();
    query.close();
    if (orderOld != null) {
      orderOld.payTime = DateTime.now().millisecondsSinceEpoch.toString();
      orderBox.put(orderOld);
    }
  }

//
// NewHitaOrderEntity? queryAicCanShow() {
//   var queryBuilder = orderBox.query(NewHitaOrderEntity_.playState.equals(1) &
//       NewHitaOrderEntity_.localPath.notNull())
//     ..order(NewHitaOrderEntity_.dateInsert);
//   var query = queryBuilder.build();
//   NewHitaOrderEntity? order = query.findFirst();
//   query.close();
//   return order;
// }

}
