import 'package:get/get.dart';

import 'truda_success_controller.dart';

class TrudaSuccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaSuccessController>(() => TrudaSuccessController());
  }
}
