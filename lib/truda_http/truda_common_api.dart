import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../truda_entities/truda_info_entity.dart';
import '../truda_pages/main/home/truda_follow_controller.dart';
import '../truda_services/truda_my_info_service.dart';
import '../truda_utils/truda_loading.dart';
import '../truda_utils/truda_log.dart';
import 'truda_http_urls.dart';
import 'truda_http_util.dart';

class TrudaCommonApi {
  static Future<TrudaInfoDetail> refreshMe() async {
    TrudaLog.debug('NewHitaCommonApi refreshMe()');
    return TrudaHttpUtil()
        .post<TrudaInfoDetail>(
      TrudaHttpUrls.userInfoApi,
    )
        .then((value) {
      TrudaMyInfoService.to.setMyDetail = value;
      return value;
    }).catchError((e) {});
  }

  static Future<int> followHostOrCancel(String herId, {bool showLoading = true}) async {
    TrudaLog.debug('NewHitaCommonApi followHostOrCancel $herId');

    return TrudaHttpUtil().post<int>(TrudaHttpUrls.followUpApi + herId,
        errCallback: (err) {
          TrudaLoading.toast(err.message);
        }, showLoading: showLoading).then((value) {
          // 通知关注列表刷新
          if (Get.isRegistered<TrudaFollowController>()){
            Get.find<TrudaFollowController>().shouldReload = true;
          }
      return value;
    });
  }
}
