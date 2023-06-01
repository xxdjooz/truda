import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_routes/newhita_pages.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_constants.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';
import '../truda_services/newhita_storage_service.dart';
import '../truda_utils/newhita_loading.dart';

class TrudaSheetHostChatOption extends StatefulWidget {
  String herId;

  TrudaSheetHostChatOption({Key? key, required this.herId}) : super(key: key);

  @override
  State<TrudaSheetHostChatOption> createState() =>
      _TrudaSheetHostChatOptionState();
}

class _TrudaSheetHostChatOptionState extends State<TrudaSheetHostChatOption> {
  @override
  void initState() {
    super.initState();
  }

  void handleBlack() {
    NewHitaLoading.show();
    if (widget.herId == TrudaConstants.serviceId){
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      NewHitaStorageService.to.updateBlackList(TrudaConstants.serviceId, true);
      NewHitaLoading.dismiss();
      Get.back(result: 1);
      return;
    }
    NewHitaHttpUtil().post<int>(NewHitaHttpUrls.blacklistActionApi + widget.herId,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }, doneCallback: (success, message) {
      NewHitaLoading.dismiss();
      Get.back();
    }).then((value) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      NewHitaStorageService.to.updateBlackList(widget.herId, value == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: TrudaColors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(20), topEnd: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                handleBlack();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsetsDirectional.only(top: 20, bottom: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(20),
                        topEnd: Radius.circular(20))),
                child: Text(
                  NewHitaStorageService.to.checkBlackList(widget.herId)
                      ? TrudaLanguageKey.newhita_dialog_remove_black.tr
                      : TrudaLanguageKey.newhita_dialog_add_black.tr,
                  style: const TextStyle(
                      color: TrudaColors.baseColorRed, fontSize: 16),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Get.back();
                var result = await Get.toNamed(
                  NewHitaAppPages.reportPageNew,
                  arguments: {
                    'reportType': 0,
                    'herId': widget.herId,
                  },
                );
                if (result == 1) {
                  Get.back(result: 1);
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
                      color: TrudaColors.baseColorRed, fontSize: 16),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                NewHitaStorageService.to.objectBoxMsg.removeHer(widget.herId);
                Get.back();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                decoration: BoxDecoration(),
                child: Text(
                  TrudaLanguageKey.newhita_dialog_clear_message_record.tr,
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
                    start: 60, end: 60, bottom: 10, top: 0),
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
