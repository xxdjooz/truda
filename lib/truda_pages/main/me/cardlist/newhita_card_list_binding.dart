import 'package:get/get.dart';

import 'newhita_card_list_controller.dart';

class NewHitaCardListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaCardListController>(() => NewHitaCardListController());
  }
}
