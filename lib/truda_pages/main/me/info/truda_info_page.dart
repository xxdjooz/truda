import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_common/truda_common_dialog.dart';
import '../../../../truda_services/newhita_event_bus_bean.dart';
import '../../../../truda_services/newhita_storage_service.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import '../../../../truda_widget/newhita_avatar_with_bg.dart';
import '../../../../truda_widget/newhita_decoration_bg.dart';
import '../../../../truda_widget/newhita_sheet_header.dart';
import 'truda_info_controller.dart';

class TrudaInfoPage extends GetView<TrudaInfoController> {
  TrudaInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaInfoController>(
      dispose: (c) {
        NewHitaStorageService.to.eventBus.fire(eventBusRefreshMe);
      },
      builder: (contro) {
        return Scaffold(
          appBar: NewHitaAppBar(
            title: Text(TrudaLanguageKey.newhita_details_edit_info.tr),
            backgroundColor: TrudaColors.white,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Container(
                color: TrudaColors.baseColorGrey,
                width: double.infinity,
                height: 10,
              ),
            ),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: TrudaColors.baseColorBlackBg,
          body: SingleChildScrollView(
            child: ColoredBox(
              color: TrudaColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 130,
                  ),
                  GestureDetector(
                    onTap: contro.changeAvatar,
                    child: Stack(
                      children: [
                        NewHitaAvatarWithBg(
                          url: controller.myDetail?.portrait ?? '',
                          width: 135,
                          height: 135,
                        ),
                        PositionedDirectional(
                          end: 0,
                          bottom: 0,
                          child: Image.asset(
                              'assets/images/newhita_info_camera.png'),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  // InkWell(
                  //     onTap: () {
                  //       _editName(controller);
                  //     },
                  //     child: Container(
                  //       width: double.infinity,
                  //       padding: const EdgeInsets.symmetric(horizontal: 15),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Container(
                  //                 width: 10,
                  //                 height: 10,
                  //                 decoration: const ShapeDecoration(
                  //                   color: TrudaColors.white,
                  //                   shape: CircleBorder(
                  //                     side: BorderSide(
                  //                       color: Colors.black38,
                  //                       width: 2,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 10,
                  //                 height: 10,
                  //               ),
                  //               Text(
                  //                 TrudaLanguageKey.newhita_details_name.tr,
                  //                 style: TextStyle(color: Colors.white),
                  //               ),
                  //             ],
                  //           ),
                  //           Container(
                  //             width: double.infinity,
                  //             margin: const EdgeInsets.symmetric(
                  //               horizontal: 5,
                  //             ),
                  //             padding: const EdgeInsets.symmetric(horizontal: 12),
                  //             decoration: const BoxDecoration(
                  //               border: NewHitaBorder(
                  //                 start: BorderSide(
                  //                   color: Colors.white54,
                  //                   width: 2,
                  //                 ),
                  //               ),
                  //             ),
                  //             child: Container(
                  //               decoration: const BoxDecoration(
                  //                 color: Colors.white12,
                  //               ),
                  //               margin: const EdgeInsets.symmetric(
                  //                 horizontal: 4,
                  //                 vertical: 10,
                  //               ),
                  //               padding: const EdgeInsets.symmetric(
                  //                 horizontal: 12,
                  //                 vertical: 10,
                  //               ),
                  //               child: Text(
                  //                 controller.myDetail?.nickname ?? "",
                  //                 style: const TextStyle(
                  //                     color: TrudaColors.white, fontSize: 16),
                  //                 maxLines: 1,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: TrudaColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _wItem(
                          title: TrudaLanguageKey.newhita_details_name.tr,
                          onTap: () {
                            _editName(controller);
                          },
                          text: controller.myDetail?.nickname ?? "",
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _wItem(
                          title: TrudaLanguageKey.newhita_details_sex.tr,
                          onTap: _selectGender,
                          text: controller.myDetail?.gender == 2
                              ? TrudaLanguageKey.newhita_woman.tr
                              : TrudaLanguageKey.newhita_man.tr,
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _wItem(
                          title: TrudaLanguageKey.newhita_details_birth.tr,
                          onTap: controller.changeBirthday,
                          text: controller.getBirth(),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Builder(builder: (context) {
                          return _wItem(
                            title: TrudaLanguageKey.newhita_details_sign.tr,
                            onTap: () {
                              _editIntro(controller, context);
                            },
                          );
                        }),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          child: Text(
                            controller.myDetail?.intro ?? '...',
                            style: const TextStyle(
                                color: TrudaColors.textColor999,
                                fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectGender() {
    var genderNow = (controller.myDetail?.gender ?? 0).obs;
    TrudaCommonDialog.bottomSheet(
      Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NewHitaSheetHeader(),
            Container(
                padding: EdgeInsetsDirectional.only(top: 30),
                decoration: const BoxDecoration(
                  // gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       TrudaColors.baseColorGradient1,
                  //       TrudaColors.baseColorGradient2,
                  //     ]),
                  color: TrudaColors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              genderNow.value = 1;
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsetsDirectional.all(20),
                                  decoration: BoxDecoration(
                                    color: genderNow.value == 1
                                        ? TrudaColors.baseColorBlue
                                        : TrudaColors.baseColorBlue
                                            .withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/newhita_gender_male.png',
                                    width: 40,
                                    color: genderNow.value == 1
                                        ? TrudaColors.white
                                        : TrudaColors.baseColorBlue,
                                  ),
                                ),
                                Text(
                                  TrudaLanguageKey.newhita_man.tr,
                                  style: const TextStyle(
                                      color: TrudaColors.baseColorBlue,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              genderNow.value = 2;
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsetsDirectional.all(20),
                                  decoration: BoxDecoration(
                                    color: genderNow.value == 2
                                        ? TrudaColors.baseColorRedLight
                                        : TrudaColors.baseColorRedLight
                                            .withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/newhita_gender_female.png',
                                    width: 40,
                                    color: genderNow.value == 2
                                        ? TrudaColors.white
                                        : TrudaColors.baseColorRedLight,
                                  ),
                                ),
                                Text(
                                  TrudaLanguageKey.newhita_woman.tr,
                                  style: const TextStyle(
                                      color: TrudaColors.baseColorRedLight,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.changeGender(genderNow.value);
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: const EdgeInsetsDirectional.only(
                            start: 60, end: 60, bottom: 20, top: 20),
                        height: 52,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              TrudaColors.baseColorGradient1,
                              TrudaColors.baseColorGradient2,
                            ]), // 渐变色
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          TrudaLanguageKey.newhita_base_confirm.tr,
                          style: const TextStyle(
                              color: TrudaColors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        );
      }),
    );
  }

  void _editName(TrudaInfoController controller) {
    final maxlen = controller.initNameController();
    var lengthRx = controller.nameTextController.text.length.obs;
    TrudaCommonDialog.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const NewHitaSheetHeader(),
          Container(
            decoration: BoxDecoration(
              color: TrudaColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  TrudaLanguageKey.newhita_details_edit_name.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: TrudaColors.textColor333,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.only(start: 15, end: 5),
                  margin: const EdgeInsetsDirectional.only(
                      top: 15, start: 15, end: 15, bottom: 5),
                  decoration: const BoxDecoration(
                    color: TrudaColors.baseColorBg,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 16,
                            color: TrudaColors.textColor333,
                          ),
                          controller: controller.nameTextController,
                          focusNode: controller.nameFocusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(maxlen),
                            FilteringTextInputFormatter.deny(RegExp(r'^\s+'))
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: TrudaLanguageKey.newhita_not_exceed
                                  .trArgs([maxlen.toString()]),
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                color: TrudaColors.textColor999,
                              )),
                          onChanged: (str) {
                            lengthRx.value = str.length;
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.nameTextController.text = "";
                            lengthRx.value = 0;
                          },
                          icon: Image.asset(
                              "assets/images/newhita_close_black.png"))
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Container(
                //       margin: const EdgeInsetsDirectional.only(end: 15),
                //       child: Obx(() {
                //         return Text(
                //           "${lengthRx.value}/$maxlen",
                //           style: const TextStyle(
                //             color: TrudaColors.textColor999,
                //           ),
                //         );
                //       }),
                //     ),
                //   ],
                // ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    controller.changeName();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: const EdgeInsetsDirectional.only(
                        start: 60, end: 60, bottom: 20, top: 20),
                    height: 52,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          TrudaColors.baseColorGradient1,
                          TrudaColors.baseColorGradient2,
                        ]), // 渐变色
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      TrudaLanguageKey.newhita_base_confirm.tr,
                      style: const TextStyle(
                          color: TrudaColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editIntro(TrudaInfoController controller, BuildContext context) {
    controller.initIntroController();
    var lengthRx = controller.introTextController.text.length.obs;
    // 为了解决输入法遮挡问题----》
    // showModalBottomSheet，isScrollControlled
    // AnimatedPadding，以及上面传过来的context
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return AnimatedPadding(
            duration: Duration.zero,
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NewHitaSheetHeader(),
                Container(
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //     colors: [
                    //       TrudaColors.baseColorGradient1,
                    //       TrudaColors.baseColorGradient2,
                    //     ]),
                    color: TrudaColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container(
                      //   margin:
                      //       const EdgeInsetsDirectional.only(top: 10, bottom: 20),
                      //   width: 42,
                      //   height: 6,
                      //   decoration: const BoxDecoration(
                      //       color: Color(0xFFCCCCCC),
                      //       borderRadius:
                      //           BorderRadiusDirectional.all(Radius.circular(3))),
                      // ),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Text(TrudaLanguageKey.newhita_details_signature.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: TrudaColors.textColor333,
                          )),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsetsDirectional.only(start: 15, end: 5),
                        margin: EdgeInsetsDirectional.only(
                            top: 15, start: 25, end: 25, bottom: 5),
                        decoration: BoxDecoration(
                            color: TrudaColors.baseColorBlackBg,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                minLines: 5,
                                maxLines: 8,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: TrudaColors.textColor333,
                                ),
                                controller: controller.introTextController,
                                focusNode: controller.introFocusNode,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(200),
                                ],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: TrudaLanguageKey
                                        .newhita_not_exceed
                                        .trArgs(["200"]),
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: TrudaColors.textColor999,
                                    )),
                                onChanged: (str) {
                                  lengthRx.value = str.length;
                                },
                              ),
                            ),
                            // IconButton(
                            //     onPressed: () {
                            //       controller.introTextController.text = "";
                            //       lengthRx.value = 0;
                            //     },
                            //     icon: Image.asset(
                            //         "assets/images/newhita_close_black.png"))
                          ],
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Container(
                      //       margin: EdgeInsetsDirectional.only(end: 15),
                      //       child: Obx(() {
                      //         return Text(
                      //           "${lengthRx.value}/200",
                      //           style: const TextStyle(
                      //             color: TrudaColors.textColor999,
                      //           ),
                      //         );
                      //       }),
                      //     )
                      //   ],
                      // ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          controller.changeIntro();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: const EdgeInsetsDirectional.only(
                              start: 60, end: 60, bottom: 20, top: 20),
                          height: 52,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                TrudaColors.baseColorGradient1,
                                TrudaColors.baseColorGradient2,
                              ]), // 渐变色
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            TrudaLanguageKey.newhita_base_confirm.tr,
                            style: const TextStyle(
                                color: TrudaColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
    // TrudaCommonDialog.bottomSheet(
    //   Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       const NewHitaSheetHeader(),
    //       Container(
    //         decoration: BoxDecoration(
    //           // gradient: LinearGradient(
    //           //     begin: Alignment.topCenter,
    //           //     end: Alignment.bottomCenter,
    //           //     colors: [
    //           //       TrudaColors.baseColorGradient1,
    //           //       TrudaColors.baseColorGradient2,
    //           //     ]),
    //           color: TrudaColors.white,
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             // Container(
    //             //   margin:
    //             //       const EdgeInsetsDirectional.only(top: 10, bottom: 20),
    //             //   width: 42,
    //             //   height: 6,
    //             //   decoration: const BoxDecoration(
    //             //       color: Color(0xFFCCCCCC),
    //             //       borderRadius:
    //             //           BorderRadiusDirectional.all(Radius.circular(3))),
    //             // ),
    //             const SizedBox(
    //               height: 20,
    //               width: 20,
    //             ),
    //             Text(TrudaLanguageKey.newhita_details_signature.tr,
    //                 style: const TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 16,
    //                   color: TrudaColors.textColor333,
    //                 )),
    //             Container(
    //               alignment: Alignment.center,
    //               padding: EdgeInsetsDirectional.only(start: 15, end: 5),
    //               margin: EdgeInsetsDirectional.only(
    //                   top: 15, start: 25, end: 25, bottom: 5),
    //               decoration: BoxDecoration(
    //                   color: TrudaColors.baseColorBlackBg,
    //                   borderRadius: BorderRadius.all(Radius.circular(12))),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                     child: TextField(
    //                       minLines: 5,
    //                       maxLines: 8,
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         color: TrudaColors.textColor333,
    //                       ),
    //                       controller: controller.introTextController,
    //                       focusNode: controller.introFocusNode,
    //                       inputFormatters: [
    //                         LengthLimitingTextInputFormatter(200),
    //                       ],
    //                       decoration: InputDecoration(
    //                           border: InputBorder.none,
    //                           hintText: TrudaLanguageKey.newhita_not_exceed
    //                               .trArgs(["200"]),
    //                           hintStyle: TextStyle(
    //                             fontSize: 12,
    //                             color: TrudaColors.textColor999,
    //                           )),
    //                       onChanged: (str) {
    //                         lengthRx.value = str.length;
    //                       },
    //                     ),
    //                   ),
    //                   // IconButton(
    //                   //     onPressed: () {
    //                   //       controller.introTextController.text = "";
    //                   //       lengthRx.value = 0;
    //                   //     },
    //                   //     icon: Image.asset(
    //                   //         "assets/images/newhita_close_black.png"))
    //                 ],
    //               ),
    //             ),
    //             // Row(
    //             //   mainAxisAlignment: MainAxisAlignment.end,
    //             //   children: [
    //             //     Container(
    //             //       margin: EdgeInsetsDirectional.only(end: 15),
    //             //       child: Obx(() {
    //             //         return Text(
    //             //           "${lengthRx.value}/200",
    //             //           style: const TextStyle(
    //             //             color: TrudaColors.textColor999,
    //             //           ),
    //             //         );
    //             //       }),
    //             //     )
    //             //   ],
    //             // ),
    //             GestureDetector(
    //               onTap: () {
    //                 Get.back();
    //                 controller.changeIntro();
    //               },
    //               child: Container(
    //                 alignment: Alignment.center,
    //                 width: double.infinity,
    //                 margin: const EdgeInsetsDirectional.only(
    //                     start: 60, end: 60, bottom: 20, top: 20),
    //                 height: 52,
    //                 decoration: BoxDecoration(
    //                     gradient: const LinearGradient(colors: [
    //                       TrudaColors.baseColorGradient1,
    //                       TrudaColors.baseColorGradient2,
    //                     ]), // 渐变色
    //                     borderRadius: BorderRadius.circular(50)),
    //                 child: Text(
    //                   TrudaLanguageKey.newhita_base_confirm.tr,
    //                   style: const TextStyle(
    //                       color: TrudaColors.white,
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 16),
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _wItem({
    required String title,
    String? text,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: TrudaColors.textColor333,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (text != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      text,
                      style: const TextStyle(
                          color: TrudaColors.textColor999, fontSize: 14),
                    ),
                  ),
                const Spacer(),
                const SizedBox(
                  width: 4,
                ),
                Image.asset(
                  'assets/images/newhita_arrow_right.png',
                  matchTextDirection: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
