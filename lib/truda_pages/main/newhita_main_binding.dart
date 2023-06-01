import 'package:get/get.dart';
import 'package:truda/truda_pages/main/newhita_main_controller.dart';

class NewHitaMainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NewHitaMainController>(NewHitaMainController());
  }
}
