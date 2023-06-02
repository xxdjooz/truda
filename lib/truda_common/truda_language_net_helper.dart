import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_translate_entity.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../truda_services/truda_app_info_service.dart';
import '../truda_services/truda_storage_service.dart';
import 'truda_constants.dart';

class TrudaLanguageNetHelper {
  @Deprecated('改用新的获取加密的翻译文案的方法 handleLanguageJsonV2')
  static handleLanguageJson() {
    NewHitaLog.debug("updateLanguage postRequest");
    //请求接口 返回支持的 languagecode 以及 翻译json文件
    TrudaHttpUtil()
        .post<TrudaTranslateData>(TrudaHttpUrls.getTransationsApi)
        .then((value) {
      //转服务器语言数据为map =》用户端
      String languageurl = value.configUrl!;
      int configVersion = value.configVersion ?? 0;
      NewHitaLog.debug(
          "updateLanguage languageurl= $languageurl?v=$configVersion");
      // 这里拼接?v=是为了每次有新版本就去下载，没有新版本用缓存的
      DefaultCacheManager().downloadFile("$languageurl?v=$configVersion")
          // .getSingleFile("$languageurl?v=$configVersion",
          //     key: configVersion.toString())
          .then((file) async {
        String jsonString = file.file.readAsStringSync();
        var data_list = json.decode(jsonString);
        if (data_list is List) {
          Map<String, String> map = {};
          data_list.forEach((element) {
            if (element is Map) {
              if (element.containsKey("configKey")) {
                // map.addAll(
                //     {element["configKey"]: element["configValue"]});
                map[element["configKey"]] = element["configValue"] ?? "";
              }
            }
          });
          TrudaLanguageNetHelper._updateLanguage(map);
        }
      });
    });
  }

  // 获取已经下载的翻译的版本
  static const downloadLangVersionKey = 'downloadLangVersionKey';

  // 获取已经下载的翻译
  static const downloadLangKey = 'downloadLangKey';

  //请求接口 返回支持的 languagecode 以及 翻译json文件
  static handleLanguageJsonV2() {
    TrudaHttpUtil()
        .post<TrudaTranslateData>(TrudaHttpUrls.getTransationsV2Api)
        .then((value) {
      String languageurl = value.configUrl!;
      int configVersion = value.configVersion ?? 0;

      final downloadVersion =
          TrudaStorageService.to.prefs.getInt(downloadLangVersionKey) ?? -1;
      if (configVersion > downloadVersion) {
        // 有新版本就下载
        _downLoadLanguageStr(languageurl, value.appNumber!).then((downLoad) {
          if (downLoad != null) {
            TrudaStorageService.to.prefs
                .setInt(downloadLangVersionKey, configVersion);
            TrudaStorageService.to.prefs.setString(downloadLangKey, downLoad);
            _useLanguage(downLoad, value.appNumber!);
          }
        });
      } else {
        // 没有新版本用下载好的
        final data = TrudaStorageService.to.prefs.getString(downloadLangKey);
        if (data != null) {
          _useLanguage(data, value.appNumber!);
        }
      }
    });
  }

  //更新语言
  static _updateLanguage(Map<String, String> map) {
    // 判断下发的json文件是否完整对应本地翻译条数
    // map.length > 377
    if (map.keys.length > 0) {
      String languageCode = Get.deviceLocale?.languageCode ?? "en";
      var oldMap = Get.translations[languageCode];
      NewHitaLog.debug("updateLanguage languageCode = $languageCode");
      var newMap = <String, String>{};
      if (oldMap != null && oldMap.isNotEmpty) {
        newMap.addAll(oldMap);
        map.forEach((key, value) {
          newMap[key] = value;
        });
      } else {
        newMap.addAll(map);
      }
      NewHitaLog.debug(
          "updateLanguage map->${map.length} newMap->${newMap.length}");
      Get.addTranslations({languageCode: newMap});
      Get.updateLocale(Locale(languageCode));
    }
  }

  // 下载
  static Future<String?> _downLoadLanguageStr(String url, int appNumber) async {
    NewHitaLog.debug("updateLanguage languageurl= $url");
    final dio = Dio();
    final response = await dio.get<String>(url);
    dio.close();
    return response.data;
  }

  // 把加密数据解密出来并转化成map
  static _useLanguage(String lang, int appNumber) async {
    final Map<String, String> map = {};
    String appChannel = TrudaAppInfoService.to.channelName;
    String appName = TrudaConstants.appNameLower;
    String hex = '0123456789ABCDEF';
    // 1 Android 0 ios
    int appSystem = GetPlatform.isAndroid ? 1 : 0;
    map['keyGroup'] = '$appChannel$appName$appNumber$appSystem$hex';
    map['ivGroup'] = '$appNumber$appSystem$appChannel$appName$hex';
    map['str'] = lang;
    // 解密有500ms,用子线程解密
    final jsonStr = await compute(aesDecode, map);
    var dataList = json.decode(jsonStr);
    if (dataList is List) {
      Map<String, String> map = {};
      for (var element in dataList) {
        if (element is Map) {
          if (element.containsKey("configKey")) {
            // map.addAll(
            //     {element["configKey"]: element["configValue"]});
            map[element["configKey"]] = element["configValue"] ?? "";
          }
        }
      }
      TrudaLanguageNetHelper._updateLanguage(map);
    }
  }
}

// aes解密，这是个全局方法，因为要放子线程计算
String aesDecode(Map<String, String> map) {
  // key
  String keyStr = base64.encode(utf8.encode(map['keyGroup'] ?? '')).substring(0, 32);
  // iv
  String ivStr =
  base64.encode(utf8.encode(map['ivGroup'] ?? '')).substring(0, 16);
  final key = encrypt.Key.fromUtf8(keyStr);
  final iv = encrypt.IV.fromUtf8(ivStr);

  final encrypter =
  encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  // 解密
  final decrypted =
  encrypter.decrypt(encrypt.Encrypted.fromBase64(map['str'] ?? ''), iv: iv);
  return decrypted;
}
