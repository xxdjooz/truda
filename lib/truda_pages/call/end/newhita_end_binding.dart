import 'package:get/get.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import 'newhita_end_controller.dart';

@Deprecated('这个没有使用，NewHitaEndPage可以出现多个')
class NewHitaEndBinding implements Bindings {
  @override
  void dependencies() {
    /// 这个页面是有可能出现多个的，Controller要注意处理！！！
    Get.create<NewHitaEndController>(() {
      NewHitaLog.debug('NewHitaEndBinding create NewHitaEndController');
      return NewHitaEndController();
    });
  }
}
