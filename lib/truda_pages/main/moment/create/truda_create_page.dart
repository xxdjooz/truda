import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/main/moment/create/truda_create_controller.dart';
import 'package:truda/truda_widget/newhita_click_widget.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_utils/truda_choose_image_util.dart';
import '../../../../truda_widget/newhita_app_bar.dart';

class TrudaCreatePage extends GetView<TrudaCreateController> {
  TrudaCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaCreateController>(builder: (contro) {
      return Listener(
        onPointerDown: (event) {
          if (controller.introFocusNode.hasFocus) {
            controller.introFocusNode.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: TrudaColors.white,
          appBar: NewHitaAppBar(
            // title: Text(
            //   TrudaLanguageKey.newhita_story_post.tr,
            //   style: TextStyle(color: TrudaColors.textColor333),
            // ),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: GestureDetector(
              onTap: () => Navigator.maybePop(Get.context!),
              child: Container(
                padding: const EdgeInsetsDirectional.only(start: 15),
                alignment: AlignmentDirectional.centerStart,
                child: Image.asset('assets/images/newhita_base_back.png',
                  matchTextDirection: true,),
              ),

            ),
            actions: [
              NewHitaClickWidget(
                child: Center(
                  child: Image.asset('assets/images/newhita_moment_create.png'),
                ),
                onTap: controller.postContent,
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          extendBodyBehindAppBar: false,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsetsDirectional.only(start: 15, end: 5),
                  margin: EdgeInsetsDirectional.only(
                      top: 15, start: 15, end: 15, bottom: 5),
                  decoration: BoxDecoration(
                      // color: Color(0xff2E262C),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    minLines: 5,
                    maxLines: 30,
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
                        hintText:
                            TrudaLanguageKey.newhita_not_exceed.trArgs(["200"]),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: TrudaColors.textColor999,
                        )),
                    onChanged: (str) {
                      controller.lengthRx.value = str.length;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsetsDirectional.only(end: 15),
                      child: Obx(() {
                        return Text(
                          "${controller.lengthRx.value}/200",
                          style: const TextStyle(
                            color: TrudaColors.textColor999,
                          ),
                        );
                      }),
                    )
                  ],
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                  ),
                  itemCount: controller.goraMomentDetail.medias!.length >= 3
                      ? controller.goraMomentDetail.medias!.length
                      : controller.goraMomentDetail.medias!.length + 1,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == controller.goraMomentDetail.medias!.length) {
                      return GestureDetector(
                        onTap: () {
                          TrudaChooseImageUtil(
                                  type: 1, callBack: controller.upLoadCallBack)
                              .openChooseDialog();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: TrudaColors.baseColorBlackBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child:
                              Image.asset('assets/images/newhita_moment_add.png'),
                        ),
                      );
                    }
                    var media = controller.goraMomentDetail.medias![index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Builder(builder: (context) {
                        String path = media.localPath!;
                        bool isUploading = media.uploadState == 0;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Image.file(
                                File(path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isUploading)
                              CircularProgressIndicator(
                                strokeWidth: 2.0,
                              )
                            else
                              PositionedDirectional(
                                  top: 0,
                                  end: 0,
                                  child: GestureDetector(
                                    onTap: () => contro.removeMedia(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      color: Colors.transparent,
                                      child: Image.asset(
                                        'assets/images/newhita_close_black.png',
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
                          ],
                        );
                      }),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    TrudaLanguageKey.newhita_story_create_forbid.tr,
                    style: TextStyle(
                      color: TrudaColors.textColor999,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
