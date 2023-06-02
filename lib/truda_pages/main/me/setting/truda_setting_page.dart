import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_dialogs/truda_dialog_confirm.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_common/truda_common_dialog.dart';
import '../../../../truda_common/truda_constants.dart';
import '../../../../truda_dialogs/truda_dialog_search.dart';
import '../../../../truda_routes/truda_pages.dart';
import '../../../../truda_widget/truda_app_bar.dart';
import '../../../../truda_widget/truda_decoration_bg.dart';
import '../../../login/account/truda_account_pasaword_page.dart';
import 'truda_setting_controller.dart';

class TrudaSettingPage extends GetView<TrudaSettingController> {
  TrudaSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaSettingController>(builder: (contro) {
      return Scaffold(
        backgroundColor: TrudaColors.baseColorBg,
        appBar: TrudaAppBar(
          title: Text(TrudaLanguageKey.newhita_mine_setting.tr),
          actions: [
            if (!kReleaseMode)
              GestureDetector(
                child: Icon(
                  Icons.build,
                  color: Colors.blue,
                ),
                onTap: () async {
                  var result = await Get.toNamed(TrudaAppPages.test);
                  TrudaLog.debug('NewHitaSettingPage test result=$result');
                },
              )
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        extendBodyBehindAppBar: false,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                if (TrudaConstants.appMode != 2)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                          TrudaLanguageKey.newhita_setting_trouble.tr,
                          style: const TextStyle(
                              color: TrudaColors.textColor333),
                        ),
                        const Spacer(),
                        Obx(() => GestureDetector(
                              child: controller.dnd.value
                                  ? SizedBox(
                                      width: 34,
                                      height: 20,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        alignment: Alignment.centerRight,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                          width: 19,
                                          height: 19,
                                          decoration: BoxDecoration(
                                              color: TrudaColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 34,
                                      height: 20,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                          width: 19,
                                          height: 19,
                                          decoration: BoxDecoration(
                                              color: TrudaColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                    ),
                              onTap: () {
                                // controller.dnd.value = !controller.dnd.value;
                                controller.switchDND();
                              },
                            )),
                      ],
                    ),
                  ),
                _wItemSet(
                  title: TrudaLanguageKey.newhita_setting_search.tr,
                  onTap: () {
                    // Get.toNamed(NewHitaAppPages.search);
                    TrudaDialogSearch.openMe();
                  },
                ),
                _wItemSet(
                  title: TrudaLanguageKey.newhita_setting_about_us.tr,
                  onTap: () {
                    Get.toNamed(TrudaAppPages.aboutUs);
                  },
                ),
                _wItemSet(
                  title: TrudaLanguageKey.newhita_cancellation.tr,
                  onTap: () {
                    TrudaCommonDialog.dialog(TrudaDialogConfirm(
                      title: TrudaLanguageKey.newhita_cancellation_tip.tr,
                      callback: (i) {
                        controller.cancellation();
                      },
                    ));
                  },
                ),
                _wItemSet(
                  title: TrudaLanguageKey.newhita_setting_black_list.tr,
                  onTap: () {
                    Get.toNamed(TrudaAppPages.blackList);
                  },
                ),
                _wItemSet(
                  title: TrudaLanguageKey.newhita_story_mine.tr,
                  onTap: () {
                    Get.toNamed(TrudaAppPages.myMoment);
                  },
                ),
                _wItemSet(
                  title: TrudaLanguageKey.newhita_visitor_pw_change.tr,
                  onTap: () {
                    Get.to(const TrudaAccountPasswordPage());
                  },
                ),
                const ColoredBox(
                  color: TrudaColors.baseColorBg,
                  child: SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    TrudaCommonDialog.dialog(TrudaDialogConfirm(
                      title: TrudaLanguageKey.newhita_login_logout.tr,
                      callback: (i) {
                        controller.logout();
                      },
                    ));
                    // controller.logout();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      color: TrudaColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      TrudaLanguageKey.newhita_setting_logout.tr,
                      style: const TextStyle(color: TrudaColors.baseColorRed),
                    ),
                  ),
                ),
                const ColoredBox(
                  color: TrudaColors.baseColorBg,
                  child: SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                ),
                // OutlinedButton(
                //   onPressed: () {
                //     Get.dialog(NewHitaDialogConfirm(
                //       title: TrudaLanguageKey.newhita_login_logout.tr,
                //       callback: (i) {
                //         controller.logout();
                //       },
                //     ));
                //     // controller.logout();
                //   },
                //   style: TextButton.styleFrom(
                //     side: BorderSide(color: Colors.red[400]!, width: 1),
                //     shape: const RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(40)),
                //     ),
                //   ),
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                //     child: Text(
                //       TrudaLanguageKey.newhita_setting_logout.tr,
                //       style: TextStyle(color: Colors.red[400]!),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _wItemSet({
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
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
            Image.asset(
              'assets/images/newhita_arrow_right.png',
              matchTextDirection: true,
            ),
          ],
        ),
      ),
    );
  }
}
