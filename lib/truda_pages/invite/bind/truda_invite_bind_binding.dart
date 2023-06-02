import 'package:get/get.dart';

import 'truda_invite_bind_controller.dart';

class TrudaInviteBindBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaInviteBindController>(() => TrudaInviteBindController());
  }
}
