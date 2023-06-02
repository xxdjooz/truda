import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';

import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../truda_dialogs/truda_dialog_match_one.dart';
import '../../../truda_entities/truda_match_host_entity.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_services/newhita_my_info_service.dart';
import '../../../truda_services/newhita_storage_service.dart';
import '../../../truda_utils/newhita_loading.dart';
import '../../../truda_utils/newhita_log.dart';
import '../../vip/truda_vip_controller.dart';
import 'truda_match_page.dart';

class TrudaMatchController extends GetxController with RouteAware {
  // 0匹配中，1匹配到，2匹配失败
  int matching = 2;
  TrudaMatchHost? detail;
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  @override
  void onInit() {
    super.onInit();

    _mPlayer.openPlayer().then((value) {
      // setState(() {
      //   _mPlayerIsInited = true;
      // });
      playBgm();
    });
    _mPlayer.setVolume(1);
    refreshTodayTimes();
  }

  void playBgm() async {
    Uint8List? dataBuffer;
    var codec = Codec.mp3;
    dataBuffer = (await rootBundle.load('assets/newhita_match_bgm.mp3'))
        .buffer
        .asUint8List();

    await _mPlayer.startPlayer(
        fromDataBuffer: dataBuffer,
        sampleRate: 8000,
        codec: codec,
        whenFinished: () async {
          NewHitaLog.debug('NewHitaMatchController playBgm whenFinished');
          await _mPlayer.seekToPlayer(Duration());
          playBgm();
        });
  }

  void showMatched() {
    _getOneHost(showLoading: true);
  }

  void _getOneHost({bool showLoading = false}) {
    bool isVip = NewHitaMyInfoService.to.isVipNow;
    if (getTodayTimes() >= TrudaMatchPage.totalMatchTimes && !isVip) {
      TrudaCommonDialog.dialog(TrudaDialogConfirm(
        title: TrudaLanguageKey.newhita_vip_upgrade_ask.tr,
        callback: (int callback) {
          TrudaVipController.openDialog(
              createPath: TrudaChargePath.recharge_vip_dialog_match);
        },
      )).then((value) {});
      return;
    }
    matching = 0;
    TrudaHttpUtil().post<TrudaMatchHost>(TrudaHttpUrls.matchOneAnchor,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
      NewHitaLoading.dismiss();
      matching = 2;
    }, showLoading: showLoading).then((value) {
      detail = value;
      matching = 1;
      NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
          value.nickName ?? '', value.userId!,
          portrait: value.portrait));
      TrudaDialogMatchOne.checkToShow(detail!);
      addTodayTimes();
    }).catchError((err) {
      // 这里搞了一个测试数据
      // detail = NewHitaMatchHost();
      // detail?.userId = '107780488';
      // detail?.nickName = '测试';
      // detail?.portrait =
      //     'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg5.51tietu.net%2Fpic%2F2019-082708%2Fnw2oszgeulvnw2oszgeulv.jpg&refer=http%3A%2F%2Fimg5.51tietu.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1656495460&t=9b0bb1b1957648224b04ff03f49b8aba';
      // matching = 0;
      // update();
      // var fakeUrl =
      //     'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/testChildMp4.mp4';
      // initPlayer(fakeUrl);
      // 这个是对的逻辑
      matching = 2;
    });
  }

  void playRing({bool isGot = false}) async {}

  void setBgmPlay(bool play) {
    if (play) {
      _mPlayer.resumePlayer();
    } else {
      _mPlayer.pausePlayer();
    }
  }

  @override
  void onClose() {
    _mPlayer.stopPlayer();
    _mPlayer.closePlayer();
    super.onClose();
    NewHitaLog.debug('NewHitaMatchController onClose');
  }

  final String keyEveryDay =
      "keyEveryDay-${NewHitaMyInfoService.to.myDetail?.userId}-";

  void refreshTodayTimes() {
    TrudaMatchPage.todayMatchTimes.value = getTodayTimes();
  }

  String _getTodayStr() {
    final today = DateTime.now();
    return "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
  }

  // 获取今天使用了几次
  int getTodayTimes() {
    return NewHitaStorageService.to.prefs
            .getInt('$keyEveryDay${_getTodayStr()}') ??
        0;
  }

  // 今天次数加一
  void addTodayTimes() {
    int times = getTodayTimes();
    times++;
    NewHitaStorageService.to.prefs
        .setInt('$keyEveryDay${_getTodayStr()}', times);

    refreshTodayTimes();
  }

  // 今天次数加一
  void setTodayTimes(int times) {
    NewHitaStorageService.to.prefs
        .setInt('$keyEveryDay${_getTodayStr()}', times);
    refreshTodayTimes();
  }
}
