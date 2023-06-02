import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/main/moment/newhita_moment_list_controller.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_widget/newhita_decoration_bg.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import '../../../truda_common/truda_constants.dart';
import '../../../truda_utils/newhita_format_util.dart';
import '../../call/local/truda_local_controller.dart';
import '../../chat/truda_chat_controller.dart';
import '../../host/newhita_host_controller.dart';
import '../../some/newhita_media_view_page.dart';
import '../home/newhita_host_widget.dart';

class NewHitaMomentListPage extends GetView<NewHitaMomentListController> {
  bool iosMock;

  NewHitaMomentListPage({Key? key, this.iosMock = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewHitaMomentListController());
    return GetBuilder<NewHitaMomentListController>(builder: (contro) {
      return Container(
        decoration: iosMock ? null : const NewHitaDecorationBg(),
        child: Scaffold(
          appBar: iosMock
              ? null
              : NewHitaAppBar(
                  // title: Text(
                  //   TrudaLanguageKey.newhita_setting_black_list.tr,
                  // ),
                  title: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 15),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images_sized/newhita_circle_indicator.png'),
                        ),
                      ),
                      child: Text(
                        TrudaLanguageKey.newhita_story.tr,
                        style: const TextStyle(
                          color: TrudaColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  leadingWidth: 0,
                  leading: const SizedBox(),
                  titleSpacing: 0,
                  actions: [
                    GestureDetector(
                      child: Image.asset(
                          'assets/images/newhita_moment_camera.png'),
                      onTap: () {
                        Get.toNamed(NewHitaAppPages.createMoment);
                      },
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // )
                  ],
                ),
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              color: TrudaColors.white,
              borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(20), topStart: Radius.circular(20)),
            ),
            child:
                GetBuilder<NewHitaMomentListController>(builder: (controller) {
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: controller.enablePullUp,
                controller: controller.refreshController,
                onRefresh: controller.onRefresh,
                onLoading: controller.onLoading,
                child: controller.dataList.isEmpty
                    ? ListView(
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 300,
                            child: controller.justOpen
                                ? const CircularProgressIndicator()
                                : Image.asset(
                                    'assets/images/newhita_base_empty.png',
                                    height: 100,
                                    width: 100,
                                  ),
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: controller.dataList.length,
                        padding: const EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          var bean = controller.dataList[index];
                          String? updateTime;
                          var time = DateTime.fromMillisecondsSinceEpoch(
                              bean.createdAt ?? 0);
                          updateTime = DateFormat('HH:mm').format(time);
                          return Container(
                            margin:
                                const EdgeInsetsDirectional.only(bottom: 10),
                            // padding: const EdgeInsetsDirectional.all(10),
                            decoration: BoxDecoration(
                              color: TrudaColors.white,
                              borderRadius: BorderRadius.circular(14),
                              // border: Border(
                              //     top: BorderSide(color: Colors.white24, width: 1)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    var result =
                                    await NewHitaHostController
                                        .startMe(bean.userId!,
                                        bean.portrait);
                                    if (result == 1) {
                                      controller.onRefresh();
                                    }
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      NewHitaNetImage(
                                        bean.portrait ?? "",
                                        width: 42,
                                        height: 42,
                                        radius: 21,
                                      ),
                                      PositionedDirectional(
                                        top: -4,
                                        start: -4,
                                        child: NewHitaHostStateWidget(
                                          isDoNotDisturb:
                                              bean.isDoNotDisturb ?? 0,
                                          isOnline: bean.isOnline ?? 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var result =
                                              await NewHitaHostController
                                                  .startMe(bean.userId!,
                                                      bean.portrait);
                                          if (result == 1) {
                                            controller.onRefresh();
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(end: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (bean.nickname ?? "--"),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: TrudaColors
                                                            .textColor000,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        updateTime,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: TrudaColors
                                                                .textColor999,
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                            GestureDetector(
                                              onTap: () {
                                                TrudaChatController.startMe(bean.userId!);
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
                                                  width: 43,
                                                  height: 43,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (bean.isShowOnline && !TrudaConstants.isFakeMode)
                                              GestureDetector(
                                                onTap: () {
                                                  TrudaLocalController.startMe(
                                                      bean.userId!, bean.portrait);
                                                },
                                                child: Container(
                                                  // padding: EdgeInsets.all(10),
                                                  // decoration: BoxDecoration(
                                                  //   borderRadius: BorderRadius.all(Radius.circular(30)),
                                                  //   color: TrudaColors.baseColorGreen,
                                                  // ),
                                                  child: Image.asset(
                                                    "assets/images_ani/newhita_home_call.webp",
                                                    width: 43,
                                                    height: 43,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (bean.content != null &&
                                          bean.content!.isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            bean.content ?? '',
                                            style: const TextStyle(
                                              color: TrudaColors.textColor333,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      if (bean.medias?.isNotEmpty == true)
                                        GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 0,
                                          ),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisSpacing: 4,
                                            crossAxisSpacing: 5,
                                            crossAxisCount:
                                                bean.medias!.length == 1
                                                    ? 2
                                                    : 3,
                                          ),
                                          itemCount: bean.medias!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var media = bean.medias![index];
                                            var heroId =
                                                bean.createdAt ?? index;
                                            return GestureDetector(
                                              onTap: () {
                                                NewHitaMediaViewPage.startMe(
                                                    context,
                                                    path: media.mediaUrl ?? '',
                                                    cover: media.screenshotUrl,
                                                    type: media.mediaType,
                                                    heroId: heroId);
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Hero(
                                                    tag: heroId,
                                                    child: NewHitaNetImage(
                                                      media.mediaType == 1
                                                          ? media.screenshotUrl!
                                                          : media.mediaUrl!,
                                                      radius: 14,
                                                    ),
                                                  ),
                                                  if (media.mediaType == 1)
                                                    Image.asset(
                                                        'assets/images/newhita_base_video_play.png'),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              var hadPraised =
                                                  bean.praised == 1;
                                              if (hadPraised) {
                                                bean.praised = 0;
                                                bean.praiseCount =
                                                    (bean.praiseCount ?? 1) - 1;
                                              } else {
                                                bean.praised = 1;
                                                bean.praiseCount =
                                                    (bean.praiseCount ?? 0) + 1;
                                              }
                                              controller.priseMoment(
                                                  bean.momentId ?? '',
                                                  !hadPraised);
                                              controller.update();
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    bean.praised == 1
                                                        ? 'assets/images/newhita_moment_heart_red.png'
                                                        : 'assets/images/newhita_moment_heart.png',
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    (bean.praiseCount ?? 0)
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: TrudaColors
                                                            .textColor999,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     contro.blackMoment(
                                          //         bean.momentId!, index);
                                          //   },
                                          //   child: Container(
                                          //     color: Colors.transparent,
                                          //     padding: const EdgeInsets.symmetric(
                                          //         vertical: 5),
                                          //     child: Image.asset(
                                          //       'assets/images/newhita_base_close.png',
                                          //       width: 20,
                                          //       height: 20,
                                          //       color: TrudaColors.textColor999,
                                          //     ),
                                          //   ),
                                          // ),
                                          const SizedBox(width: 15),
                                          GestureDetector(
                                            onTap: () {
                                              contro.reportMoment(
                                                  bean.momentId!, index);
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/newhita_moment_report.png',
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    TrudaLanguageKey
                                                        .newhita_report_title.tr,
                                                    style: const TextStyle(
                                                        color: TrudaColors.textColor999,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
              );
            }),
          ),
        ),
      );
    });
  }
}
