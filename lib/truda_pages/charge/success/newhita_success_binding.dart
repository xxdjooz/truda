import 'package:get/get.dart';

import 'newhita_success_controller.dart';

class NewHitaSuccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaSuccessController>(() => NewHitaSuccessController());
  }
}
