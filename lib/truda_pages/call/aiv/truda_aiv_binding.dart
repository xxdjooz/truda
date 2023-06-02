import 'package:get/get.dart';

import 'truda_aiv_controller.dart';

class TrudaAivBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaAivController>(() => TrudaAivController());
  }
}
