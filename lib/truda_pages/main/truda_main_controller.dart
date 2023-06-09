import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_dialogs/truda_dialog_first_tip.dart';
import 'package:truda/truda_entities/truda_leval_entity.dart';
import 'package:truda/truda_entities/truda_sensitive_word_entity.dart';
import 'package:truda/truda_pages/main/home/truda_page_index_manager.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_socket/truda_socket_manager.dart';
import 'package:truda/truda_utils/truda_adjust_manager.dart';
import 'package:truda/truda_utils/truda_ai_help_manager.dart';
import 'package:truda/truda_utils/truda_check_app_update.dart';
import 'package:truda/truda_utils/truda_firebase_manager.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../../truda_dialogs/truda_dialog_new_user.dart';
import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_routes/truda_pages.dart';
import '../../truda_rtm/truda_rtm_manager.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_utils/ai/truda_ai_logic_utils.dart';
import '../../truda_utils/truda_loading.dart';
import '../../truda_utils/truda_pay_cache_manager.dart';
import '../../truda_utils/truda_permission_handler.dart';
import '../charge/truda_google_billing.dart';
import '../charge/truda_in_app_purchase_apple.dart';

class TrudaMainController extends GetxController {
  // 页控制器
  late final PageController pageController;
  var currentIndex = 0.obs;

  // 计时器
  Timer? _timer;

  // tab栏动画
  void handleNavBarTap(int index) {
    // 有这个事件说明app不是后台
    TrudaAppPages.isAppBackground = false;
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    // pageController.animateToPage(index,
    //     duration: const Duration(milliseconds: 200), curve: Curves.ease);
    pageController.jumpToPage(index);
    if (index == 2) {
      TrudaStorageService.to.objectBoxMsg.refreshUnreadNum();
    }
    TrudaPageIndexManager.setMainIndex(index);
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);

    Get.putAsync<TrudaSocketManager>(() => TrudaSocketManager().init());

    TrudaAdjustManager.checkAdjustUploadAttr();
    TrudaAdjustManager.getGoolgeReferrer();
    TrudaAiLogicUtils().init();
  }

  @override
  void onReady() {
    super.onReady();
    getGift();
    getLevalList();
    getSensitiveList();
    NewTrudaUserCardsTip.checkToShow();
    TrudaFirstTip.checkToShow();
    TrudaAihelpManager.initAIHelp();
    TrudaStorageService.to.objectBoxMsg.refreshUnreadNum();

    // firebase 初始化
    if (!TrudaConstants.isFakeMode && !TrudaConstants.isTestMode) {
      // if (!NewHitaConstants.isFakeMode) {
      TrudaLog.debug('firebase init');
      TrudaFirebaseManager.init().then((value) {
        TrudaFirebaseManager.getToken();
      });
    }

    TrudaPermissionHandler.checkNotificationPermission();

    TrudaCheckAppUpdate.check();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final tick = timer.tick;
      // 每5s 检查aic
      final remainder5 = tick % 5;
      if (remainder5 == 0) {
        // NewHitaLog_pro.debug(
        //     'LinaMainController _timer $tick remainder5=${remainder5}');
        // NewHitaAicHandler().checkAicToShow();
      }
      // 每15s 检查 rtm
      final remainder15 = tick % 15;
      if (remainder15 == 0) {
        TrudaRtmManager.connectRTM();
      }
      // 每30s 检查 支付
      final remainder30 = tick % 30;
      if (remainder30 == 0) {
        // GoogleBillingManager.fixNoEndPurchase();
        if (GetPlatform.isIOS) {
          TrudaAppleInAppPurchase.fixNoEndPurchase();
        } else {
          TrudaGoogleBilling.fixNoEndPurchase();
        }
        TrudaPayCacheManager.checkOrderList();
      }
    });

    // try {
    //   NewHitaAdsUtils.initAds();
    // } catch (e) {
    //   print(e);
    // }

    ///初始化内购
    if (GetPlatform.isIOS == true) {
      TrudaAppleInAppPurchase.initAppPurchase();
    } else if (GetPlatform.isAndroid == true) {
      //谷歌内购
      TrudaGoogleBilling.getGooglePrice();
    }
  }

  void getGift() {
    TrudaHttpUtil().post<List<TrudaGiftEntity>>(TrudaHttpUrls.allGiftListApi,
        errCallback: (err) {
      TrudaLoading.toast(err.message);
    }).then((value) {
      if (value.isNotEmpty) {
        String jsonGifts = json.encode(value);
        TrudaStorageService.to.prefs
            .setString(TrudaConstants.giftsJson, jsonGifts);
      }
    });
  }

  void getLevalList() {
    var areaCode = TrudaMyInfoService.to.myDetail?.areaCode ?? 1;
    TrudaHttpUtil()
        .post<List<TrudaLevalBean>>(TrudaHttpUrls.LevelRuleApi + '/$areaCode',
            errCallback: (err) {})
        .then((value) {
      if (value.isNotEmpty) {
        TrudaMyInfoService.to.levalList = value;
        // for (var le in value) {
        //   NewHitaLog.debug('${le.grade} ${le.howExp} ${le.awardName}');
        // }
      }
    });
  }

  void getSensitiveList() {
    TrudaHttpUtil()
        .post<List<TrudaSensitiveWordBean>>(TrudaHttpUrls.sensitiveWordsApi,
            errCallback: (err) {})
        .then((value) {
      if (value.isNotEmpty) {
        List<String> list = value.map((e) => e.words ?? '').toList();
        TrudaMyInfoService.to.sensitiveList = list;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    TrudaLog.debug('MainController onClose');
    _timer?.cancel();
    TrudaAiLogicUtils().cancel();
  }
}
