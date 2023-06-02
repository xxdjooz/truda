import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_common_type.dart';
import 'package:truda/truda_common/truda_language_key.dart';

import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_constants.dart';
import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';

//
class TrudaDialogCallSexy extends StatelessWidget {
  static void checkToShow(TrudaCallback<int> callback) async {
    if (TrudaConstants.isFakeMode) {
      return;
    }
    TrudaCommonDialog.dialog(TrudaDialogCallSexy(callback));
  }

  TrudaDialogCallSexy(this.callback, {Key? key}) : super(key: key);

  final noMore = false.obs;
  late TrudaCallback<int> callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 30, end: 30),
        padding: const EdgeInsetsDirectional.only(
            bottom: 20, start: 20, end: 20, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: TrudaColors.baseColorGradient2, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Image.asset(
                "assets/images_sized/newhita_call_yellow.png",
                width: 70,
                height: 70,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 10, bottom: 15),
              child: Text(
                TrudaLanguageKey.newhita_video_sex_warn.tr,
                style:
                    TextStyle(color: TrudaColors.textColor333, fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: () {
                noMore.value = !noMore.value;
              },
              child: Text.rich(
                TextSpan(children: [
                  WidgetSpan(
                      child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 5),
                    child: Obx(
                      () => noMore.value
                          ? Icon(
                              Icons.check_circle,
                              color: TrudaColors.baseColorRed,
                              size: 15,
                            )
                          : Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey,
                              size: 15,
                            ),
                    ),
                  )),
                  TextSpan(
                    text: TrudaLanguageKey.newhita_video_sex_warn_no_more.tr,
                  )
                ]),
                style: const TextStyle(
                  color: TrudaColors.textColor999,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                // CblHttpManager.postRequest<CblNetCodeEntity>(
                //     CblHttpUrls.noLongerReminds,
                //     (a) {},
                //     (e) {},
                //     {},
                //     false);
                if (noMore.value) {
                  TrudaHttpUtil().post<String>(
                      TrudaHttpUrls.noLongerReminds,
                      errCallback: (err) {});
                }
                Get.back();
              },
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(52 * 0.5)),
                    gradient: LinearGradient(colors: [
                      TrudaColors.baseColorGradient1,
                      TrudaColors.baseColorGradient2,
                    ])),
                child: Text(
                  TrudaLanguageKey.newhita_base_confirm.tr,
                  style: TextStyle(
                      color: TrudaColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                callback.call(0);
              },
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TrudaColors.baseColorRed.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(52 * 0.5),
                  ),
                ),
                child: Text(
                  TrudaLanguageKey.newhita_confirm_hang_up.tr,
                  style: TextStyle(
                      color: TrudaColors.baseColorRed, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
