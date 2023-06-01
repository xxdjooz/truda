import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_send_gift_result.dart';

TrudaSendGiftResult $TrudaSendGiftResultFromJson(Map<String, dynamic> json) {
	final TrudaSendGiftResult trudaSendGiftResult = TrudaSendGiftResult();
	final int? gid = jsonConvert.convert<int>(json['gid']);
	if (gid != null) {
		trudaSendGiftResult.gid = gid;
	}
	final int? deposit = jsonConvert.convert<int>(json['deposit']);
	if (deposit != null) {
		trudaSendGiftResult.deposit = deposit;
	}
	final int? time = jsonConvert.convert<int>(json['time']);
	if (time != null) {
		trudaSendGiftResult.time = time;
	}
	return trudaSendGiftResult;
}

Map<String, dynamic> $TrudaSendGiftResultToJson(TrudaSendGiftResult entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['gid'] = entity.gid;
	data['deposit'] = entity.deposit;
	data['time'] = entity.time;
	return data;
}