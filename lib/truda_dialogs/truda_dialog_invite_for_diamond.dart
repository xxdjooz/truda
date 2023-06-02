import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_services/truda_storage_service.dart';
import '../truda_utils/newhita_check_calling_util.dart';

class TrudaDialogInvite extends StatefulWidget {
  static const strInviteOthers = 'strInviteOthers';

  const TrudaDialogInvite({Key? key}) : super(key: key);

  static checkToShow() {
    // if (NewHitaConstants.isFakeMode) {
    //   return;
    // }
    var hadShow = TrudaStorageService.to.prefs.getInt(strInviteOthers) ?? 0;
    NewHitaLog.debug('TrudaDialogInvite $hadShow');
    if (hadShow < 1) {
      hadShow++;
      TrudaStorageService.to.prefs.setInt(strInviteOthers, hadShow);
      return;
    }
    TrudaStorageService.to.prefs.setInt(strInviteOthers, 0);
    // 这一步检查很重要，会出现打开被叫页面同时打开这个弹窗，
    // 导致在TrudaRemoteController取参数时为null
    // 这个得研究下
    if (!NewHitaCheckCallingUtil.checkCalling()) {
      TrudaCommonDialog.dialog(const TrudaDialogInvite());
    }
  }

  @override
  State<TrudaDialogInvite> createState() => _TrudaDialogInviteState();
}

class _TrudaDialogInviteState extends State<TrudaDialogInvite>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Image.asset(
            'assets/images_sized/newhita_invite_dialog_pic.png',
            width: 190,
          ),
          GestureDetector(
            onTap: () {
              Get.offNamed(TrudaAppPages.invitePage);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    TrudaColors.baseColorGradient1,
                    TrudaColors.baseColorGradient2,
                  ]), // 渐变色
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                TrudaLanguageKey.newhita_invite_free_diamond.tr,
                style: const TextStyle(
                  color: TrudaColors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Align(
              alignment: AlignmentDirectional.center,
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                  padding: EdgeInsetsDirectional.only(
                      start: 10, end: 10, top: 10, bottom: 10),
                  child: Image.asset(
                    'assets/images/newhita_close_white.png',
                    width: 26,
                    height: 26,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
