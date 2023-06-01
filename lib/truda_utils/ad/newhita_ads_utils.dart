import 'package:anythink_sdk/at_index.dart';

import '../../truda_common/truda_constants.dart';
import '../../truda_http/newhita_http_urls.dart';
import '../../truda_http/newhita_http_util.dart';
import '../../truda_services/newhita_app_info_service.dart';
import '../../truda_services/newhita_storage_service.dart';
import '../newhita_log.dart';
import 'newhita_ads_spots_entity.dart';

class NewHitaAdsUtils {
  ///看视频奖励钻石的
  static const UID_REWARD_MESSAGE_CHAT = "00000";

  ///应用下载广告
  static const UID_NATIVE_CHAT = "11111";

  /// 会话界面 ad
  static const NATIVE_CONVERSATION_LIST = "native-conversation-list";

  /// 私聊界面 ad
  static const NATIVE_CHAT = "native-chat";

  /// 个人中心 video ad
  static const REWARD_PROFILE = "reward-profile";

  /// 消息会话 video ad
  static const REWARD_ONE_MESSAGE_CHAT = "reward-conversation-list";

  static Map<String, NewHitaAdsSpotsEntity> adMap = {};

  /// 是否显示 对应广告
  static bool isShowAd(String key) {
    return adMap[key]?.adStatus == 1;
  }

  /// 获取广告码
  static String getAdCode(String key) {
    return adMap[key]?.adCode ?? "";
  }

  /// 获取我们的广告码
  static String getAdId(String adCode) {
    var adid;
    adMap.forEach((key, value) {
      if (value.adCode == adCode) {
        adid = value.adId;
      }
    });
    return adid;
  }

  ///初始化广告
  static initAds() {
    logi('初始化');
    _setLogEnabled();
    _setChannelStr();
    _initTopon();
    _nativeListen();
    _rewarderListen();
    getAdSpots(isRefresh: true);
    // _loadAd();
  }

  ///缓存
  static _loadAd() {
    _loadnativeAd(getAdCode(NATIVE_CONVERSATION_LIST));
    _loadnativeAd(getAdCode(NATIVE_CHAT));
    _loadRewardedVideo(getAdCode(REWARD_ONE_MESSAGE_CHAT));
    _loadRewardedVideo(getAdCode(REWARD_PROFILE));
  }

  ///打开SDK的Debug log，强烈建议在测试阶段打开，方便排查问题
  static _setLogEnabled() async {
    if (TrudaConstants.isTestMode) {
      logi('设置日志开关');
      //只有在测试环境才打开
      await ATInitManger.setLogEnabled(
        logEnabled: true,
      ).then((value) {
        logi('设置日志开关$value');
      });
    }
  }

  ///设置渠道
  static _setChannelStr() async {
    await ATInitManger.setChannelStr(
      channelStr: NewHitaAppInfoService.to.channelName,
    ).then((value) {
      logi('设置渠道$value');
    });
  }

  ///初始化
  static _initTopon() async {
    await ATInitManger.initAnyThinkSDK(
            appidStr: 'a6458b2957077b',
            appidkeyStr: '8567ba8fb68d0ac90cdc8338c92fd0e4')
        .then((value) {
      logi('初始化完成');
    });
  }

  ///加载本地广告
  static _loadnativeAd(String adCode) async {
    logi('原生广告加载  $adCode');
    if (adCode.isEmpty) {
      return;
    }
    logi('原生广告加载');
    await ATNativeManager.loadNativeAd(placementID: adCode,
        // placementID: 'b5c2c6d50e7f44',
        extraMap: {
          ATNativeManager.parent():
              ATNativeManager.createNativeSubViewAttribute(double.infinity, 60),
        });
  }

  ///加载激励广告
  static _loadRewardedVideo(String adCode) async {
    if (adCode.isEmpty) {
      return;
    }
    await ATRewardedManager.loadRewardedVideo(
        placementID: adCode, extraMap: {});
  }

  ///设置本地广告的监听
  static _rewarderListen() {
    ATListenerManager.rewardedVideoEventHandler.listen((value) {
      NewHitaStorageService.to.eventBus.fire(value);
      switch (value.rewardStatus) {
        //广告加载失败
        case RewardedStatus.rewardedVideoDidFailToLoad:
          print(
              "flutter rewardedVideoDidFailToLoad ---- placementID: ${value.placementID} ---- errStr:${value.requestMessage}");
          break;
        //广告加载成功
        case RewardedStatus.rewardedVideoDidFinishLoading:
          print(
              "flutter rewardedVideoDidFinishLoading ---- placementID: ${value.placementID}");
          break;
        //广告开始播放
        case RewardedStatus.rewardedVideoDidStartPlaying:
          print(
              "flutter rewardedVideoDidStartPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告结束播放
        case RewardedStatus.rewardedVideoDidEndPlaying:
          print(
              "flutter rewardedVideoDidEndPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告播放失败
        case RewardedStatus.rewardedVideoDidFailToPlay:
          print(
              "flutter rewardedVideoDidFailToPlay ---- placementID: ${value.placementID} ---- errStr:${value.extraMap}");
          break;
        //激励成功，建议在此回调中下发奖励
        case RewardedStatus.rewardedVideoDidRewardSuccess:
          adSpotsCallBack(value.placementID);
          print(
              "flutter rewardedVideoDidRewardSuccess ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告被点击
        case RewardedStatus.rewardedVideoDidClick:
          print(
              "flutter rewardedVideoDidClick ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //Deeplink
        case RewardedStatus.rewardedVideoDidDeepLink:
          print(
              "flutter rewardedVideoDidDeepLink ---- placementID: ${value.placementID} ---- extra:${value.extraMap} ---- isDeeplinkSuccess:${value.isDeeplinkSuccess}");
          break;
        //广告被关闭
        case RewardedStatus.rewardedVideoDidClose:
          print(
              "flutter rewardedVideoDidClose ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;

        //广告开始播放（只针对穿山甲的再看一个广告）
        case RewardedStatus.rewardedVideoDidAgainStartPlaying:
          print(
              "flutter rewardedVideoDidAgainStartPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告结束播放（只针对穿山甲的再看一个广告）
        case RewardedStatus.rewardedVideoDidAgainEndPlaying:
          print(
              "flutter rewardedVideoDidAgainEndPlaying ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告播放失败（只针对穿山甲的再看一个广告）
        case RewardedStatus.rewardedVideoDidAgainFailToPlay:
          print(
              "flutter rewardedVideoDidAgainFailToPlay ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //激励成功（只针对穿山甲的再看一个广告）
        case RewardedStatus.rewardedVideoDidAgainRewardSuccess:
          print(
              "flutter rewardedVideoDidAgainRewardSuccess ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告被点击（只针对穿山甲的再看一个广告）
        case RewardedStatus.rewardedVideoDidAgainClick:
          print(
              "flutter rewardedVideoDidAgainClick ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        case RewardedStatus.rewardedVideoUnknown:
          print("flutter rewardedVideoUnknown");
          break;
      }
    });
  }

  ///设置本地广告的监听
  static _nativeListen() {
    ATListenerManager.nativeEventHandler.listen((value) {
      NewHitaStorageService.to.eventBus.fire(value);
      switch (value.nativeStatus) {
        //广告加载失败
        case NativeStatus.nativeAdFailToLoadAD:
          print(
              "flutter nativeAdFailToLoadAD ---- placementID: ${value.placementID} ---- errStr:${value.requestMessage}");
          break;
        //广告加载成功
        case NativeStatus.nativeAdDidFinishLoading:
          print(
              "flutter nativeAdDidFinishLoading ---- placementID: ${value.placementID}");
          break;
        //广告被点击
        case NativeStatus.nativeAdDidClick:
          adSpotsCallBack(value.placementID);
          print(
              "flutter nativeAdDidClick ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //Deeplink
        case NativeStatus.nativeAdDidDeepLink:
          print(
              "flutter nativeAdDidDeepLink ---- placementID: ${value.placementID} ---- extra:${value.extraMap} ---- isDeeplinkSuccess:${value.isDeeplinkSuccess}");
          break;
        //广告视频结束播放，部分广告平台有此回调
        case NativeStatus.nativeAdDidEndPlayingVideo:
          print(
              "flutter nativeAdDidEndPlayingVideo ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告进入全屏播放，仅iOS有此回调
        case NativeStatus.nativeAdEnterFullScreenVideo:
          print(
              "flutter nativeAdEnterFullScreenVideo ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告离开全屏播放，仅iOS有此回调
        case NativeStatus.nativeAdExitFullScreenVideoInAd:
          print(
              "flutter nativeAdExitFullScreenVideoInAd ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告展示成功
        case NativeStatus.nativeAdDidShowNativeAd:
          print(
              "flutter nativeAdDidShowNativeAd ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告视频开始播放，部分广告平台有此回调
        case NativeStatus.nativeAdDidStartPlayingVideo:
          print(
              "flutter nativeAdDidStartPlayingVideo ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告关闭按钮被点击，部分广告平台有此回调
        case NativeStatus.nativeAdDidTapCloseButton:
          print(
              "flutter nativeAdDidTapCloseButton ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        case NativeStatus.nativeAdDidCloseDetailInAdView:
          print(
              "flutter nativeAdDidCloseDetailInAdView ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        //广告加载Draw成功，仅iOS有此回调
        case NativeStatus.nativeAdDidLoadSuccessDraw:
          print(
              "flutter nativeAdDidLoadSuccessDraw ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          break;
        case NativeStatus.nativeAdUnknown:
          print("flutter downloadUnknown");
          break;
      }
    });
  }

  ///提交广告事件
  static void adSpotsCallBack(String adCode) {
    NewHitaHttpUtil()
        .post<void>(
          NewHitaHttpUrls.adSpotsCallback + getAdId(adCode),
          errCallback: (e) {},
        )
        .then((value) => {logi('adSpotsCallBack ')});
  }

  ///获取广告列表
  static void getAdSpots({bool isRefresh = false}) {
    NewHitaHttpUtil().post<List<NewHitaAdsSpotsEntity>>(NewHitaHttpUrls.getAdSpots,
        errCallback: (e) {
      NewHitaLog.debug('ad spots call back success 3 ${e.toString()}');
    }).then((data) {
      NewHitaLog.debug('ad spots call back success  1 ');
      NewHitaLog.debug('ad spots call back success ${data.length.toString()}');
      data.forEach((element) {
        NewHitaLog.debug('ad spots  ${element.keyCode}    ');
      });
      adMap =
          Map.fromEntries(data.map((value) => MapEntry(value.keyCode, value)));
      if (isRefresh) {
        //第一次获取刷新 在刷新的时候必须传入 activity
        _loadAd();
      }
    });
  }

  static void logi(String msg) {
    NewHitaLog.debug("ads ===> $msg ");
  }
}
