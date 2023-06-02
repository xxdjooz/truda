import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_lottery_entity.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';

import '../../truda_common/truda_common_dialog.dart';
import '../../truda_dialogs/truda_dialog_lottery_get.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_routes/newhita_pages.dart';
import '../../truda_utils/newhita_ui_image_util.dart';
import '../../truda_widget/pie_chart/newhita_pie_chart_widget.dart';

class NewHitaLotteryController extends GetxController {
  Map<int, ui.Image> images = {};
  List<TrudaLotteryBean> data = [];
  var haveLotteryTimes = 0;
  final lastTimes = NewHitaMyInfoService.to.haveLotteryTimes;
  NewHitaPieChartController controller = NewHitaPieChartController();
  bool rolling = false;
  var emptyPosition = 0;

  @override
  void onInit() {
    super.onInit();
    _getList();

    controller.arrivePosition = (index) {
      rolling = false;
      var bean = data[index];
      TrudaCommonDialog.dialog(
        TrudaDialogLotteryGet(
          bean: bean,
        ),
        barrierColor: Colors.black87,
      );
    };
    haveLotteryTimes = lastTimes.value;
  }

  @override
  void onReady() {
    super.onReady();
  }

  //  "configId": 7,//奖品id
  //  "name": "5点经验",//奖品名称
  //  "icon": "",// 奖品图标
  //  "areaCode": 0,// 地区
  //  "probability": 10,// 中奖概率
  //  "drawMode": 1,// 抽奖模式，1.充值抽奖
  //  "drawType": 1,// 奖品类型，0.谢谢参与，1.送钻石，2.送会员天数，3.送钻石加成卡
  //  "value": 1,// 值
  void _getList() {
    TrudaHttpUtil().post<List<TrudaLotteryBean>>(TrudaHttpUrls.lotteryConfig,
        errCallback: (err) {
      // NewHitaLoading.toast(err.message);
    }).then((value) {
      data = value;
      initImage();
    });
  }

  void drawOne() {
    if (rolling) return;
    if (lastTimes.value <= 0) {
      Get.offNamed(NewHitaAppPages.googleCharge);
      return;
    }
    lastTimes.value--;
    controller.beginRoll();
    rolling = true;
    TrudaHttpUtil().post<TrudaLotteryBean>(TrudaHttpUrls.lotteryOne,
        errCallback: (err) {
      // NewHitaLoading.toast(err.message);
      controller.toIndex(emptyPosition);
    }).then((value) {
      for (var index = 0; index < data.length; index++) {
        final bean = data[index];
        if (bean.configId == value.configId) {
          controller.toIndex(index);
          break;
        }
      }
    }).catchError((e) {
      controller.toIndex(emptyPosition);
    });
  }

  void initImage() {
    NewHitaUiImageUtil.load('assets/images/3.0x/newhita_lottery_face.png')
        .then((value) {
      for (int index = 0; index < data.length; index++) {
        var bean = data[index];
        if (bean.drawType == 0) {
          images[index] = value;
          emptyPosition = index;
        }
      }
      update();
    });
    NewHitaUiImageUtil.load('assets/images/3.0x/newhita_lottery_diamond.png')
        .then((value) {
      for (int index = 0; index < data.length; index++) {
        var bean = data[index];
        if (bean.drawType == 1) {
          images[index] = value;
        }
      }
      update();
    });
    NewHitaUiImageUtil.load('assets/images/3.0x/newhita_lottery_vip.png')
        .then((value) {
      for (int index = 0; index < data.length; index++) {
        var bean = data[index];
        if (bean.drawType == 2) {
          images[index] = value;
        }
      }
      update();
    });
    NewHitaUiImageUtil.load('assets/images/3.0x/newhita_lottery_upgrade.png')
        .then((value) {
      for (int index = 0; index < data.length; index++) {
        var bean = data[index];
        if (bean.drawType == 3) {
          images[index] = value;
        }
      }
      update();
    });
  }

  @override
  void onClose() {
    super.onClose();
    // for (var i in images.values) {
    //   i.dispose();
    // }
  }
}
