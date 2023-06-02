import 'package:get/get.dart';

import 'truda_about_controller.dart';

class TrudaAboutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaAboutController>(() => TrudaAboutController());
  }
}