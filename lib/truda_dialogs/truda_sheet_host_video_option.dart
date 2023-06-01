import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_routes/newhita_pages.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';
import '../truda_services/newhita_storage_service.dart';
import '../truda_utils/newhita_loading.dart';
import 'truda_dialog_confirm.dart';

class TrudaSheetHostVideoOption extends StatefulWidget {
  // NewHitaHostDetail detail;
  String herId;
  String mId;

  TrudaSheetHostVideoOption({
    Key? key,
    required this.herId,
    required this.mId,
  }) : super(key: key);

  @override
  State<TrudaSheetHostVideoOption> createState() =>
      _TrudaSheetHostVideoOptionState();
}

class _TrudaSheetHostVideoOptionState extends State<TrudaSheetHostVideoOption> {
  @override
  void initState() {
    super.initState();
  }

  void handleBlack() {
    NewHitaLoading.show();
    NewHitaHttpUtil().post<int>(NewHitaHttpUrls.blacklistActionApi + widget.herId,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
      Get.back();
    }, doneCallback: (success, message) {
      NewHitaLoading.dismiss();
    }).then((value) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      NewHitaStorageService.to.updateBlackList(widget.herId, value == 1);
      Get.back(result: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: TrudaColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsetsDirectional.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                bool black = NewHitaStorageService.to.checkBlackList(widget.herId);
                String str = black
                    ? TrudaLanguageKey.newhita_confirm_black_remove.tr
                    : TrudaLanguageKey.newhita_confirm_black_add.tr;
                TrudaCommonDialog.dialog(TrudaDialogConfirm(
                  title: str,
                  callback: (i) {
                    handleBlack();
                  },
                ));
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsetsDirectional.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(20),
                        topEnd: Radius.circular(20))),
                child: Text(
                  NewHitaStorageService.to.checkBlackList(widget.herId)
                      ? TrudaLanguageKey.newhita_dialog_remove_black.tr
                      : TrudaLanguageKey.newhita_dialog_add_black.tr,
                  style: const TextStyle(
                      color: TrudaColors.textColor333, fontSize: 16),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                // Get.back();

                // var result = await Get.toNamed(NewHitaAppPages.reportPage,
                //     arguments: widget.herId);
                // if (result == 1) {}
                // Get.back(result: result);

                var result = await Get.toNamed(
                  NewHitaAppPages.reportPageNew,
                  arguments: {
                    'reportType': 2,
                    'rId': widget.mId,
                  },
                );
                if (result == 1) {
                  Get.back(result: 2);
                }
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                decoration: BoxDecoration(),
                child: Text(
                  TrudaLanguageKey.newhita_report_title.tr,
                  style: const TextStyle(
                      color: TrudaColors.textColor333, fontSize: 16),
                ),
              ),
            ),
            const ColoredBox(
              color: TrudaColors.baseColorBg,
              child: SizedBox(
                width: double.infinity,
                height: 10,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: const EdgeInsetsDirectional.only(
                    start: 60, end: 60, bottom: 10, top: 20),
                height: 52,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(52 * 0.5)),
                  // border: Border.all(color: Colors.grey, width: 1)
                  // gradient: LinearGradient(colors: [
                  //   TrudaColors.baseColorRed,
                  //   TrudaColors.baseColorOrange,
                  // ]),
                ),
                child: Text(
                  TrudaLanguageKey.newhita_base_cancel.tr,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ],
        ));
  }
}
