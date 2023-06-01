import 'package:get/get.dart';

import 'newhita_call_list_controller.dart';

class NewHitaCallListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaCallListController>(() => NewHitaCallListController());
  }
}
