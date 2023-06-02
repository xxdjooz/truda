import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../truda_common/truda_common_dialog.dart';
import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../../truda_dialogs/truda_dialog_create_moment.dart';
import '../../../../truda_entities/truda_moment_entity.dart';
import '../../../../truda_http/truda_http_urls.dart';
import '../../../../truda_http/truda_http_util.dart';
import '../../../../truda_utils/newhita_choose_image_util.dart';
import '../../../../truda_utils/newhita_loading.dart';
import '../../../../truda_utils/newhita_log.dart';

class TrudaCreateController extends GetxController {
  final Map<String, int> pathUploadState = {};
  late final NewHitaUpLoadCallBack upLoadCallBack;
  final TrudaMomentDetail goraMomentDetail = TrudaMomentDetail();

  @override
  void onInit() {
    super.onInit();
    goraMomentDetail.medias = [];
    upLoadCallBack = (uploader, type, url, path) {
      NewHitaLog.debug('NewHitaUpLoadCallBack type=$type url=$url path=$path');
      switch (type) {
        case NewHitaUploadType.cancel:
          {}
          break;
        case NewHitaUploadType.begin:
          goraMomentDetail.medias!.add(TrudaMomentMedia()
            ..localPath = path
            ..uploadState = 0);
          update();
          break;
        case NewHitaUploadType.success:
          for (var element in goraMomentDetail.medias!) {
            if (element.localPath == path) {
              element.mediaUrl = url;
              element.uploadState = 1;
            }
          }
          update();
          break;
        case NewHitaUploadType.failed:
          for (var element in goraMomentDetail.medias!) {
            if (element.localPath == path) {
              element.uploadState = 2;
            }
          }
          break;
      }
    };
  }

  @override
  void onReady() {
    super.onReady();
    TrudaCommonDialog.dialog(TrudaDialogCreateMoment());
  }

  void removeMedia(int index) {
    goraMomentDetail.medias?.removeAt(index);
    update();
  }

  // classifyId	是	string	类型id
  // title	是	string	标题
  // tag	是	string	标签 每个标签前用#号分开
  // paths	是	string	内容 多个用,
  // content	是	string	文字内容
  void postContent() {
    final str = StringBuffer();
    var m = goraMomentDetail.medias!;
    if (m.isEmpty || m.first.uploadState != 1) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_at_least_1_pic.tr);
      return;
    }
    for (int index = 0; index < m.length; index++) {
      str.write(m[index].mediaUrl ?? '');
      if (index != m.length - 1) {
        str.write(',');
      }
    }
    TrudaHttpUtil().post<void>(TrudaHttpUrls.saveReviewContent,
        data: {
          'content': introTextController.text,
          'paths': str.toString(),
        },
        showLoading: true, errCallback: (err) {
      NewHitaLog.debug(err);
      NewHitaLoading.toast(err.message);
    }).then((value) {
      TrudaCommonDialog.dialog(TrudaDialogConfirm(
        callback: (i) {},
        title: TrudaLanguageKey.newhita_story_is_reviewing.tr,
        onlyConfirm: true,
        showSuccessIcon: true,
      )).then((value) => Get.back());
    });
  }

  TextEditingController introTextController = TextEditingController();
  var lengthRx = 0.obs;
  FocusNode introFocusNode = FocusNode();

  void initIntroController() {
    String intro = '';
    introTextController.addListener(() {
      if ((introTextController.text.length) > 200) {
        introTextController.text = introTextController.text.substring(0, 200);
        introTextController.selection = TextSelection(
            baseOffset: introTextController.text.length,
            extentOffset: introTextController.text.length);
      }
      NewHitaLog.debug("输入的内容 = ${introTextController.text}");
    });

    introTextController.text = intro;
  }
}
