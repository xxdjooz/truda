import 'package:get/get.dart';

import 'truda_host_controller.dart';

class TrudaHostBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaHostController>(() => TrudaHostController());
  }
}
