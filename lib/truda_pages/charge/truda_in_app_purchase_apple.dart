import 'dart:async';

class TrudaAppleInAppPurchase {
  static final StreamController<int> _streamController =
      StreamController.broadcast(sync: false);
  // 0 notify成功，1
  static Stream<int> get resultStream => _streamController.stream;
  static initAppPurchase() async {}
  static fixNoEndPurchase() async {}
  static checkPurchaseAndPay(
      String productId, String orderNo, Function(bool) callBack) async {}
}

/// 这个注释上下是打包时要切换注释的，下面的是线上的
// import 'dart:async';
//
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
//
// import '../../truda_common/truda_language_key.dart';
// import '../../truda_http/truda_http_urls.dart';
// import '../../truda_http/truda_http_util.dart';
// import '../../truda_services/newhita_storage_service.dart';
// import '../../truda_utils/newhita_loading.dart';
// import '../../truda_utils/newhita_log.dart';
// import '../../truda_utils/newhita_pay_cache_manager.dart';
//
// class TrudaAppleInAppPurchase {
//   static final StreamController<int> _streamController =
//       StreamController.broadcast(sync: false);
//   // 0 notify成功，1
//   static Stream<int> get resultStream => _streamController.stream;
//
//   static final _appInAppPurchase = TrudaAppleInAppPurchase._intal();
//   static late final Stream purchaseUpdated;
//   static final String _notFoundProduct =
//       TrudaLanguageKey.newhita_google_billing_goods_not_find.tr;
//   static final String _purchaseError = TrudaLanguageKey.newhita_invoke_err.tr;
//   static final String _netError = TrudaLanguageKey.newhita_socket_net_error.tr;
//   static final String _OrderNotComplete =
//       TrudaLanguageKey.newhita_order_no_complete.tr;
//   static final String _BaseCancel = TrudaLanguageKey.newhita_base_cancel.tr;
//   static final String _OperateError = TrudaLanguageKey.newhita_invoke_err.tr;
//
//   TrudaAppleInAppPurchase._intal() {
//     purchaseUpdated = InAppPurchase.instance.purchaseStream;
//     purchaseUpdated.listen((purchaseDetailsList) {
//       NewHitaLog.debug("内购交易状态变动");
//
//       purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//         switch (purchaseDetails.status) {
//           case PurchaseStatus.pending:
//             NewHitaLog.debug("支付中...可用信息 productid ${purchaseDetails.productID}");
//             break;
//           case PurchaseStatus.purchased:
//             NewHitaLog.debug("付款成功");
//
//             NewHitaStorageService.to.objectBoxOrder
//                 .updateOrderPayTimeIos(purchaseDetails.productID);
//
//             if (purchaseDetails is AppStorePurchaseDetails) {
//               String serverVerificationData =
//                   purchaseDetails.verificationData.serverVerificationData;
//
//               NewHitaLog.debug("调用服务器接口 告诉接口支付完成");
//               NewHitaHttpUtil().post<void>(
//                 NewHitaHttpUrls.appleNotifyApi,
//                 data: {"receipt": serverVerificationData},
//                 errCallback: (e) {
//                   if (e.code > 0) {
//                     InAppPurchase.instance.completePurchase(purchaseDetails);
//                   }
//                   NewHitaLoading.toast(_netError);
//                 },
//               ).then((value) async {
//                 await InAppPurchase.instance.completePurchase(purchaseDetails);
//                 _whenNotifySuccess();
//               });
//               // NetRequestApis.requestVertifyApplePurchaseSign(
//               //     serverVerificationData, netSuccessCallback: (data) async {
//               //   NewHitaLoading.dismiss();
//               //
//               //   if (data.code == 0) {
//               //     await InAppPurchase.instance
//               //         .completePurchase(purchaseDetails);
//               //     _whenNotifySuccess();
//               //   } else {
//               //     NewHitaLog.debug("已完成的内购凭证提交给服务器接口 服务器返回验证失败 结束本次交易");
//               //     NewHitaLoading.toast(data.message ?? _netError);
//               //     await InAppPurchase.instance
//               //         .completePurchase(purchaseDetails);
//               //   }
//               // }, netErrorCallback: (e) {
//               //   NewHitaLog.debug("已完成的内购凭证提交给服务器接口失败");
//               //   NewHitaLoading.dismiss();
//               //   NewHitaLoading.toast(_OrderNotComplete);
//               // });
//             }
//             break;
//           case PurchaseStatus.error:
//             NewHitaLog.debug("报错的交易结束掉");
//             NewHitaLoading.dismiss();
//             NewHitaLoading.toast(purchaseDetails.error?.message ?? _OperateError);
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//             break;
//           case PurchaseStatus.restored:
//             NewHitaLog.debug("恢复订阅成功");
//             NewHitaLoading.dismiss();
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//             break;
//           case PurchaseStatus.canceled:
//             {
//               NewHitaLog.debug("取消的交易");
//               NewHitaLoading.dismiss();
//               NewHitaLoading.toast(_BaseCancel);
//               await InAppPurchase.instance.completePurchase(purchaseDetails);
//             }
//             break;
//           default:
//             NewHitaLog.debug("其他状态下的未完成交易");
//             NewHitaLoading.dismiss();
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//             break;
//         }
//       });
//     }, onDone: () {
//       NewHitaLoading.dismiss();
//       NewHitaLog.debug("ondone");
//     }, onError: (error) {
//       NewHitaLoading.dismiss();
//       NewHitaLog.debug(error);
//     });
//   }
//
//   factory TrudaAppleInAppPurchase() {
//     return _appInAppPurchase;
//   }
//
//   static initAppPurchase() async {
//     TrudaAppleInAppPurchase();
//     NewHitaLog.debug("苹果内购初始化完成");
//   }
//
//   static _whenNotifySuccess() {
//     _streamController.add(0);
//     NewHitaLog.debug("用户充值成功 刷新用户数据");
//     // AppNetCacheService.to.requestLastSimpleUserData();
//
//     NewHitaLog.debug("内购用户充值成功 刷新优惠充值数据");
//     // refreshAndCacheDiscountRecharge();
//
//     NewHitaLog.debug("一笔订单支付完成 查询本地未支付订单数据 上报至服务器");
//     // AppDataBaseService.to.queryAllWaitPayOrderDatas(requestServer: true);
//     NewHitaPayCacheManager.checkOrderList();
//   }
//
//   static fixNoEndPurchase() async {
//     NewHitaLog.debug("进行补单逻辑");
//
//     //获取购买过的 未结束的交易
//     List<SKPaymentTransactionWrapper> transactions =
//         await SKPaymentQueueWrapper().transactions();
//     NewHitaLog.debug("iOS 进行补单逻辑 fixNoEndPurchase");
//
//     for (SKPaymentTransactionWrapper element in transactions) {
//       if (element.transactionState ==
//           SKPaymentTransactionStateWrapper.purchased) {
//         NewHitaLog.debug("有一笔付款的订单交易 未完成 进行补单操作");
//
//         //TEST DATA 结束所有交易 删除本地所有订单缓存
//         // SKPaymentQueueWrapper().finishTransaction(element);
//         // LocalStore.clearOrderCache();
//         // return;
//
//         String serverVerificationData =
//             await SKReceiptManager.retrieveReceiptData();
//
//         NewHitaLog.debug("调用服务器接口 告诉接口支付完成");
//         NewHitaHttpUtil().post<void>(
//           NewHitaHttpUrls.appleNotifyApi,
//           data: {"receipt": serverVerificationData},
//           errCallback: (e) {
//             if (e.code > 0) {
//               SKPaymentQueueWrapper().finishTransaction(element);
//             }
//             NewHitaLoading.toast(_netError);
//           },
//         ).then((value) async {
//           await SKPaymentQueueWrapper().finishTransaction(element);
//           _whenNotifySuccess();
//         });
//         // NetRequestApis.requestVertifyApplePurchaseSign(serverVerificationData,
//         //     showLoading: true, netSuccessCallback: (data) async {
//         //   NewHitaLoading.dismiss();
//         //
//         //   if (data.code == 0) {
//         //     await SKPaymentQueueWrapper().finishTransaction(element);
//         //     _whenNotifySuccess();
//         //   } else {
//         //     NewHitaLog.debug("已完成的内购凭证提交给服务器接口 服务器返回验证失败 结束本次交易");
//         //     NewHitaLoading.toast(data.message ?? _netError);
//         //     await SKPaymentQueueWrapper().finishTransaction(element);
//         //   }
//         // }, netErrorCallback: (e) {
//         //   NewHitaLog.debug("已完成的内购凭证提交给服务器接口失败");
//         //   NewHitaLoading.dismiss();
//         //   NewHitaLoading.toast(_OrderNotComplete);
//         // });
//       }
//     }
//   }
//
//   /// 是否有未完成的交易
//   static Future<void> checkUnCompletePurchases(Function(bool) callBack) async {
//     List<SKPaymentTransactionWrapper> notCompleteTransactions =
//         <SKPaymentTransactionWrapper>[];
//
//     List<SKPaymentTransactionWrapper> transactions =
//         await SKPaymentQueueWrapper().transactions();
//
//     for (SKPaymentTransactionWrapper element in transactions) {
//       if (element.transactionState ==
//           SKPaymentTransactionStateWrapper.purchased) {
//         notCompleteTransactions.add(element);
//       } else {
//         NewHitaLog.debug("未支付的交易全部取消");
//         await SKPaymentQueueWrapper().finishTransaction(element);
//       }
//     }
//
//     if (notCompleteTransactions.isNotEmpty) {
//       callBack.call(true);
//
//       NewHitaLoading.toast(_OrderNotComplete);
//       fixNoEndPurchase();
//     }
//     callBack.call(false);
//   }
//
//   /// 核查苹果内购能否被调起(未完成交易检查 商品信息检查)
//   static checkAppleInAppPurchase(String productId,
//       Function(bool, ProductDetails?) callBackInAppPurchaseProduct) async {
//     TrudaAppleInAppPurchase.checkUnCompletePurchases((hasUnComplete) async {
//       if (hasUnComplete == true) {
//         NewHitaLog.debug("有未完成的交易 本次内购请求取消");
//         callBackInAppPurchaseProduct.call(false, null);
//       } else {
//         NewHitaLog.debug("开始本次内购请求");
//         final bool available = await InAppPurchase.instance.isAvailable();
//
//         if (available == true) {
//           final ProductDetailsResponse goodQueryResult =
//               await InAppPurchase.instance.queryProductDetails({productId});
//
//           if (goodQueryResult.productDetails.isNotEmpty) {
//             NewHitaLog.debug("确认内购商品信息正确后 创建订单 再调起内购");
//             callBackInAppPurchaseProduct.call(
//                 true, goodQueryResult.productDetails.first);
//           } else {
//             callBackInAppPurchaseProduct.call(false, null);
//             NewHitaLoading.toast(_notFoundProduct);
//           }
//         } else {
//           callBackInAppPurchaseProduct.call(false, null);
//           NewHitaLoading.toast(_purchaseError);
//           TrudaAppleInAppPurchase.initAppPurchase();
//         }
//       }
//     });
//   }
//
//   static void callInAppPurchasePay(
//       ProductDetails productDetails, String orderNo) {
//     final PurchaseParam inAppPurchasePara = PurchaseParam(
//         productDetails: productDetails, applicationUserName: orderNo);
//
//     InAppPurchase.instance.buyConsumable(purchaseParam: inAppPurchasePara);
//   }
//
//   /// 核查苹果内购能否被调起並支付
//   static checkPurchaseAndPay(
//       String productId, String orderNo, Function(bool) callBack) async {
//     NewHitaLoading.show();
//     TrudaAppleInAppPurchase.checkUnCompletePurchases((hasUnComplete) async {
//       if (hasUnComplete == true) {
//         NewHitaLog.debug("有未完成的交易 本次内购请求取消");
//         callBack.call(false);
//         NewHitaLoading.dismiss();
//       } else {
//         NewHitaLog.debug("开始本次内购请求");
//         final bool available = await InAppPurchase.instance.isAvailable();
//
//         if (available == true) {
//           final ProductDetailsResponse goodQueryResult =
//               await InAppPurchase.instance.queryProductDetails({productId});
//
//           if (goodQueryResult.productDetails.isNotEmpty) {
//             NewHitaLog.debug("确认内购商品信息 调起内购");
//             callInAppPurchasePay(goodQueryResult.productDetails.first, orderNo);
//           } else {
//             callBack.call(false);
//             NewHitaLoading.toast(_notFoundProduct);
//             NewHitaLoading.dismiss();
//           }
//         } else {
//           callBack.call(false);
//           NewHitaLoading.toast(_purchaseError);
//           TrudaAppleInAppPurchase.initAppPurchase();
//           NewHitaLoading.dismiss();
//         }
//       }
//     });
//   }
// }
