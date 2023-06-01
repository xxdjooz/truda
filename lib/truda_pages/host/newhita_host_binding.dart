import 'package:get/get.dart';

import 'newhita_host_controller.dart';

class NewHitaHostBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaHostController>(() => NewHitaHostController());
  }
}
