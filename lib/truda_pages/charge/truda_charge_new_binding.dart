import 'package:get/get.dart';
import 'package:truda/truda_pages/charge/truda_charge_new_controller.dart';

class TrudaChargeNewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaChargeNewController>(() => TrudaChargeNewController());
  }
}
