import 'package:get/get.dart';
import 'newhita_chat_controller.dart';

class NewHitaChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHitaChatController>(() => NewHitaChatController());
  }
}