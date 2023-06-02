import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_text_styles.dart';
import 'package:truda/truda_pages/chat/truda_chat_controller.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/truda_log.dart';
import 'package:truda/truda_widget/truda_net_image.dart';
import 'package:intl/intl.dart';

import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_database/entity/truda_conversation_entity.dart';
import '../../../truda_services/truda_my_info_service.dart';
import '../../../truda_utils/ad/truda_ads_utils.dart';
import '../../../truda_utils/truda_ai_help_manager.dart';
import 'truda_msg_controller.dart';

class TrudaMsgPage extends StatelessWidget {
  TrudaMsgPage({Key? key}) : super(key: key);
  final TrudaMsgController msgController = Get.put(TrudaMsgController());

  @override
  Widget build(BuildContext context) {
    TrudaLog.debug("NewHitaMsgPage build");
    return GetBuilder<TrudaMsgController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            color: TrudaColors.white,
            borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(20), topStart: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Obx(() {
                  return CustomScrollView(
                    slivers: [
                      if (TrudaConstants.appMode != 2)
                        SliverToBoxAdapter(
                          child: InkWell(
                              onTap: () {
                                TrudaAihelpManager.enterMinAIHelp(
                                    TrudaMyInfoService.to
                                            .getMyLeval()
                                            ?.grade ??
                                        1,
                                    1);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 13),
                                decoration: const BoxDecoration(
                                  color: TrudaColors.white,
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(50),
                                    topEnd: Radius.circular(20),
                                    bottomStart: Radius.circular(50),
                                    bottomEnd: Radius.circular(20),
                                  ),
                                ),
                                margin: EdgeInsetsDirectional.only(bottom: 10),
                                height: 84,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/newhita_conver_service.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              TrudaLanguageKey
                                                  .newhita_mine_customer_service
                                                  .tr,
                                              style: TextStyle(
                                                  color: TrudaColors
                                                      .textColor666),
                                            ),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: TrudaColors
                                                      .textColor666),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              color:
                                                  TrudaColors.textColor666),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              )),
                        ),
                      if (TrudaAdsUtils.isShowAd(
                              TrudaAdsUtils.NATIVE_CONVERSATION_LIST) &&
                          msgController.nativeUtils.isReady)
                        SliverToBoxAdapter(
                          child: Container(
                              height: 76,
                              padding: EdgeInsetsDirectional.only(bottom: 10),
                              child: msgController.nativeUtils
                                  .preparedMessageNativeAd(context)),
                        ),
                      if (TrudaAdsUtils.isShowAd(
                              TrudaAdsUtils.REWARD_ONE_MESSAGE_CHAT) &&
                          msgController.rewardedUtils.isReady)
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: () {
                              msgController.rewardedUtils.showRewardAd();
                            },
                            child: Container(
                              // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                              decoration: const BoxDecoration(
                                color: TrudaColors.white,
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(50),
                                  topEnd: Radius.circular(20),
                                  bottomStart: Radius.circular(50),
                                  bottomEnd: Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 12),
                              margin: EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 12),

                              height: 90,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/newhita_ad_free_diamond.png',
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        TrudaLanguageKey
                                            .newhita_message_free_coins.tr,
                                        style: TextStyle(
                                            color: TrudaColors.textColor666,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        TrudaLanguageKey
                                            .newhita_message_free_coins_value
                                            .tr,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: TrudaColors.textColor666),
                                      ),
                                    ],
                                  )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    "assets/images/newhita_ad_go.png",
                                    width: 24,
                                    height: 24,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      msgController.dataList.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) =>
                                    NewHitaMsgWidget(
                                  msg: msgController.dataList[index],
                                  msgController: msgController,
                                ),
                                childCount: msgController.dataList.length,
                              ),
                            )
                          : SliverPadding(
                              padding: EdgeInsets.zero,
                            ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class NewHitaMsgWidget extends StatelessWidget {
  final TrudaConversationEntity msg;
  final TrudaMsgController msgController;

  const NewHitaMsgWidget(
      {Key? key, required this.msg, required this.msgController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var her = TrudaStorageService.to.objectBoxMsg.queryHer(msg.herId);
    TrudaLog.debug('NewHitaMsgWidget build her=$her');
    var time = DateTime.fromMillisecondsSinceEpoch(msg.dateInsert);
    var str = DateFormat('MM.dd HH:mm').format(time);
    return Padding(
      padding: EdgeInsetsDirectional.only(
        bottom: 10,
      ),
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: ValueKey(msg.herId),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            // SlidableAction(
            //   // An action can be bigger than the others.
            //   flex: 1,
            //   onPressed: (c) {},
            //   backgroundColor: Color(0xFFFF306D).withOpacity(0.2),
            //   foregroundColor: Color(0xFFFF306D),
            //   icon: Icons.delete_outline,
            //   // label: '',
            // ),
            CustomSlidableAction(
              backgroundColor: Colors.transparent,
              flex: 1,
              padding: EdgeInsets.zero,
              onPressed: (BuildContext context) {
                TrudaStorageService.to.objectBoxMsg.removeHer(msg.herId);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFF306D),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: AlignmentDirectional.center,
                child: Image.asset(
                  'assets/images/newhita_conver_delete.png',
                  width: 38,
                  height: 38,
                ),
              ),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            TrudaChatController.startMe(msg.herId);
          },
          // onLongPress: () {
          //   NewHitaStorageService.to.objectBoxMsg.removeHer(msg.herId);
          // },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: const BoxDecoration(
              color: TrudaColors.white,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(50),
                topEnd: Radius.circular(20),
                bottomStart: Radius.circular(50),
                bottomEnd: Radius.circular(20),
              ),
            ),
            height: 77,
            child: Row(
              children: [
                msg.herId == TrudaConstants.systemId ||
                        msg.herId == TrudaConstants.serviceId
                    ? Image.asset(
                        'assets/images/newhita_conver_system.png',
                        width: 50,
                        height: 50,
                      )
                    : TrudaNetImage(
                        her?.portrait ?? "",
                        width: 50,
                        height: 50,
                        isCircle: true,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          msg.herId == TrudaConstants.systemId
                              ? TrudaLanguageKey.newhita_message_official.tr
                              : msg.herId == TrudaConstants.serviceId
                                  ? TrudaConstants.appName
                                  : her?.name ?? "",
                          style: const TrudaTextStyles.black16(),
                        ),
                        Text(
                          str,
                          style: const TextStyle(
                              color: TrudaColors.textColor999, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(child: _getConversitonContent()),
                            ],
                          ),
                        ),
                        msg.unReadQuality > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  msg.unReadQuality.toString(),
                                  style: TextStyle(
                                      color: TrudaColors.white, fontSize: 12),
                                ))
                            : SizedBox(
                                width: 40,
                              ),
                        // GestureDetector(
                        //   onTap: () {
                        //     bool black =
                        //     NewHitaStorageService.to.checkBlackList(msg.herId);
                        //     String str = black
                        //         ? TrudaLanguageKey.newhita_confirm_black_remove.tr
                        //         : TrudaLanguageKey.newhita_confirm_black_add.tr;
                        //     Get.dialog(NewHitaDialogConfirm(
                        //       title: str,
                        //       callback: (i) {
                        //         msgController.handleBlack(msg.herId);
                        //       },
                        //     ));
                        //   },
                        //   child: ColoredBox(
                        //     color: Colors.white,
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(4.0),
                        //       child: Image.asset(
                        //         'assets/images/newhita_base_close.png',
                        //         width: 12,
                        //         height: 12,
                        //         fit: BoxFit.fill,
                        //         color: TrudaColors.textColor999,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // type text = 10
  // type gift = 11
  // type call = 12
  // type imge = 13 图片消息
  // type voice = 14 语音消息
  // type video = 15
  // type severImge = 20//服务器图片消息
  // type severVoice = 21 //服务器语音消息
  // type = 24 //AIA下发的视频
  // type = 25 //AIB
  // type = 23    服务器会发送begincall
  Widget _getConversitonContent() {
    switch (msg.lastMsgType) {
      case 10:
        return Text(msg.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: TrudaColors.textColor999, fontSize: 14));
      case 11:
        return Image.asset('assets/images/newhita_conver_gift.png');
      case 13:
      case 20:
        return Image.asset('assets/images/newhita_conver_photo.png');
      case 14:
      case 21:
        return Image.asset('assets/images/newhita_conver_voice.png');
      case 12:
        return Image.asset('assets/images/newhita_conver_call.png');
    }
    return Text(msg.content);
  }
}
