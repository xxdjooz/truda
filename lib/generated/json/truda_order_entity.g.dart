import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_order_entity.dart';

TrudaOrderBean $TrudaOrderBeanFromJson(Map<String, dynamic> json) {
	final TrudaOrderBean trudaOrderBean = TrudaOrderBean();
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		trudaOrderBean.userId = userId;
	}
	final int? linkId = jsonConvert.convert<int>(json['linkId']);
	if (linkId != null) {
		trudaOrderBean.linkId = linkId;
	}
	final int? afterChange = jsonConvert.convert<int>(json['afterChange']);
	if (afterChange != null) {
		trudaOrderBean.afterChange = afterChange;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaOrderBean.id = id;
	}
	final int? beforeChange = jsonConvert.convert<int>(json['beforeChange']);
	if (beforeChange != null) {
		trudaOrderBean.beforeChange = beforeChange;
	}
	final int? depletionType = jsonConvert.convert<int>(json['depletionType']);
	if (depletionType != null) {
		trudaOrderBean.depletionType = depletionType;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaOrderBean.updatedAt = updatedAt;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaOrderBean.createdAt = createdAt;
	}
	final int? anchorId = jsonConvert.convert<int>(json['anchorId']);
	if (anchorId != null) {
		trudaOrderBean.anchorId = anchorId;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		trudaOrderBean.type = type;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		trudaOrderBean.diamonds = diamonds;
	}
	return trudaOrderBean;
}

Map<String, dynamic> $TrudaOrderBeanToJson(TrudaOrderBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['linkId'] = entity.linkId;
	data['afterChange'] = entity.afterChange;
	data['id'] = entity.id;
	data['beforeChange'] = entity.beforeChange;
	data['depletionType'] = entity.depletionType;
	data['updatedAt'] = entity.updatedAt;
	data['createdAt'] = entity.createdAt;
	data['anchorId'] = entity.anchorId;
	data['type'] = entity.type;
	data['diamonds'] = entity.diamonds;
	return data;
}

TrudaOrderData $TrudaOrderDataFromJson(Map<String, dynamic> json) {
	final TrudaOrderData trudaOrderData = TrudaOrderData();
	final int? currencyFee = jsonConvert.convert<int>(json['currencyFee']);
	if (currencyFee != null) {
		trudaOrderData.currencyFee = currencyFee;
	}
	final int? paidAt = jsonConvert.convert<int>(json['paidAt']);
	if (paidAt != null) {
		trudaOrderData.paidAt = paidAt;
	}
	final String? currencyCode = jsonConvert.convert<String>(json['currencyCode']);
	if (currencyCode != null) {
		trudaOrderData.currencyCode = currencyCode;
	}
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		trudaOrderData.orderNo = orderNo;
	}
	final String? channelName = jsonConvert.convert<String>(json['channelName']);
	if (channelName != null) {
		trudaOrderData.channelName = channelName;
	}
	final String? tradeNo = jsonConvert.convert<String>(json['tradeNo']);
	if (tradeNo != null) {
		trudaOrderData.tradeNo = tradeNo;
	}
	final int? orderStatus = jsonConvert.convert<int>(json['orderStatus']);
	if (orderStatus != null) {
		trudaOrderData.orderStatus = orderStatus;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaOrderData.createdAt = createdAt;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaOrderData.updatedAt = updatedAt;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		trudaOrderData.diamonds = diamonds;
	}
	return trudaOrderData;
}

Map<String, dynamic> $TrudaOrderDataToJson(TrudaOrderData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['currencyFee'] = entity.currencyFee;
	data['paidAt'] = entity.paidAt;
	data['currencyCode'] = entity.currencyCode;
	data['orderNo'] = entity.orderNo;
	data['channelName'] = entity.channelName;
	data['tradeNo'] = entity.tradeNo;
	data['orderStatus'] = entity.orderStatus;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['diamonds'] = entity.diamonds;
	return data;
}

TrudaCostBean $TrudaCostBeanFromJson(Map<String, dynamic> json) {
	final TrudaCostBean trudaCostBean = TrudaCostBean();
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		trudaCostBean.userId = userId;
	}
	final int? linkId = jsonConvert.convert<int>(json['linkId']);
	if (linkId != null) {
		trudaCostBean.linkId = linkId;
	}
	final int? afterChange = jsonConvert.convert<int>(json['afterChange']);
	if (afterChange != null) {
		trudaCostBean.afterChange = afterChange;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		trudaCostBean.id = id;
	}
	final int? beforeChange = jsonConvert.convert<int>(json['beforeChange']);
	if (beforeChange != null) {
		trudaCostBean.beforeChange = beforeChange;
	}
	final int? depletionType = jsonConvert.convert<int>(json['depletionType']);
	if (depletionType != null) {
		trudaCostBean.depletionType = depletionType;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaCostBean.updatedAt = updatedAt;
	}
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaCostBean.createdAt = createdAt;
	}
	final int? anchorId = jsonConvert.convert<int>(json['anchorId']);
	if (anchorId != null) {
		trudaCostBean.anchorId = anchorId;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		trudaCostBean.type = type;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		trudaCostBean.diamonds = diamonds;
	}
	final int? inviteeRepeat = jsonConvert.convert<int>(json['inviteeRepeat']);
	if (inviteeRepeat != null) {
		trudaCostBean.inviteeRepeat = inviteeRepeat;
	}
	final String? inviterNickname = jsonConvert.convert<String>(json['inviterNickname']);
	if (inviterNickname != null) {
		trudaCostBean.inviterNickname = inviterNickname;
	}
	return trudaCostBean;
}

Map<String, dynamic> $TrudaCostBeanToJson(TrudaCostBean entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['linkId'] = entity.linkId;
	data['afterChange'] = entity.afterChange;
	data['id'] = entity.id;
	data['beforeChange'] = entity.beforeChange;
	data['depletionType'] = entity.depletionType;
	data['updatedAt'] = entity.updatedAt;
	data['createdAt'] = entity.createdAt;
	data['anchorId'] = entity.anchorId;
	data['type'] = entity.type;
	data['diamonds'] = entity.diamonds;
	data['inviteeRepeat'] = entity.inviteeRepeat;
	data['inviterNickname'] = entity.inviterNickname;
	return data;
}