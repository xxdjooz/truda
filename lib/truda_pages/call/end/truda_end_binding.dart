import 'package:get/get.dart';
import 'package:truda/truda_utils/truda_log.dart';

import 'truda_end_controller.dart';

@Deprecated('这个没有使用，TrudaEndPage可以出现多个')
class TrudaEndBinding implements Bindings {
  @override
  void dependencies() {
    /// 这个页面是有可能出现多个的，Controller要注意处理！！！
    Get.create<TrudaEndController>(() {
      TrudaLog.debug('TrudaEndBinding create TrudaEndController');
      return TrudaEndController();
    });
  }
}
