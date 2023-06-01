import 'package:get/get.dart';
import 'package:truda/truda_pages/main/moment/create/newhita_create_controller.dart';

class NewHitaCreateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaCreateController>(() => NewHitaCreateController());
  }
}
