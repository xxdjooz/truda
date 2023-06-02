import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_charge_entity.dart';
import 'package:truda/truda_utils/truda_format_util.dart';


TrudaPayChannelBean $TrudaPayChannelBeanFromJson(Map<String, dynamic> json) {
	final TrudaPayChannelBean trudaPayChannelBean = TrudaPayChannelBean();
	final int? browserOpen = jsonConvert.convert<int>(json['browserOpen']);
	if (browserOpen != null) {
		trudaPayChannelBean.browserOpen = browserOpen;
	}
	final String? channelType = jsonConvert.convert<String>(json['channelType']);
	if (channelType != null) {
		trudaPayChannelBean.channelType = channelType;
	}
	final int? payType = jsonConvert.convert<int>(json['payType']);
	if (payType != null) {
		trudaPayChannelBean.payType = payType;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaPayChannelBean.id = id;
	}
	final String? storeCode = jsonConvert.convert<String>(json['storeCode']);
	if (storeCode != null) {
		trudaPayChannelBean.storeCode = storeCode;
	}
	final String? channelName = jsonConvert.convert<String>(json['channelName']);
	if (channelName != null) {
		trudaPayChannelBean.channelName = channelName;
	}
	final int? isTripartite = jsonConvert.convert<int>(json['isTripartite']);
	if (isTripartite != null) {
		trudaPayChannelBean.isTripartite = isTripartite;
	}
	final int? isExpand = jsonConvert.convert<int>(json['isExpand']);
	if (isExpand != null) {
		trudaPayChannelBean.isExpand = isExpand;
	}
	final String? nationalFlagPath = jsonConvert.convert<String>(json['nationalFlagPath']);
	if (nationalFlagPath != null) {
		trudaPayChannelBean.nationalFlagPath = nationalFlagPath;
	}
	final dynamic areaInfo = jsonConvert.convert<dynamic>(json['areaInfo']);
	if (areaInfo != null) {
		trudaPayChannelBean.areaInfo = areaInfo;
	}
	final List<TrudaPayCommoditeBean>? commodities = jsonConvert.convertListNotNull<TrudaPayCommoditeBean>(json['commodities']);
	if (commodities != null) {
		trudaPayChannelBean.commodities = commodities;
	}
	final int? payOrder = jsonConvert.convert<int>(json['payOrder']);
	if (payOrder != null) {
		trudaPayChannelBean.payOrder = payOrder;
	}
	final bool? openMenu = jsonConvert.convert<bool>(json['openMenu']);
	if (openMenu != null) {
		trudaPayChannelBean.openMenu = openMenu;
	}
	return trudaPayChannelBean;
}

Map<String, dynamic> $TrudaPayChannelBeanToJson(TrudaPayChannelBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['browserOpen'] = entity.browserOpen;
	data['channelType'] = entity.channelType;
	data['payType'] = entity.payType;
	data['id'] = entity.id;
	data['storeCode'] = entity.storeCode;
	data['channelName'] = entity.channelName;
	data['isTripartite'] = entity.isTripartite;
	data['isExpand'] = entity.isExpand;
	data['nationalFlagPath'] = entity.nationalFlagPath;
	data['areaInfo'] = entity.areaInfo;
	data['commodities'] =  entity.commodities?.map((v) => v.toJson()).toList();
	data['payOrder'] = entity.payOrder;
	data['openMenu'] = entity.openMenu;
	return data;
}

TrudaPayCommoditeBean $TrudaPayCommoditeBeanFromJson(Map<String, dynamic> json) {
	final TrudaPayCommoditeBean trudaPayCommoditeBean = TrudaPayCommoditeBean();
	final String? productCode = jsonConvert.convert<String>(json['productCode']);
	if (productCode != null) {
		trudaPayCommoditeBean.productCode = productCode;
	}
	final String? storeCode = jsonConvert.convert<String>(json['storeCode']);
	if (storeCode != null) {
		trudaPayCommoditeBean.storeCode = storeCode;
	}
	final int? discountType = jsonConvert.convert<int>(json['discountType']);
	if (discountType != null) {
		trudaPayCommoditeBean.discountType = discountType;
	}
	final int? payType = jsonConvert.convert<int>(json['payType']);
	if (payType != null) {
		trudaPayCommoditeBean.payType = payType;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		trudaPayCommoditeBean.icon = icon;
	}
	final String? currency = jsonConvert.convert<String>(json['currency']);
	if (currency != null) {
		trudaPayCommoditeBean.currency = currency;
	}
	final int? discount = jsonConvert.convert<int>(json['discount']);
	if (discount != null) {
		trudaPayCommoditeBean.discount = discount;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaPayCommoditeBean.createdAt = createdAt;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		trudaPayCommoditeBean.name = name;
	}
	final int? browserOpen = jsonConvert.convert<int>(json['browserOpen']);
	if (browserOpen != null) {
		trudaPayCommoditeBean.browserOpen = browserOpen;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaPayCommoditeBean.updatedAt = updatedAt;
	}
	final int? bonus = jsonConvert.convert<int>(json['bonus']);
	if (bonus != null) {
		trudaPayCommoditeBean.bonus = bonus;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaPayCommoditeBean.id = id;
	}
	final dynamic discountFrequency = jsonConvert.convert<dynamic>(json['discountFrequency']);
	if (discountFrequency != null) {
		trudaPayCommoditeBean.discountFrequency = discountFrequency;
	}
	final int? exp = jsonConvert.convert<int>(json['exp']);
	if (exp != null) {
		trudaPayCommoditeBean.exp = exp;
	}
	final int? currencyPrice = jsonConvert.convert<int>(json['currencyPrice']);
	if (currencyPrice != null) {
		trudaPayCommoditeBean.currencyPrice = currencyPrice;
	}
	final int? discountDuration = jsonConvert.convert<int>(json['discountDuration']);
	if (discountDuration != null) {
		trudaPayCommoditeBean.discountDuration = discountDuration;
	}
	final String? channelType = jsonConvert.convert<String>(json['channelType']);
	if (channelType != null) {
		trudaPayCommoditeBean.channelType = channelType;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		trudaPayCommoditeBean.value = value;
	}
	final int? price = jsonConvert.convert<int>(json['price']);
	if (price != null) {
		trudaPayCommoditeBean.price = price;
	}
	final int? online = jsonConvert.convert<int>(json['online']);
	if (online != null) {
		trudaPayCommoditeBean.online = online;
	}
	final int? savetime = jsonConvert.convert<int>(json['savetime']);
	if (savetime != null) {
		trudaPayCommoditeBean.savetime = savetime;
	}
	return trudaPayCommoditeBean;
}

Map<String, dynamic> $TrudaPayCommoditeBeanToJson(TrudaPayCommoditeBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['productCode'] = entity.productCode;
	data['storeCode'] = entity.storeCode;
	data['discountType'] = entity.discountType;
	data['payType'] = entity.payType;
	data['icon'] = entity.icon;
	data['currency'] = entity.currency;
	data['discount'] = entity.discount;
	data['createdAt'] = entity.createdAt;
	data['name'] = entity.name;
	data['browserOpen'] = entity.browserOpen;
	data['updatedAt'] = entity.updatedAt;
	data['bonus'] = entity.bonus;
	data['id'] = entity.id;
	data['discountFrequency'] = entity.discountFrequency;
	data['exp'] = entity.exp;
	data['currencyPrice'] = entity.currencyPrice;
	data['discountDuration'] = entity.discountDuration;
	data['channelType'] = entity.channelType;
	data['value'] = entity.value;
	data['price'] = entity.price;
	data['online'] = entity.online;
	data['savetime'] = entity.savetime;
	return data;
}

TrudaCreateOrderBean $TrudaCreateOrderBeanFromJson(Map<String, dynamic> json) {
	final TrudaCreateOrderBean trudaCreateOrderBean = TrudaCreateOrderBean();
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		trudaCreateOrderBean.orderNo = orderNo;
	}
	final String? productCode = jsonConvert.convert<String>(json['productCode']);
	if (productCode != null) {
		trudaCreateOrderBean.productCode = productCode;
	}
	final int? payType = jsonConvert.convert<int>(json['payType']);
	if (payType != null) {
		trudaCreateOrderBean.payType = payType;
	}
	final String? payUrl = jsonConvert.convert<String>(json['payUrl']);
	if (payUrl != null) {
		trudaCreateOrderBean.payUrl = payUrl;
	}
	return trudaCreateOrderBean;
}

Map<String, dynamic> $TrudaCreateOrderBeanToJson(TrudaCreateOrderBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['orderNo'] = entity.orderNo;
	data['productCode'] = entity.productCode;
	data['payType'] = entity.payType;
	data['payUrl'] = entity.payUrl;
	return data;
}

TrudaPayCutCommodite $TrudaPayCutCommoditeFromJson(Map<String, dynamic> json) {
	final TrudaPayCutCommodite trudaPayCutCommodite = TrudaPayCutCommodite();
	final String? productCode = jsonConvert.convert<String>(json['productCode']);
	if (productCode != null) {
		trudaPayCutCommodite.productCode = productCode;
	}
	final String? storeCode = jsonConvert.convert<String>(json['storeCode']);
	if (storeCode != null) {
		trudaPayCutCommodite.storeCode = storeCode;
	}
	final int? discountType = jsonConvert.convert<int>(json['discountType']);
	if (discountType != null) {
		trudaPayCutCommodite.discountType = discountType;
	}
	final int? discountDuration = jsonConvert.convert<int>(json['discountDuration']);
	if (discountDuration != null) {
		trudaPayCutCommodite.discountDuration = discountDuration;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		trudaPayCutCommodite.icon = icon;
	}
	final String? currency = jsonConvert.convert<String>(json['currency']);
	if (currency != null) {
		trudaPayCutCommodite.currency = currency;
	}
	final int? discount = jsonConvert.convert<int>(json['discount']);
	if (discount != null) {
		trudaPayCutCommodite.discount = discount;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaPayCutCommodite.createdAt = createdAt;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		trudaPayCutCommodite.name = name;
	}
	final int? bonus = jsonConvert.convert<int>(json['bonus']);
	if (bonus != null) {
		trudaPayCutCommodite.bonus = bonus;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaPayCutCommodite.id = id;
	}
	final dynamic discountFrequency = jsonConvert.convert<dynamic>(json['discountFrequency']);
	if (discountFrequency != null) {
		trudaPayCutCommodite.discountFrequency = discountFrequency;
	}
	final int? exp = jsonConvert.convert<int>(json['exp']);
	if (exp != null) {
		trudaPayCutCommodite.exp = exp;
	}
	final int? currencyPrice = jsonConvert.convert<int>(json['currencyPrice']);
	if (currencyPrice != null) {
		trudaPayCutCommodite.currencyPrice = currencyPrice;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		trudaPayCutCommodite.value = value;
	}
	final int? price = jsonConvert.convert<int>(json['price']);
	if (price != null) {
		trudaPayCutCommodite.price = price;
	}
	final int? online = jsonConvert.convert<int>(json['online']);
	if (online != null) {
		trudaPayCutCommodite.online = online;
	}
	final int? savetime = jsonConvert.convert<int>(json['savetime']);
	if (savetime != null) {
		trudaPayCutCommodite.savetime = savetime;
	}
	final List<TrudaPayCutChannel>? channelPays = jsonConvert.convertListNotNull<TrudaPayCutChannel>(json['channelPays']);
	if (channelPays != null) {
		trudaPayCutCommodite.channelPays = channelPays;
	}
	return trudaPayCutCommodite;
}

Map<String, dynamic> $TrudaPayCutCommoditeToJson(TrudaPayCutCommodite entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['productCode'] = entity.productCode;
	data['storeCode'] = entity.storeCode;
	data['discountType'] = entity.discountType;
	data['discountDuration'] = entity.discountDuration;
	data['icon'] = entity.icon;
	data['currency'] = entity.currency;
	data['discount'] = entity.discount;
	data['createdAt'] = entity.createdAt;
	data['name'] = entity.name;
	data['bonus'] = entity.bonus;
	data['id'] = entity.id;
	data['discountFrequency'] = entity.discountFrequency;
	data['exp'] = entity.exp;
	data['currencyPrice'] = entity.currencyPrice;
	data['value'] = entity.value;
	data['price'] = entity.price;
	data['online'] = entity.online;
	data['savetime'] = entity.savetime;
	data['channelPays'] =  entity.channelPays?.map((v) => v.toJson()).toList();
	return data;
}

TrudaPayCutChannel $TrudaPayCutChannelFromJson(Map<String, dynamic> json) {
	final TrudaPayCutChannel trudaPayCutChannel = TrudaPayCutChannel();
	final int? browserOpen = jsonConvert.convert<int>(json['browserOpen']);
	if (browserOpen != null) {
		trudaPayCutChannel.browserOpen = browserOpen;
	}
	final String? channelType = jsonConvert.convert<String>(json['channelType']);
	if (channelType != null) {
		trudaPayCutChannel.channelType = channelType;
	}
	final int? payType = jsonConvert.convert<int>(json['payType']);
	if (payType != null) {
		trudaPayCutChannel.payType = payType;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaPayCutChannel.id = id;
	}
	final String? storeCode = jsonConvert.convert<String>(json['storeCode']);
	if (storeCode != null) {
		trudaPayCutChannel.storeCode = storeCode;
	}
	final String? channelName = jsonConvert.convert<String>(json['channelName']);
	if (channelName != null) {
		trudaPayCutChannel.channelName = channelName;
	}
	final int? isTripartite = jsonConvert.convert<int>(json['isTripartite']);
	if (isTripartite != null) {
		trudaPayCutChannel.isTripartite = isTripartite;
	}
	final int? isExpand = jsonConvert.convert<int>(json['isExpand']);
	if (isExpand != null) {
		trudaPayCutChannel.isExpand = isExpand;
	}
	final String? nationalFlagPath = jsonConvert.convert<String>(json['nationalFlagPath']);
	if (nationalFlagPath != null) {
		trudaPayCutChannel.nationalFlagPath = nationalFlagPath;
	}
	final int? payOrder = jsonConvert.convert<int>(json['payOrder']);
	if (payOrder != null) {
		trudaPayCutChannel.payOrder = payOrder;
	}
	final bool? openMenu = jsonConvert.convert<bool>(json['openMenu']);
	if (openMenu != null) {
		trudaPayCutChannel.openMenu = openMenu;
	}
	final int? currencyPrice = jsonConvert.convert<int>(json['currencyPrice']);
	if (currencyPrice != null) {
		trudaPayCutChannel.currencyPrice = currencyPrice;
	}
	final String? currency = jsonConvert.convert<String>(json['currency']);
	if (currency != null) {
		trudaPayCutChannel.currency = currency;
	}
	return trudaPayCutChannel;
}

Map<String, dynamic> $TrudaPayCutChannelToJson(TrudaPayCutChannel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['browserOpen'] = entity.browserOpen;
	data['channelType'] = entity.channelType;
	data['payType'] = entity.payType;
	data['id'] = entity.id;
	data['storeCode'] = entity.storeCode;
	data['channelName'] = entity.channelName;
	data['isTripartite'] = entity.isTripartite;
	data['isExpand'] = entity.isExpand;
	data['nationalFlagPath'] = entity.nationalFlagPath;
	data['payOrder'] = entity.payOrder;
	data['openMenu'] = entity.openMenu;
	data['currencyPrice'] = entity.currencyPrice;
	data['currency'] = entity.currency;
	return data;
}