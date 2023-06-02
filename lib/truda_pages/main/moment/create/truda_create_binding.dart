import 'package:get/get.dart';
import 'package:truda/truda_pages/main/moment/create/truda_create_controller.dart';

class TrudaCreateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaCreateController>(() => TrudaCreateController());
  }
}
