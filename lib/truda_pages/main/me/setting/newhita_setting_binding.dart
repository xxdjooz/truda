import 'package:get/get.dart';
import 'newhita_setting_controller.dart';

class NewHitaSettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaSettingController>(() => NewHitaSettingController());
  }
}
