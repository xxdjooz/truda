import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_pages/some/truda_web_page.dart';

import '../../truda_common/truda_common_dialog.dart';
import '../../truda_common/truda_constants.dart';
import '../../truda_common/truda_language_key.dart';
import '../../truda_widget/newhita_gradient_boder.dart';

showAgreeDialog(Function fun) {
  bool _checked = true;
  TrudaCommonDialog.dialog(
      Container(
          child: Center(
        child: NewHitaGradientBoder(
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Text(TrudaLanguageKey.newhita_login_check_policy.tr),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(end: 20, top: 20),
                  child: Text.rich(
                    TextSpan(children: [
                      WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   _checked = !_checked;
                              // });
                            },
                            child: Container(
                              padding: EdgeInsetsDirectional.only(
                                start: 22,
                                end: 5,
                                top: 9,
                                bottom: 7,
                              ),
                              color: Colors.transparent,
                              child: _checked == true
                                  ? Image.asset(
                                      'assets/images/newhita_base_checked.png',
                                    )
                                  : Image.asset(
                                      'assets/images/newhita_base_check.png',
                                    ),
                            ),
                          ),
                          alignment: PlaceholderAlignment.middle),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: TrudaLanguageKey.newhita_login_agree_1.tr,
                        children: [
                          const TextSpan(text: ' '),
                          TextSpan(
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                              text:
                                  TrudaLanguageKey.newhita_login_privacy_policy.tr,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  TrudaWebPage.startMe(
                                      TrudaConstants.privacyPolicy, true);
                                }),
                          const TextSpan(text: ' '),
                          TextSpan(text: TrudaLanguageKey.newhita_login_agree_2.tr),
                          const TextSpan(text: ' '),
                          TextSpan(
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                              text: TrudaLanguageKey.newhita_login_terms_service.tr,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  TrudaWebPage.startMe(
                                      TrudaConstants.agreement, true);
                                }),
                          const TextSpan(text: ' '),
                          TextSpan(text: TrudaLanguageKey.newhita_login_agree_3.tr),
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      )
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    fun.call();
                    TrudaConstants.agree = true;
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: EdgeInsetsDirectional.only(
                        start: 20, end: 20, bottom: 20, top: 20),
                    height: 52,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      gradient: const LinearGradient(colors: [
                        TrudaColors.baseColorGradient1,
                        TrudaColors.baseColorGradient2,
                      ]),),
                    child: Text(
                      TrudaLanguageKey.newhita_base_confirm.tr,
                      style: TextStyle(
                          color: TrudaColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            )),
      )),
      useSafeArea: false);
}
