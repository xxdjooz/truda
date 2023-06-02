import 'package:get/get.dart';
import 'package:truda/truda_pages/main/me/moment_list/truda_my_moment_controller.dart';

class TrudaMyMomentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaMyMomentController>(() => TrudaMyMomentController());
  }
}
