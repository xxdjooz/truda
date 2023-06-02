import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:truda/truda_rtm/truda_rtm_manager.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_entities/truda_config_entity.dart';

class TrudaAboutController extends GetxController {
  late String herId;
  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
  }

  void getConfig() {
    TrudaHttpUtil()
        .post<TrudaConfigData>(
          TrudaHttpUrls.configApi,
        )
        .then((value) {});
  }
}
