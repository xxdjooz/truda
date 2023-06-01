import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_rtm/newhita_rtm_msg_entity.dart';
import 'package:truda/truda_utils/newhita_voice_player.dart';

import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_database/entity/truda_msg_entity.dart';
import '../newhita_chat_msg_widget.dart';
import '../newhita_chat_msg_wrapper.dart';

class NewHitaChatMsgVoice extends StatefulWidget {
  final NewHitaChatMsgWrapper wrapper;

  const NewHitaChatMsgVoice({Key? key, required this.wrapper}) : super(key: key);

  @override
  State<NewHitaChatMsgVoice> createState() => _NewHitaChatMsgVoiceState();
}

class _NewHitaChatMsgVoiceState extends State<NewHitaChatMsgVoice> {
  TrudaHerEntity? her;
  late TrudaMsgEntity msg = widget.wrapper.msgEntity;
  NewHitaRTMMsgVoice? rtmMsg;
  String? url;
  bool _playing = false;
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    her = widget.wrapper.her;
    msg = widget.wrapper.msgEntity;
    if (msg.rawData.isNotEmpty) {
      Map<String, dynamic> jsonMap = json.decode(msg.rawData);
      rtmMsg = NewHitaRTMMsgVoice.fromJson(jsonMap);
    }
    // 收到的消息有rtmMsg，发送中的图片消息还没有
    url = rtmMsg?.voiceUrl;
    // NewHitaLog.debug("_NewHitaChatMsgVoiceState url=$url ${rtmMsg?.duration}");
    sub = NewHitaAudioPlayer().onPlayerStateChanged.listen((event) {
      // NewHitaLog.debug("state change event=$event");
      final bool isCurrent = url == NewHitaAudioPlayer().currentUrl;
      switch (event) {
        case PlayerState.playing:
          setState(() {
            _playing = isCurrent;
          });
          break;
        case PlayerState.stopped:
        case PlayerState.paused:
        case PlayerState.completed:
          if (isCurrent) {
            setState(() {
              _playing = false;
            });
          }
          break;
      }
      setState(() {});
    });
  }

  void playIt() {
    if (url == null) return;
    NewHitaAudioPlayer().playUrl(url!);
  }

  @override
  Widget build(BuildContext context) {
    return widget.wrapper.herSend
        ? GestureDetector(
            onTap: () {
              playIt();
            },
            child: NewHitaLianChatMsgHer(
              wrapper: widget.wrapper,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: TrudaColors.baseColorChatHer,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      !_playing
                          ? 'assets/images/newhita_chat_voice_receive.png'
                          : 'assets/images_ani/newhita_voice_her.webp',
                      width: 18,
                      height: 18,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      msg.content ?? '',
                      style: TextStyle(
                        color: TrudaColors.baseColorChatHerText,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              playIt();
            },
            child: NewHitaLianChatMsgMe(
              wrapper: widget.wrapper,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: TrudaColors.baseColorChatMine,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      !_playing
                          ? 'assets/images/newhita_chat_voice_send.png'
                          : 'assets/images_ani/newhita_voice_me.webp',
                      width: 18,
                      height: 18,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      msg.content ?? '',
                      style: TextStyle(
                        color: TrudaColors.baseColorChatMineText,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }
}
