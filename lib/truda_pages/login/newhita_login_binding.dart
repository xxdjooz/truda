import 'package:get/get.dart';
import 'newhita_login_controller.dart';

class NewHitaLoginBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<NewHitaLoginController>(() => NewHitaLoginController());
    Get.put<NewHitaLoginController>(NewHitaLoginController());
  }
}