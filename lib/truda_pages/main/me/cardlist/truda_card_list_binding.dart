import 'package:get/get.dart';

import 'truda_card_list_controller.dart';

class TrudaCardListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaCardListController>(() => TrudaCardListController());
  }
}
