import 'package:truda/generated/json/base/json_convert_content.dart';
import 'package:truda/truda_entities/truda_gift_entity.dart';

TrudaGiftEntity $TrudaGiftEntityFromJson(Map<String, dynamic> json) {
	final TrudaGiftEntity trudaGiftEntity = TrudaGiftEntity();
	final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
	if (createdAt != null) {
		trudaGiftEntity.createdAt = createdAt;
	}
	final int? updatedAt = jsonConvert.convert<int>(json['updatedAt']);
	if (updatedAt != null) {
		trudaGiftEntity.updatedAt = updatedAt;
	}
	final int? gid = jsonConvert.convert<int>(json['gid']);
	if (gid != null) {
		trudaGiftEntity.gid = gid;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		trudaGiftEntity.name = name;
	}
	final int? diamonds = jsonConvert.convert<int>(json['diamonds']);
	if (diamonds != null) {
		trudaGiftEntity.diamonds = diamonds;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		trudaGiftEntity.type = type;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		trudaGiftEntity.icon = icon;
	}
	final String? animEffectUrl = jsonConvert.convert<String>(json['animEffectUrl']);
	if (animEffectUrl != null) {
		trudaGiftEntity.animEffectUrl = animEffectUrl;
	}
	final int? areaCode = jsonConvert.convert<int>(json['areaCode']);
	if (areaCode != null) {
		trudaGiftEntity.areaCode = areaCode;
	}
	final int? online = jsonConvert.convert<int>(json['online']);
	if (online != null) {
		trudaGiftEntity.online = online;
	}
	final int? rankBy = jsonConvert.convert<int>(json['rankBy']);
	if (rankBy != null) {
		trudaGiftEntity.rankBy = rankBy;
	}
	final bool? choose = jsonConvert.convert<bool>(json['choose']);
	if (choose != null) {
		trudaGiftEntity.choose = choose;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		trudaGiftEntity.quantity = quantity;
	}
	final int? vipVisible = jsonConvert.convert<int>(json['vipVisible']);
	if (vipVisible != null) {
		trudaGiftEntity.vipVisible = vipVisible;
	}
	final String? sendGiftRecordId = jsonConvert.convert<String>(json['sendGiftRecordId']);
	if (sendGiftRecordId != null) {
		trudaGiftEntity.sendGiftRecordId = sendGiftRecordId;
	}
	return trudaGiftEntity;
}

Map<String, dynamic> $TrudaGiftEntityToJson(TrudaGiftEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['gid'] = entity.gid;
	data['name'] = entity.name;
	data['diamonds'] = entity.diamonds;
	data['type'] = entity.type;
	data['icon'] = entity.icon;
	data['animEffectUrl'] = entity.animEffectUrl;
	data['areaCode'] = entity.areaCode;
	data['online'] = entity.online;
	data['rankBy'] = entity.rankBy;
	data['choose'] = entity.choose;
	data['quantity'] = entity.quantity;
	data['vipVisible'] = entity.vipVisible;
	data['sendGiftRecordId'] = entity.sendGiftRecordId;
	return data;
}