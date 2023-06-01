import 'package:get/get.dart';

import 'newhita_invite_controller.dart';

class NewHitaInviteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaInviteController>(() => NewHitaInviteController());
  }
}
