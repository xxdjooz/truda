import 'package:get/get.dart';
import 'package:truda/truda_pages/main/truda_main_controller.dart';

class TrudaMainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TrudaMainController>(TrudaMainController());
  }
}
