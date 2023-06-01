import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../truda_entities/truda_info_entity.dart';
import '../truda_pages/main/home/newhita_follow_controller.dart';
import '../truda_services/newhita_my_info_service.dart';
import '../truda_utils/newhita_loading.dart';
import '../truda_utils/newhita_log.dart';
import 'newhita_http_urls.dart';
import 'newhita_http_util.dart';

class NewHitaCommonApi {
  static Future<TrudaInfoDetail> refreshMe() async {
    NewHitaLog.debug('NewHitaCommonApi refreshMe()');
    return NewHitaHttpUtil()
        .post<TrudaInfoDetail>(
      NewHitaHttpUrls.userInfoApi,
    )
        .then((value) {
      NewHitaMyInfoService.to.setMyDetail = value;
      return value;
    }).catchError((e) {});
  }

  static Future<int> followHostOrCancel(String herId, {bool showLoading = true}) async {
    NewHitaLog.debug('NewHitaCommonApi followHostOrCancel $herId');

    return NewHitaHttpUtil().post<int>(NewHitaHttpUrls.followUpApi + herId,
        errCallback: (err) {
          NewHitaLoading.toast(err.message);
        }, showLoading: showLoading).then((value) {
          // 通知关注列表刷新
          if (Get.isRegistered<NewHitaFollowController>()){
            Get.find<NewHitaFollowController>().shouldReload = true;
          }
      return value;
    });
  }
}
