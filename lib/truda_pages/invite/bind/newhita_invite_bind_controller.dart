import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_services/newhita_my_info_service.dart';

class NewHitaInviteBindController extends GetxController {
  var errText = ''.obs;
  TextEditingController introTextController = TextEditingController();
  var lengthRx = 0.obs;
  FocusNode introFocusNode = FocusNode();
  var notOutTime = true;
  @override
  void onInit() {
    super.onInit();
    final creatTime = NewHitaMyInfoService.to.myDetail?.createdAt ?? 0;
    // 超过一个小时不能绑定邀请码
    if (DateTime.now().millisecondsSinceEpoch - creatTime > 60 * 60 * 1000) {
      notOutTime = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    introFocusNode.requestFocus();
  }

  @override
  void onClose() {
    super.onClose();
    if (introFocusNode.hasFocus) {
      introFocusNode.unfocus();
    }
  }

  Future getData() async {
    String text = introTextController.text.trim();
    if (text.isEmpty) {
      errText.value = TrudaLanguageKey.newhita_invite_fill_code.tr;
      return;
    }
    await TrudaHttpUtil().post<void>(TrudaHttpUrls.bindInviteCode + text,
        errCallback: (err) {
      errText.value = TrudaLanguageKey.newhita_invite_fill_code.tr;
    }).then((value) {
      TrudaCommonDialog.dialog(TrudaDialogConfirm(
        callback: (int callback) {
          Get.back(result: 1);
        },
        title: TrudaLanguageKey.newhita_invite_bound.tr,
      ));
    });
  }
}
