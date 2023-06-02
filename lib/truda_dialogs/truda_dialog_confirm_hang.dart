import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_type.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_widget/truda_gradient_button.dart';
import '../truda_widget/truda_line_button.dart';

class TrudaDialogConfirmHang extends StatelessWidget {
  TrudaCallback<int> callback;
  String title;
  bool isPick;

  TrudaDialogConfirmHang({
    Key? key,
    required this.callback,
    required this.title,
    this.isPick = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 200),
            padding:
                EdgeInsetsDirectional.only(top: 50, bottom: 20, start: 10, end: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TrudaColors.baseColorGradient2, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(color: TrudaColors.textColor333, fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
                TrudaGradientButton(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {
                    Get.back();
                    callback.call(1);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      isPick
                          ? TrudaLanguageKey.newhita_confirm_pick_up.tr
                          : TrudaLanguageKey.newhita_tip_no.tr,
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
                          color: TrudaColors.baseColorRed.withOpacity(0.1),
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
                            TrudaLanguageKey.newhita_confirm_hang_up.tr,
                            style: TextStyle(
                                color: TrudaColors.baseColorRed, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images_sized/newhita_hang_up.png',
            height: 240,
          )
        ],
      ),
    );
  }
}
