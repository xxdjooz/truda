import 'package:get/get.dart';
import 'truda_info_controller.dart';

class TrudaInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaInfoController>(() => TrudaInfoController());
  }
}
