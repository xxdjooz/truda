import 'package:get/get.dart';
import 'package:truda/truda_http/newhita_http_urls.dart';
import 'package:truda/truda_http/newhita_http_util.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_rtm/newhita_rtm_manager.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_entities/truda_config_entity.dart';

class NewHitaAboutController extends GetxController {
  late String herId;
  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
  }

  void getConfig() {
    NewHitaHttpUtil()
        .post<TrudaConfigData>(
          NewHitaHttpUrls.configApi,
        )
        .then((value) {});
  }
}
