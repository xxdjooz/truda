import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_translations.dart';
import 'package:truda/truda_http/truda_http_overrides.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:truda/truda_services/truda_app_info_service.dart';
import 'package:truda/truda_services/truda_host_video_service.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:truda/truda_widget/newhita_ball_beat.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // 崩溃统计
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn = NewHitaConstants.sentryDsn;
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 1.0;
  //   },
  //   appRunner: () async {
  //     // This is required so ObjectBox can get the application directory
  //     // to store the database in.
  //     WidgetsFlutterBinding.ensureInitialized();
  //
  //     /// 试图解决有手机（有账号机）ssl问题
  //     HttpOverrides.global = NewHitaHttpOverrides();
  //     await NewHitaGlobal.init();
  //     runApp(const NewHitaApp());
  //   },
  // );

  WidgetsFlutterBinding.ensureInitialized();

  /// 试图解决有手机（有账号机）ssl问题
  HttpOverrides.global = TrudaHttpOverrides();
  await NewHitaGlobal.init();
  runApp(const NewHitaApp());
}

/// 全局静态数据
class NewHitaGlobal {
  /// 初始化
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    setSystemUi();
    NewHitaLoading();

    await Get.putAsync<TrudaStorageService>(() => TrudaStorageService().init());
    await Get.putAsync<TrudaAppInfoService>(() => TrudaAppInfoService().init());
    await Get.putAsync<TrudaMyInfoService>(() => TrudaMyInfoService().init());
    await Get.putAsync<TrudaHostVideoService>(
        () => TrudaHostVideoService().init());

    // Get.put<ConfigStore>(ConfigStore());
    // Get.put<UserStore>(UserStore());
  }

  static void setSystemUi() {
    if (GetPlatform.isAndroid) {
      // SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      //   statusBarBrightness: Brightness.dark,
      //   statusBarIconBrightness: Brightness.dark,
      //   systemNavigationBarDividerColor: Colors.transparent,
      //   systemNavigationBarColor: TrudaColors.white,
      //   systemNavigationBarIconBrightness: Brightness.dark,
      // );
      //   static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
      //     systemNavigationBarColor: Color(0xFF000000),
      //     systemNavigationBarIconBrightness: Brightness.light,
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.light,
      //   );
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
  }
}

class NewHitaApp extends StatelessWidget {
  const NewHitaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(
        height: 40,
      ),
      // footerBuilder: () => ClassicFooter(),
      footerBuilder: () => CustomFooter(builder: (context, status) {
        return status == LoadStatus.loading
            ? Center(
                child: NewHitaBallBeatIndicator(),
              )
            : const SizedBox(
                height: 0,
              );
      }),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      child: GetMaterialApp(
        showPerformanceOverlay: kProfileMode,
        localizationsDelegates: [
          // this line is important
          RefreshLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
          // GlobalMaterialLocalizations.delegate
        ],
        title: TrudaConstants.appName,
        translations: TrudaTrans(),
        locale: Get.deviceLocale,
        // locale: Locale("pt"),
        fallbackLocale: Locale("en"),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: TrudaAppPages.initial,
        getPages: TrudaAppPages.routes,
        navigatorObservers: [TrudaAppPages.observer],
        // home: MyHomePage(title: "test db"),
        // home: _Example(),
        // EasyLoading 吐司和进度条
        builder: EasyLoading.init(),
        defaultTransition: Transition.cupertino,
      ),
    );
  }
}
