import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/chat/msgitem/truda_chat_msg_image.dart';
import 'package:truda/truda_pages/chat/msgitem/truda_chat_msg_voice.dart';
import 'package:truda/truda_pages/chat/widget/truda_chat_input_controller.dart';
import 'package:truda/truda_pages/chat/widget/truda_chat_input_widget.dart';
import 'package:truda/truda_widget/gift/truda_vap_player.dart';

import '../../truda_common/truda_charge_path.dart';
import '../../truda_dialogs/truda_sheet_host_chat_option.dart';
import '../../truda_rtm/truda_rtm_msg_entity.dart';
import '../../truda_utils/ad/truda_ads_utils.dart';
import '../../truda_utils/truda_gift_follow_tip.dart';
import '../../truda_widget/truda_app_bar.dart';
import '../vip/truda_vip_controller.dart';
import 'truda_chat_controller.dart';
import 'truda_chat_msg_wrapper.dart';
import 'msgitem/truda_chat_msg_call.dart';
import 'msgitem/truda_chat_msg_gift.dart';
import 'msgitem/truda_chat_msg_text.dart';

class TrudaChatPage extends GetView<TrudaChatController> {
  TrudaChatPage({Key? key}) : super(key: key);

  final centerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaChatController>(
        // init: controller,
        builder: (controller) {
      return Scaffold(
        backgroundColor: TrudaColors.baseColorBlackBg,
        resizeToAvoidBottomInset: true,
        appBar: TrudaAppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            child: Image.asset('assets/images/newhita_base_back.png',
              matchTextDirection: true,),
            onTap: () {
              Get.back();
            },
          ),
          title: GetBuilder<TrudaChatController>(
              id: 'herInfo',
              builder: (controller) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Container(
                    //   width: 10,
                    //   height: 10,
                    //   decoration: BoxDecoration(
                    //       color: controller.herDetail?.realOnlineColor,
                    //       borderRadius: BorderRadius.all(Radius.circular(10))),
                    // ),
                    if (controller.herDetail?.realOnlineState == 1)
                      Image.asset('assets/images/newhita_base_online.png'),
                    SizedBox(
                      width: 5,
                    ),
                    LimitedBox(
                      maxWidth: 200,
                      child: Text(
                        controller.herId == TrudaConstants.systemId
                            ? TrudaLanguageKey.newhita_message_official.tr
                            :controller.herId == TrudaConstants.serviceId
                            ? TrudaConstants.appName
                            : controller.herDetail?.nickname ??
                                controller.her?.name ??
                                '',
                        maxLines: 1,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: TrudaColors.textColor000,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                );
              }),
          centerTitle: true,
          actions: [
            // IconButton(
            //     onPressed: () {
            //       // controller.showGift(
            //       //     'https://oss.hanilink.com/assets/gift/1630663212846.mp4');
            //
            //       // Future.delayed(Duration(seconds: 5), () {
            //       //   Get.back();
            //       // });
            //     },
            //     icon: const Icon(
            //       Icons.add,
            //       color: Colors.yellow,
            //     )),
            if (controller.herId != TrudaConstants.systemId)
              Center(
                child: GestureDetector(
                  child: Image.asset('assets/images/newhita_base_more.png'),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return TrudaSheetHostChatOption(
                              herId: controller.herId);
                        });
                  },
                ),
              ),
            const SizedBox(width: 15),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (TrudaAdsUtils.isShowAd(TrudaAdsUtils.NATIVE_CHAT) &&
                    controller.nativeUtils.isReady)
                  Container(
                      height: 60,
                      child: controller.nativeUtils
                          .preparedMessageChatNativeAd(context)),
                if (controller.showMsgTipView &&
                    controller.herId != TrudaConstants.systemId  &&
                    controller.herId != TrudaConstants.serviceId)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          color: Color(0xffFFEBEE),
                          padding: EdgeInsetsDirectional.only(
                            top: 10,
                            bottom: 10,
                            start: 15,
                            end: 15,
                          ),
                          margin: const EdgeInsetsDirectional.only(
                            bottom: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(
                                TrudaLanguageKey.newhita_vip_for_message.tr,
                                style: TextStyle(
                                  color: TrudaColors.textColor333,
                                  fontSize: 14,
                                ),
                              )),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // showRecharge("rtm_top_tip_click_recharge",
                                      //     upid: widget.upid);
                                      // NewHitaChargeDialogManager.showChargeDialog(
                                      //     TrudaChargePath.rtm_top_tip_click_recharge,
                                      //     upid: controller.herId);
                                      TrudaVipController.openDialog(
                                          createPath: TrudaChargePath
                                              .recharge_vip_for_message);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin:
                                          const EdgeInsetsDirectional.only(top: 5),
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 15, end: 15, top: 8, bottom: 8),
                                      decoration: const BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(30)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              TrudaColors.baseColorGradient1,
                                              TrudaColors.baseColorGradient2,
                                            ]),
                                      ),
                                      child: Text(
                                        TrudaLanguageKey.newhita_vip_active.tr,
                                        style: const TextStyle(
                                          color: TrudaColors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   appearMsgTip = false;
                            //   userClose = true;
                            // });
                            controller.showMsgTipView = false;
                            controller.update();
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                            color: Colors.transparent,
                            child: Image.asset(
                                'assets/images/newhita_close_black.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Listener(
                    onPointerDown: (event) {
                      Get.find<TrudaChatInputController>().onPointerDown();
                    },
                    child: NotificationListener(
                        onNotification: (notification) {
                          if (notification is ScrollNotification) {
                            if (notification.metrics is PageMetrics) {
                              return false;
                            }
                            if (notification.metrics is FixedScrollMetrics) {
                              if (notification.metrics.axisDirection ==
                                      AxisDirection.left ||
                                  notification.metrics.axisDirection ==
                                      AxisDirection.right) {
                                return false;
                              }
                            }
                            controller.extentAfter =
                                notification.metrics.extentAfter;
                            controller.extentBefore =
                                notification.metrics.extentBefore;
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                            onRefresh: controller.getOldList,

                            // 两个列表，分别添加下拉出来的旧数据和新发的数据
                            // 为啥这么做？实现不会跳动的双向列表
                            // centerKey代表了列表的中心
                            // https://juejin.cn/post/7029517821004480549
                            child: CustomScrollView(
                              // 加上这个physics，才能在条数少的时候能下拉，
                              // 不过确实当前都条数少不能滑动时，为啥下拉
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: controller.scroller,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              center: centerKey,
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      // var item = controller.loadMoreData[index];
                                      var item = controller.showOldData[index];
                                      // if (item.sendType == 0) {
                                      //   return renderRightItem(item);
                                      // } else {
                                      //   return renderLeftItem(item);
                                      // }
                                      return getMsgWidget(item, index);
                                    },
                                    childCount: controller.showOldData.length,
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.zero,
                                  key: centerKey,
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      // var item = controller.newData[index];
                                      var item = controller.showNewData[index];
                                      return getMsgWidget(item, index);
                                    },
                                    childCount: controller.showNewData.length,
                                  ),
                                ),
                                // footer!,
                              ],
                            ))),
                  ),
                ),
                if (controller.herId != TrudaConstants.systemId)
                  TrudaChatInputWidget(userId: controller.herId),
                // if (controller.herId != NewHitaConstants.systemId)
                //   NewHitaGiftFollowTip(
                //     controller: controller.tipController,
                //   ),
              ],
            ),
            Positioned.fill(
                child: TrudaVapPlayer(
              vapController: controller.myVapController,
            ))
          ],
        ),
        // floatingActionButton: GestureDetector(
        //   onTap: () {
        //     TrudaLocalController.startMe(
        //         controller.userId, controller.her?.portrait);
        //   },
        //   // tooltip: 'chat',
        //   // heroTag: 'chat',
        //   // backgroundColor: Colors.transparent,
        //   child: Image.asset(
        //     width: 100,
        //     height: 100,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // floatingActionButtonLocation: const _NewHitaChatCallLocation(),
      );
    });
  }

  Widget getMsgWidget(TrudaChatMsgWrapper wrapper, int index) {
    if (TrudaRTMMsgPhoto.typeCodes.contains(wrapper.msgEntity.msgType)) {
      return TrudaChatMsgImage(wrapper: wrapper);
    }
    if (TrudaRTMMsgVoice.typeCodes.contains(wrapper.msgEntity.msgType)) {
      return TrudaChatMsgVoice(wrapper: wrapper);
    }
    switch (wrapper.msgEntity.msgType) {
      case TrudaRTMMsgText.typeCode:
        return TrudaChatMsgText(wrapper: wrapper);
      case TrudaRTMMsgGift.typeCode:
        return TrudaChatMsgGift(wrapper: wrapper);
      case TrudaRTMMsgCallState.typeCode:
        return TrudaChatMsgCall(wrapper: wrapper);
      default:
        return const SizedBox();
    }
  }
}

// class _NewHitaChatCallLocation extends StandardFabLocation
//     with FabEndOffsetX, FabFloatOffsetY {
//   const _NewHitaChatCallLocation();
//   @override
//   double getOffsetY(
//       ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
//     // 比着原来的高度减去一些放右下角
//     return super.getOffsetY(scaffoldGeometry, adjustment) - 120;
//   }
//
//   @override
//   String toString() => 'FloatingActionButtonLocation.endFloat';
// }
class TrudaChatFloatCall extends StatefulWidget {
  Function callBack;

  TrudaChatFloatCall({Key? key, required this.callBack}) : super(key: key);

  @override
  State<TrudaChatFloatCall> createState() => _TrudaChatFloatCallState();
}

class _TrudaChatFloatCallState extends State<TrudaChatFloatCall> {
  double toRight = 15;
  double toBottom = 15;
  double maxToRight = Get.width - 75;
  double maxToBottom = Get.width - 35;

  /// 拖动小窗口
  void _onPanUpdate(DragUpdateDetails tapInfo) {
    toBottom -= tapInfo.delta.dy;
    // toRight -= tapInfo.delta.dx;
    toRight -= tapInfo.delta.dx;
    if (toBottom < 15) {
      toBottom = 15;
    } else if (toBottom > maxToBottom) {
      toBottom = maxToBottom;
    }
    if (toRight < 15) {
      toRight = 15;
    } else if (toRight > maxToRight) {
      toRight = maxToRight;
    }
    setState(() {});
  }

  void _onPanCancel(DragEndDetails tapInfo) {
    setState(() {
      if (toRight > Get.width / 2) {
        toRight = maxToRight;
      } else {
        toRight = 15;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        Positioned(
            bottom: 15,
            right: toRight,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanCancel,
              onTap: () => widget.callBack.call(),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TrudaColors.baseColorOrange,
                          TrudaColors.baseColorRed,
                        ]),
                    border: Border.all(
                      color: TrudaColors.white,
                      width: 1,
                    )),
                child: Image.asset(
                  "assets/images_ani/newhita_host_call.webp",
                  width: 26,
                  height: 26,
                ),
              ),
            ))
      ],
    );
  }
}
