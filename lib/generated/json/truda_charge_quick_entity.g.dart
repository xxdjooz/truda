import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_charge_quick_entity.dart';
import 'package:get/get.dart';

import 'package:truda/truda_common/truda_language_key.dart';

import 'package:truda/truda_utils/truda_format_util.dart';


TrudaPayQuickData $TrudaPayQuickDataFromJson(Map<String, dynamic> json) {
	final TrudaPayQuickData trudaPayQuickData = TrudaPayQuickData();
	final TrudaPayQuickCommodite? discountProduct = jsonConvert.convert<TrudaPayQuickCommodite>(json['discountProduct']);
	if (discountProduct != null) {
		trudaPayQuickData.discountProduct = discountProduct;
	}
	final List<TrudaPayQuickCommodite>? normalProducts = jsonConvert.convertListNotNull<TrudaPayQuickCommodite>(json['normalProducts']);
	if (normalProducts != null) {
		trudaPayQuickData.normalProducts = normalProducts;
	}
	return trudaPayQuickData;
}

Map<String, dynamic> $TrudaPayQuickDataToJson(TrudaPayQuickData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['discountProduct'] = entity.discountProduct?.toJson();
	data['normalProducts'] =  entity.normalProducts?.map((v) => v.toJson()).toList();
	return data;
}

TrudaPayQuickCommodite $TrudaPayQuickCommoditeFromJson(Map<String, dynamic> json) {
	final TrudaPayQuickCommodite trudaPayQuickCommodite = TrudaPayQuickCommodite();
	final String? productId = jsonConvert.convert<String>(json['productId']);
	if (productId != null) {
		trudaPayQuickCommodite.productId = productId;
	}
	final String? productNo = jsonConvert.convert<String>(json['productNo']);
	if (productNo != null) {
		trudaPayQuickCommodite.productNo = productNo;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		trudaPayQuickCommodite.name = name;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		trudaPayQuickCommodite.description = description;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		trudaPayQuickCommodite.icon = icon;
	}
	final int? price = jsonConvert.convert<int>(json['price']);
	if (price != null) {
		trudaPayQuickCommodite.price = price;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		trudaPayQuickCommodite.value = value;
	}
	final int? bonus = jsonConvert.convert<int>(json['bonus']);
	if (bonus != null) {
		trudaPayQuickCommodite.bonus = bonus;
	}
	final int? exp = jsonConvert.convert<int>(json['exp']);
	if (exp != null) {
		trudaPayQuickCommodite.exp = exp;
	}
	final dynamic appSystem = jsonConvert.convert<dynamic>(json['appSystem']);
	if (appSystem != null) {
		trudaPayQuickCommodite.appSystem = appSystem;
	}
	final int? productType = jsonConvert.convert<int>(json['productType']);
	if (productType != null) {
		trudaPayQuickCommodite.productType = productType;
	}
	final int? discountType = jsonConvert.convert<int>(json['discountType']);
	if (discountType != null) {
		trudaPayQuickCommodite.discountType = discountType;
	}
	final int? discount = jsonConvert.convert<int>(json['discount']);
	if (discount != null) {
		trudaPayQuickCommodite.discount = discount;
	}
	final dynamic discountFrequency = jsonConvert.convert<dynamic>(json['discountFrequency']);
	if (discountFrequency != null) {
		trudaPayQuickCommodite.discountFrequency = discountFrequency;
	}
	final int? discountDuration = jsonConvert.convert<int>(json['discountDuration']);
	if (discountDuration != null) {
		trudaPayQuickCommodite.discountDuration = discountDuration;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaPayQuickCommodite.createdAt = createdAt;
	}
	final int? savetime = jsonConvert.convert<int>(json['savetime']);
	if (savetime != null) {
		trudaPayQuickCommodite.savetime = savetime;
	}
	final int? vipDays = jsonConvert.convert<int>(json['vipDays']);
	if (vipDays != null) {
		trudaPayQuickCommodite.vipDays = vipDays;
	}
	final int? pushToGoogle = jsonConvert.convert<int>(json['pushToGoogle']);
	if (pushToGoogle != null) {
		trudaPayQuickCommodite.pushToGoogle = pushToGoogle;
	}
	final int? productStatus = jsonConvert.convert<int>(json['productStatus']);
	if (productStatus != null) {
		trudaPayQuickCommodite.productStatus = productStatus;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		trudaPayQuickCommodite.remark = remark;
	}
	final String? usdRate = jsonConvert.convert<String>(json['usdRate']);
	if (usdRate != null) {
		trudaPayQuickCommodite.usdRate = usdRate;
	}
	final List<TrudaPayQuickChannel>? channelPays = jsonConvert.convertListNotNull<TrudaPayQuickChannel>(json['channelPays']);
	if (channelPays != null) {
		trudaPayQuickCommodite.channelPays = channelPays;
	}
	final TrudaDiamondCardBean? diamondCard = jsonConvert.convert<TrudaDiamondCardBean>(json['diamondCard']);
	if (diamondCard != null) {
		trudaPayQuickCommodite.diamondCard = diamondCard;
	}
	return trudaPayQuickCommodite;
}

Map<String, dynamic> $TrudaPayQuickCommoditeToJson(TrudaPayQuickCommodite entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['productId'] = entity.productId;
	data['productNo'] = entity.productNo;
	data['name'] = entity.name;
	data['description'] = entity.description;
	data['icon'] = entity.icon;
	data['price'] = entity.price;
	data['value'] = entity.value;
	data['bonus'] = entity.bonus;
	data['exp'] = entity.exp;
	data['appSystem'] = entity.appSystem;
	data['productType'] = entity.productType;
	data['discountType'] = entity.discountType;
	data['discount'] = entity.discount;
	data['discountFrequency'] = entity.discountFrequency;
	data['discountDuration'] = entity.discountDuration;
	data['createdAt'] = entity.createdAt;
	data['savetime'] = entity.savetime;
	data['vipDays'] = entity.vipDays;
	data['pushToGoogle'] = entity.pushToGoogle;
	data['productStatus'] = entity.productStatus;
	data['remark'] = entity.remark;
	data['usdRate'] = entity.usdRate;
	data['channelPays'] =  entity.channelPays?.map((v) => v.toJson()).toList();
	data['diamondCard'] = entity.diamondCard?.toJson();
	return data;
}

TrudaPayQuickChannel $TrudaPayQuickChannelFromJson(Map<String, dynamic> json) {
	final TrudaPayQuickChannel trudaPayQuickChannel = TrudaPayQuickChannel();
	final String? productCode = jsonConvert.convert<String>(json['productCode']);
	if (productCode != null) {
		trudaPayQuickChannel.productCode = productCode;
	}
	final String? storeCode = jsonConvert.convert<String>(json['storeCode']);
	if (storeCode != null) {
		trudaPayQuickChannel.storeCode = storeCode;
	}
	final int? browserOpen = jsonConvert.convert<int>(json['browserOpen']);
	if (browserOpen != null) {
		trudaPayQuickChannel.browserOpen = browserOpen;
	}
	final String? channelType = jsonConvert.convert<String>(json['channelType']);
	if (channelType != null) {
		trudaPayQuickChannel.channelType = channelType;
	}
	final int? payType = jsonConvert.convert<int>(json['payType']);
	if (payType != null) {
		trudaPayQuickChannel.payType = payType;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaPayQuickChannel.id = id;
	}
	final String? channelName = jsonConvert.convert<String>(json['channelName']);
	if (channelName != null) {
		trudaPayQuickChannel.channelName = channelName;
	}
	final int? isTripartite = jsonConvert.convert<int>(json['isTripartite']);
	if (isTripartite != null) {
		trudaPayQuickChannel.isTripartite = isTripartite;
	}
	final int? isExpand = jsonConvert.convert<int>(json['isExpand']);
	if (isExpand != null) {
		trudaPayQuickChannel.isExpand = isExpand;
	}
	final String? nationalFlagPath = jsonConvert.convert<String>(json['nationalFlagPath']);
	if (nationalFlagPath != null) {
		trudaPayQuickChannel.nationalFlagPath = nationalFlagPath;
	}
	final int? payOrder = jsonConvert.convert<int>(json['payOrder']);
	if (payOrder != null) {
		trudaPayQuickChannel.payOrder = payOrder;
	}
	final bool? openMenu = jsonConvert.convert<bool>(json['openMenu']);
	if (openMenu != null) {
		trudaPayQuickChannel.openMenu = openMenu;
	}
	final int? currencyPrice = jsonConvert.convert<int>(json['currencyPrice']);
	if (currencyPrice != null) {
		trudaPayQuickChannel.currencyPrice = currencyPrice;
	}
	final String? currency = jsonConvert.convert<String>(json['currency']);
	if (currency != null) {
		trudaPayQuickChannel.currency = currency;
	}
	final int? price = jsonConvert.convert<int>(json['price']);
	if (price != null) {
		trudaPayQuickChannel.price = price;
	}
	final int? uploadUsd = jsonConvert.convert<int>(json['uploadUsd']);
	if (uploadUsd != null) {
		trudaPayQuickChannel.uploadUsd = uploadUsd;
	}
	return trudaPayQuickChannel;
}

Map<String, dynamic> $TrudaPayQuickChannelToJson(TrudaPayQuickChannel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['productCode'] = entity.productCode;
	data['storeCode'] = entity.storeCode;
	data['browserOpen'] = entity.browserOpen;
	data['channelType'] = entity.channelType;
	data['payType'] = entity.payType;
	data['id'] = entity.id;
	data['channelName'] = entity.channelName;
	data['isTripartite'] = entity.isTripartite;
	data['isExpand'] = entity.isExpand;
	data['nationalFlagPath'] = entity.nationalFlagPath;
	data['payOrder'] = entity.payOrder;
	data['openMenu'] = entity.openMenu;
	data['currencyPrice'] = entity.currencyPrice;
	data['currency'] = entity.currency;
	data['price'] = entity.price;
	data['uploadUsd'] = entity.uploadUsd;
	return data;
}

TrudaDiamondCardBean $TrudaDiamondCardBeanFromJson(Map<String, dynamic> json) {
	final TrudaDiamondCardBean trudaDiamondCardBean = TrudaDiamondCardBean();
	final int? increaseDiamonds = jsonConvert.convert<int>(json['increaseDiamonds']);
	if (increaseDiamonds != null) {
		trudaDiamondCardBean.increaseDiamonds = increaseDiamonds;
	}
	final int? totalDiamonds = jsonConvert.convert<int>(json['totalDiamonds']);
	if (totalDiamonds != null) {
		trudaDiamondCardBean.totalDiamonds = totalDiamonds;
	}
	final int? propDuration = jsonConvert.convert<int>(json['propDuration']);
	if (propDuration != null) {
		trudaDiamondCardBean.propDuration = propDuration;
	}
	return trudaDiamondCardBean;
}

Map<String, dynamic> $TrudaDiamondCardBeanToJson(TrudaDiamondCardBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['increaseDiamonds'] = entity.increaseDiamonds;
	data['totalDiamonds'] = entity.totalDiamonds;
	data['propDuration'] = entity.propDuration;
	return data;
}