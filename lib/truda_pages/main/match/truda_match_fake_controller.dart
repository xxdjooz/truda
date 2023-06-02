import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';

import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_dialogs/truda_dialog_match_moment.dart';
import '../../../truda_entities/truda_moment_entity.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_services/truda_storage_service.dart';
import '../../../truda_utils/truda_loading.dart';
import '../../../truda_utils/truda_log.dart';

/// 这个是审核模式下的匹配，匹配到的是一个动态
class TrudaMatchFakeController extends GetxController with RouteAware {
  // 0匹配中，1匹配到，2匹配失败
  int matching = 2;
  TrudaMomentDetail? detail;
  bool shouldShowGirl = false;
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  @override
  void onInit() {
    super.onInit();
    _getOneHost();
    // _audioCache.loop('newhita_match_bgm.mp3',
    //     mode: PlayerMode.LOW_LATENCY, stayAwake: true);

    _mPlayer.openPlayer().then((value) {
      // setState(() {
      //   _mPlayerIsInited = true;
      // });
      playBgm();
    });
    _mPlayer.setVolume(1);
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
          TrudaLog.debug('NewHitaMatchController playBgm whenFinished');
          await _mPlayer.seekToPlayer(Duration());
          playBgm();
        });
  }

  void showMatched() {
    shouldShowGirl = true;
    if (matching == 2) {
      _getOneHost(showLoading: true);
    } else if (matching == 0) {
      TrudaLoading.show();
    } else if (matching == 1) {
      TrudaLoading.dismiss();
      shouldShowGirl = false;
      TrudaDialogMatchMoment.checkToShow(detail!).then((value) {
        _getOneHost();
      });
      matching = 2;
    }
  }

  void _getOneHost({bool showLoading = false}) {
    matching = 0;
    TrudaHttpUtil().post<TrudaMomentDetail>(TrudaHttpUrls.momentRand,
        errCallback: (err) {
      TrudaLoading.toast(err.message);
      TrudaLoading.dismiss();
      matching = 2;
    }, showLoading: showLoading).then((value) {
      detail = value;
      matching = 1;
      TrudaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
          value.nickname ?? '', value.userId!,
          portrait: value.portrait));
      if (shouldShowGirl) {
        showMatched();
      }
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

  void playRing({bool isGot = false}) async {
  }

  void setBgmPlay(bool play) {
    TrudaLog.debug('NewHitaMatchFake setBgmPlay $play');
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
    TrudaLog.debug('NewHitaMatchController onClose');
  }
}
