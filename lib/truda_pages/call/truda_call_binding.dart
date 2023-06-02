import 'package:get/get.dart';

import 'truda_call_controller.dart';

class TrudaCallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaCallController>(() => TrudaCallController());
  }
}