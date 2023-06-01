import 'package:get/get.dart';

import 'newhita_aiv_controller.dart';

class NewHitaAivBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaAivController>(() => NewHitaAivController());
  }
}
