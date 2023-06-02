import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_widget/newhita_app_bar.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_common/truda_constants.dart';
import '../../truda_dialogs/truda_sheet_invite_method.dart';
import '../../truda_utils/newhita_loading.dart';
import '../../truda_widget/newhita_stacked_list.dart';
import 'truda_invite_controller.dart';

class TrudaInvitePage extends GetView<TrudaInviteController> {
  TrudaInvitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    return GetBuilder<TrudaInviteController>(builder: (contr) {
      return Scaffold(
        appBar: NewHitaAppBar(
          leading: GestureDetector(
            onTap: () => Navigator.maybePop(Get.context!),
            child: Container(
              padding: const EdgeInsetsDirectional.only(start: 15),
              alignment: AlignmentDirectional.centerStart,
              child: Image.asset('assets/images/newhita_host_back.png'),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(NewHitaAppPages.inviteBonus);
              },
              child: Image.asset(
                'assets/images/newhita_invite_benefit.png',
              ),
            ),
            // const SizedBox(width: 15),
          ],
        ),
        backgroundColor: const Color(0xffF5D9FC),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Image.asset(
              'assets/images_sized/newhita_invite_pic.png',
              width: double.infinity,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const AspectRatio(aspectRatio: 1),
                  Container(
                    decoration: BoxDecoration(
                      color: TrudaColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsetsDirectional.only(
                      start: 16,
                      end: 16,
                      top: 16,
                      bottom: 1,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio: 945 / 174,
                          child: Image.asset(
                            getLanguagePic(context),
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 15 / 17,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffA965F5)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        TrudaLanguageKey
                                            .newhita_invite_got_num.tr,
                                        style: const TextStyle(
                                          color: TrudaColors.textColorTitle,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: (controller.inviteBean?.portraits
                                                    ?.isNotEmpty !=
                                                true)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                child: Image.asset(
                                                  'assets/images_sized/newhita_base_avatar.webp',
                                                  fit: BoxFit.fill,
                                                  width: 44,
                                                  height: 44,
                                                ),
                                              )
                                            : NewHitaStackedList(
                                                list: controller
                                                    .inviteBean?.portraits),
                                      ),
                                      Text(
                                        (controller.inviteBean?.inviteCount ??
                                                0)
                                            .toString(),
                                        style: TextStyle(
                                          color: TrudaColors.baseColorTheme,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                              height: 15,
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 15 / 17,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffA965F5)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        TrudaLanguageKey
                                            .newhita_invite_diamonds.tr,
                                        style: const TextStyle(
                                          color: TrudaColors.textColorTitle,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Image.asset(
                                            'assets/images/newhita_invite_diamond.png'),
                                      ),
                                      Text(
                                        (controller.inviteBean?.awardIncome ??
                                                0)
                                            .toString(),
                                        style: const TextStyle(
                                          color: TrudaColors.baseColorTheme,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return TrudaSheetInviteMethod(
                                      link: controller.inviteBean?.shareUrl ??
                                          '');
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  TrudaColors.baseColorGradient1,
                                  TrudaColors.baseColorGradient2,
                                ]), // 渐变色
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              TrudaLanguageKey.newhita_invite_got_user.tr,
                              style: TextStyle(
                                color: TrudaColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: controller.inviteBean?.inviteCode ?? '',
                              ),
                            );
                            NewHitaLoading.toast(
                                TrudaLanguageKey.newhita_base_success.tr);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  TrudaLanguageKey.newhita_invite_code.tr +
                                      ':',
                                  style: TextStyle(
                                    color: TrudaColors.textColor666,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  controller.inviteBean?.inviteCode ?? '--',
                                  style: TextStyle(
                                    color: TrudaColors.textColor333,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                  height: 5,
                                ),
                                Image.asset(
                                    'assets/images/newhita_invite_copy.png'),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            bottom: 10,
                          ),
                          child: Text(
                            TrudaLanguageKey.newhita_invite_manually_fill.tr,
                            style: TextStyle(
                              color: TrudaColors.baseColorRed,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: TrudaColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images_sized/newhita_circle_indicator.png'),
                            ),
                          ),
                          child: Text(
                            TrudaLanguageKey.newhita_invite_description.tr,
                            style: TextStyle(
                              color: TrudaColors.textColorTitle,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Text(
                              TrudaLanguageKey.newhita_invite_rules_1.tr,
                            style: TextStyle(
                              color: TrudaColors.textColor666,
                              fontSize: 14,
                            ),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Text(
                              TrudaLanguageKey.newhita_invite_rules_2.tr,
                            style: TextStyle(
                              color: TrudaColors.textColor666,
                              fontSize: 14,
                            ),),
                        ),
                        if (!TrudaConstants.isFakeMode)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Text(
                                TrudaLanguageKey.newhita_invite_rules_3.tr,
                              style: TextStyle(
                                color: TrudaColors.textColor666,
                                fontSize: 14,
                              ),),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String getLanguagePic(BuildContext context) {
    final languageCodes = [
      'ar',
      'en',
      'es',
      'hi',
      'id',
      'pt',
      'th',
      'tr',
      'vi',
    ];
    // 这个会返回en，为啥？
    // String languageCode = Localizations.localeOf(context).languageCode;
    String lCode = Get.locale?.languageCode ?? '??';
    if (!languageCodes.contains(lCode)) {
      lCode = 'en';
    }
    return 'assets/images_sized/newhita_invite_title_$lCode.webp';
  }
}
