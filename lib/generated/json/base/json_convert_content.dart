// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter/material.dart' show debugPrint;
import 'package:truda/truda_entities/truda_ai_config_entity.dart';
import 'package:truda/truda_entities/truda_aiv_entity.dart';
import 'package:truda/truda_entities/truda_banner_entity.dart';
import 'package:truda/truda_entities/truda_call_record_entity.dart';
import 'package:truda/truda_entities/truda_card_entity.dart';
import 'package:truda/truda_entities/truda_charge_entity.dart';
import 'package:truda/truda_entities/truda_charge_quick_entity.dart';
import 'package:truda/truda_entities/truda_config_entity.dart';
import 'package:truda/truda_entities/truda_contribute_entity.dart';
import 'package:truda/truda_entities/truda_end_call_entity.dart';
import 'package:truda/truda_entities/truda_gift_entity.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';
import 'package:truda/truda_entities/truda_hot_entity.dart';
import 'package:truda/truda_entities/truda_info_entity.dart';
import 'package:truda/truda_entities/truda_invite_entity.dart';
import 'package:truda/truda_entities/truda_join_call_entity.dart';
import 'package:truda/truda_entities/truda_leval_entity.dart';
import 'package:truda/truda_entities/truda_link_content_entity.dart';
import 'package:truda/truda_entities/truda_login_entity.dart';
import 'package:truda/truda_entities/truda_lottery_entity.dart';
import 'package:truda/truda_entities/truda_lottery_user_entity.dart';
import 'package:truda/truda_entities/truda_match_host_entity.dart';
import 'package:truda/truda_entities/truda_moment_entity.dart';
import 'package:truda/truda_entities/truda_order_check_entity.dart';
import 'package:truda/truda_entities/truda_order_entity.dart';
import 'package:truda/truda_entities/truda_oss_entity.dart';
import 'package:truda/truda_entities/truda_send_gift_result.dart';
import 'package:truda/truda_entities/truda_sensitive_word_entity.dart';
import 'package:truda/truda_entities/truda_translate_entity.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_entity.dart';
import 'package:truda/truda_socket/truda_socket_entity.dart';
import 'package:truda/truda_utils/ad/truda_ads_spots_entity.dart';

JsonConvert jsonConvert = JsonConvert();
typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);
typedef EnumConvertFunction<T> = T Function(String value);

class JsonConvert {
	static final Map<String, JsonConvertFunction> convertFuncMap = {
		(TrudaAiConfigEntity).toString(): TrudaAiConfigEntity.fromJson,
		(TrudaAiConfigGroups).toString(): TrudaAiConfigGroups.fromJson,
		(TrudaAiConfigGroupsItem).toString(): TrudaAiConfigGroupsItem.fromJson,
		(TrudaAivBean).toString(): TrudaAivBean.fromJson,
		(TrudaBannerBean).toString(): TrudaBannerBean.fromJson,
		(TrudaCallRecordEntity).toString(): TrudaCallRecordEntity.fromJson,
		(TrudaCardBean).toString(): TrudaCardBean.fromJson,
		(TrudaPayChannelBean).toString(): TrudaPayChannelBean.fromJson,
		(TrudaPayCommoditeBean).toString(): TrudaPayCommoditeBean.fromJson,
		(TrudaCreateOrderBean).toString(): TrudaCreateOrderBean.fromJson,
		(TrudaPayCutCommodite).toString(): TrudaPayCutCommodite.fromJson,
		(TrudaPayCutChannel).toString(): TrudaPayCutChannel.fromJson,
		(TrudaPayQuickData).toString(): TrudaPayQuickData.fromJson,
		(TrudaPayQuickCommodite).toString(): TrudaPayQuickCommodite.fromJson,
		(TrudaPayQuickChannel).toString(): TrudaPayQuickChannel.fromJson,
		(TrudaDiamondCardBean).toString(): TrudaDiamondCardBean.fromJson,
		(TrudaConfigData).toString(): TrudaConfigData.fromJson,
		(TrudaAppUpdate).toString(): TrudaAppUpdate.fromJson,
		(TrudaPayScale).toString(): TrudaPayScale.fromJson,
		(TrudaContributeBean).toString(): TrudaContributeBean.fromJson,
		(TrudaEndCallEntity).toString(): TrudaEndCallEntity.fromJson,
		(TrudaGiftEntity).toString(): TrudaGiftEntity.fromJson,
		(TrudaHostDetail).toString(): TrudaHostDetail.fromJson,
		(TrudaHostMedia).toString(): TrudaHostMedia.fromJson,
		(TrudaUpListData).toString(): TrudaUpListData.fromJson,
		(TrudaAreaData).toString(): TrudaAreaData.fromJson,
		(TrudaInfoDetail).toString(): TrudaInfoDetail.fromJson,
		(TrudaBalanceBean).toString(): TrudaBalanceBean.fromJson,
		(TrudaInviteBean).toString(): TrudaInviteBean.fromJson,
		(TrudaJoinCall).toString(): TrudaJoinCall.fromJson,
		(TrudaLevalBean).toString(): TrudaLevalBean.fromJson,
		(TrudaLinkContent).toString(): TrudaLinkContent.fromJson,
		(TrudaLogin).toString(): TrudaLogin.fromJson,
		(TrudaLoginToken).toString(): TrudaLoginToken.fromJson,
		(TrudaLoginUser).toString(): TrudaLoginUser.fromJson,
		(TrudaLotteryBean).toString(): TrudaLotteryBean.fromJson,
		(TrudaLotteryUser).toString(): TrudaLotteryUser.fromJson,
		(TrudaMatchHostLimit).toString(): TrudaMatchHostLimit.fromJson,
		(TrudaMatchHost).toString(): TrudaMatchHost.fromJson,
		(TrudaMomentDetail).toString(): TrudaMomentDetail.fromJson,
		(TrudaMomentMedia).toString(): TrudaMomentMedia.fromJson,
		(TrudaOrderCheckEntity).toString(): TrudaOrderCheckEntity.fromJson,
		(TrudaOrderBean).toString(): TrudaOrderBean.fromJson,
		(TrudaOrderData).toString(): TrudaOrderData.fromJson,
		(TrudaCostBean).toString(): TrudaCostBean.fromJson,
		(TrudaOssConfig).toString(): TrudaOssConfig.fromJson,
		(TrudaSendGiftResult).toString(): TrudaSendGiftResult.fromJson,
		(TrudaSensitiveWordBean).toString(): TrudaSensitiveWordBean.fromJson,
		(TrudaTranslateData).toString(): TrudaTranslateData.fromJson,
		(TrudaTranslateDataConfigs).toString(): TrudaTranslateDataConfigs.fromJson,
		(TrudaRTMText).toString(): TrudaRTMText.fromJson,
		(TrudaRTMUser).toString(): TrudaRTMUser.fromJson,
		(TrudaRTMMsgText).toString(): TrudaRTMMsgText.fromJson,
		(TrudaRTMMsgVoice).toString(): TrudaRTMMsgVoice.fromJson,
		(TrudaRTMMsgPhoto).toString(): TrudaRTMMsgPhoto.fromJson,
		(TrudaRTMMsgCallState).toString(): TrudaRTMMsgCallState.fromJson,
		(TrudaRTMMsgGift).toString(): TrudaRTMMsgGift.fromJson,
		(TrudaRTMMsgBeginCall).toString(): TrudaRTMMsgBeginCall.fromJson,
		(TrudaRTMMsgAIB).toString(): TrudaRTMMsgAIB.fromJson,
		(TrudaRTMMsgAIC).toString(): TrudaRTMMsgAIC.fromJson,
		(TrudaSocketEntity).toString(): TrudaSocketEntity.fromJson,
		(TrudaSocketHostState).toString(): TrudaSocketHostState.fromJson,
		(TrudaSocketBalance).toString(): TrudaSocketBalance.fromJson,
		(TrudaAdsSpotsEntity).toString(): TrudaAdsSpotsEntity.fromJson,
	};

  T? convert<T>(dynamic value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    if (value is T) {
      return value;
    }
    try {
      return _asT<T>(value, enumConvert: enumConvert);
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return null;
    }
  }

  List<T?>? convertList<T>(List<dynamic>? value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return value.map((dynamic e) => _asT<T>(e,enumConvert: enumConvert)).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

List<T>? convertListNotNull<T>(dynamic value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>).map((dynamic e) => _asT<T>(e,enumConvert: enumConvert)!).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  T? _asT<T extends Object?>(dynamic value,
      {EnumConvertFunction? enumConvert}) {
    final String type = T.toString();
    final String valueS = value.toString();
    if (enumConvert != null) {
      return enumConvert(valueS) as T;
    } else if (type == "String") {
      return valueS as T;
    } else if (type == "int") {
      final int? intValue = int.tryParse(valueS);
      if (intValue == null) {
        return double.tryParse(valueS)?.toInt() as T?;
      } else {
        return intValue as T;
      }
    } else if (type == "double") {
      return double.parse(valueS) as T;
    } else if (type == "DateTime") {
      return DateTime.parse(valueS) as T;
    } else if (type == "bool") {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    } else if (type == "Map" || type.startsWith("Map<")) {
      return value as T;
    } else {
      if (convertFuncMap.containsKey(type)) {
        return convertFuncMap[type]!(Map<String, dynamic>.from(value)) as T;
      } else {
        throw UnimplementedError('$type unimplemented');
      }
    }
  }

	//list is returned by type
	static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
		if(<TrudaAiConfigEntity>[] is M){
			return data.map<TrudaAiConfigEntity>((Map<String, dynamic> e) => TrudaAiConfigEntity.fromJson(e)).toList() as M;
		}
		if(<TrudaAiConfigGroups>[] is M){
			return data.map<TrudaAiConfigGroups>((Map<String, dynamic> e) => TrudaAiConfigGroups.fromJson(e)).toList() as M;
		}
		if(<TrudaAiConfigGroupsItem>[] is M){
			return data.map<TrudaAiConfigGroupsItem>((Map<String, dynamic> e) => TrudaAiConfigGroupsItem.fromJson(e)).toList() as M;
		}
		if(<TrudaAivBean>[] is M){
			return data.map<TrudaAivBean>((Map<String, dynamic> e) => TrudaAivBean.fromJson(e)).toList() as M;
		}
		if(<TrudaBannerBean>[] is M){
			return data.map<TrudaBannerBean>((Map<String, dynamic> e) => TrudaBannerBean.fromJson(e)).toList() as M;
		}
		if(<TrudaCallRecordEntity>[] is M){
			return data.map<TrudaCallRecordEntity>((Map<String, dynamic> e) => TrudaCallRecordEntity.fromJson(e)).toList() as M;
		}
		if(<TrudaCardBean>[] is M){
			return data.map<TrudaCardBean>((Map<String, dynamic> e) => TrudaCardBean.fromJson(e)).toList() as M;
		}
		if(<TrudaPayChannelBean>[] is M){
			return data.map<TrudaPayChannelBean>((Map<String, dynamic> e) => TrudaPayChannelBean.fromJson(e)).toList() as M;
		}
		if(<TrudaPayCommoditeBean>[] is M){
			return data.map<TrudaPayCommoditeBean>((Map<String, dynamic> e) => TrudaPayCommoditeBean.fromJson(e)).toList() as M;
		}
		if(<TrudaCreateOrderBean>[] is M){
			return data.map<TrudaCreateOrderBean>((Map<String, dynamic> e) => TrudaCreateOrderBean.fromJson(e)).toList() as M;
		}
		if(<TrudaPayCutCommodite>[] is M){
			return data.map<TrudaPayCutCommodite>((Map<String, dynamic> e) => TrudaPayCutCommodite.fromJson(e)).toList() as M;
		}
		if(<TrudaPayCutChannel>[] is M){
			return data.map<TrudaPayCutChannel>((Map<String, dynamic> e) => TrudaPayCutChannel.fromJson(e)).toList() as M;
		}
		if(<TrudaPayQuickData>[] is M){
			return data.map<TrudaPayQuickData>((Map<String, dynamic> e) => TrudaPayQuickData.fromJson(e)).toList() as M;
		}
		if(<TrudaPayQuickCommodite>[] is M){
			return data.map<TrudaPayQuickCommodite>((Map<String, dynamic> e) => TrudaPayQuickCommodite.fromJson(e)).toList() as M;
		}
		if(<TrudaPayQuickChannel>[] is M){
			return data.map<TrudaPayQuickChannel>((Map<String, dynamic> e) => TrudaPayQuickChannel.fromJson(e)).toList() as M;
		}
		if(<TrudaDiamondCardBean>[] is M){
			return data.map<TrudaDiamondCardBean>((Map<String, dynamic> e) => TrudaDiamondCardBean.fromJson(e)).toList() as M;
		}
		if(<TrudaConfigData>[] is M){
			return data.map<TrudaConfigData>((Map<String, dynamic> e) => TrudaConfigData.fromJson(e)).toList() as M;
		}
		if(<TrudaAppUpdate>[] is M){
			return data.map<TrudaAppUpdate>((Map<String, dynamic> e) => TrudaAppUpdate.fromJson(e)).toList() as M;
		}
		if(<TrudaPayScale>[] is M){
			return data.map<TrudaPayScale>((Map<String, dynamic> e) => TrudaPayScale.fromJson(e)).toList() as M;
		}
		if(<TrudaContributeBean>[] is M){
			return data.map<TrudaContributeBean>((Map<String, dynamic> e) => TrudaContributeBean.fromJson(e)).toList() as M;
		}
		if(<TrudaEndCallEntity>[] is M){
			return data.map<TrudaEndCallEntity>((Map<String, dynamic> e) => TrudaEndCallEntity.fromJson(e)).toList() as M;
		}
		if(<TrudaGiftEntity>[] is M){
			return data.map<TrudaGiftEntity>((Map<String, dynamic> e) => TrudaGiftEntity.fromJson(e)).toList() as M;
		}
		if(<TrudaHostDetail>[] is M){
			return data.map<TrudaHostDetail>((Map<String, dynamic> e) => TrudaHostDetail.fromJson(e)).toList() as M;
		}
		if(<TrudaHostMedia>[] is M){
			return data.map<TrudaHostMedia>((Map<String, dynamic> e) => TrudaHostMedia.fromJson(e)).toList() as M;
		}
		if(<TrudaUpListData>[] is M){
			return data.map<TrudaUpListData>((Map<String, dynamic> e) => TrudaUpListData.fromJson(e)).toList() as M;
		}
		if(<TrudaAreaData>[] is M){
			return data.map<TrudaAreaData>((Map<String, dynamic> e) => TrudaAreaData.fromJson(e)).toList() as M;
		}
		if(<TrudaInfoDetail>[] is M){
			return data.map<TrudaInfoDetail>((Map<String, dynamic> e) => TrudaInfoDetail.fromJson(e)).toList() as M;
		}
		if(<TrudaBalanceBean>[] is M){
			return data.map<TrudaBalanceBean>((Map<String, dynamic> e) => TrudaBalanceBean.fromJson(e)).toList() as M;
		}
		if(<TrudaInviteBean>[] is M){
			return data.map<TrudaInviteBean>((Map<String, dynamic> e) => TrudaInviteBean.fromJson(e)).toList() as M;
		}
		if(<TrudaJoinCall>[] is M){
			return data.map<TrudaJoinCall>((Map<String, dynamic> e) => TrudaJoinCall.fromJson(e)).toList() as M;
		}
		if(<TrudaLevalBean>[] is M){
			return data.map<TrudaLevalBean>((Map<String, dynamic> e) => TrudaLevalBean.fromJson(e)).toList() as M;
		}
		if(<TrudaLinkContent>[] is M){
			return data.map<TrudaLinkContent>((Map<String, dynamic> e) => TrudaLinkContent.fromJson(e)).toList() as M;
		}
		if(<TrudaLogin>[] is M){
			return data.map<TrudaLogin>((Map<String, dynamic> e) => TrudaLogin.fromJson(e)).toList() as M;
		}
		if(<TrudaLoginToken>[] is M){
			return data.map<TrudaLoginToken>((Map<String, dynamic> e) => TrudaLoginToken.fromJson(e)).toList() as M;
		}
		if(<TrudaLoginUser>[] is M){
			return data.map<TrudaLoginUser>((Map<String, dynamic> e) => TrudaLoginUser.fromJson(e)).toList() as M;
		}
		if(<TrudaLotteryBean>[] is M){
			return data.map<TrudaLotteryBean>((Map<String, dynamic> e) => TrudaLotteryBean.fromJson(e)).toList() as M;
		}
		if(<TrudaLotteryUser>[] is M){
			return data.map<TrudaLotteryUser>((Map<String, dynamic> e) => TrudaLotteryUser.fromJson(e)).toList() as M;
		}
		if(<TrudaMatchHostLimit>[] is M){
			return data.map<TrudaMatchHostLimit>((Map<String, dynamic> e) => TrudaMatchHostLimit.fromJson(e)).toList() as M;
		}
		if(<TrudaMatchHost>[] is M){
			return data.map<TrudaMatchHost>((Map<String, dynamic> e) => TrudaMatchHost.fromJson(e)).toList() as M;
		}
		if(<TrudaMomentDetail>[] is M){
			return data.map<TrudaMomentDetail>((Map<String, dynamic> e) => TrudaMomentDetail.fromJson(e)).toList() as M;
		}
		if(<TrudaMomentMedia>[] is M){
			return data.map<TrudaMomentMedia>((Map<String, dynamic> e) => TrudaMomentMedia.fromJson(e)).toList() as M;
		}
		if(<TrudaOrderCheckEntity>[] is M){
			return data.map<TrudaOrderCheckEntity>((Map<String, dynamic> e) => TrudaOrderCheckEntity.fromJson(e)).toList() as M;
		}
		if(<TrudaOrderBean>[] is M){
			return data.map<TrudaOrderBean>((Map<String, dynamic> e) => TrudaOrderBean.fromJson(e)).toList() as M;
		}
		if(<TrudaOrderData>[] is M){
			return data.map<TrudaOrderData>((Map<String, dynamic> e) => TrudaOrderData.fromJson(e)).toList() as M;
		}
		if(<TrudaCostBean>[] is M){
			return data.map<TrudaCostBean>((Map<String, dynamic> e) => TrudaCostBean.fromJson(e)).toList() as M;
		}
		if(<TrudaOssConfig>[] is M){
			return data.map<TrudaOssConfig>((Map<String, dynamic> e) => TrudaOssConfig.fromJson(e)).toList() as M;
		}
		if(<TrudaSendGiftResult>[] is M){
			return data.map<TrudaSendGiftResult>((Map<String, dynamic> e) => TrudaSendGiftResult.fromJson(e)).toList() as M;
		}
		if(<TrudaSensitiveWordBean>[] is M){
			return data.map<TrudaSensitiveWordBean>((Map<String, dynamic> e) => TrudaSensitiveWordBean.fromJson(e)).toList() as M;
		}
		if(<TrudaTranslateData>[] is M){
			return data.map<TrudaTranslateData>((Map<String, dynamic> e) => TrudaTranslateData.fromJson(e)).toList() as M;
		}
		if(<TrudaTranslateDataConfigs>[] is M){
			return data.map<TrudaTranslateDataConfigs>((Map<String, dynamic> e) => TrudaTranslateDataConfigs.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMText>[] is M){
			return data.map<TrudaRTMText>((Map<String, dynamic> e) => TrudaRTMText.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMUser>[] is M){
			return data.map<TrudaRTMUser>((Map<String, dynamic> e) => TrudaRTMUser.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgText>[] is M){
			return data.map<TrudaRTMMsgText>((Map<String, dynamic> e) => TrudaRTMMsgText.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgVoice>[] is M){
			return data.map<TrudaRTMMsgVoice>((Map<String, dynamic> e) => TrudaRTMMsgVoice.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgPhoto>[] is M){
			return data.map<TrudaRTMMsgPhoto>((Map<String, dynamic> e) => TrudaRTMMsgPhoto.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgCallState>[] is M){
			return data.map<TrudaRTMMsgCallState>((Map<String, dynamic> e) => TrudaRTMMsgCallState.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgGift>[] is M){
			return data.map<TrudaRTMMsgGift>((Map<String, dynamic> e) => TrudaRTMMsgGift.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgBeginCall>[] is M){
			return data.map<TrudaRTMMsgBeginCall>((Map<String, dynamic> e) => TrudaRTMMsgBeginCall.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgAIB>[] is M){
			return data.map<TrudaRTMMsgAIB>((Map<String, dynamic> e) => TrudaRTMMsgAIB.fromJson(e)).toList() as M;
		}
		if(<TrudaRTMMsgAIC>[] is M){
			return data.map<TrudaRTMMsgAIC>((Map<String, dynamic> e) => TrudaRTMMsgAIC.fromJson(e)).toList() as M;
		}
		if(<TrudaSocketEntity>[] is M){
			return data.map<TrudaSocketEntity>((Map<String, dynamic> e) => TrudaSocketEntity.fromJson(e)).toList() as M;
		}
		if(<TrudaSocketHostState>[] is M){
			return data.map<TrudaSocketHostState>((Map<String, dynamic> e) => TrudaSocketHostState.fromJson(e)).toList() as M;
		}
		if(<TrudaSocketBalance>[] is M){
			return data.map<TrudaSocketBalance>((Map<String, dynamic> e) => TrudaSocketBalance.fromJson(e)).toList() as M;
		}
		if(<TrudaAdsSpotsEntity>[] is M){
			return data.map<TrudaAdsSpotsEntity>((Map<String, dynamic> e) => TrudaAdsSpotsEntity.fromJson(e)).toList() as M;
		}

		debugPrint("${M.toString()} not found");
	
		return null;
}

	static M? fromJsonAsT<M>(dynamic json) {
		if (json is List) {
			return _getListChildType<M>(json.map((e) => e as Map<String, dynamic>).toList());
		} else {
			return jsonConvert.convert<M>(json);
		}
	}
}