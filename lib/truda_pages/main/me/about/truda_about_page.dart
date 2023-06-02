import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_services/truda_app_info_service.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_common/truda_constants.dart';
import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import '../../../../truda_widget/newhita_decoration_bg.dart';
import '../../../some/truda_web_page.dart';
import 'truda_about_controller.dart';

class TrudaAboutPage extends GetView<TrudaAboutController> {
  TrudaAboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const NewHitaDecorationBg(),
      child: Scaffold(
        appBar: NewHitaAppBar(
          title: Text(TrudaLanguageKey.newhita_setting_about_us.tr),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: Container(
          // decoration: const NewHitaDecorationBg(),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        'assets/newhita_base_logo.png',
                        width: 125,
                        height: 125,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      TrudaConstants.appName,
                      style: TextStyle(
                          color: TrudaColors.textColor333, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      TrudaAppInfoService.to.version,
                      style: TextStyle(
                          color: TrudaColors.textColor666, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     NewHitaWebPage.startMe(NewHitaConstants.privacyPolicy, true);
                    //   },
                    //   child: MaterialBanner(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 10, horizontal: 15),
                    //     backgroundColor: Colors.transparent,
                    //     content: Text(
                    //       TrudaLanguageKey.newhita_login_privacy_policy.tr,
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     actions: [
                    //       Image.asset('assets/images/newhita_arrow_right.png'),
                    //     ],
                    //   ),
                    // ),
                    _wItemSet(
                      onTap: () {
                        TrudaWebPage.startMe(TrudaConstants.privacyPolicy, true);
                      },
                      title: TrudaLanguageKey.newhita_login_privacy_policy.tr,
                    ),
                    _wItemSet(
                      onTap: () {
                        TrudaWebPage.startMe(TrudaConstants.agreement, true);
                      },
                      title: TrudaLanguageKey.newhita_login_terms_service.tr,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wItemSet({
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: TrudaColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: const TextStyle(color: TrudaColors.textColor333),
            ),
            const Spacer(),
            Image.asset('assets/images/newhita_arrow_right.png'),
          ],
        ),
      ),
    );
  }
}
