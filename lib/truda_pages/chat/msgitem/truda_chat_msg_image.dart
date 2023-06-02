import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_pages/some/truda_media_view_page.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_entity.dart';
import 'package:truda/truda_widget/truda_net_image.dart';

import '../truda_chat_msg_widget.dart';
import '../truda_chat_msg_wrapper.dart';

class TrudaChatMsgImage extends StatelessWidget {
  final TrudaChatMsgWrapper wrapper;

  const TrudaChatMsgImage({Key? key, required this.wrapper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var her = wrapper.her;
    var msg = wrapper.msgEntity;
    TrudaRTMMsgPhoto? rtmMsg;
    if (msg.rawData.isNotEmpty) {
      Map<String, dynamic> jsonMap = json.decode(msg.rawData);
      rtmMsg = TrudaRTMMsgPhoto.fromJson(jsonMap);
    }
    // 收到的消息有rtmMsg，发送中的图片消息还没有
    var url = rtmMsg?.thumbnailUrl ?? rtmMsg?.imageUrl;
    return wrapper.herSend
        ? TrudaLianChatMsgHer(
            wrapper: wrapper,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: TrudaColors.baseColorChatHer,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: LimitedBox(
                maxWidth: 180,
                maxHeight: 240,
                child: GestureDetector(
                    onTap: () {
                      TrudaMediaViewPage.startMe(context,
                          path: url ?? '', cover: '', type: 0, heroId: 0);
                    },
                    child: TrudaNetImage(url ?? '')),
              ),
            ),
          )
        : TrudaLianChatMsgMe(
            wrapper: wrapper,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: TrudaColors.baseColorChatMine,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              margin: const EdgeInsets.only(top: 5),
              child: LimitedBox(
                maxWidth: 180,
                maxHeight: 240,
                child: url != null
                    ? GestureDetector(
                        onTap: () {
                          TrudaMediaViewPage.startMe(context,
                              path: url ?? '', cover: '', type: 0, heroId: 0);
                        },
                        child: TrudaNetImage(url))
                    : Image.file(File(msg.extra ?? '')),
              ),
            ),
          );
  }
}
