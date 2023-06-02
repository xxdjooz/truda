import '../../truda_common/truda_common_dialog.dart';
import 'truda_charge_quick_dialog.dart';

class TrudaChargeDialogManager {
  static bool isShowingChargeDialog = false;

  // 最新的弹窗
  static Future showChargeDialog(String createPath,
      {String? upid, Function? closeCallBack, bool noMoneyShow = false}) async {
    await TrudaCommonDialog.dialog(
      TrudaChargeQuickDialog(
        createPath: createPath,
        upId: upid,
        closeCallBack: closeCallBack,
        noMoneyShow: noMoneyShow,
      ),
    );
  }
}
