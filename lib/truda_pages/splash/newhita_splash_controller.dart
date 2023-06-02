import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_net_helper.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_pages/login/newhita_login_to_main_api.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';

import '../../truda_entities/truda_config_entity.dart';
import '../../truda_entities/truda_info_entity.dart';
import '../../truda_utils/newhita_adjust_manager.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_utils/newhita_third_util.dart';

class NewHitaSplashController extends GetxController {
  var counter = 0.obs;

  void incrementCounter() {
    counter++;
  }

  // 获取config
  void getConfig() {
    TrudaHttpUtil().post<TrudaConfigData>(TrudaHttpUrls.configApi,
        errCallback: (e) {
      NewHitaLoading.toast(e.message);
      Future.delayed(Duration(seconds: 2), () {
        getConfig();
      });
    }).then((value) {
      NewHitaMyInfoService.to.config = value;
      if (NewHitaMyInfoService.to.authorization?.isNotEmpty == true) {
        _getDetail();
      } else {
        Get.offAllNamed(NewHitaAppPages.login);
      }
      // 初始化adjust
      if (GetPlatform.isAndroid) {
        NewHitaAdjustManager.initAdjust();
      } else {
        NewHitaAdjustManager.requestTracking();
      }

      // 测试拿到的数据
      // String? permission = value.fbPermission;
      // if (permission == null){
      //   NewHitaLog.debug('NewHitaSplashController permission == null');
      // } else if(permission.isEmpty){
      //   NewHitaLog.debug('NewHitaSplashController permission isEmpty');
      // } else {
      //   List<String> list = permission.split(',');
      //   NewHitaLog.debug('NewHitaSplashController ${list.length} $list');
      // }
    });
  }

  // 已经登陆过，加载个人信息后去主页
  void _getDetail() {
    NewHitaLog.debug('NewHitaSplashController refreshMe()');
    TrudaHttpUtil().post<TrudaInfoDetail>(TrudaHttpUrls.userInfoApi,
        errCallback: (err) {
      NewHitaLoading.dismiss();
      Get.offAllNamed(NewHitaAppPages.login);
    }, showLoading: true,).then((value) {
      getDetailToMain(value);
    });
  }

  @override
  void onInit() {
    super.onInit();
    getConfig();
    try {
      TrudaLanguageNetHelper.handleLanguageJsonV2();
    } catch (e) {
      print(e);
    }
  }

  @override
  void onReady() {
    super.onReady();
    // _testFacebookEvent();
  }

  // todo google上传第一个包，调一下这个使fb有数据，注意使用完要移除掉 ！！！！！！
  void _testFacebookEvent() {
    var str = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, dynamic> map = {};
    map["fb_currency"] = 'USD';
    // 这里有个坑，传null进去会导致上传失败
    // map["fb_content_type"] = 'gora';
    // map["fb_content_id"] = str;
    map["fb_search_string"] = str;
    NewHitaThirdUtil.facebookLog(1.0, 'USD', map);
  }
}
