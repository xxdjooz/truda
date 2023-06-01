import 'package:get/get.dart';

import 'newhita_local_controller.dart';

class NewHitaLocalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaLocalController>(() => NewHitaLocalController());
  }
}