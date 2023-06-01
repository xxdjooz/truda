import 'package:get/get.dart';
import 'package:truda/truda_pages/charge/newhita_charge_new_controller.dart';

class NewHitaChargeNewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaChargeNewController>(() => NewHitaChargeNewController());
  }
}
