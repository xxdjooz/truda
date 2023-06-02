import 'dart:async';

import 'package:anythink_sdk/at_rewarded.dart';
import 'package:anythink_sdk/at_rewarded_response.dart';

import '../../truda_services/truda_storage_service.dart';

class TrudaAdsRewardedUtils {
  String adCode;
  Function refresh;
  bool isReady = false;
  late final StreamSubscription<ATRewardResponse> sub;
  TrudaAdsRewardedUtils(this.adCode, this.refresh) {
    hasAdReady();
    sub = TrudaStorageService.to.eventBus.on<ATRewardResponse>().listen((value) {
      switch (value.rewardStatus) {
        //广告加载失败
        case RewardedStatus.rewardedVideoDidFailToLoad:
          print(
              "ad_reward rewardedVideoDidFailToLoad ---- placementID: ${value.placementID} ---- errStr:${value.requestMessage}");
          break;
        //广告加载成功
        case RewardedStatus.rewardedVideoDidFinishLoading:
          print(
              "ad_reward rewardedVideoDidFinishLoading ---- placementID: ${value.placementID}");
          if (value.placementID == adCode) {
            hasAdReady();
          }
          break;
        //广告被关闭
        case RewardedStatus.rewardedVideoDidClose:
          print(
              "ad_reward rewardedVideoDidClose ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          if (value.placementID == adCode) {
            hasAdReady();
          }
          break;
        case RewardedStatus.rewardedVideoUnknown:
          print("ad_reward rewardedVideoUnknown");
          break;
      }
    });
  }

  ///取消订阅
  void closeSub() {
    sub.cancel();
  }

  void loadRewardedVideo() async {
    await ATRewardedManager.loadRewardedVideo(
        placementID: adCode, extraMap: {});
    print('ad_reward 加载视频结束 e');
  }

  void hasAdReady() async {
    await ATRewardedManager.rewardedVideoReady(
      placementID: adCode,
    ).then((value) {
      print('ad_reward 广告视频缓存$value   ');
      isReady = value;
      if (!value) {
        //没有加载成功 就去加载
        loadRewardedVideo();
      }
      refresh.call();
    });
  }

  void showRewardAd() async {
    await ATRewardedManager.showRewardedVideo(
      placementID: adCode,
    ).then((value) {
      // print('广告视频展示$value');
    });
  }
}
