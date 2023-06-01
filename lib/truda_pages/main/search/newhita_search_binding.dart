import 'package:get/get.dart';

import 'newhita_search_controller.dart';

class NewHitaSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaSearchController>(() => NewHitaSearchController());
  }
}