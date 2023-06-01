import 'package:get/get.dart';
import 'newhita_charge_ios_controller.dart';

class NewHitaChargeIosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaChargeIosController>(() => NewHitaChargeIosController());
  }
}
