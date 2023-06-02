import 'package:get/get.dart';

import 'truda_remote_controller.dart';

class TrudaRemoteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaRemoteController>(() => TrudaRemoteController());
  }
}