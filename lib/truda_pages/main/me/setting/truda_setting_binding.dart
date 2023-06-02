import 'package:get/get.dart';
import 'truda_setting_controller.dart';

class TrudaSettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaSettingController>(() => TrudaSettingController());
  }
}
