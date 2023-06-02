import 'package:truda/truda_utils/truda_format_util.dart';

import '../generated/json/base/json_field.dart';
import '../generated/json/truda_charge_entity.g.dart';

@JsonSerializable()
class TrudaPayChannelBean {
  TrudaPayChannelBean();

  factory TrudaPayChannelBean.fromJson(Map<String, dynamic> json) =>
      $TrudaPayChannelBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayChannelBeanToJson(this);

  int? browserOpen;
  String? channelType;
  int? payType;
  int? id;
  String? storeCode;
  String? channelName;
  int? isTripartite;
  int? isExpand;
  String? nationalFlagPath;
  dynamic? areaInfo;
  List<TrudaPayCommoditeBean>? commodities;
  int? payOrder;
  //自定义字段 用户展开关闭支付方式
  bool? openMenu;
}

@JsonSerializable()
class TrudaPayCommoditeBean {
  TrudaPayCommoditeBean();

  factory TrudaPayCommoditeBean.fromJson(Map<String, dynamic> json) =>
      $TrudaPayCommoditeBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayCommoditeBeanToJson(this);

  String? productCode;
  String? storeCode;
  int? discountType;
  int? payType;
  String? icon;
  String? currency;
  int? discount;
  int? createdAt;
  String? name;
  int? browserOpen;
  int? updatedAt;
  int? bonus;
  int? id;
  dynamic? discountFrequency;
  int? exp;
  int? currencyPrice;
  int? discountDuration;
  String? channelType;
  int? value;
  int? price;
  int? online;
  //保存这条记录存储的时间
  int? savetime;

  @JSONField(serialize: false, deserialize: false)
  int? googlePrice;
  @JSONField(serialize: false, deserialize: false)
  String? googleCurrencyCode;

  int? get realPrice => googlePrice ?? currencyPrice;
  String? get realCurrency => googleCurrencyCode ?? currency;
  // 这个Google返回的有问题，可能港币返回的就是一个$
  // String? get realCurrencySymbol =>
  //     googleCurrencySymbol ?? HiDataConvert.currencyToSymbol(realCurrency);

  String? get realCurrencySymbol =>
      TrudaFormatUtil.currencyToSymbol(realCurrency);
}

@JsonSerializable()
class TrudaCreateOrderBean {
  TrudaCreateOrderBean();

  factory TrudaCreateOrderBean.fromJson(Map<String, dynamic> json) =>
      $TrudaCreateOrderBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaCreateOrderBeanToJson(this);

  String? orderNo;
  String? productCode;
  int? payType;
  String? payUrl;
}

// {
//     "code":0,
//     "data":{
//         "appSystem":1,
//         "bonus":0,
//         "channelPays":[
//             {
//                 "areaCode":3,
//                 "browserOpen":0,
//                 "channelName":"Google Play",
//                 "channelStatus":1,
//                 "channelType":"discount_",
//                 "createdAt":1652262124792,
//                 "currency":"INR",
//                 "currencyPrice":15700,
//                 "discountDisplay":1,
//                 "discountTop":0,
//                 "isExpand":0,
//                 "nationalFlagPath":"https://wscdn.hanilink.com/assets/commodities/1652261949175.png",
//                 "payId":1524323949522243585,
//                 "payOrder":1,
//                 "payType":1,
//                 "productCode":"timik199",
//                 "storeCode":"1002",
//                 "updatedAt":1656659531586
//             },
//             {
//                 "areaCode":3,
//                 "browserOpen":1,
//                 "channelName":"Quick Payment 3",
//                 "channelStatus":1,
//                 "channelType":"discount_paytm",
//                 "createdAt":1652325839616,
//                 "currency":"INR",
//                 "currencyPrice":18000,
//                 "discountDisplay":1,
//                 "discountTop":0,
//                 "isExpand":1,
//                 "nationalFlagPath":"https://wscdn.hanilink.com/assets/commodities/1652325807597.png",
//                 "payId":1524591188859228161,
//                 "payOrder":5,
//                 "payType":16,
//                 "productCode":"android199_155_discount",
//                 "storeCode":"1002",
//                 "updatedAt":1656959702056
//             },
//             {
//                 "areaCode":3,
//                 "browserOpen":1,
//                 "channelName":"Quick Payment 6",
//                 "channelStatus":1,
//                 "channelType":"discount_PAYY_WEB",
//                 "createdAt":1653724401718,
//                 "currency":"INR",
//                 "currencyPrice":18000,
//                 "discountDisplay":1,
//                 "discountTop":0,
//                 "isExpand":0,
//                 "nationalFlagPath":"https://wscdn.hanilink.com/assets/commodities/1652928137399.png",
//                 "payId":1530457183497711617,
//                 "payOrder":7,
//                 "payType":19,
//                 "productCode":"android199_155_discount",
//                 "storeCode":"1002",
//                 "updatedAt":1656940207820
//             },
//             {
//                 "areaCode":3,
//                 "browserOpen":1,
//                 "channelName":"Quick Payment 1",
//                 "channelStatus":1,
//                 "channelType":"discount_paytm",
//                 "createdAt":1652325666379,
//                 "currency":"INR",
//                 "currencyPrice":18000,
//                 "discountDisplay":1,
//                 "discountTop":0,
//                 "isExpand":1,
//                 "nationalFlagPath":"https://wscdn.hanilink.com/assets/commodities/1652770667854.png",
//                 "payId":1524590462246391810,
//                 "payOrder":10,
//                 "payType":15,
//                 "productCode":"android199_155_discount",
//                 "storeCode":"1002",
//                 "updatedAt":1655884513809
//             }
//         ],
//         "currency":"INR",
//         "currencyPrice":15700,
//         "description":"buy a certain amount of diamonds",
//         "discount":10,
//         "discountType":1,
//         "exp":155,
//         "icon":"https://wscdn.hanilink.com/assets/commodities/diamonds1.png",
//         "name":"diamonds",
//         "price":199,
//         "productCode":"timik199",
//         "productId":1524336991198826497,
//         "productNo":"android199_155_discount",
//         "productStatus":1,
//         "productType":2,
//         "pushToGoogle":1,
//         "remark":"安卓",
//         "storeCode":"1002",
//         "usdRate":7890900,
//         "value":155
//     },
//     "message":"Operation succeeded",
//     "timestamp":1657011832429
// }
// 折扣商品是商品里面有渠道
@JsonSerializable()
class TrudaPayCutCommodite {
  TrudaPayCutCommodite();

  factory TrudaPayCutCommodite.fromJson(Map<String, dynamic> json) =>
      $TrudaPayCutCommoditeFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayCutCommoditeToJson(this);

  String? productCode;
  String? storeCode;
  // 折扣类型，1.首充折扣，2.单次折扣，3.限时折扣
  int? discountType;
  // 折扣限时，0为不限时，单位毫秒数
  int? discountDuration;
  String? icon;
  String? currency;
  // 折扣（50表示优惠50%）
  int? discount;
  int? createdAt;
  String? name;
  int? bonus;
  int? id;
  dynamic? discountFrequency;
  int? exp;
  int? currencyPrice;
  int? value;
  int? price;
  int? online;
  //保存这条记录存储的时间
  int? savetime;

  //支付渠道
  List<TrudaPayCutChannel>? channelPays;

  @JSONField(serialize: false, deserialize: false)
  int? googlePrice;
  @JSONField(serialize: false, deserialize: false)
  String? googleCurrencyCode;

  int? get realPrice => googlePrice ?? currencyPrice;
  String? get realCurrency => googleCurrencyCode ?? currency;

  // 这个Google返回的有问题，可能港币返回的就是一个$
  // String? get realCurrencySymbol =>
  //     googleCurrencySymbol ?? HiDataConvert.currencyToSymbol(realCurrency);

  String? get realCurrencySymbol =>
      TrudaFormatUtil.currencyToSymbol(realCurrency);
}

//  "areaCode":3,
//  "browserOpen":1,
//  "channelName":"Quick Payment 1",
//  "channelStatus":1,
//  "channelType":"discount_paytm",
//  "createdAt":1652325666379,
//  "currency":"INR",
//  "currencyPrice":18000,
//  "discountDisplay":1,
//  "discountTop":0,
//  "isExpand":1,
//  "nationalFlagPath":"https://wscdn.hanilink.com/assets/commodities/1652770667854.png",
//  "payId":1524590462246391810,
//  "payOrder":10,
//  "payType":15,
//  "productCode":"android199_155_discount",
//  "storeCode":"1002",
//  "updatedAt":1655884513809
//
@JsonSerializable()
class TrudaPayCutChannel {
  TrudaPayCutChannel();

  factory TrudaPayCutChannel.fromJson(Map<String, dynamic> json) =>
      $TrudaPayCutChannelFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayCutChannelToJson(this);

  int? browserOpen;
  String? channelType;
  int? payType;
  int? id;
  String? storeCode;
  String? channelName;
  int? isTripartite;
  int? isExpand;
  String? nationalFlagPath;
  int? payOrder;
  //自定义字段 用户展开关闭支付方式
  bool? openMenu;
  int? currencyPrice;
  String? currency;
}
