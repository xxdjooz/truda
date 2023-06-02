import 'package:get/get.dart';
import 'truda_charge_ios_controller.dart';

class TrudaChargeIosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaChargeIosController>(() => TrudaChargeIosController());
  }
}
