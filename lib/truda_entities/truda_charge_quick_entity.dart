import 'package:get/get.dart';
import 'package:truda/generated/json/base/json_field.dart';
import 'package:truda/generated/json/truda_charge_quick_entity.g.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_utils/newhita_format_util.dart';

@JsonSerializable()
class TrudaPayQuickData {
  TrudaPayQuickData();

  factory TrudaPayQuickData.fromJson(Map<String, dynamic> json) =>
      $TrudaPayQuickDataFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayQuickDataToJson(this);

  TrudaPayQuickCommodite? discountProduct;
  List<TrudaPayQuickCommodite>? normalProducts;
}

// 折扣商品是商品里面有渠道
@JsonSerializable()
class TrudaPayQuickCommodite {
  TrudaPayQuickCommodite();

  factory TrudaPayQuickCommodite.fromJson(Map<String, dynamic> json) =>
      $TrudaPayQuickCommoditeFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayQuickCommoditeToJson(this);

  String? productId;
  String? productNo;
  String? name;
  String? description;
  String? icon;
  int? price;
  int? value;
  int? bonus;
  int? exp;

  dynamic? appSystem;
  int? productType;
  // 折扣类型，1.首充折扣，2.单次折扣，3.限时折扣
  int? discountType;
  // 折扣（50表示优惠50%）
  int? discount;
  dynamic? discountFrequency;
  // 折扣限时，0为不限时，单位毫秒数
  int? discountDuration;

  int? createdAt;
  //保存这条记录存储的时间
  int? savetime;
  int? vipDays;
  int? pushToGoogle;
  int? productStatus;
  String? remark;
  String? usdRate;

  //支付渠道
  List<TrudaPayQuickChannel>? channelPays;

  TrudaDiamondCardBean? diamondCard;
  // 充值页面展示的价格
  String get showPrice {
    if (channelPays == null || channelPays!.isEmpty) {
      return TrudaLanguageKey.newhita_recharge.tr;
    }
    final channels = channelPays!;
    for (var chan in channels) {
      if (chan.payType == 1 && GetPlatform.isAndroid) {
        return chan.showPrice;
      }
      if (chan.payType == 2 && GetPlatform.isIOS) {
        return chan.showPrice;
      }
    }
    return channels.first.showPrice;
  }
}

// {
// "payId":1534470782591389698,
// "payType":1,
// "channelType":null,
// "channelName":"Google Play",
// "storeCode":"1013",
// "nationalFlagPath":"https://wscdn.hanilink.com/assets/commodities/1652266068828.png",
// "areaCode":7,
// "discount":null,
// "channelStatus":1,
// "createdAt":1654681318314,
// "updatedAt":1654686153725,
// "payOrder":0,
// "browserOpen":0,
// "isExpand":1,
// "discountDisplay":null,
// "discountTop":null,
// "currencyPrice":399,
// "currency":"USD",
// "productCode":"some399"
//  }
@JsonSerializable()
class TrudaPayQuickChannel {
  TrudaPayQuickChannel();

  factory TrudaPayQuickChannel.fromJson(Map<String, dynamic> json) =>
      $TrudaPayQuickChannelFromJson(json);

  Map<String, dynamic> toJson() => $TrudaPayQuickChannelToJson(this);

  String? productCode;
  String? storeCode;

  int? browserOpen;
  String? channelType;
  int? payType;
  int? id;
  String? channelName;
  int? isTripartite;
  int? isExpand;
  String? nationalFlagPath;
  int? payOrder;
  //自定义字段 用户展开关闭支付方式
  bool? openMenu;
  int? currencyPrice;
  String? currency;
  // 美元价格
  int? price;
  // 上传时 0.使用当地价格，1.使用美元价格
  int? uploadUsd;

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
      NewHitaFormatUtil.currencyToSymbol(realCurrency);

  @override
  String toString() {
    return '$channelName $productCode $currency $currencyPrice';
  }

  String get showPrice {
    var price =
        "$realCurrencySymbol ${realPrice != null ? realPrice! / 100 : "--"}";
    if (price.endsWith('.0')) {
      // Rp 59670.0
      price = price.substring(0, price.length - 2);
    }
    if (price.endsWith('.00') && price.length > 9) {
      // usd 345.00
      price = price.substring(0, price.length - 3);
    }
    return price;
  }
}

@JsonSerializable()
class TrudaDiamondCardBean {
  TrudaDiamondCardBean();

  factory TrudaDiamondCardBean.fromJson(Map<String, dynamic> json) =>
      $TrudaDiamondCardBeanFromJson(json);

  Map<String, dynamic> toJson() => $TrudaDiamondCardBeanToJson(this);
  // 增量钻石数
  int? increaseDiamonds;
  // 加成后的总钻石数
  int? totalDiamonds;
  // 加成比例
  int? propDuration;
}
