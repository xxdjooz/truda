import 'dart:async';

import 'package:anythink_sdk/at_native.dart';
import 'package:anythink_sdk/at_native_response.dart';
import 'package:anythink_sdk/at_platformview/at_native_platform_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../truda_services/newhita_storage_service.dart';
import '../newhita_log.dart';

class NewHitaAdsNativeUtils {
  String adCode;
  Function refresh;
  bool isReady = false;
  late final StreamSubscription<ATNativeResponse> sub;

  Widget? _native_ad = null;

  NewHitaAdsNativeUtils(this.adCode, this.refresh) {
    hasNativeAdReady();
    sub = NewHitaStorageService.to.eventBus.on<ATNativeResponse>().listen((value) {
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
          if (value.placementID == adCode) {
            hasNativeAdReady();
          }
          break;
        //广告被点击
        case NativeStatus.nativeAdDidClick:
          print(
              "flutter nativeAdDidClick ---- placementID: ${value.placementID} ---- extra:${value.extraMap}");
          if (value.placementID == adCode) {
            _native_ad = null;
            hasNativeAdReady();
          }
          break;
        case NativeStatus.nativeAdUnknown:
          print("flutter rewardedVideoUnknown");
          break;
      }
    });
  }

  ///取消订阅
  void closeSub() {
    sub.cancel();
  }

  ///加载本地广告
  void _loadnativeAd() async {
    logi('原生广告加载  $adCode');
    await ATNativeManager.loadNativeAd(placementID: adCode,
        // placementID: 'b5c2c6d50e7f44',
        extraMap: {
          ATNativeManager.parent():
              ATNativeManager.createNativeSubViewAttribute(double.infinity, 60),
        });
  }

  ///判断本地广告是否加载
  void hasNativeAdReady() async {
    await ATNativeManager.nativeAdReady(
      placementID: adCode,
    ).then((value) {
      logi('flutter原生广告视频缓存$value');
      isReady = value;
      if (!value) {
        //没有加载成功 就去加载
        _loadnativeAd();
      }
      refresh.call();
    });
  }

  /// 获取会话列表的广告
  Widget preparedMessageNativeAd(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _native_ad ??= PlatformNativeWidget(
      adCode,
      {
        ATNativeManager.parent(): ATNativeManager.createNativeSubViewAttribute(
            size.width, 110,
            backgroundColorStr: '#FFFFFFFF'),
        ATNativeManager.appIcon(): ATNativeManager.createNativeSubViewAttribute(
            56, 56,
            x: 15, y: 5, backgroundColorStr: 'clearColor'),
        ATNativeManager.mainTitle():
            ATNativeManager.createNativeSubViewAttribute(
          size.width - 170,
          20,
          x: 80,
          y: 5,
          textSize: 15,
        ),
        ATNativeManager.desc(): ATNativeManager.createNativeSubViewAttribute(
            size.width - 170, 30,
            x: 80, y: 25, textSize: 10),
        ATNativeManager.cta(): ATNativeManager.createNativeSubViewAttribute(
            80, 40,
            x: size.width - 90,
            y: 5,
            textSize: 15,
            textColorStr: "#FF333333",
            backgroundColorStr: "#FFB7F012"),
        // ATNativeManager.mainImage():
        //     ATNativeManager.createNativeSubViewAttribute(
        //         size.width - 20, size.width * 0.6,
        //         x: 10, y: 100, backgroundColorStr: '#00000000'),
        ATNativeManager.adLogo(): ATNativeManager.createNativeSubViewAttribute(
            20, 10,
            x: 100, y: 100, backgroundColorStr: '#00000000'),
        // ATNativeManager.dislike(): ATNativeManager.createNativeSubViewAttribute(
        //   20,
        //   20,
        //   x: size.width - 30,
        //   y: 10,
        // ),
      },
      isAdaptiveHeight: true,
    );
    return _native_ad!;
  }

  /// 获取聊天界面的广告
  Widget preparedMessageChatNativeAd(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _native_ad ??= PlatformNativeWidget(
      adCode,
      {
        ATNativeManager.parent(): ATNativeManager.createNativeSubViewAttribute(
            size.width, 60,
            backgroundColorStr: '#FFFFFF'),
        ATNativeManager.appIcon(): ATNativeManager.createNativeSubViewAttribute(
            50, 50,
            x: 15, y: 5, backgroundColorStr: 'clearColor'),
        ATNativeManager.mainTitle():
            ATNativeManager.createNativeSubViewAttribute(
          size.width - 170,
          20,
          x: 80,
          y: 5,
          textSize: 15,
        ),
        ATNativeManager.desc(): ATNativeManager.createNativeSubViewAttribute(
            size.width - 170, 30,
            x: 80, y: 25, textSize: 10),
        ATNativeManager.cta(): ATNativeManager.createNativeSubViewAttribute(
            80, 40,
            x: size.width - 90,
            y: 10,
            textSize: 15,
            textColorStr: "#FFffffff",
            backgroundColorStr: "#FFFF0567"),
        // ATNativeManager.mainImage():
        //     ATNativeManager.createNativeSubViewAttribute(
        //         size.width - 20, size.width * 0.6,
        //         x: 10, y: 100, backgroundColorStr: '#00000000'),
        ATNativeManager.adLogo(): ATNativeManager.createNativeSubViewAttribute(
            20, 10,
            x: 100, y: 100, backgroundColorStr: '#00000000'),
        // ATNativeManager.dislike(): ATNativeManager.createNativeSubViewAttribute(
        //   20,
        //   20,
        //   x: size.width - 30,
        //   y: 10,
        // ),
      },
      isAdaptiveHeight: true,
    );

    return _native_ad!;
  }

  static void logi(String msg) {
    NewHitaLog.debug("ads ===> $msg ");
  }
}
