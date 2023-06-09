import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:truda/truda_rtm/truda_rtm_msg_sender.dart';

import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_database/entity/truda_msg_entity.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_rtm/truda_rtm_msg_entity.dart';
import '../../../truda_services/truda_my_info_service.dart';
import '../../../truda_services/truda_storage_service.dart';
import '../../../truda_utils/truda_choose_image_util.dart';
import '../../../truda_utils/truda_loading.dart';
import '../../../truda_utils/truda_log.dart';
import '../../../truda_widget/truda_voice_widget_record.dart';
import '../../chargedialog/truda_charge_dialog_manager.dart';
import '../../vip/truda_vip_controller.dart';
import '../truda_chat_controller.dart';

class TrudaChatInputController extends GetxController {
  final String userId;

  TrudaChatInputController(this.userId);

  late final TrudaUpLoadCallBack upLoadCallBack;
  late String myId;
  final TextEditingController textEditingController =
      TextEditingController(text: "");
  late TrudaUploadCallBack voiceRecord;

  final isShowEmoji = false.obs;
  final isShowRecord = false.obs;
  final isCanSendText = false.obs;
  late TrudaChatController _chatController;

  @override
  void onInit() {
    super.onInit();
    myId = TrudaMyInfoService.to.userLogin?.userId ?? "";
    initImageHandler();
    initVoiceHandler();
  }

  @override
  void onReady() {
    super.onReady();
    _chatController = Get.find<TrudaChatController>();
  }

  void onPointerDown() {
    isShowEmoji.value = false;
    isShowRecord.value = false;
  }

  // 发送文字消息
  void sendTextMsg() {
    if (!_chatController.canSendMsg()) {
      askVip();
      return;
    }
    var str = textEditingController.text;
    if (str.isEmpty) return;
    var json = TrudaRtmMsgSender.makeRTMMsgText(userId, str);
    var msg = TrudaMsgEntity(myId, userId, 0, str,
        DateTime.now().millisecondsSinceEpoch, json, TrudaRTMMsgText.typeCode,
        msgEventType: NewHitaMsgEventType.sending, sendState: 1);
    textEditingController.clear();
    // 有敏感词或者3个数字，假发送
    bool hasSenstiveWord = false;
    // List<String> containSensitiveWord = [];
    // NewHitaMyInfoService.to.sensitiveList?.forEach((element) {
    //   String eleString = element;
    //   if (str.toLowerCase().contains(eleString.toLowerCase()) == true) {
    //     hasSenstiveWord = true;
    //     containSensitiveWord.add(element);
    //   }
    // });
    for (var ele in (TrudaMyInfoService.to.sensitiveList ?? <String>[])){
      if (str.toLowerCase().contains(ele.toLowerCase())){
        hasSenstiveWord = true;
        break;
      }
    }
    RegExp rep = RegExp(r"\d{3,}");
    bool hasContinuousNum = rep.hasMatch(str);
    //输入了敏感词或者3个相邻的数字 直接存本地 不存在实际发送
    if (hasSenstiveWord || hasContinuousNum || TrudaConstants.appMode == 2) {
      TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
        ..msgEventType = NewHitaMsgEventType.none
        ..sendState = 0);
      if(hasSenstiveWord || hasContinuousNum){
        TrudaHttpUtil().post<void>(TrudaHttpUrls.uploadSensitiveRecord,
            data: {"targetId": userId, "sendAuth": "0", "payload": str});
      }

      // costFeeForMsg(msg);
      return;
    }

    TrudaStorageService.to.eventBus.fire(msg);

    TrudaHttpUtil().post<void>(TrudaHttpUrls.rtmServerSendApi, data: {
      "recipientId": userId,
      "payload": json,
    }, errCallback: (err) {
      TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
        ..msgEventType = NewHitaMsgEventType.sendErr
        ..sendState = 2);
      TrudaStorageService.to.eventBus.fire(msg);
      if (err.code == 8) {
        TrudaChargeDialogManager.showChargeDialog(
          TrudaChargePath.chating_click_recharge,
          upid: userId,
          noMoneyShow: true,
        );
      }
    }).then((value) {
      TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
        ..msgEventType = NewHitaMsgEventType.sendDone
        ..sendState = 0);
      TrudaStorageService.to.eventBus.fire(msg);
      // _chatController.minusFreeMsg();
    });
  }

  void askVip() {
    TrudaCommonDialog.dialog(TrudaDialogConfirm(
      callback: (i) {
        TrudaVipController.openDialog(
            createPath: TrudaChargePath.recharge_vip_for_message);
      },
      title: TrudaLanguageKey.newhita_vip_for_message.tr,
      rightText: TrudaLanguageKey.newhita_vip_active_now.tr,
    ));
  }

  // void costFeeForMsg(TrudaMsgEntity msg) {
  //   NewHitaStorageService.to.eventBus.fire(msg);
  //   NewHitaHttpUtil().post<void>(NewHitaHttpUrls.costMsgFeeApi, errCallback: (err) {
  //     NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
  //       ..msgEventType = NewHitaMsgEventType.sendErr
  //       ..sendState = 2);
  //     if (err.code == 8) {
  //       NewHitaChargeDialogManager.showChargeDialog(
  //         TrudaChargePath.chating_click_recharge,
  //         upid: userId,
  //       );
  //     }
  //   }).then((value) {
  //     // _chatController.minusFreeMsg();
  //   }).then((value) {
  //     NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
  //       ..msgEventType = NewHitaMsgEventType.none
  //       ..sendState = 0);
  //   });
  // }

  // void addImageMsg(String localPath) {
  //   var json = NewHitaRtmMsgSender.makeRTMMsgImage(userId, localPath);
  //   var msg = TrudaMsgEntity(
  //       myId,
  //       userId,
  //       0,
  //       'image',
  //       DateTime.now().millisecondsSinceEpoch,
  //       json,
  //       NewHitaRTMMsgPhoto.typeCodes[0],
  //       msgEventType: NewHitaMsgEventType.sending);
  //   msg.extra = localPath;
  //   NewHitaStorageService.to.eventBus.fire(msg);
  // }

  void initVoiceHandler() {
    voiceRecord = (String duration, String localPath) {
      var msg = TrudaMsgEntity(
          myId,
          userId,
          0,
          duration,
          DateTime.now().millisecondsSinceEpoch,
          '',
          TrudaRTMMsgVoice.typeCodes[0],
          msgEventType: NewHitaMsgEventType.uploading,
          sendState: 1);
      msg.extra = localPath;
      // NewHitaStorageService.to.eventBus.fire(msg);
      TrudaHttpUtil().post<String>(TrudaHttpUrls.s3UploadUrl,
          data: {'endType': '.wav'}, errCallback: (err) {
        TrudaLog.debug(err);
        TrudaLoading.toast(err.message);
      }, showLoading: true).then((url) {
        TrudaLog.debug(url);
        uploadFile(File(localPath), url).then((value) {
          var realUrl = url.split('?')[0];
          if (value == 200) {
            var json = TrudaRtmMsgSender.makeRTMMsgVoice(
                userId, realUrl, int.parse(duration));
            msg.rawData = json;
            TrudaLog.debug(json);
            // ios审核模式，假发送
            if (TrudaConstants.appMode == 2){
              TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
                ..msgEventType = NewHitaMsgEventType.none
                ..sendState = 0);
              return;
            }
            msg.msgEventType = NewHitaMsgEventType.sending;
            msg.sendState = 1;
            TrudaStorageService.to.eventBus.fire(msg);
            TrudaHttpUtil().post<void>(TrudaHttpUrls.rtmServerSendApi, data: {
              "recipientId": userId,
              "payload": json,
            }, errCallback: (err) {
              TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
                ..msgEventType = NewHitaMsgEventType.sendErr
                ..sendState = 2);
              if (err.code == 8) {
                TrudaChargeDialogManager.showChargeDialog(
                  TrudaChargePath.chating_click_recharge,
                  upid: userId,
                  noMoneyShow: true,
                );
              }
            }).then((value) {
              TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
                ..msgEventType = NewHitaMsgEventType.sendDone
                ..sendState = 0);
              // _chatController.minusFreeMsg();
            });
          }
        });
      });
    };
  }

  Future<int> uploadFile(File file, String uri) async {
    TrudaLog.debug('uploadFile $file');
    // 初始化一个Http客户端，并加入自定义Header
    var req = await HttpClient().putUrl(Uri.parse(uri));
    // headers.forEach((key, value) {
    //   req.headers.add(key, value);
    // });
    req.headers.add('Content-Type', 'audio/wav');
    req.headers.add('Accept', '*/*');
    req.headers.add('Connection', 'keep-alive');
    // 读文件
    req.bufferOutput = true;
    var s = await file.open();
    var x = 0;
    var size = file.lengthSync();
    req.headers.add('Content-Length', size.toString());
    var chunkSize = 65536;
    while (x < size) {
      var _len = size - x >= chunkSize ? chunkSize : size - x;
      var val = s.readSync(_len).toList();
      x = x + _len;
      // 处理数据块
      // val = proc(val);
      // 加入http发送缓冲区
      req.add(val);
      // 立即发送并清空缓冲区
      // await req.flush();
      // req.write(val);
      await req.flush();
    }
    await s.close();

    // 文件发送完成
    await req.close();
    // 获取返回数据
    final response = await req.done;
    // 其它处理逻辑
    print("response statusCode: ${response.statusCode}");
    return response.statusCode;
  }

  void initImageHandler() {
    upLoadCallBack = (uploader, type, url, path) {
      TrudaLog.debug('NewHitaUpLoadCallBack type=$type url=$url path=$path');
      switch (type) {
        case TrudaUploadType.cancel:
          {}
          break;
        case TrudaUploadType.begin:
          TrudaLog.debug('NewHitaUpLoadCallBack begin url=$url path=$path');
          var msg = TrudaMsgEntity(
              myId,
              userId,
              0,
              'image',
              DateTime.now().millisecondsSinceEpoch,
              '',
              TrudaRTMMsgPhoto.typeCodes[0],
              msgEventType: NewHitaMsgEventType.uploading,
              sendState: 1);
          msg.extra = path;
          TrudaStorageService.to.eventBus.fire(msg);
          uploader.msg = msg;
          break;
        case TrudaUploadType.success:
          var json = TrudaRtmMsgSender.makeRTMMsgImage(userId, url!);
          var msg = uploader.msg!;
          msg.rawData = json;

          // ios审核模式，假发送
          if (TrudaConstants.appMode == 2){
            TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
              ..msgEventType = NewHitaMsgEventType.sendDone
              ..sendState = 0);
            return;
          }
          msg.msgEventType = NewHitaMsgEventType.sending;
          msg.sendState = 1;
          // NewHitaStorageService.to.eventBus.fire(msg);
          TrudaHttpUtil().post<void>(TrudaHttpUrls.rtmServerSendApi, data: {
            "recipientId": userId,
            "payload": json,
          }, errCallback: (err) {
            TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
              ..msgEventType = NewHitaMsgEventType.sendErr
              ..sendState = 2);
            if (err.code == 8) {
              TrudaChargeDialogManager.showChargeDialog(
                TrudaChargePath.chating_click_recharge,
                upid: userId,
                noMoneyShow: true,
              );
            }
          }).then((value) {
            TrudaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msg
              ..msgEventType = NewHitaMsgEventType.sendDone
              ..sendState = 0);
            // _chatController.minusFreeMsg();
          });
          break;
        case TrudaUploadType.failed:
          {}
          break;
      }
    };
  }
}
