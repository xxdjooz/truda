import 'package:get/get.dart';

import 'truda_search_controller.dart';

class TrudaSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaSearchController>(() => TrudaSearchController());
  }
}