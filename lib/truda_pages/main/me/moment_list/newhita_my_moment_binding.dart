import 'package:get/get.dart';
import 'package:truda/truda_pages/main/me/moment_list/newhita_my_moment_controller.dart';

class NewHitaMyMomentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaMyMomentController>(() => NewHitaMyMomentController());
  }
}
