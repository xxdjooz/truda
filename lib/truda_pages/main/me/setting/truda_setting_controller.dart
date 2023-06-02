import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:truda/truda_rtm/truda_rtm_manager.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_entities/truda_config_entity.dart';

class TrudaSettingController extends GetxController {
  var dnd = false.obs;
  late String herId;

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    dnd.value = TrudaMyInfoService.to.myDetail?.isDoNotDisturb == 1;
  }

  void getConfig() {
    TrudaHttpUtil()
        .post<TrudaConfigData>(
          TrudaHttpUrls.configApi,
        )
        .then((value) {});
  }

  void switchDND() {
    var newDnd = dnd.value ? 0 : 1;
    TrudaHttpUtil()
        .post<void>(TrudaHttpUrls.updateUserInfoApi,
            data: {"isDoNotDisturb": newDnd}, showLoading: true)
        .then((value) {
      TrudaMyInfoService.to.myDetail?.isDoNotDisturb = newDnd;
      dnd.value = newDnd == 1;
    });
  }

  void logout() {
    // CblLocalStore.removeUser();
    // CblHttpManager.postRequest(CblHttpUrls.loginOutApi);
    // CblRouterManager.offAllNamed(LoginRouter);
    // CblLocalStore.saveAgree(false);
    // Get.find<CblPersonController>().hadUploadAdjust = false;
    // todo
    TrudaAppPages.logout();
  }


  void cancellation() {
    // CblLocalStore.removeUser();
    // CblHttpManager.postRequest(CblHttpUrls.loginOutApi);
    // CblRouterManager.offAllNamed(LoginRouter);
    // CblLocalStore.saveAgree(false);
    // Get.find<CblPersonController>().hadUploadAdjust = false;
    // todo
    TrudaHttpUtil().post(TrudaHttpUrls.delete_current_account).then((value) {
      TrudaAppPages.logout();
    });
  }
}
