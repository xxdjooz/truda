import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/truda_choose_image_util.dart';
import 'package:truda/truda_utils/truda_loading.dart';
import 'package:intl/intl.dart';

import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_entities/truda_info_entity.dart';
import '../../../../truda_utils/truda_log.dart';

class TrudaInfoController extends GetxController {
  var dnd = false.obs;
  late String herId;
  TrudaInfoDetail? myDetail;

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    myDetail = TrudaMyInfoService.to.myDetail;
  }

  void changeAvatar() {
    TrudaChooseImageUtil(
        type: 0,
        callBack: (uploader, type, url, path) {
          switch (type) {
            case TrudaUploadType.cancel:
              {}
              break;
            case TrudaUploadType.begin:
              TrudaLoading.show();
              break;
            case TrudaUploadType.success:
              TrudaLoading.dismiss();
              TrudaHttpUtil()
                  .post<void>(
                TrudaHttpUrls.updateUserInfoApi,
                data: {"portrait": url},
                showLoading: true,
              )
                  .then((value) {
                myDetail?.portrait = url;
                update();
              });
              break;
            case TrudaUploadType.failed:
              TrudaLoading.dismiss();
              break;
          }
        }).openChooseDialog();
  }

  TextEditingController nameTextController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  int initNameController() {
    String name = myDetail?.nickname ?? '';
    name = name.replaceAll(RegExp(r"\d"), "*");
    var maxLen = 10;
    if ((Get.locale?.languageCode ?? '') == const Locale('ar').languageCode) {
      maxLen = 30;
    }
    nameTextController.addListener(() {
      if ((nameTextController.text.length) > maxLen) {
        nameTextController.text = nameTextController.text.substring(0, maxLen);
        nameTextController.selection = TextSelection(
            baseOffset: nameTextController.text.length,
            extentOffset: nameTextController.text.length);
      }
      TrudaLog.debug("输入的内容 = ${nameTextController.text}");
    });

    nameTextController.text = name;
    return maxLen;
  }

  void changeGender(int gender) {
    if (TrudaStorageService.to.getHadSetGender()) {
      TrudaLoading.toast(TrudaLanguageKey.newhita_mine_edit_sex.tr);
      return;
    }
    TrudaHttpUtil().post<void>(TrudaHttpUrls.updateUserInfoApi,
        data: {"gender": gender}, errCallback: (e) {
      TrudaLoading.dismiss();
    }).then((value) {
      myDetail?.gender = gender;
      update();
      TrudaLoading.dismiss();
      TrudaStorageService.to.saveHadSetGender();
    });
  }

  void changeName() {
    if (nameTextController.text.isNotEmpty) {
      // nameFocusNode.unfocus();

      bool hasSenstiveWord = false;
      List<String> containSensitiveWord = [];
      TrudaMyInfoService.to.sensitiveList?.forEach((element) {
        String eleString = element is String ? element : "";
        if (nameTextController?.text
                .toLowerCase()
                .contains(eleString.toLowerCase()) ==
            true) {
          hasSenstiveWord = true;
          containSensitiveWord.add(element);
        }
      });

      if (hasSenstiveWord == true) {
        // NewHitaLoading.show("您输入的文字含有违规内容${containSensitiveWord}，请重新输入");
        TrudaLoading.toast(TrudaLanguageKey.newhita_edit_is_sensitive.tr);
        return;
      }

      TrudaLog.debug("去除尾部的空格符");
      String finalS = nameTextController.text.replaceAll(RegExp(r'\s*$'), "");
      finalS = finalS.replaceAll(RegExp(r"\d"), "*");
      TrudaLoading.show();
      TrudaHttpUtil().post<void>(TrudaHttpUrls.updateUserInfoApi,
          data: {"nickname": finalS}, errCallback: (e) {
        TrudaLoading.dismiss();
      }).then((value) {
        myDetail?.nickname = finalS;
        update();
        TrudaLoading.dismiss();
      });
    } else {
      TrudaLoading.toast(TrudaLanguageKey.newhita_not_entered.tr);
    }
  }

  TextEditingController introTextController = TextEditingController();
  FocusNode introFocusNode = FocusNode();

  void initIntroController() {
    String intro = myDetail?.intro ?? '';
    intro = intro.replaceAll(RegExp(r"\d"), "*");

    introTextController.addListener(() {
      if ((introTextController.text.length) > 200) {
        introTextController.text = introTextController.text.substring(0, 200);
        introTextController.selection = TextSelection(
            baseOffset: introTextController.text.length,
            extentOffset: introTextController.text.length);
      }
      TrudaLog.debug("输入的内容 = ${introTextController.text}");
    });

    introTextController.text = intro;
  }

  void changeIntro() {
    if (introTextController.text.isNotEmpty) {
      introFocusNode.unfocus();

      bool hasSenstiveWord = false;
      List<String> containSensitiveWord = [];
      TrudaMyInfoService.to.sensitiveList?.forEach((element) {
        String eleString = element is String ? element : "";
        if (introTextController.text
                .toLowerCase()
                .contains(eleString.toLowerCase()) ==
            true) {
          hasSenstiveWord = true;
          containSensitiveWord.add(element);
        }
      });
      String finalS = introTextController.text.replaceAll(RegExp(r'\s*$'), "");
      finalS = finalS.replaceAll(RegExp(r"\d"), "*");
      if (hasSenstiveWord == true) {
        TrudaLoading.toast(TrudaLanguageKey.newhita_edit_is_sensitive.tr);
        return;
      }
      TrudaLoading.show();
      TrudaHttpUtil().post<void>(TrudaHttpUrls.updateUserInfoApi,
          data: {"intro": finalS}, errCallback: (e) {
        TrudaLoading.dismiss();
      }).then((value) {
        myDetail?.intro = finalS;
        update();
        TrudaLoading.dismiss();
      });
    } else {
      TrudaLoading.toast(TrudaLanguageKey.newhita_not_entered.tr);
    }
  }

  String getBirth() {
    if ((myDetail?.birthday ?? 0) == 0) {
      return '';
    }
    var time = DateTime.fromMillisecondsSinceEpoch(myDetail!.birthday!);
    var str = DateFormat('yyyy-MM-dd').format(time);
    return str;
  }

  void changeBirthday() {
    DateTime? birthday;
    if ((myDetail?.birthday ?? 0) > 0) {
      birthday = DateTime.fromMillisecondsSinceEpoch(myDetail!.birthday!);
    }

    DateTime dateTime = DateTime.now();
    DatePicker.showDatePicker(
      Get.context!,
      showTitleActions: true,
      minTime: DateTime(dateTime.year - 60, dateTime.month, dateTime.day),
      maxTime: DateTime(dateTime.year - 18, dateTime.month, dateTime.day),
      onChanged: (date) {},
      onConfirm: (date) {
        TrudaLoading.show();
        TrudaHttpUtil().post<void>(TrudaHttpUrls.updateUserInfoApi,
            data: {"birthday": date.millisecondsSinceEpoch}, errCallback: (e) {
          TrudaLoading.dismiss();
        }).then((value) {
          myDetail?.birthday = date.millisecondsSinceEpoch;
          update();
          TrudaLoading.dismiss();
        });
      },
      currentTime: birthday ?? DateTime.now(),
      locale: currentUerLanguageType,
    );
  }

  static LocaleType get currentUerLanguageType {
    // en,
    // fa,
    // zh,
    // nl,
    // ru,
    // it,
    // fr,
    // gr,
    // es,
    // pl,
    // pt,
    // ko,
    // kk,
    // ar,
    // tr,
    // az,
    // jp,
    // de,
    // da,
    // mn,
    // bn,
    // vi,
    // hy,
    // id,
    // bg,
    // eu,
    // cat,
    // th,
    // si,
    // no,
    // sq,
    // sv,
    // kh,
    // tw,
    // fi

    if (Get.locale?.languageCode == null) {
      return LocaleType.en;
    }

    if (Get.locale!.languageCode.matchAsPrefix("ar") != null) {
      return LocaleType.ar;
    } else if (Get.locale!.languageCode.matchAsPrefix("id") != null) {
      return LocaleType.id;
    } else if (Get.locale!.languageCode.matchAsPrefix("tr") != null) {
      return LocaleType.tr;
    } else if (Get.locale!.languageCode.matchAsPrefix("hi") != null) {
      return LocaleType.hi;
    } else if (Get.locale!.languageCode.matchAsPrefix("es") != null) {
      return LocaleType.es;
    } else if (Get.locale!.languageCode.matchAsPrefix("pt") != null) {
      return LocaleType.pt;
    } else if (Get.locale!.languageCode.matchAsPrefix("vi") != null) {
      return LocaleType.vi;
    } else if (Get.locale!.languageCode.matchAsPrefix("zh") != null) {
      return LocaleType.zh;
    }
    return LocaleType.en;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
