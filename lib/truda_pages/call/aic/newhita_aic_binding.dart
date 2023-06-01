import 'package:get/get.dart';

import 'newhita_aic_controller.dart';

class NewHitaAicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaAicController>(() => NewHitaAicController());
  }
}