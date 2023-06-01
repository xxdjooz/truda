import 'package:get/get.dart';
import 'package:truda/truda_pages/splash/newhita_splash_controller.dart';

class NewHitaSplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaSplashController>(() => NewHitaSplashController());
  }
}
