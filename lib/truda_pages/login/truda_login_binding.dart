import 'package:get/get.dart';
import 'truda_login_controller.dart';

class TrudaLoginBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<NewHitaLoginController>(() => NewHitaLoginController());
    Get.put<TrudaLoginController>(TrudaLoginController());
  }
}