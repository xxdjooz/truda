import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:truda/truda_database/entity/truda_aic_entity.dart';
import 'package:truda/truda_pages/call/remote/newhita_remote_controller.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_check_calling_util.dart';

import '../truda_common/truda_constants.dart';
import '../truda_database/entity/truda_her_entity.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';
import '../truda_rtm/newhita_rtm_msg_entity.dart';
import '../truda_services/newhita_my_info_service.dart';
import '../truda_widget/newhita_cache_manager.dart';
import 'newhita_loading.dart';
import 'newhita_log.dart';

class NewHitaAicHandler {
  // NewHitaAicHandler() 返回单例
  static final NewHitaAicHandler _instance = NewHitaAicHandler._();

  factory NewHitaAicHandler() {
    return _instance;
  }

  NewHitaAicHandler._();

  // 这是个模拟收到aic的方法
  void testGetAicMsg() {
    NewHitaStorageService.to.objectBoxCall.deleteAicHadShow();
    //{\"callCardCount\":0,\"extra\":\"624ff55eebcc317144526180\",
// \"filename\":\"https://oss.hanilink.com/users/107012498/upload/anchor/upload/video/1505217394515206145.mp4\",
// \"id\":107781256,\"isFollowed\":false,\"isOnline\":1,\"muteStatus\":1,\"nickname\":\"Mary\",
// \"portrait\":\"https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG\",
// \"propDuration\":70000,\"userId\":107780487}
    NewHitaRTMMsgAIC aic = NewHitaRTMMsgAIC();
    aic.filename =
        'https://yesme-public.oss-cn-hongkong.aliyuncs.com/app/testMp4.mp4';
    aic.id = 445444747474747;
    aic.userId = '107780488';
    aic.nickname = '1057644';
    aic.portrait =
        'https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG';
    aic.nickname = 'test test';
    aic.isCard = 0;
    getAicMsg(aic);
  }

  // 收到aic的处理
  void getAicMsg(NewHitaRTMMsgAIC aic) {
    var entity =
        TrudaHerEntity(aic.nickname ?? '', aic.userId!, portrait: aic.portrait);
    NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(entity);
    NewHitaStorageService.to.eventBus.fire(entity);
    // aic.filename =
    //     'https://yesme-public.oss-cn-hongkong.aliyuncs.com/app/testMp4.mp4';
    NewHitaStorageService.to.objectBoxCall.putOrUpdateAic(
        TrudaAicEntity.fromRtm(aic, DateTime.now().millisecondsSinceEpoch));
    final String url = aic.filename!;
    // final String url =
    //     'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/testMp4.mp4';
    NewHitaAicCacheManager.instance
        .getFileStream(aic.filename!, withProgress: true)
        .listen((fileResponse) {
      if (fileResponse is DownloadProgress) {
        // NewHitaLog.debug(fileResponse);
      }
      if (fileResponse is FileInfo) {
        NewHitaLog.debug('aic download --> ${fileResponse.file.path}');
        var ob = NewHitaStorageService.to.objectBoxCall;
        var aic = ob.queryAic(fileResponse.originalUrl);
        if (aic == null) return;
        aic.localPath = fileResponse.file.path;
        aic.playState = 1;
        ob.putOrUpdateAic(aic);
        checkAicToShow();
      }
    }, onError: (object) {
      var ob = NewHitaStorageService.to.objectBoxCall;
      var aic = ob.queryAic(url);
      if (aic == null) return;
      aic.playState = 3;
      ob.putOrUpdateAic(aic);
    });
  }

  bool checkingAic = false;
  // 取出一个aic显示
  void checkAicToShow() {
    if (!NewHitaCheckCallingUtil.checkCanAic()) return;
    if (checkingAic) return;
    checkingAic = true;
    checkAic().catchError((err) {
      NewHitaLog.debug('aic catchError =$err');
      checkingAic = false;
    }).then((value) {
      checkingAic = false;
    });
  }

  Future checkAic() async {
    if (!NewHitaCheckCallingUtil.checkCanAic()) {
      checkingAic = false;
      return;
    }
    var ob = NewHitaStorageService.to.objectBoxCall;
    var aic = ob.queryAicCanShow();
    if (aic == null || aic.localPath == null) return;
    if (aic == null || aic.localPath == null) {
      checkingAic = false;
      return;
    }
    // 把这个aic设为已经弹出
    aic.playState = 2;
    ob.putOrUpdateAic(aic);
    // VideoPlayerController videoController =
    //     VideoPlayerController.file(File(aic.localPath!));
    // await videoController.initialize();
    // NewHitaLog.debug('aic check =${videoController.value}');
    // if (videoController.value.duration.inSeconds <= 1) {
    //   checkingAic = false;
    //   await videoController.dispose();
    //   return;
    // }
    // await videoController.dispose();
    await NewHitaRemoteController.startMeAic(aic);
  }

  // 每次启动app的时候调一下
  void clearAicHadShow() {
    NewHitaStorageService.to.objectBoxCall.deleteAicHadShow();
    NewHitaAicCacheManager.instance.emptyCache();
  }

  /// ************* 新的逻辑 *******************

  /// 上一个 aic 的主播id
  String previousUid = "";
  // 取出一个aic显示
  Future<bool> checkAicToShowExcept(String userId) async {
    eventss(1);
    if (!NewHitaCheckCallingUtil.checkCanAic() || checkingAic) {
      return false;
    }
    eventss(2);
    checkingAic = true;
    bool isShowAic = false;
    await checkAicExcept(userId).catchError((err) {
      NewHitaLog.debug('aic catchError =$err');
      checkingAic = false;
    }).then((value) {
      checkingAic = false;
      isShowAic = value;
      NewHitaLog.debug('aic========== =$value');
    });
    checkingAic = false;

    return isShowAic;
  }

  Future<bool> checkAicExcept(String userId) async {
    eventss(3);
    if (!NewHitaCheckCallingUtil.checkCanAic()) {
      checkingAic = false;
      return false;
    }
    eventss(4);
    var ob = NewHitaStorageService.to.objectBoxCall;

    ///查询不等于 上一次触发的ai 的user id
    var aic = ob.queryAicCanShowExcept(userId);

    if (aic == null || aic.localPath == null) {
      checkingAic = false;
      return false;
    }
    eventss(5);

    var myDiamonds =
        NewHitaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
    if (myDiamonds > 60 || NewHitaMyInfoService.to.isHaveCallCard()) {
      //能接起电话  不能调起虚拟视频    如有 60 钻石  or 有体验卡
      if (TrudaConstants.isTestMode &&
          //判断是不是测试
          NewHitaHttpUrls.getConfigBaseUrl().startsWith('https://test')) {
        NewHitaLoading.toast(
          '测试时，有钱也打开aic',
          duration: Duration(seconds: 4),
        );
      } else {
        NewHitaLog.debug('NewHitaRemoteController 有钱屏蔽aic');
        return false;
      }
    }
    eventss(6);
    // VideoPlayerController videoController =
    //     VideoPlayerController.network(aic.filename!);
    // await videoController.initialize();
    // NewHitaLog.debug('aic check =${videoController.value}');
    // if (videoController.value.duration.inSeconds <= 1) {
    //   checkingAic = false;
    //   await videoController.dispose();
    //   return false;
    // }
    // await videoController.dispose();
    // eventss(7);
    // startMeAic前面已经检查过了，这里再检查一遍
    if (!NewHitaCheckCallingUtil.checkCanAic()) {
      return false;
    }
    // 把这个aic设为已经弹出
    aic.playState = 2;
    ob.putOrUpdateAic(aic);
    //设置这一次的 uid
    previousUid = aic.userId ?? "";
    eventss(7);
    NewHitaRemoteController.startMeAic(aic);
    return true;
  }

  void eventss(int aaa) {
    //直接被拦截
    NewHitaHttpUtil().post<void>(
      '${NewHitaHttpUrls.appCallStatistics}/6/$aaa',
    );
  }
}
