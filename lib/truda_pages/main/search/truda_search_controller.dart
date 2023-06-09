import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:truda/truda_rtm/truda_rtm_manager.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/truda_loading.dart';

import '../../../truda_entities/truda_config_entity.dart';
import '../../host/truda_host_controller.dart';

class TrudaSearchController extends GetxController {
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
    TrudaLoading.show();
    TrudaHttpUtil().post<TrudaHostDetail>(TrudaHttpUrls.searchUpApi + str,
        doneCallback: (bool success, String message) {
      TrudaLoading.dismiss();
    }).then((value) {
      TrudaHostController.startMe(value.userId!, value.portrait);
    });
  }

  Future _getList() async {
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await TrudaHttpUtil().post<List<TrudaHostDetail>>(
        TrudaHttpUrls.commandUpListApi + "-1",
        data: {},
        pageCallback: (has) {}, errCallback: (err) {
      TrudaLoading.toast(err.message);
    }).then((value) {
      list = value;
      update();
    });
  }
}
