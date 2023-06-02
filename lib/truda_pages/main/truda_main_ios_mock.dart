import 'package:get/get.dart';
import 'dart:convert';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_dialogs/truda_dialog_first_tip.dart';
import 'package:truda/truda_entities/truda_leval_entity.dart';
import 'package:truda/truda_entities/truda_sensitive_word_entity.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_socket/truda_socket_manager.dart';
import 'package:truda/truda_utils/newhita_adjust_manager.dart';
import 'package:truda/truda_utils/newhita_ai_help_manager.dart';
import 'package:truda/truda_utils/newhita_firebase_manager.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_utils/newhita_loading.dart';
import '../../truda_utils/newhita_permission_handler.dart';
import 'package:flutter/material.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_widget/newhita_decoration_bg.dart';
import 'match/truda_match_page.dart';
import 'truda_main_page.dart';
import 'home/truda_home_ios_page.dart';
import 'me/truda_me_page.dart';
import 'moment/truda_moment_list_page.dart';
import 'msg/truda_msg_tab.dart';

/// iOS的审核模式下的页面
class TrudaIOSMainBinding implements Bindings {
  @override
  void dependencies() {

  }
}

class NewHitaIOSMainController extends GetxController {
  // 页控制器
  late final PageController pageController;
  var currentIndex = 0.obs;

  // tab栏动画
  void handleNavBarTap(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    pageController.jumpToPage(index);
    if (index == 2) {
      TrudaStorageService.to.objectBoxMsg.refreshUnreadNum();
    }
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    NewHitaAdjustManager.checkAdjustUploadAttr();
    Get.putAsync<TrudaSocketManager>(() => TrudaSocketManager().init());
  }

  @override
  void onReady() {
    super.onReady();
    getGift();
    getLevalList();
    getSensitiveList();
    TrudaFirstTip.checkToShow();
    NewHitaAihelpManager.initAIHelp();
    TrudaStorageService.to.objectBoxMsg.refreshUnreadNum();

    // firebase 初始化
    if (!TrudaConstants.isFakeMode && !TrudaConstants.isTestMode) {
      // if (!NewHitaConstants.isFakeMode) {
      NewHitaLog.debug('firebase init');
      NewHitaFirebaseManager.init().then((value) {
        NewHitaFirebaseManager.getToken();
      });
    }

    NewHitaPermissionHandler.checkNotificationPermission();

  }

  void getGift() {
    TrudaHttpUtil().post<List<TrudaGiftEntity>>(TrudaHttpUrls.allGiftListApi,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
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
  }
}

class NewHitaIOSMainPage extends StatefulWidget {
  NewHitaIOSMainPage({Key? key}) : super(key: key);

  @override
  State<NewHitaIOSMainPage> createState() => _NewHitaIOSMainPageState();
}

class _NewHitaIOSMainPageState extends State<NewHitaIOSMainPage>{

  var lastClickTime = 0;

  @override
  Widget build(BuildContext context) {
    Get.put<NewHitaIOSMainController>(NewHitaIOSMainController());
    return GetBuilder<NewHitaIOSMainController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          var nowTime = DateTime.now().millisecondsSinceEpoch;
          if (nowTime - lastClickTime < 800 && lastClickTime != 0) {
            return true;
          }
          lastClickTime = nowTime;
          return false;
        },
        child: Scaffold(
          backgroundColor: TrudaColors.baseColorBlackBg,
          body: Container(
            decoration: const NewHitaDecorationBg(),
            child: PageView(
              pageSnapping: false,
              scrollBehavior: null,
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.pageController,
              children: <Widget>[
                TrudaMatchPage(),
                TrudaHomeIosPage(),
                TrudaMsgTab(),
                TrudaMePage(),
              ],
              // onPageChanged: controller.handlePageChanged,
            ),
          ),
          bottomNavigationBar: Obx(() {
            return BottomNavigationBar(
              // backgroundColor: Colors.transparent,
              items: <BottomNavigationBarItem>[
                // BottomNavigationBarItem(
                //   activeIcon: Image.asset('assets/images/newhita_main_home_s.png'),
                //   icon: Image.asset('assets/images/newhita_main_home.png'),
                //   label: '',
                //   backgroundColor: Colors.black12,
                // ),
                BottomNavigationBarItem(
                  activeIcon: Image.asset('assets/images/newhita_main_play_s.png'),
                  icon: Image.asset('assets/images/newhita_main_play.png'),
                  label: '',
                  backgroundColor: Colors.black12,
                ),
                BottomNavigationBarItem(
                  activeIcon:
                      Image.asset('assets/images/newhita_main_discover_s.png'),
                  icon: Image.asset('assets/images/newhita_main_discover.png'),
                  label: '',
                  backgroundColor: Colors.black12,
                ),
                BottomNavigationBarItem(
                  activeIcon: TrudaMsgNum(
                    checked: true,
                  ),
                  icon: TrudaMsgNum(
                    checked: false,
                  ),
                  label: '',
                  backgroundColor: Colors.black12,
                ),
                BottomNavigationBarItem(
                  activeIcon: Image.asset('assets/images/newhita_main_me_s.png'),
                  icon: Image.asset('assets/images/newhita_main_me.png'),
                  label: '',
                  backgroundColor: Colors.black12,
                ),
              ],
              currentIndex: controller.currentIndex.value,
              // fixedColor: AppColors.primaryElement,
              type: BottomNavigationBarType.fixed,
              onTap: controller.handleNavBarTap,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            );
          }),
        ),
      );
    });
  }
}