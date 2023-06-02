import 'package:get/get.dart';
import 'truda_chat_controller.dart';

class TrudaChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrudaChatController>(() => TrudaChatController());
  }
}