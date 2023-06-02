import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_pages/call/local/truda_local_controller.dart';

import '../../../truda_common/truda_call_status.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_rtm/newhita_rtm_msg_entity.dart';
import '../newhita_chat_msg_widget.dart';
import '../newhita_chat_msg_wrapper.dart';

class NewHitaChatMsgCall extends StatelessWidget {
  final NewHitaChatMsgWrapper wrapper;

  const NewHitaChatMsgCall({Key? key, required this.wrapper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var her = wrapper.her;
    var msg = wrapper.msgEntity;
    Map<String, dynamic> jsonMap = json.decode(msg.rawData);
    var call = NewHitaRTMMsgCallState.fromJson(jsonMap);
    String content = call.statusType == TrudaCallStatus.PICK_UP ||
            call.statusType == TrudaCallStatus.USE_VIDEO_CARD ||
            call.statusType == TrudaCallStatus.USE_CARD_AND_PAY
        ? call.duration ?? ''
        : TrudaLanguageKey.newhita_call_disconnected.tr;
    return wrapper.herSend
        ? NewHitaLianChatMsgHer(
            wrapper: wrapper,
            child: GestureDetector(
              onTap: () {
                if (her != null) {
                  TrudaLocalController.startMe(her.uid, her.portrait);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: TrudaColors.baseColorChatHer,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/newhita_chat_call_state_receive.png',
                    ),
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Text(
                      content,
                      maxLines: 10,
                      style: const TextStyle(
                        color: TrudaColors.baseColorChatHerText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : NewHitaLianChatMsgMe(
            wrapper: wrapper,
            child: GestureDetector(
              onTap: () {
                if (her != null) {
                  TrudaLocalController.startMe(her.uid, her.portrait);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: TrudaColors.baseColorChatMine,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      content,
                      maxLines: 10,
                      style: const TextStyle(
                        color: TrudaColors.baseColorChatMineText,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/newhita_chat_call_state_send.png',
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
