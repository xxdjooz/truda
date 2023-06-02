import 'package:get/get.dart';

import 'truda_local_controller.dart';

class TrudaLocalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaLocalController>(() => TrudaLocalController());
  }
}