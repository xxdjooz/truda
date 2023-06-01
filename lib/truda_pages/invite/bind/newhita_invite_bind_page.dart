import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_widget/newhita_app_bar.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_language_key.dart';
import 'newhita_invite_bind_controller.dart';

class NewHitaInviteBindPage extends GetView<NewHitaInviteBindController> {
  NewHitaInviteBindPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewHitaInviteBindController>(
      builder: (contr) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffD8ABFF),
                TrudaColors.white,
              ],
              stops: [.25, .5],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: NewHitaAppBar(),
            body: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 15,
                top: 10,
                end: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TrudaLanguageKey.newhita_invite_bind.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TrudaColors.textColorTitle,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Text(
                    controller.notOutTime
                        ? TrudaLanguageKey.newhita_invite_code_one_hour.tr
                        : TrudaLanguageKey.newhita_invite_out_time.tr,
                    style: TextStyle(
                      color: controller.notOutTime
                          ? TrudaColors.textColor333
                          : TrudaColors.baseColorRed,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 62,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: TrudaColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            minLines: 1,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16,
                              color: TrudaColors.textColor333,
                            ),
                            controller: controller.introTextController,
                            focusNode: controller.introFocusNode,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    TrudaLanguageKey.newhita_invite_code.tr,
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  color: TrudaColors.textColor999,
                                )),
                            onChanged: (str) {
                              controller.lengthRx.value = str.length;
                            },
                            // 去掉禁用，让接口去判断
                            // enabled: controller.notOutTime,
                          ),
                        ),
                        Obx(() {
                          return (controller.lengthRx.value == 0)
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    controller.introTextController.text = '';
                                    controller.errText.value = '';
                                  },
                                  child: Image.asset(
                                      'assets/images/newhita_close_black.png'));
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 10,
                    ),
                    child: Obx(() {
                      return Text(
                        controller.errText.value,
                        style: TextStyle(
                          color: TrudaColors.baseColorRed,
                          fontSize: 12,
                        ),
                      );
                    }),
                  ),
                  GestureDetector(
                    child: Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              TrudaColors.baseColorGradient1,
                              TrudaColors.baseColorGradient2,
                            ]), // 渐变色
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          TrudaLanguageKey.newhita_base_confirm.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: TrudaColors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      controller.getData();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
