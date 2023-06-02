import 'package:get/get.dart';
import 'package:truda/truda_pages/splash/truda_splash_controller.dart';

class TrudaSplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaSplashController>(() => TrudaSplashController());
  }
}
