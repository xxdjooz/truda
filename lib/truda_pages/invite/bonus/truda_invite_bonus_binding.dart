import 'package:get/get.dart';

import 'truda_invite_bonus_controller.dart';

class TrudaInviteBonusBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaInviteBonusController>(() => TrudaInviteBonusController());
  }
}
