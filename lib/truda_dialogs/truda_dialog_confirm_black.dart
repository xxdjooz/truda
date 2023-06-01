import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_type.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_widget/newhita_gradient_button.dart';
import '../truda_widget/newhita_line_button.dart';

class TrudaDialogConfirmBlack extends StatelessWidget {
  TrudaCallback<int> callback;
  String userId;
  String portrait;
  TrudaDialogConfirmBlack({
    Key? key,
    required this.callback,
    required this.userId,
    required this.portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 60),
            padding:
                EdgeInsetsDirectional.only(top: 80, bottom: 20, start: 10, end: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TrudaColors.baseColorGradient2, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TrudaLanguageKey.newhita_setting_black_list.tr,
                  style: TextStyle(color: TrudaColors.textColor333, fontSize: 16),
                ),

                const SizedBox(
                  height: 10,
                ),
                Text(
                  TrudaLanguageKey.newhita_add_black_tip.tr,
                  style: TextStyle(color: TrudaColors.textColor666, fontSize: 14),
                ),
                const SizedBox(
                  height: 30,
                ),
                NewHitaGradientButton(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {
                    Get.back();
                    callback.call(1);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      TrudaLanguageKey.newhita_base_confirm.tr,
                      style: TextStyle(
                          color: TrudaColors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                          color: TrudaColors.textColor666.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50)),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          callback.call(0);
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            TrudaLanguageKey.newhita_think_again.tr,
                            style: TextStyle(
                                color: TrudaColors.baseColorGradient1, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          NewHitaNetImage(
            portrait,
            height: 115,
            width: 115,
            radius: 60,
            borderWidth: 2,
          )
        ],
      ),
    );
  }
}
