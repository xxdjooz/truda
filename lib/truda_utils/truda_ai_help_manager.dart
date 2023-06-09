import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/truda_loading.dart';

import 'truda_log.dart';

class TrudaAihelpManager {
  static final aihelp_channel = MethodChannel("newhita_aihelp_channel");

  static Future<void> initAIHelp() async {
    String? jsonString = TrudaMyInfoService.to.config?.aiHelp;
    if (jsonString != null) {
      Map map = json.decode(jsonString);

      try {
        String apiKey = map["appKey"];
        String domainName = map["domain"];
        String appId = map["appID"];

        final result = await aihelp_channel.invokeMethod('initAIHelp',
            {"apiKey": apiKey, "domainName": domainName, "appId": appId});
      } on PlatformException catch (e) {
        TrudaLog.debug("init aihelp err");
        TrudaLoading.toast('init aihelp err');
      }
    }
  }

  ///  0 个人中心  1 会话列表
  static Future<void> enterMinAIHelp(int level, int entrance) async {
    var user = TrudaMyInfoService.to.userLogin;
    try {
      final result = await aihelp_channel.invokeMethod('enterMinAIHelp', {
        "userId": user?.username ?? "",
        "nickname": user?.nickname ?? "",
        "level": level,
        "created": user?.created ?? 0,
        "entranceType": entrance,
      });
    } on PlatformException catch (e) {
      TrudaLog.debug("aihelp err enterMinAIHelp");
      TrudaLoading.toast('aihelp err enterMinAIHelp');
    }
  }

  static Future<void> enterOrderAIHelp(int level, String orderInfo) async {
    var user = TrudaMyInfoService.to.userLogin;
    try {
      final result = await aihelp_channel.invokeMethod('enterOrderAIHelp', {
        "userId": user?.username ?? "",
        "nickname": user?.nickname ?? "",
        "level": level,
        "created": user?.created ?? 0,
        "orderInfo": orderInfo,
      });
    } on PlatformException catch (e) {
      TrudaLog.debug("aihelp err enterOrderAIHelp");
      TrudaLoading.toast('aihelp err enterOrderAIHelp');
    }
  }

  static Future<void> exitapp() async {
    try {
      final result = await aihelp_channel.invokeMethod('exitapp');
    } on PlatformException catch (e) {
      TrudaLog.debug("退出APP失败");
    }
  }
}
