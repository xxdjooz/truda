import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';
import 'package:truda/truda_http/newhita_http_urls.dart';
import 'package:truda/truda_http/newhita_http_util.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_rtm/newhita_rtm_manager.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';

import '../../../truda_entities/truda_config_entity.dart';
import '../../host/newhita_host_controller.dart';

class NewHitaSearchController extends GetxController {
  late String herId;
  List<TrudaHostDetail>? list;
  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
  }

  @override
  void onReady() {
    super.onReady();
    _getList();
  }

  void search(String str) {
    NewHitaLoading.show();
    NewHitaHttpUtil().post<TrudaHostDetail>(NewHitaHttpUrls.searchUpApi + str,
        doneCallback: (bool success, String message) {
      NewHitaLoading.dismiss();
    }).then((value) {
      NewHitaHostController.startMe(value.userId!, value.portrait);
    });
  }

  Future _getList() async {
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await NewHitaHttpUtil().post<List<TrudaHostDetail>>(
        NewHitaHttpUrls.commandUpListApi + "-1",
        data: {},
        pageCallback: (has) {}, errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }).then((value) {
      list = value;
      update();
    });
  }
}
