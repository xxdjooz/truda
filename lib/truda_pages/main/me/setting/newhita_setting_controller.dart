import 'package:get/get.dart';
import 'package:truda/truda_http/newhita_http_urls.dart';
import 'package:truda/truda_http/newhita_http_util.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_rtm/newhita_rtm_manager.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_entities/truda_config_entity.dart';

class NewHitaSettingController extends GetxController {
  var dnd = false.obs;
  late String herId;

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    dnd.value = NewHitaMyInfoService.to.myDetail?.isDoNotDisturb == 1;
  }

  void getConfig() {
    NewHitaHttpUtil()
        .post<TrudaConfigData>(
          NewHitaHttpUrls.configApi,
        )
        .then((value) {});
  }

  void switchDND() {
    var newDnd = dnd.value ? 0 : 1;
    NewHitaHttpUtil()
        .post<void>(NewHitaHttpUrls.updateUserInfoApi,
            data: {"isDoNotDisturb": newDnd}, showLoading: true)
        .then((value) {
      NewHitaMyInfoService.to.myDetail?.isDoNotDisturb = newDnd;
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
    NewHitaAppPages.logout();
  }


  void cancellation() {
    // CblLocalStore.removeUser();
    // CblHttpManager.postRequest(CblHttpUrls.loginOutApi);
    // CblRouterManager.offAllNamed(LoginRouter);
    // CblLocalStore.saveAgree(false);
    // Get.find<CblPersonController>().hadUploadAdjust = false;
    // todo
    NewHitaHttpUtil().post(NewHitaHttpUrls.delete_current_account).then((value) {
      NewHitaAppPages.logout();
    });
  }
}
