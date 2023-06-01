import 'package:get/get.dart';

import 'newhita_invite_bonus_controller.dart';

class NewHitaInviteBonusBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaInviteBonusController>(() => NewHitaInviteBonusController());
  }
}
