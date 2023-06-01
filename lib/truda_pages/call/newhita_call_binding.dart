import 'package:get/get.dart';

import 'newhita_call_controller.dart';

class NewHitaCallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaCallController>(() => NewHitaCallController());
  }
}