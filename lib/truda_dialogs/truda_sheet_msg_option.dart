import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_services/newhita_storage_service.dart';
import 'truda_dialog_confirm.dart';

class TrudaSheetMsgOption extends StatefulWidget {
  TrudaSheetMsgOption({Key? key}) : super(key: key);

  @override
  State<TrudaSheetMsgOption> createState() => _TrudaSheetMsgOptionState();
}

class _TrudaSheetMsgOptionState extends State<TrudaSheetMsgOption> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       TrudaColors.baseColorGradient1,
          //       TrudaColors.baseColorGradient2,
          //     ]),
          color: TrudaColors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(20), topEnd: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                NewHitaStorageService.to.objectBoxMsg.setAllRead();
                Get.back();
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
                  TrudaLanguageKey.newhita_dialog_clear_message_unread.tr,
                  style: const TextStyle(
                      color: TrudaColors.textColor333, fontSize: 16),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Get.back();
                TrudaCommonDialog.dialog(TrudaDialogConfirm(
                  title: TrudaLanguageKey.newhita_delete_tip.tr,
                  callback: (i) {
                    NewHitaStorageService.to.objectBoxMsg.clearAllMsg();
                  },
                ));
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsetsDirectional.only(top: 20, bottom: 20),
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
                  // border: Border.all(color: Colors.black12, width: 1)
                  // gradient: LinearGradient(colors: [
                  //   TrudaColors.baseColorRed,
                  //   TrudaColors.baseColorOrange,
                  // ]),
                ),
                child: Text(
                  TrudaLanguageKey.newhita_base_cancel.tr,
                  style: const TextStyle(
                      color: TrudaColors.textColor666, fontSize: 16),
                ),
              ),
            ),
          ],
        ));
  }
}
