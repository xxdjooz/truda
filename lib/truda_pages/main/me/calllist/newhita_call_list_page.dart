import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_common/truda_text_styles.dart';
import 'package:truda/truda_pages/host/truda_host_controller.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_common/truda_constants.dart';
import '../../../../truda_utils/newhita_format_util.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import '../../../../truda_widget/newhita_avatar_with_bg.dart';
import '../../../call/local/truda_local_controller.dart';
import '../../../chat/truda_chat_controller.dart';
import '../../home/truda_host_widget.dart';
import 'newhita_call_list_controller.dart';

class NewHitaCallListPage extends GetView<NewHitaCallListController> {
  NewHitaCallListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewHitaCallListController>(builder: (contro) {
      return Scaffold(
        appBar: NewHitaAppBar(
          title: Text(
            TrudaLanguageKey.newhita_conver_history.tr,
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: GetBuilder<NewHitaCallListController>(builder: (controller) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: controller.enablePullUp,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: controller.loadState != 1
                ? ListView(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 300,
                        child: controller.loadState == 2
                            ? Image.asset(
                                'assets/images/newhita_base_empty.png',
                                height: 100,
                                width: 100,
                              )
                            : CircularProgressIndicator(),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: controller.dataList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var bean = controller.dataList[index];
                      String updateTime;
                      var time = DateTime.fromMillisecondsSinceEpoch(
                          bean.createdAt ?? 0);
                      updateTime = DateFormat('yyyy.MM.dd HH:mm').format(time);
                      return GestureDetector(
                        onTap: () {
                          TrudaHostController.startMe(
                              (bean.peerUserId ?? 0).toString(),
                              bean.peerPortrait);
                        },
                        child: Container(
                          margin: EdgeInsetsDirectional.only(bottom: 10),
                          padding: EdgeInsetsDirectional.symmetric(vertical: 15,horizontal: 10),
                          decoration: BoxDecoration(
                            color: TrudaColors.white,
                            borderRadius: BorderRadiusDirectional.circular(20),
                            // border: Border(
                            //     top: BorderSide(
                            //         color: Colors.white30, width: 0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  TrudaHostController.startMe(
                                      (bean.peerUserId ?? 0).toString(),
                                      bean.peerPortrait);
                                },
                                child: Stack(
                                  children: [
                                    NewHitaAvatarWithBg(
                                      url: bean.peerPortrait ?? "",
                                      width: 65,
                                      height: 65,
                                    ),
                                    PositionedDirectional(
                                      bottom: 0,
                                      end: 0,
                                      child: TrudaHostStateWidget(
                                        isDoNotDisturb:
                                            bean.peerIsDoNotDisturb ?? 0,
                                        isOnline: bean.peerIsOnline ?? 0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                height: 70,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    (bean.peerNickname ?? "--"),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        const TrudaTextStyles
                                                            .black16(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              (bean.channelStatus != 4)
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFFFF51A8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Text(
                                                        TrudaLanguageKey
                                                            .newhita_call_disconnected
                                                            .tr,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: TrudaColors
                                                                .white,
                                                            fontSize: 12),
                                                      ),
                                                    )
                                                  : Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff19D9B9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            width: 4,
                                                            height: 4,
                                                            margin:
                                                                EdgeInsetsDirectional
                                                                    .only(
                                                                        end: 4),
                                                          ),
                                                          Text(
                                                            NewHitaFormatUtil
                                                                .getTimeStrFromSecond(
                                                                    (bean.clientDuration ??
                                                                            0) ~/
                                                                        1000),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    TrudaColors
                                                                        .white,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Container(
                                            height: 5,
                                            color: Colors.transparent,
                                          ),
                                          Text(updateTime,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: TrudaColors
                                                      .textColor999,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (bean.isShowOnline &&
                                        !TrudaConstants.isFakeMode)
                                      GestureDetector(
                                        onTap: () {
                                          TrudaLocalController.startMe(
                                              (bean.peerUserId ?? 0).toString(),
                                              bean.peerPortrait);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            gradient: const LinearGradient(colors: [
                                              TrudaColors.baseColorGradient1,
                                              TrudaColors.baseColorGradient2,
                                            ]),
                                          ),
                                          child: Image.asset(
                                            "assets/images_ani/newhita_host_call.webp",
                                            width: 26,
                                            height: 26,
                                          ),
                                        ),
                                      )
                                    else
                                      GestureDetector(
                                        onTap: () {
                                          TrudaChatController.startMe(
                                              (bean.peerUserId ?? 0)
                                                  .toString());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            gradient: const LinearGradient(colors: [
                                              TrudaColors.baseColorGradient1,
                                              TrudaColors.baseColorGradient2,
                                            ]),),
                                          child: Image.asset(
                                            "assets/images/newhita_host_msg.png",
                                            width: 28,
                                            height: 28,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              )),

                              // Icon(
                              //   Icons.call,
                              //   color: bean.callStatus == 1004
                              //       ? Colors.green
                              //       : Colors.redAccent,
                              // )
                            ],
                          ),
                        ),
                      );
                    }),
          );
        }),
      );
    });
  }
}
