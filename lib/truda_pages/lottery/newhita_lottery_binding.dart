import 'package:get/get.dart';

import 'newhita_lottery_controller.dart';

class NewHitaLotteryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaLotteryController>(() => NewHitaLotteryController());
  }
}
