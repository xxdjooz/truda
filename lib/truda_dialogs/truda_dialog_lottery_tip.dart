import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_widget/truda_gradient_button.dart';

class TrudaDialogLotteryTip extends StatelessWidget {
  TrudaDialogLotteryTip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsetsDirectional.only(top: 30, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                TrudaLanguageKey.newhita_lottery_charge_tip.tr,
                style: TextStyle(
                  color: TrudaColors.textColor333,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                TrudaLanguageKey.newhita_lottery_qa_1.tr,
                style: TextStyle(
                  color: TrudaColors.textColor666,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                TrudaLanguageKey.newhita_lottery_qa_2.tr,
                style: TextStyle(
                  color: TrudaColors.textColor666,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: TrudaGradientButton(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        TrudaLanguageKey.newhita_base_confirm.tr,
                        style: TextStyle(
                            color: TrudaColors.textColor333, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
