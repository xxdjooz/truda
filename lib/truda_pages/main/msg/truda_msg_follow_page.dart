import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_pages/chat/truda_chat_controller.dart';
import 'package:truda/truda_pages/main/msg/truda_msg_follow_controller.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/truda_log.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';
import 'package:intl/intl.dart';

import '../../../truda_database/entity/truda_conversation_entity.dart';

class TrudaMsgFollowPage extends StatelessWidget {
  TrudaMsgFollowPage({Key? key}) : super(key: key);
  final TrudaMsgFollowController msgController =
      Get.put(TrudaMsgFollowController());

  @override
  Widget build(BuildContext context) {
    TrudaLog.debug("NewHitaMsgPage build");
    return Scaffold(
      backgroundColor: Colors.transparent,
      // body: GetBuilder<NewHitaMsgController>(
      //     tag: "list",
      //     init: msgController,
      //     builder: (controller) {
      //       NewHitaLog.debug("NewHitaMsgPage GetBuilder");
      //       return ListView.builder(
      //           itemCount: msgController.dataList.length,
      //           itemExtent: 90,
      //           itemBuilder: (context, index) {
      //             return getItem(msgController.dataList[index]);
      //           });
      //     }),
      body: Obx(() {
        return msgController.dataList.value.isEmpty
            ? RefreshIndicator(
                onRefresh: msgController.refresh,
                child: ListView(
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
                ),
              )
            : RefreshIndicator(
                onRefresh: msgController.refresh,
                child: ListView.builder(
                    itemCount: msgController.dataList.length,
                    itemExtent: 90,
                    itemBuilder: (context, index) {
                      return TrudaMsgWidget(msg: msgController.dataList[index]);
                    }),
              );
      }),
    );
  }
}

class TrudaMsgWidget extends StatelessWidget {
  final TrudaConversationEntity msg;

  const TrudaMsgWidget({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var her = TrudaStorageService.to.objectBoxMsg.queryHer(msg.herId);
    // NewHitaLog.debug('NewHitaMsgWidget build her=$her');
    var time = DateTime.fromMillisecondsSinceEpoch(msg.dateInsert);
    var str = DateFormat('MM.dd HH:mm').format(time);
    return InkWell(
      onTap: () {
        TrudaChatController.startMe(msg.herId);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Row(
          children: [
            NewHitaNetImage(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      her?.name ?? "",
                      style: TextStyle(color: TrudaColors.textColor666),
                    ),
                    Text(
                      str,
                      style: TextStyle(color: TrudaColors.textColor666),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(child: _getConversitonContent()),
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
                  ],
                ),
              ],
            )),
          ],
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
            style: TextStyle(color: TrudaColors.white, fontSize: 12));
      case 11:
        return Image.asset('assets/images/newhita_conver_gift.png');
      case 13:
      case 20:
        return Image.asset('assets/images/newhita_conver_photo.png');
      case 14:
      case 21:
        return Image.asset('assets/images/newhita_conver_voice.png');
    }
    return Text(msg.content);
  }
}
