import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_entity.dart';
import 'package:truda/truda_widget/truda_net_image.dart';

import '../truda_chat_msg_widget.dart';
import '../truda_chat_msg_wrapper.dart';

class TrudaChatMsgGift extends StatelessWidget {
  final TrudaChatMsgWrapper wrapper;

  const TrudaChatMsgGift({Key? key, required this.wrapper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var her = wrapper.her;
    var msg = wrapper.msgEntity;
    TrudaRTMMsgGift? rtmMsg;
    if (msg.rawData.isNotEmpty) {
      Map<String, dynamic> jsonMap = json.decode(msg.rawData);
      rtmMsg = TrudaRTMMsgGift.fromJson(jsonMap);
    }
    // 收到的消息有rtmMsg，发送中的图片消息还没有
    var url = rtmMsg?.giftImageUrl;
    return wrapper.herSend
        ? TrudaLianChatMsgHer(
            wrapper: wrapper,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: TrudaColors.baseColorChatHer,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: LimitedBox(
                maxWidth: 180,
                maxHeight: 240,
                child: TrudaNetImage(url ?? ''),
              ),
            ),
          )
        : TrudaLianChatMsgMe(
            wrapper: wrapper,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: TrudaColors.baseColorChatMine,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TrudaNetImage(
                    url ?? '',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '×${rtmMsg?.quantity ?? 1}',
                    style: TextStyle(color: TrudaColors.white, fontSize: 20),
                  )
                ],
              ),
            ),
          );
  }
}
