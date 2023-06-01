import 'package:get/get.dart';

import 'newhita_invite_bind_controller.dart';

class NewHitaInviteBindBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaInviteBindController>(() => NewHitaInviteBindController());
  }
}
