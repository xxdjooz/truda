import 'package:get/get.dart';

import 'truda_black_list_controller.dart';

class TrudaBlackListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaBlackListController>(() => TrudaBlackListController());
  }
}
