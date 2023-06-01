import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_order_check_entity.dart';

TrudaOrderCheckEntity $TrudaOrderCheckEntityFromJson(Map<String, dynamic> json) {
	final TrudaOrderCheckEntity trudaOrderCheckEntity = TrudaOrderCheckEntity();
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		trudaOrderCheckEntity.orderNo = orderNo;
	}
	final int? orderStatus = jsonConvert.convert<int>(json['orderStatus']);
	if (orderStatus != null) {
		trudaOrderCheckEntity.orderStatus = orderStatus;
	}
	return trudaOrderCheckEntity;
}

Map<String, dynamic> $TrudaOrderCheckEntityToJson(TrudaOrderCheckEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['orderNo'] = entity.orderNo;
	data['orderStatus'] = entity.orderStatus;
	return data;
}