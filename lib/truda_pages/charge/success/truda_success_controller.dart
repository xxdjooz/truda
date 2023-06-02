import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';
import 'package:truda/truda_utils/newhita_check_calling_util.dart';

import '../../../truda_dialogs/truda_dialog_bind_tip.dart';
import 'truda_sheet_charge_success.dart';

class TrudaSuccessController extends GetxController {
  static startMeCheck({int lottery = 0}) {
    if (NewHitaCheckCallingUtil.checkCalling()) return;
    if (TrudaConstants.isFakeMode) return;
    // Get.toNamed(
    //   NewHitaAppPages.chargeSuccess,
    // );
    Get.bottomSheet(
      TrudaSheetChargeSuccess(
        lottery: lottery,
      ),
      // 不加这个默认最高屏幕一半
      isScrollControlled: true,
    );
  }

  late String herId;
  List<TrudaHostDetail>? list;
  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
  }

  @override
  void onReady() {
    super.onReady();
    // _getList();
  }

  // Future _getList() async {
  //   // var areaCode = NewHitaStorageService.to.getAreaCode();
  //   await NewHitaHttpUtil().post<List<NewHitaHostDetail>>(
  //       NewHitaHttpUrls.commandUpListApi + "-1",
  //       data: {},
  //       pageCallback: (has) {}, errCallback: (err) {
  //     NewHitaLoading.toast(err.message);
  //   }).then((value) {
  //     list = value;
  //     update();
  //   });
  // }

  @override
  void onClose() {
    super.onClose();
    TrudaBindTip.checkToShow();
  }
}
