import 'package:get/get.dart';

import 'newhita_remote_controller.dart';

class NewHitaRemoteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaRemoteController>(() => NewHitaRemoteController());
  }
}