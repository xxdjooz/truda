import 'package:truda/truda_entities/truda_charge_entity.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../../truda_entities/truda_charge_quick_entity.dart';

class TrudaGoogleBilling {
  static Future correctCutGooglePrice(TrudaPayCutCommodite product) async {
    return;
  }

  static fixNoEndPurchase() async {}

  static Future correctGooglePrice(List<TrudaPayChannelBean> list) async {
    return;
  }

  static Future correctShopGooglePrice(List<TrudaPayQuickCommodite> list) async {
    return;
  }

  static void getDefaultSkuDetails(List<String> idList) async {}
  static void getGooglePrice() {}

  static callPay(String? productId, String? orderNo) async {}

  static Future<bool> correctQuickGooglePrice(
      TrudaPayQuickChannel channel) async {
    NewHitaLog.debug(channel);
    return false;
  }
}

/// 这个注释上下是打包时要切换注释的，下面的是线上的
// import 'package:get/get.dart';
// import 'package:truda/truda_common/truda_language_key.dart';
// import 'package:truda/truda_entities/truda_charge_entity.dart';
// import 'package:truda/truda_entities/truda_charge_quick_entity.dart';
// import 'package:truda/truda_http/truda_http_urls.dart';
// import 'package:truda/truda_http/truda_http_util.dart';
// import 'package:truda/truda_services/truda_my_info_service.dart';
// import 'package:truda/truda_services/truda_storage_service.dart';
// import 'package:truda/truda_utils/newhita_loading.dart';
// import 'package:truda/truda_utils/newhita_log.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
//
// import '../../truda_common/truda_constants.dart';
// import '../../truda_utils/newhita_billing_err_statistics.dart';
//
// class TrudaGoogleBilling {
//   static BillingClient billingClient =
//       BillingClient((PurchasesResultWrapper purchasesResult) {
//     if (purchasesResult.responseCode == BillingResponse.ok) {
//       purchasesResult.purchasesList.forEach((purchaseWrapper) {
//         TrudaGoogleBilling.consumeAsync(purchaseWrapper);
//       });
//     } else {
//       NewHitaLog.debug(
//           'TrudaGoogleBilling purchasesResult err ${purchasesResult.responseCode}');
//       final code =
//           const BillingResponseConverter().toJson(purchasesResult.responseCode);
//       NewHitaBillingErrStatistics.err(code);
//     }
//   });
//
//   //google in app purchase 结束该交易
//   static consumeAsync(PurchaseWrapper purchaseWrapper,
//       {bool isFixOrder = false}) async {
//     //google pay 确认api 防止3天自动退款
//     if (purchaseWrapper.purchaseState == PurchaseStateWrapper.purchased) {
//       billingClient.acknowledgePurchase(purchaseWrapper.purchaseToken);
//       var orderId = purchaseWrapper.obfuscatedProfileId;
//       if (orderId != null) {
//         NewHitaStorageService.to.objectBoxOrder.updateOrderPayTime(orderId);
//       }
//     }
//
//     NewHitaHttpUtil().post<void>(
//       NewHitaHttpUrls.googleNotifyApi,
//       data: {
//         "signature": purchaseWrapper.signature,
//         "jsonPurchaseInfo": purchaseWrapper.originalJson,
//         "isfixorder": isFixOrder,
//       },
//       errCallback: (e) {
//         NewHitaBillingErrStatistics.err(NewHitaBillingErrStatistics.googleNotifyErr);
//       },
//     ).then((value) {
//       billingClient
//           .consumeAsync(purchaseWrapper.purchaseToken)
//           .then((BillingResultWrapper result) {
//         if (result.responseCode != BillingResponse.ok) {
//           NewHitaBillingErrStatistics.err(NewHitaBillingErrStatistics.consumeErr);
//         }
//       });
//       // todo
//       // CblPayManager().payCallBack.call();
//     });
//   }
//
//   static fixNoEndPurchase() async {
//     BillingResultWrapper connection_billingResultWrapper = await billingClient
//         .startConnection(onBillingServiceDisconnected: () {});
//     if (connection_billingResultWrapper.responseCode == BillingResponse.ok) {
//       //获取购买过的 未结束的交易
//       PurchasesResultWrapper purchasesResultWrapper =
//           await billingClient.queryPurchases(SkuType.inapp);
//       NewHitaLog.debug(
//           'TrudaGoogleBilling fixNoEndPurchase ${purchasesResultWrapper.purchasesList.length}');
//       purchasesResultWrapper.purchasesList.forEach((purchaseWrapper) {
//         //  调用接口获取该交易的状态 成功则结束该交易
//         NewHitaLog.debug("执行补单操作 ${purchaseWrapper.originalJson}");
//         TrudaGoogleBilling.consumeAsync(purchaseWrapper, isFixOrder: true);
//       });
//     } else {
//       NewHitaLog.debug(
//           'TrudaGoogleBilling fixNoEndPurchase ${connection_billingResultWrapper.responseCode}');
//     }
//   }
//
//   static callPay(String? productId, String? orderNo) async {
//     if (productId == null) {
//       NewHitaLoading.toast(TrudaLanguageKey.newhita_invoke_err.tr);
//       NewHitaBillingErrStatistics.err(NewHitaBillingErrStatistics.productIdNull);
//       return;
//     }
//     if (orderNo == null) {
//       NewHitaLoading.toast(TrudaLanguageKey.newhita_err_unknown.tr);
//       NewHitaBillingErrStatistics.err(NewHitaBillingErrStatistics.orderNoNull);
//       return;
//     }
//
//     BillingResultWrapper connection_billingResultWrapper = await billingClient
//         .startConnection(onBillingServiceDisconnected: () {});
//     if (connection_billingResultWrapper.responseCode == BillingResponse.ok) {
//       // productId = "60001";
//
//       SkuDetailsResponseWrapper skuDetailsResponseWrapper = await billingClient
//           .querySkuDetails(skuType: SkuType.inapp, skusList: [productId]);
//       if (skuDetailsResponseWrapper.skuDetailsList.length <= 0) {
//         NewHitaLoading.toast(
//             TrudaLanguageKey.newhita_google_billing_goods_not_find.tr);
//         NewHitaBillingErrStatistics.err(NewHitaBillingErrStatistics.productNotFound);
//       } else {
//         SkuDetailsWrapper skuDetailsWrapper =
//             skuDetailsResponseWrapper.skuDetailsList.first;
//
//         BillingResultWrapper billingResultWrapper =
//             await billingClient.launchBillingFlow(
//           sku: skuDetailsWrapper.sku,
//           accountId: NewHitaMyInfoService.to.myDetail?.userId,
//           obfuscatedProfileId: orderNo,
//         );
//         if (billingResultWrapper.responseCode == BillingResponse.ok) {
//           NewHitaLog.debug('TrudaGoogleBilling ok');
//         } else {
//           NewHitaLog.debug(
//               'TrudaGoogleBilling err ${billingResultWrapper.responseCode}');
//           NewHitaBillingErrStatistics.err(
//               NewHitaBillingErrStatistics.launchBillingErr);
//         }
//       }
//     } else {
//       NewHitaLoading.toast(TrudaLanguageKey.newhita_google_billing_init_failure.tr);
//       NewHitaBillingErrStatistics.err(NewHitaBillingErrStatistics.connectErr);
//     }
//   }
//
//   static void getDefaultSkuDetails(List<String> idList) async {
//     BillingResultWrapper connection_billingResultWrapper = await billingClient
//         .startConnection(onBillingServiceDisconnected: () {});
//     if (connection_billingResultWrapper.responseCode == BillingResponse.ok) {
//       // productId = "60001";
//       SkuDetailsResponseWrapper skuDetailsResponseWrapper = await billingClient
//           .querySkuDetails(skuType: SkuType.inapp, skusList: idList);
//       if (skuDetailsResponseWrapper.skuDetailsList.isEmpty) {
//         NewHitaLog.debug('GoogleBilling getDefaultSkuDetails isEmpty');
//       } else {
//         _skuDetailsWrappers = skuDetailsResponseWrapper.skuDetailsList;
//         NewHitaLog.debug(
//             'GoogleBilling getDefaultSkuDetails size=${_skuDetailsWrappers?.length}');
//       }
//     }
//   }
//
//   // 获取到的Google商品
//   static List<SkuDetailsWrapper>? _skuDetailsWrappers;
//
//   // 接口的商品id
//   static List<String>? _ids;
//
//   static Future<List<SkuDetailsWrapper>?> getSkuDetailsWrappers(
//       {List<String>? idList}) async {
//     if (_skuDetailsWrappers != null) {
//       NewHitaLog.debug('correctGooglePrice from cache');
//       return _skuDetailsWrappers;
//     }
//     if (idList == null || idList.isEmpty) return null;
//     _ids = idList;
//     BillingResultWrapper connection_billingResultWrapper = await billingClient
//         .startConnection(onBillingServiceDisconnected: () {});
//     if (connection_billingResultWrapper.responseCode == BillingResponse.ok) {
//       // productId = "60001";
//       SkuDetailsResponseWrapper skuDetailsResponseWrapper = await billingClient
//           .querySkuDetails(skuType: SkuType.inapp, skusList: _ids!);
//       if (skuDetailsResponseWrapper.skuDetailsList.isEmpty) {
//         return null;
//       } else {
//         NewHitaLog.debug('correctGooglePrice from net');
//         _skuDetailsWrappers = skuDetailsResponseWrapper.skuDetailsList;
//         return skuDetailsResponseWrapper.skuDetailsList;
//       }
//     } else {
//       return null;
//     }
//   }
//
//   // 更正Google商品价格
//   static Future correctGooglePrice(List<NewHitaPayChannelBean> list) async {
//     for (var element in list) {
//       // 这个是Google的商品
//       if (element.payType == 1) {
//         var products = element.commodities;
//         if (products == null) return;
//         var ids = products.map((e) => e.productCode!).toList();
//         var map = {for (var e in products) e.productCode!: e};
//         NewHitaLog.debug('correctGooglePrice $ids');
//         // BillingResultWrapper connection_billingResultWrapper =
//         //     await billingClient.startConnection(
//         //         onBillingServiceDisconnected: () {});
//         // if (connection_billingResultWrapper.responseCode ==
//         //     BillingResponse.ok) {
//         //   // productId = "60001";
//         //   SkuDetailsResponseWrapper skuDetailsResponseWrapper =
//         //       await billingClient.querySkuDetails(
//         //           skuType: SkuType.inapp, skusList: ids);
//         var skuWrappers = await getSkuDetailsWrappers(idList: ids);
//         if (skuWrappers == null || skuWrappers.isEmpty) {
//           return;
//         } else {
//           for (var skuDetaail in skuWrappers) {
//             NewHitaLog.debug('correctGooglePrice sku=${skuDetaail.sku}'
//                 ' priceAmountMicros=${skuDetaail.priceAmountMicros}'
//                 ' priceCurrencySymbol=${skuDetaail.priceCurrencySymbol}'
//                 ' priceCurrencyCode=${skuDetaail.priceCurrencyCode}');
//             var product = map[skuDetaail.sku];
//             // product?.googlePrice = it.priceAmountMicros/10000
//             // product?.googleCurrencyCode = it.priceCurrencyCode
//             product?.googlePrice = skuDetaail.priceAmountMicros ~/ 10000;
//             product?.googleCurrencyCode = skuDetaail.priceCurrencyCode;
//             // product?.googleCurrencySymbol = skuDetaail.priceCurrencySymbol;
//           }
//         }
//       } else {
//         return;
//       }
//     }
//   }
//
//   static Map<String, SkuDetailsWrapper> _cutMap = {};
//
//   // 更正折扣Google商品价格
//   static Future correctCutGooglePrice(NewHitaPayCutCommodite product) async {
//     var skuDet = _cutMap[product.productCode!];
//     if (skuDet != null) {
//       NewHitaLog.debug('correctGooglePrice from cache');
//       product.googlePrice = skuDet.priceAmountMicros ~/ 10000;
//       product.googleCurrencyCode = skuDet.priceCurrencyCode;
//       // product.googleCurrencySymbol = skuDet.priceCurrencySymbol;
//       return;
//     }
//     BillingResultWrapper connection_billingResultWrapper = await billingClient
//         .startConnection(onBillingServiceDisconnected: () {});
//     if (connection_billingResultWrapper.responseCode == BillingResponse.ok) {
//       // productId = "60001";
//       SkuDetailsResponseWrapper skuDetailsResponseWrapper = await billingClient
//           .querySkuDetails(
//               skuType: SkuType.inapp, skusList: [product.productCode!]);
//       var _skuWrappers = skuDetailsResponseWrapper.skuDetailsList;
//       if (_skuWrappers.isEmpty) {
//         return;
//       } else {
//         NewHitaLog.debug('correctGooglePrice from net');
//         var skuDetaail = _skuWrappers.first;
//         _cutMap[product.productCode!] = skuDetaail;
//         product.googlePrice = skuDetaail.priceAmountMicros ~/ 10000;
//         product.googleCurrencyCode = skuDetaail.priceCurrencyCode;
//         // product.googleCurrencySymbol = skuDetaail.priceCurrencySymbol;
//       }
//     } else {
//       return;
//     }
//   }
//
//   // 更正折扣Google商品价格
//   static Future<bool> correctQuickGooglePrice(
//       NewHitaPayQuickChannel channel) async {
//     var skuDet = _cutMap[channel.productCode!];
//     if (skuDet != null) {
//       NewHitaLog.debug('correctGooglePrice from cache');
//       channel.googlePrice = skuDet.priceAmountMicros ~/ 10000;
//       channel.googleCurrencyCode = skuDet.priceCurrencyCode;
//       // product.googleCurrencySymbol = skuDet.priceCurrencySymbol;
//       return true;
//     }
//     BillingResultWrapper connection_billingResultWrapper = await billingClient
//         .startConnection(onBillingServiceDisconnected: () {});
//     if (connection_billingResultWrapper.responseCode == BillingResponse.ok) {
//       // productId = "60001";
//       SkuDetailsResponseWrapper skuDetailsResponseWrapper = await billingClient
//           .querySkuDetails(
//               skuType: SkuType.inapp, skusList: [channel.productCode!]);
//       var _skuWrappers = skuDetailsResponseWrapper.skuDetailsList;
//       if (_skuWrappers.isEmpty) {
//         return false;
//       } else {
//         NewHitaLog.debug('correctGooglePrice from net');
//         var skuDetaail = _skuWrappers.first;
//         _cutMap[channel.productCode!] = skuDetaail;
//         channel.googlePrice = skuDetaail.priceAmountMicros ~/ 10000;
//         channel.googleCurrencyCode = skuDetaail.priceCurrencyCode;
//         // product.googleCurrencySymbol = skuDetaail.priceCurrencySymbol;
//         return true;
//       }
//     } else {
//       return false;
//     }
//   }
//
//   // 更正Google商品价格
//   static Future correctShopGooglePrice(List<NewHitaPayQuickCommodite> list) async {
//     List<String> ids = [];
//     List<NewHitaPayQuickChannel> channels = [];
//     // 数据结构是每个商品有很多渠道
//     // 遍历每个商品的渠道列表的google渠道
//     for (var element in list) {
//       if (element.channelPays == null) continue;
//       for (var chann in element.channelPays!) {
//         if (chann.payType == 1) {
//           ids.add(chann.productCode!);
//           channels.add(chann);
//         }
//       }
//     }
//     var skuWrappers = await getSkuDetailsWrappers(idList: ids);
//     if (skuWrappers == null || skuWrappers.isEmpty) {
//       return;
//     } else {
//       // for (var skuDetaail in skuWrappers) {
//       //   NewHitaLog.debug('correctGooglePrice sku=${skuDetaail.sku}'
//       //       ' priceAmountMicros=${skuDetaail.priceAmountMicros}'
//       //       ' priceCurrencySymbol=${skuDetaail.priceCurrencySymbol}'
//       //       ' priceCurrencyCode=${skuDetaail.priceCurrencyCode}');
//       //
//       //   var chann = map[skuDetaail.sku];
//       //   // chann?.googlePrice = it.priceAmountMicros/10000
//       //   // chann?.googleCurrencyCode = it.priceCurrencyCode
//       //   chann?.googlePrice = skuDetaail.priceAmountMicros ~/ 10000;
//       //   chann?.googleCurrencyCode = skuDetaail.priceCurrencyCode;
//       //   // chann?.googleCurrencySymbol = skuDetaail.priceCurrencySymbol;
//       // }
//       final map = {for (var item in skuWrappers) item.sku: item};
//       for (var chann in channels) {
//         var wrapper = map[chann.productCode ?? ''];
//         if (wrapper != null) {
//           chann.googlePrice = wrapper.priceAmountMicros ~/ 10000;
//           chann.googleCurrencyCode = wrapper.priceCurrencyCode;
//         }
//       }
//     }
//   }
//
//   static final Set<String> _defaultIds = {
//     '${NewHitaConstants.appNameLower}199',
//     '${NewHitaConstants.appNameLower}299',
//     '${NewHitaConstants.appNameLower}399',
//     '${NewHitaConstants.appNameLower}499',
//     '${NewHitaConstants.appNameLower}599',
//     '${NewHitaConstants.appNameLower}699',
//     '${NewHitaConstants.appNameLower}749',
//     '${NewHitaConstants.appNameLower}799',
//     '${NewHitaConstants.appNameLower}1999',
//     '${NewHitaConstants.appNameLower}2099',
//     '${NewHitaConstants.appNameLower}3699',
//     '${NewHitaConstants.appNameLower}3899',
//     '${NewHitaConstants.appNameLower}4999',
//     '${NewHitaConstants.appNameLower}7399',
//     '${NewHitaConstants.appNameLower}7749',
//     '${NewHitaConstants.appNameLower}9999',
//     '${NewHitaConstants.appNameLower}14699',
//     '${NewHitaConstants.appNameLower}15399',
//   };
//   //  缓存google后台的商品价格
//   static void getGooglePrice() {
//     // _defaultIds 有18个配置的，但是不保证后来会增加，所以用接口查询一下
//     NewHitaHttpUtil()
//         .post<NewHitaPayQuickData>(
//       NewHitaHttpUrls.getCompositeProduct + '2',
//       errCallback: (err) {},
//     )
//         .then((value) {
//       List<NewHitaPayQuickCommodite>? allProducts = value.normalProducts;
//       NewHitaPayQuickCommodite? cutCommodite = value.discountProduct;
//       List<NewHitaPayQuickCommodite> allList = [];
//
//       if (allProducts != null) {
//         allList.addAll(allProducts);
//       }
//       if (cutCommodite != null) {
//         allList.add(cutCommodite);
//       }
//       for (var comm in allList) {
//         if (comm.channelPays != null) {
//           for (var channel in comm.channelPays!) {
//             if (channel.payType == 1 && channel.productCode != null) {
//               _defaultIds.add(channel.productCode!);
//             }
//           }
//         }
//       }
//       NewHitaLog.debug(_defaultIds);
//       TrudaGoogleBilling.getDefaultSkuDetails(_defaultIds.toList());
//     });
//   }
// }
