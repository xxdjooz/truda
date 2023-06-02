import 'package:get/get.dart';

import 'truda_invite_controller.dart';

class TrudaInviteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaInviteController>(() => TrudaInviteController());
  }
}
