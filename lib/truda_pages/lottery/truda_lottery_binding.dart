import 'package:get/get.dart';

import 'truda_lottery_controller.dart';

class TrudaLotteryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaLotteryController>(() => TrudaLotteryController());
  }
}
