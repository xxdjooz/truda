import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../truda_rtm/truda_rtm_msg_entity.dart';

@Entity()
class NewHitaOrderEntity {
  // {
  //     "userId": "234545",
  //     "orderId": "42424",
  //     "productId": "42424",
  //     "price": "242.3",
  //     "currency": "USD",
  //     "payType": "ApplePay",
  //     "type": "Subscribe",
  //     "payTime": "42424242422",
  //     "orderCreateTime": "4242424"
  // }
  int id;
  String? userId;
  String? orderNo;
  String? productId;

  /// 单位是分
  String? price;
  String? currency;
  String? payType;

  // Subscribe、Diamond
  String? type;
  String? payTime;
  String? orderCreateTime;

  // 订单状态，0.待支付，1.已支付，2.已退单，3.已关闭
  int? orderStatus;
  bool? isUploadServer;

  // 插入库时间
  int dateInsert;

  NewHitaOrderEntity({
    this.id = 0,
    required this.userId,
    required this.orderNo,
    required this.productId,
    required this.price,
    required this.currency,
    required this.payType,
    required this.type,
    required this.payTime,
    required this.orderCreateTime,
    this.dateInsert = 0,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['orderNo'] = orderNo;
    data['price'] = price;
    data['currency'] = currency;
    data['payType'] = payType;
    data['type'] = type;
    data['payTime'] = payTime;
    data['orderCreateTime'] = orderCreateTime;
    return data;
  }
}
