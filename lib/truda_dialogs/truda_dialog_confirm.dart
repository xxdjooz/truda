import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_type.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_widget/truda_gradient_boder.dart';
import '../truda_widget/truda_gradient_button.dart';
import '../truda_widget/truda_line_button.dart';

class TrudaDialogConfirm extends StatelessWidget {
  TrudaCallback<int> callback;
  String title;
  String? content;
  String? rightText;
  String? leftText;
  bool onlyConfirm;
  bool showSuccessIcon;

  TrudaDialogConfirm({
    Key? key,
    this.content,
    this.leftText,
    this.rightText,
    this.onlyConfirm = false,
    this.showSuccessIcon = false,
    required this.callback,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TrudaGradientBoder(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsetsDirectional.only(top: 30, bottom: 20),
        border: 3,
        colors: const [
          TrudaColors.baseColorGradient1,
          TrudaColors.baseColorGradient2,
        ],
        borderRadius: 20,
        colorSolid: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showSuccessIcon)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Image.asset(
                  'assets/images_sized/newhita_success.png',
                  width: 70,
                  height: 70,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                title,
                style: TextStyle(
                  color: TrudaColors.textColor333,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (content != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  content ?? '',
                  style: TextStyle(
                    color: TrudaColors.textColor666,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  if (!onlyConfirm)
                    Expanded(
                      child: TrudaLineButton(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            leftText == null
                                ? TrudaLanguageKey.newhita_base_cancel.tr
                                : leftText!,
                            style: TextStyle(
                                color: TrudaColors.textColor666,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  if (!onlyConfirm) const SizedBox(width: 15),
                  Expanded(
                    child: TrudaGradientButton(
                      onTap: () {
                        Get.back();
                        callback.call(1);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          rightText == null
                              ? TrudaLanguageKey.newhita_base_confirm.tr
                              : rightText!,
                          style: TextStyle(
                              color: TrudaColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
