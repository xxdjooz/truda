import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_pages/call/remote/truda_remote_page.dart';
import 'package:truda/truda_pages/charge/success/truda_success_page.dart';
import 'package:truda/truda_pages/chat/truda_chat_binding.dart';
import 'package:truda/truda_pages/chat/truda_chat_page.dart';
import 'package:truda/truda_pages/invite/bonus/truda_invite_bonus_page.dart';
import 'package:truda/truda_pages/invite/truda_invite_page.dart';
import 'package:truda/truda_pages/login/truda_login_page.dart';
import 'package:truda/truda_pages/lottery/truda_lottery_binding.dart';
import 'package:truda/truda_pages/main/truda_main_ios_mock.dart';
import 'package:truda/truda_pages/main/me/blacklist/truda_black_list_page.dart';
import 'package:truda/truda_pages/main/me/cardlist/truda_card_list_binding.dart';
import 'package:truda/truda_pages/main/me/cardlist/truda_card_list_page.dart';
import 'package:truda/truda_pages/main/me/moment_list/truda_my_moment_page.dart';
import 'package:truda/truda_pages/main/me/orderlist/truda_order_detail_page.dart';
import 'package:truda/truda_pages/main/me/orderlist/truda_order_tab.dart';
import 'package:truda/truda_pages/some/newhita_reportup_page.dart';
import 'package:truda/truda_pages/some/newhita_web_page.dart';
import 'package:truda/truda_pages/splash/newhita_splash_binding.dart';
import 'package:truda/truda_pages/splash/newhita_splash_page.dart';
import 'package:truda/truda_pages/vip/newhita_vip_page.dart';
import 'package:truda/truda_rtm/newhita_rtm_manager.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_socket/newhita_socket_manager.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import '../truda_pages/call/aic/truda_aic_binding.dart';
import '../truda_pages/call/aic/truda_aic_page.dart';
import '../truda_pages/call/aiv/truda_aiv_binding.dart';
import '../truda_pages/call/aiv/truda_aiv_page.dart';
import '../truda_pages/call/end/truda_end_page.dart';
import '../truda_pages/call/truda_call_binding.dart';
import '../truda_pages/call/truda_call_page.dart';
import '../truda_pages/call/local/truda_local_binding.dart';
import '../truda_pages/call/local/truda_local_page.dart';
import '../truda_pages/call/remote/truda_remote_binding.dart';
import '../truda_pages/charge/truda_charge_new_binding.dart';
import '../truda_pages/charge/truda_charge_new_page.dart';
import '../truda_pages/charge/ios/truda_charge_ios_binding.dart';
import '../truda_pages/charge/ios/truda_charge_ios_page.dart';
import '../truda_pages/charge/success/truda_success_binding.dart';
import '../truda_pages/her_video/truda_her_video_page_view.dart';
import '../truda_pages/host/truda_host_binding.dart';
import '../truda_pages/host/truda_host_page.dart';
import '../truda_pages/invite/bind/truda_invite_bind_binding.dart';
import '../truda_pages/invite/bind/truda_invite_bind_page.dart';
import '../truda_pages/invite/bonus/truda_invite_bonus_binding.dart';
import '../truda_pages/invite/truda_invite_binding.dart';
import '../truda_pages/login/truda_login_binding.dart';
import '../truda_pages/lottery/truda_lottery_page.dart';
import '../truda_pages/main/truda_main_binding.dart';
import '../truda_pages/main/truda_main_page.dart';
import '../truda_pages/main/me/about/truda_about_binding.dart';
import '../truda_pages/main/me/about/truda_about_page.dart';
import '../truda_pages/main/me/blacklist/truda_black_list_binding.dart';
import '../truda_pages/main/me/calllist/truda_call_list_binding.dart';
import '../truda_pages/main/me/calllist/truda_call_list_page.dart';
import '../truda_pages/main/me/demo_test/trudatest_page.dart';
import '../truda_pages/main/me/info/truda_info_binding.dart';
import '../truda_pages/main/me/info/truda_info_page.dart';
import '../truda_pages/main/me/moment_list/truda_my_moment_binding.dart';
import '../truda_pages/main/me/setting/truda_setting_binding.dart';
import '../truda_pages/main/me/setting/truda_setting_page.dart';
import '../truda_pages/main/moment/create/truda_create_binding.dart';
import '../truda_pages/main/moment/create/truda_create_page.dart';
import '../truda_pages/main/search/truda_search_binding.dart';
import '../truda_pages/main/search/truda_search_page.dart';
import '../truda_pages/some/newhita_report_new_page.dart';
import 'newhita_observers.dart';

class NewHitaAppPages {
  // 这个字段决定app现在是否在后台
  static bool isAppBackground = false;

  static final RouteObserver<Route> observer = NewHitaRouteObservers();
  static List<String> history = [];

  static const initial = '/';
  static const login = '/sign_in';
  static const main = '/main';
  static const chatPage = '/chatPage';
  static const callCome = '/callCome';
  static const callOut = '/callOut';
  static const call = '/call';
  static const callEnd = '/callEnd';
  static const hostDetail = '/hostDetail';
  static const aicPage = '/aicPage';
  static const aivPage = '/aivPage';
  static const search = '/search';
  static const myInfo = '/myInfo';
  static const setting = '/setting';
  static const aboutUs = '/aboutUs';
  static const blackList = '/blackList';
  static const test = '/test';
  static const callList = '/callList';
  static const googleCharge = '/googleCharge';
  static const iosCharge = '/iosCharge';
  static const reportPage = '/reportPage';
  static const reportPageNew = '/reportPageNew';
  static const webPage = '/webPage';
  static const cardList = '/cardList';
  static const orderTab = '/orderTab';
  static const orderDetail = '/orderDetail';
  static const chargeSuccess = '/chargeSuccess';
  static const matchBubble = '/matchBubble';
  static const herVideo = '/herVideo';
  static const createMoment = '/createMoment';
  static const myMoment = '/myMoment';
  static const vip = '/vip';
  static const invitePage = '/invitePage';
  static const inviteBindPage = '/inviteBindPage';
  static const lotteryPage = '/lotteryPage';
  static const inviteBonus = '/inviteBonus';

  static final List<GetPage> routes = [
    // 免登陆
    GetPage(
      name: initial,
      page: () => NewHitaSplashPage(),
      binding: NewHitaSplashBinding(),
      // middlewares: [
      //   RouteWelcomeMiddleware(priority: 1),
      // ],
    ),
    GetPage(
      name: login,
      page: () => TrudaLoginPage(),
      binding: TrudaLoginBinding(),
    ),
    GetPage(
      name: chatPage,
      page: () => TrudaChatPage(),
      binding: TrudaChatBinding(),
    ),
    GetPage(
      name: main,
      page: () =>
          TrudaConstants.appMode != 2 ? TrudaMainPage() : NewHitaIOSMainPage(),
      binding:
          TrudaConstants.appMode != 2 ? TrudaMainBinding() : TrudaIOSMainBinding(),
    ),
    GetPage(
      name: callCome,
      page: () => TrudaRemotePage(),
      binding: TrudaRemoteBinding(),
    ),
    GetPage(
      name: callOut,
      page: () => TrudaLocalPage(),
      binding: TrudaLocalBinding(),
    ),
    GetPage(
      name: call,
      page: () => TrudaCallPage(),
      binding: TrudaCallBinding(),
    ),
    GetPage(
      name: callEnd,
      page: () => TrudaEndPage(),
      // binding: TrudaEndBinding(),
    ),
    GetPage(
      name: hostDetail,
      page: () => TrudaHostPage(),
      binding: TrudaHostBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: aicPage,
      page: () => TrudaAicPage(),
      binding: TrudaAicBinding(),
    ),
    GetPage(
      name: aivPage,
      page: () => TrudaAivPage(),
      binding: TrudaAivBinding(),
    ),
    GetPage(
      name: search,
      page: () => TrudaSearchPage(),
      binding: TrudaSearchBinding(),
    ),
    GetPage(
      name: myInfo,
      page: () => TrudaInfoPage(),
      binding: TrudaInfoBinding(),
    ),
    GetPage(
      name: setting,
      page: () => TrudaSettingPage(),
      binding: TrudaSettingBinding(),
    ),
    GetPage(
      name: aboutUs,
      page: () => TrudaAboutPage(),
      binding: TrudaAboutBinding(),
    ),
    GetPage(
      name: blackList,
      page: () => TrudaBlackListPage(),
      binding: TrudaBlackListBinding(),
    ),
    GetPage(
      name: test,
      page: () => TrudaTestPage(),
    ),
    GetPage(
      name: callList,
      page: () => TrudaCallListPage(),
      binding: TrudaCallListBinding(),
    ),
    GetPage(
      name: googleCharge,
      page: () => TrudaChargeNewPage(),
      binding: TrudaChargeNewBinding(),
    ),
    GetPage(
      name: iosCharge,
      page: () => TrudaChargeIosPage(),
      binding: TrudaChargeIosBinding(),
    ),
    GetPage(
      name: reportPage,
      page: () => NewHitaReportUpPage(),
    ),
    GetPage(
      name: reportPageNew,
      page: () => NewHitaReportNewPage(),
    ),
    GetPage(
      name: webPage,
      page: () => NewHitaWebPage(),
    ),
    GetPage(
      name: cardList,
      page: () => TrudaCardListPage(),
      binding: TrudaCardListBinding(),
    ),
    GetPage(
      name: chargeSuccess,
      page: () => TrudaSuccessPage(),
      binding: TrudaSuccessBinding(),
    ),
    GetPage(
      name: createMoment,
      page: () => TrudaCreatePage(),
      binding: TrudaCreateBinding(),
    ),
    GetPage(
      name: myMoment,
      page: () => TrudaMyMomentPage(),
      binding: TrudaMyMomentBinding(),
    ),
    GetPage(
      name: vip,
      page: () => NewHitaVipPage(),
    ),
    GetPage(
      name: orderTab,
      page: () => TrudaOrderTab(),
    ),
    GetPage(
      name: orderDetail,
      page: () => TrudaOrderDetailPage(),
    ),
    GetPage(
      name: herVideo,
      page: () => TrudaHerVideoPageView(),
    ),
    GetPage(
      name: invitePage,
      page: () => TrudaInvitePage(),
      binding: TrudaInviteBinding(),
    ),
    GetPage(
      name: inviteBindPage,
      page: () => TrudaInviteBindPage(),
      binding: TrudaInviteBindBinding(),
    ),
    GetPage(
      name: lotteryPage,
      page: () => TrudaLotteryPage(),
      binding: TrudaLotteryBinding(),
    ),
    GetPage(
      name: inviteBonus,
      page: () => TrudaInviteBonusPage(),
      binding: TrudaInviteBonusBinding(),
    ),
  ];

  static void logout() {
    NewHitaLog.debug('logout()');
    NewHitaMyInfoService.to.clear();
    Get.offAllNamed(login);
    NewHitaRtmManager.closeRtm();
    NewHitaSocketManager.to.breakenSocket();

    TrudaHttpUtil().post(TrudaHttpUrls.loginOutApi);
    NewHitaStorageService.to.prefs.setString(NewHitaMyInfoService.userLoginData, '');
  }

  static void closeDialog() {
    /// 关闭弹窗
    if (Get.isOverlaysOpen) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      navigator?.popUntil((route) {
        return (!Get.isDialogOpen! && !Get.isBottomSheetOpen!);
      });
    }
  }
}
