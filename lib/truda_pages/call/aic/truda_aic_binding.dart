import 'package:get/get.dart';

import 'truda_aic_controller.dart';

class TrudaAicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaAicController>(() => TrudaAicController());
  }
}