import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_services/truda_storage_service.dart';

import '../truda_common/truda_common_dialog.dart';
import '../truda_widget/truda_gradient_button.dart';

//首次文明弹窗
class TrudaFirstTip extends StatefulWidget {
  static checkToShow() {
    // if (NewHitaConstants.isFakeMode) {
    //   return;
    // }
    var hadShow = TrudaStorageService.to.prefs.getBool('firstTip');
    if (hadShow == true) {
      return;
    }
    TrudaStorageService.to.prefs.setBool('firstTip', true);
    TrudaCommonDialog.dialog(TrudaFirstTip());
  }

  @override
  _TrudaFirstTipState createState() => _TrudaFirstTipState();
}

class _TrudaFirstTipState extends State<TrudaFirstTip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: TrudaColors.baseColorGradient2, width: 2),
            ),
            margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  TrudaLanguageKey.newhita_warm_tips.tr,
                  style: const TextStyle(
                    color: TrudaColors.textColor333,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  // margin: EdgeInsetsDirectional.only(start: 40, end: 40),
                  padding: const EdgeInsetsDirectional.only(
                      start: 20, bottom: 20, end: 20, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        TrudaLanguageKey.newhita_dialog_warning_text_1.tr,
                        style: TextStyle(
                            color: TrudaColors.textColor666, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TrudaColors.baseColorRed.withOpacity(.1),
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(12)),
                        ),
                        padding: EdgeInsetsDirectional.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Image.asset(
                                "assets/images/newhita_first_tip_1.png",
                                width: 50,
                                height: 50,
                              ),
                              margin: EdgeInsetsDirectional.only(end: 10),
                            ),
                            Flexible(
                                child: Text(
                              TrudaLanguageKey
                                  .newhita_dialog_warning_text_2.tr,
                              style: TextStyle(
                                  color: TrudaColors.baseColorRed,
                                  fontSize: 12),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TrudaColors.baseColorRed.withOpacity(.1),
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(12)),
                        ),
                        padding: EdgeInsetsDirectional.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Image.asset(
                                "assets/images/newhita_first_tip_2.png",
                                width: 50,
                                height: 50,
                              ),
                              margin: EdgeInsetsDirectional.only(end: 10),
                            ),
                            Flexible(
                                child: Text(
                              TrudaLanguageKey
                                  .newhita_dialog_warning_text_3.tr,
                              style: TextStyle(
                                  color: TrudaColors.baseColorRed,
                                  fontSize: 12),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TrudaGradientButton(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 52,
                          child: Text(
                            TrudaLanguageKey.newhita_base_confirm.tr,
                            style: const TextStyle(
                                color: TrudaColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/newhita_first_tip_top.png',
            height: 107,
          )
        ],
      ),
    );
  }
}
