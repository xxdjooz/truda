import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_constants.dart';
import '../../../truda_entities/truda_gift_entity.dart';
import '../../../truda_utils/truda_choose_image_util.dart';
import '../../../truda_widget/gift/truda_gift_list_view.dart';
import '../../../truda_widget/truda_keybord_logic.dart';
import '../../../truda_widget/truda_voice_widget_record.dart';
import '../../../truda_widget/truda_voice_widget_record_new.dart';
import '../../call/local/truda_local_controller.dart';
import '../truda_chat_controller.dart';
import 'truda_chat_input_controller.dart';

/// 聊天页面的下面的输入框
class TrudaChatInputWidget extends StatefulWidget {
  final String userId;

  TrudaChatInputWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrudaChatInputWidgetState();
}

class _TrudaChatInputWidgetState extends State<TrudaChatInputWidget>
    with WidgetsBindingObserver, TrudaKeyboardLogic {
  late final TrudaChatInputController _controller;
  late final TrudaChatController _chatController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(TrudaChatInputController(widget.userId));
    _chatController = Get.find();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.isShowEmoji.value = false;
        _controller.isShowRecord.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xff301942),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        children: [
          const ColoredBox(
            color: Colors.white12,
            child: SizedBox(
              height: 1,
              width: double.infinity,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_focusNode.hasFocus) {
                _focusNode.unfocus();
              } else {
                _focusNode.requestFocus();
              }
            },
            child: Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 14, end: 14, top: 10),
              padding: const EdgeInsetsDirectional.only(
                  start: 12, end: 5, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10)),
              height: 50,
              child: Obx(() {
                return _controller.isShowRecord.value
                    ? Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _focusNode.unfocus();
                              _controller.isShowRecord.value =
                                  !_controller.isShowRecord.value;
                            },
                            child: Image.asset(
                              "assets/images/newhita_chat_keyboard.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                          Expanded(
                              child: TrudaVoiceRecordNew(
                            uploadCallBack: _controller.voiceRecord,
                          )),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                              child: TextField(
                            focusNode: _focusNode,
                            controller: _controller.textEditingController,
                            onChanged: (str) {
                              _controller.isCanSendText.value = str.isNotEmpty;
                            },
                            style: TextStyle(color: TrudaColors.white),
                            decoration: InputDecoration.collapsed(hintText: ''),
                          )),
                          InkWell(
                            onTap: () {
                              if (!_chatController.canSendMsg()) {
                                _controller.askVip();
                                return;
                              }
                              _controller.sendTextMsg();
                            },
                            child: Obx(() {
                              return Visibility(
                                visible: _controller.isCanSendText.value,
                                child: Image.asset(
                                  "assets/images/newhita_chat_send.png",
                                  width: 40,
                                  height: 40,
                                ),
                              );
                            }),
                            // child: Icon(
                            //   Icons.send_rounded,
                            //   color: TrudaColors.white,
                            // ),
                          ),
                        ],
                      );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      _focusNode.unfocus();
                      _controller.isShowEmoji.value = false;
                      _controller.isShowRecord.value = false;
                      if (!_chatController.canSendMsg()) {
                        _controller.askVip();
                        return;
                      }
                      TrudaChooseImageUtil(
                              type: 1, callBack: _controller.upLoadCallBack)
                          .openChooseDialog();
                    },
                    child: Image.asset(
                        "assets/images/newhita_chat_photo_choose.png")),
                // InkWell(
                //   onTap: () {
                //     _focusNode.unfocus();
                //     _controller.isShowEmoji.value = false;
                //     _controller.isShowRecord.value = false;
                //     Get.toNamed(NewHitaAppPages.googleCharge);
                //   },
                //   child: Image.asset(
                //     "assets/images/newhita_diamond_big.png",
                //     width: 30,
                //     height: 30,
                //   ),
                // ),

                InkWell(
                  onTap: () {
                    _focusNode.unfocus();
                    _controller.isShowEmoji.value = false;
                    if (!_chatController.canSendMsg()) {
                      _controller.askVip();
                      return;
                    }
                    _controller.isShowRecord.value =
                        !_controller.isShowRecord.value;
                  },
                  child: Obx(() {
                    return _controller.isShowRecord.value
                        ? Image.asset(
                            "assets/images/newhita_chat_voice_recording.png",
                            // width: 40,
                            // height: 40,
                          )
                        : Image.asset(
                            "assets/images/newhita_chat_voice_record.png",
                            // width: 40,
                            // height: 40,
                          );
                  }),
                ),
                if (!TrudaConstants.isFakeMode &&
                    _chatController.herId != TrudaConstants.systemId)
                  GetBuilder<TrudaChatController>(
                      id: 'herInfo',
                      builder: (context) {
                        return InkWell(
                            onTap: () {
                              _focusNode.unfocus();
                              _controller.isShowEmoji.value = false;
                              _controller.isShowRecord.value = false;
                              TrudaLocalController.startMe(
                                  _chatController.herId,
                                  _chatController.her?.portrait);
                            },
                            child: Image.asset(
                              "assets/images_ani/newhita_call_pick.webp",
                              width: 40,
                              height: 40,
                            ));
                      }),
                InkWell(
                  onTap: () {
                    _focusNode.unfocus();
                    if (!_chatController.canSendMsg()) {
                      _controller.askVip();
                      return;
                    }
                    Future.delayed(Duration(milliseconds: 100), () {
                      _controller.isShowEmoji.value =
                          !_controller.isShowEmoji.value;
                      _controller.isShowRecord.value = false;
                    });
                  },
                  child: Image.asset("assets/images/newhita_chat_emoji.png"),
                ),

                InkWell(
                  onTap: () {
                    _focusNode.unfocus();
                    showModalBottomSheet(
                        backgroundColor: TrudaColors.transparent,
                        context: context,
                        builder: (context) {
                          return TrudaLianGiftListView(
                            choose: (TrudaGiftEntity gift) {
                              Get.find<TrudaChatController>().sendGift(gift);
                            },
                            herId: _controller.userId,
                          );
                        });
                  },
                  child: Image.asset(
                    "assets/images/newhita_chat_gift.png",
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => _controller.isShowEmoji.value
              ? SizedBox(
                  height: keyBordHeight,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      // Do something when emoji is tapped
                      var _textEditingController =
                          _controller.textEditingController;

                      _textEditingController
                        ..text += emoji.emoji
                        ..selection = TextSelection.fromPosition(TextPosition(
                            offset: _textEditingController.text.length));
                      _controller.isCanSendText.value = true;
                    },
                    onBackspacePressed: () {
                      // Backspace-Button tapped logic
                      // Remove this line to also remove the button in the UI
                      // _controller.textEditingController.
                      var _textEditingController =
                          _controller.textEditingController;
                      _textEditingController
                        ..text = _textEditingController.text.characters
                            .skipLast(1)
                            .toString()
                        ..selection = TextSelection.fromPosition(TextPosition(
                            offset: _textEditingController.text.length));
                      _controller.isCanSendText.value =
                          _textEditingController.text.isNotEmpty;
                    },
                    config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (GetPlatform.isIOS ? 1.30 : 1.0),
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        progressIndicatorColor: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: TrudaColors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        // noRecentsText: "No Recents",
                        // noRecentsStyle: const TextStyle(
                        //     fontSize: 20, color: Colors.black26),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL),
                  ),
                )
              : const SizedBox()),
          // Obx(() => _controller.isShowRecord.value
          //     ? SizedBox(
          //         height: keyBordHeight,
          //         child: NewHitaVoiceRecordWidgetNew(
          //           uploadCallBack: _controller.voiceRecord,
          //         ),
          //       )
          //     : const SizedBox()),
          // Obx(() => _controller.isShowRecord.value
          //     ? SizedBox(
          //         height: keyBordHeight,
          //         child: NewHitaVoiceWidgetRecord(
          //           uploadCallBack: _controller.voiceRecord,
          //         ),
          //       )
          //     : const SizedBox()),
        ],
      ),
    );
  }

  /// 只有显示过键盘的时候才知道键盘高度
  bool hadKeyBordShow = false;
  double keyBordHeight = 278;

  @override
  void onKeyboardChanged(bool visible) {
    if (visible) {
      _controller.isShowEmoji.value = false;
      if (!hadKeyBordShow) {
        setState(() {
          keyBordHeight = getKeyBordHeight();
        });
        hadKeyBordShow = true;
      }
      Get.find<TrudaChatController>().scrollWhenMsgAdd(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }
}
