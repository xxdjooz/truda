import 'dart:convert';

import 'package:truda/truda_http/newhita_http_util.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:truda/truda_utils/newhita_pay_event_track.dart';

import '../truda_database/entity/truda_order_entity.dart';
import '../truda_entities/truda_order_check_entity.dart';
import '../truda_http/newhita_http_urls.dart';

class NewHitaPayCacheManager {
  // 检查缓存的订单，支付成功的上报后台和三方平台
  static checkOrderList() async {
    List<NewHitaOrderEntity>? list =
        NewHitaStorageService.to.objectBoxOrder.queryOrderList();
    if (list == null || list.isEmpty) {
      return;
    }
    var orderIds = <String>[];
    var orderMap = <String, NewHitaOrderEntity>{};
    for (var element in list) {
      //订单支付状态未知 或者 待支付的订单 调用接口获取最新状态
      if (element.orderStatus == null || element.orderStatus == 0) {
        orderIds.add(element.orderNo ?? '');
        orderMap[element.orderNo ?? ''] = element;
      } else if (element.orderStatus == 3) {
        //支付失败的订单
      } else if (element.orderStatus == 1) {
        //支付成功的订单 未上传至服务器
        if (element.isUploadServer != true) {
          submitToServer(element);
        }
      }
    }
    if (orderMap.isEmpty) return;
    NewHitaHttpUtil().post<List<TrudaOrderCheckEntity>>(
        NewHitaHttpUrls.getOrderStatusApi,
        data: {'orderNos': orderIds}).then((value) {
      for (var orderCheck in value) {
        var ord = orderMap[orderCheck.orderNo];
        if (ord != null) {
          ord.orderStatus = orderCheck.orderStatus;
          NewHitaStorageService.to.objectBoxOrder.orderBox.put(ord);
          if (ord.orderStatus == 1 && ord.isUploadServer != true) {
            submitToServer(ord);
          }
        }
      }
    });
  }

  static submitToServer(NewHitaOrderEntity orderEntity) {
    NewHitaHttpUtil()
        .post<void>(NewHitaHttpUrls.uploadLogApi, data: orderEntity.toJson())
        .then((value) {
      orderEntity.isUploadServer = true;
      NewHitaStorageService.to.objectBoxOrder.orderBox.put(orderEntity);
      NewHitaPayEventTrack.instance.trackPay(orderEntity);
    });
  }

  static clearValidOrder() async {
    NewHitaStorageService.to.objectBoxOrder.deleteOrderHadDone();
    // CblOrderUploadLogEntity? orderUploadLogEntity =
    // await CblLocalStore.createOrderList;
    // List<CblOrderUploadLogOrderlist>? orderList =
    //     orderUploadLogEntity?.orderlist;
    //
    // List validOrderList = [];
    // orderList?.forEach((element) {
    //   //支付状态是失败的订单 或者 已经传入服务器的订单 均删除
    //   if (element.payStatus == 3 || element.isUploadServer == true) {
    //     validOrderList.add(element);
    //   }
    // });
    // validOrderList.forEach((element) {
    //   orderList?.remove(element);
    // });
    // CblLocalStore.resetOrderList(orderUploadLogEntity);
  }
}
