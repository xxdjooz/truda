import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truda/truda_common/truda_colors.dart';

import '../../../truda_database/entity/truda_msg_entity.dart';
import '../../../truda_services/newhita_storage_service.dart';
import '../truda_chat_msg_widget.dart';
import '../truda_chat_msg_wrapper.dart';

class TrudaChatMsgText extends StatelessWidget {
  final TrudaChatMsgWrapper wrapper;

  const TrudaChatMsgText({Key? key, required this.wrapper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var her = wrapper.her;
    var msg = wrapper.msgEntity;
    return wrapper.herSend
        ? TrudaLianChatMsgHer(
            wrapper: wrapper,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: TrudaColors.baseColorChatHer,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msg.content,
                maxLines: 10,
                style: const TextStyle(
                  color: TrudaColors.baseColorChatHerText,
                ),
              ),
            ),
          )
        : TrudaLianChatMsgMe(
            wrapper: wrapper,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: TrudaColors.baseColorChatMine,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.only(top: 5),
              child: Text(
                msg.content,
                maxLines: 10,
                style: const TextStyle(
                  color: TrudaColors.baseColorChatMineText,
                ),
              ),
            ),
          );
  }
}
