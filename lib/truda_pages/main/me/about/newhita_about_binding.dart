import 'package:get/get.dart';

import 'newhita_about_controller.dart';

class NewHitaAboutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaAboutController>(() => NewHitaAboutController());
  }
}