import 'package:get/get.dart';
import 'newhita_info_controller.dart';

class NewHitaInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaInfoController>(() => NewHitaInfoController());
  }
}
