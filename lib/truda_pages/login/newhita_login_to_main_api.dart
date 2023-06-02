import 'package:get/get.dart';

import '../../truda_common/truda_constants.dart';
import '../../truda_dialogs/truda_dialog_visitor_tip.dart';
import '../../truda_entities/truda_info_entity.dart';
import '../../truda_entities/truda_login_entity.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_routes/newhita_pages.dart';
import '../../truda_rtm/newhita_rtm_manager.dart';
import '../../truda_services/newhita_my_info_service.dart';
import '../../truda_utils/newhita_loading.dart';
import '../../truda_utils/newhita_log.dart';

// 拿到登录数据后先获取详情再去主页面
void whenGotLoginToMain(TrudaLogin theLogin){
  NewHitaMyInfoService.to.setLoginData(theLogin);
  _getDetail();
}
void _getDetail() {
  NewHitaLog.debug('NewHitaMeController refreshMe()');
  TrudaHttpUtil().post<TrudaInfoDetail>(TrudaHttpUrls.userInfoApi,
      errCallback: (err) {
        NewHitaLoading.toast(err.toString());
      }, showLoading: true).then((value) {
    getDetailToMain(value);
  });
}
// 获取详情再去主页面
void getDetailToMain(TrudaInfoDetail value){
  //线上版本
  if (value.startBirthday == "fail" &&
      value.timeBirthday == false &&
      value.stateGender == 0) {
    TrudaConstants.isFakeMode = false;
    // 开启rtm
    NewHitaRtmManager.init().then((value) {
      NewHitaRtmManager.connectRTM();
    });
  } else {
    // 审核模式不要开启rtm
    TrudaConstants.isFakeMode = true;
  }
  NewHitaMyInfoService.to.setMyDetail = value;
  // Get.offAllNamed(NewHitaAppPages.main);
  // 先检查保存用户登录的账号密码
  TrudaVisitorTip.checkToShow().then((value) {
    Get.offAllNamed(NewHitaAppPages.main);
  });
}