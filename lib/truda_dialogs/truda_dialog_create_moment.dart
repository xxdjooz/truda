import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_widget/newhita_gradient_button.dart';

class TrudaDialogCreateMoment extends StatelessWidget {
  TrudaDialogCreateMoment({
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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                TrudaLanguageKey.newhita_story_create_forbid.tr,
                style: TextStyle(
                  color: TrudaColors.textColor333,
                  fontSize: 12,
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
                  child: NewHitaGradientButton(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        TrudaLanguageKey.newhita_base_confirm.tr,
                        style: const TextStyle(
                          color: TrudaColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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
