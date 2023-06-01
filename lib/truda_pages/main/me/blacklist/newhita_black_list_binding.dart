import 'package:get/get.dart';

import 'newhita_black_list_controller.dart';

class NewHitaBlackListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaBlackListController>(() => NewHitaBlackListController());
  }
}
