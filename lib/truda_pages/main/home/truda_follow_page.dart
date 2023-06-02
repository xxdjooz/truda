import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_text_styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_utils/truda_format_util.dart';
import '../../../truda_widget/truda_avatar_with_bg.dart';
import '../../call/local/truda_local_controller.dart';
import '../../chat/truda_chat_controller.dart';
import '../../host/truda_host_controller.dart';
import 'truda_follow_controller.dart';
import 'truda_host_widget.dart';

class TrudaFollowPage extends StatelessWidget {
  TrudaFollowPage({Key? key}) : super(key: key);
  final TrudaFollowController _controller =
      Get.put(TrudaFollowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          color: TrudaColors.white,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(20), topStart: Radius.circular(20)),
        ),
        child: GetBuilder<TrudaFollowController>(builder: (controller) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: controller.enablePullUp,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: _controller.dataList.isEmpty
                ? ListView(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 300,
                        child: Image.asset(
                          'assets/images/newhita_base_empty.png',
                          height: 100,
                          width: 100,
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     mainAxisSpacing: 10,
                    //     crossAxisSpacing: 10,
                    //     childAspectRatio: 17 / 23),
                    itemCount: _controller.dataList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var bean = _controller.dataList[index];
                      return TrudaFollowWidget(
                        detail: bean,
                      );
                    }),
          );
        }),
      ),
    );
  }
}

class TrudaFollowWidget extends StatelessWidget {
  final TrudaHostDetail detail;

  const TrudaFollowWidget({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          TrudaColors.white,
          Color(0xffECD6FF),
        ]),
        borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(20), bottomEnd: Radius.circular(20)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              TrudaHostController.startMe(detail.userId!, detail.portrait);
            },
            child: Stack(
              children: [
                TrudaAvatarWithBg(
                  url: detail.portrait ?? "",
                  width: 74,
                  height: 74,
                ),
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  child: TrudaHostStateWidget(
                    isDoNotDisturb: detail.isDoNotDisturb ?? 0,
                    isOnline: detail.isOnline ?? 0,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 70,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          detail.nickname ?? "",
                          style: const TrudaTextStyles.black16(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            // NewHitaNetImage(
                            //   detail.area?.path ?? "",
                            //   radius: 9,
                            //   width: 14,
                            //   height: 14,
                            // ),
                            // const SizedBox(
                            //   width: 4,
                            // ),
                            Container(
                              decoration: BoxDecoration(
                                  color: TrudaColors.baseColorRedLight
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/newhita_base_female.png',
                                    width: 10,
                                    height: 10,
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    '${TrudaFormatUtil.getAge(DateTime.fromMillisecondsSinceEpoch(detail.birthday ?? 0))}',
                                    style: const TextStyle(
                                        color: TrudaColors.baseColorRedLight,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                        if (!TrudaConstants.isFakeMode)
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text.rich(TextSpan(
                                  text: "${detail.charge ?? '--'}",
                                  style: const TextStyle(
                                      color: TrudaColors.textColorTitle, fontSize: 14),
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Image.asset(
                                          "assets/images/newhita_diamond_small.png",
                                          height: 12,
                                          width: 12,
                                        )),
                                    TextSpan(
                                      text: TrudaLanguageKey
                                          .newhita_video_time_unit.tr,
                                      style: const TextStyle(
                                          color: TrudaColors.textColor666,
                                          fontSize: 13),
                                    ),
                                  ]))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      TrudaChatController.startMe(detail.userId!,
                          detail: detail);
                    },
                    child: Container(
                      // padding: EdgeInsets.all(8),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(30)),
                      //     color: TrudaColors.baseColorPink,
                      //     border: Border.all(
                      //       color: TrudaColors.white,
                      //       width: 1,
                      //     )),
                      child: Image.asset(
                        "assets/images/newhita_home_msg.png",
                        width: 49,
                        height: 49,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (detail.isShowOnline && !TrudaConstants.isFakeMode)
                    GestureDetector(
                      onTap: () {
                        TrudaLocalController.startMe(
                            detail.userId!, detail.portrait);
                      },
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.all(Radius.circular(30)),
                        //   color: TrudaColors.baseColorGreen,
                        // ),
                        child: Image.asset(
                          "assets/images_ani/newhita_home_call.webp",
                          width: 49,
                          height: 49,
                        ),
                      ),
                    ),
                  if (detail.isShowOnline && !TrudaConstants.isFakeMode)
                    const SizedBox(
                      width: 10,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
