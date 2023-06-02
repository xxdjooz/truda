import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_pages/host/truda_host_controller.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:intl/intl.dart';

import '../../truda_common/truda_constants.dart';
import '../../truda_database/entity/truda_msg_entity.dart';
import '../../truda_widget/truda_avatar_with_bg.dart';
import '../../truda_widget/truda_net_image.dart';
import 'truda_chat_msg_wrapper.dart';

class TrudaLianChatMsgHer extends StatelessWidget {
  final Widget child;
  final TrudaChatMsgWrapper wrapper;

  const TrudaLianChatMsgHer(
      {Key? key, required this.child, required this.wrapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var time = DateTime.fromMillisecondsSinceEpoch(wrapper.date);
    var str = DateFormat('MM.dd HH:mm').format(time);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          if (wrapper.showTime)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                str,
                style: const TextStyle(
                  color: TrudaColors.textColor999,
                  fontSize: 12,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (wrapper.herId == TrudaConstants.systemId ||
                  wrapper.herId == TrudaConstants.serviceId)
                  ? Image.asset(
                      'assets/images/newhita_conver_system.png',
                      width: 50,
                      height: 50,
                    )
                  : GestureDetector(
                      onTap: () {
                        TrudaHostController.startMe(
                            wrapper.herId, wrapper.her?.portrait ?? "");
                      },
                      child: TrudaNetImage(
                        wrapper.her?.portrait ?? "",
                        width: 40,
                        height: 40,
                        isCircle: true,
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: child,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TrudaLianChatMsgMe extends StatelessWidget {
  final Widget child;
  final TrudaChatMsgWrapper wrapper;

  const TrudaLianChatMsgMe(
      {Key? key, required this.child, required this.wrapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var time = DateTime.fromMillisecondsSinceEpoch(wrapper.date);
    var str = DateFormat('MM.dd HH:mm').format(time);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          if (wrapper.showTime)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                str,
                style: const TextStyle(
                  color: TrudaColors.textColor999,
                  fontSize: 12,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 30),
              if (wrapper.msgEntity.sendState == 1 &&
                  wrapper.msgEntity.msgEventType == NewHitaMsgEventType.sending)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    backgroundColor: Colors.white12,
                    // value: 0.2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(TrudaColors.baseColorRed),
                  ),
                ),
              if (wrapper.msgEntity.sendState == 2)
                Image.asset(
                  'assets/images/newhita_chat_send_err.png',
                  width: 20,
                  height: 20,
                ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: child,
              ),
              const SizedBox(
                width: 10,
              ),
              // NewHitaNetImage(
              //   NewHitaMyInfoService.to.myDetail?.portrait ?? '',
              //   width: 40,
              //   height: 40,
              //   isCircle: true,
              // ),
              TrudaAvatarWithBg(
                url: TrudaMyInfoService.to.myDetail?.portrait ?? '',
                width: 40,
                height: 40,
                padding: 2,
                placeholderAsset: 'assets/images_sized/newhita_base_avatar.webp',
                isVip: TrudaMyInfoService.to.myDetail?.isVip == 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
