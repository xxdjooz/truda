import 'package:get/get.dart';

import 'truda_call_list_controller.dart';

class TrudaCallListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaCallListController>(() => TrudaCallListController());
  }
}
