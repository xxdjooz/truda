import '../../truda_common/truda_common_dialog.dart';
import 'newhita_charge_quick_dialog.dart';

class NewHitaChargeDialogManager {
  static bool isShowingChargeDialog = false;

  // 最新的弹窗
  static Future showChargeDialog(String createPath,
      {String? upid, Function? closeCallBack, bool noMoneyShow = false}) async {
    await TrudaCommonDialog.dialog(
      NewHitaChargeQuickDialog(
        createPath: createPath,
        upId: upid,
        closeCallBack: closeCallBack,
        noMoneyShow: noMoneyShow,
      ),
    );
  }
}
