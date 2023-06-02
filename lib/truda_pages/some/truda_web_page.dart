import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../truda_utils/truda_log.dart';
import '../../truda_widget/newhita_app_bar.dart';

class TrudaWebPage extends StatefulWidget {
  static startMe(String url, bool fullScreen) {
    Map<String, dynamic> map = {};
    map['url'] = url;
    map['fullScreen'] = fullScreen;
    Get.toNamed(TrudaAppPages.webPage, arguments: map);
  }

  @override
  _TrudaWebPageState createState() => _TrudaWebPageState();
}

class _TrudaWebPageState extends State<TrudaWebPage> {
  String url = "";

  String title = "";
  bool fullScreen = false;
  WebViewController? webViewController;
  String _lastUrl = "";

  @override
  void initState() {
    super.initState();

    /// 这行代码尝试解决一个崩溃
    /// java.lang.NullPointerException: Attempt to read from field 'android.view.WindowManager
    /// 记得跟进这个问题
    if (GetPlatform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // if (GetPlatform.isAndroid) WebView.platform = AndroidWebView();

    var arguments = Get.arguments as Map<String, dynamic>;
    url = arguments['url']!;
    fullScreen = arguments['fullScreen'];
  }

  @override
  void dispose() {
    super.dispose();
    webViewController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrudaColors.white,
      appBar: NewHitaAppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark, // 状态栏字体黑色
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: TrudaColors.baseColorBlackBg,
      ),
      extendBodyBehindAppBar: false,
      body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: <JavascriptChannel>{
            JavascriptChannel(
                name: "flutterapp",
                onMessageReceived: (JavascriptMessage message) {
                  TrudaLog.debug("js交互传值 ${message.message}");
                  if (message.message == "goback") {
                    Get.back();
                  } else if (message.message == "grade") {
                    //打开签到页面
                  } else if (message.message == "recharge") {
                    //打开充值页面
                    // GetPlatform.isIOS
                    // todo
                    Get.toNamed(TrudaAppPages.googleCharge);
                  } else if (message.message == "gift") {
                    //打开首页hot
                    // Navigator.popUntil(
                    //     Get.context!,
                    //     (route) => ((Get.isDialogOpen != true &&
                    //             Get.isBottomSheetOpen != true &&
                    //             Get.isOverlaysOpen != true &&
                    //             Get.isSnackbarOpen != true &&
                    //             Get.currentRoute == TabRouter) ||
                    //         Get.currentRoute == TabRouter));
                    //
                    // Get.find<CblAppTabController>(
                    //         tag: CblAppTabController.TabControllerTag)
                    //     .indexChangeCallBack
                    //     ?.call(0);
                    Navigator.popUntil(
                        Get.context!,
                        (route) => ((Get.isDialogOpen != true &&
                                Get.isBottomSheetOpen != true &&
                                Get.isOverlaysOpen != true &&
                                Get.isSnackbarOpen != true &&
                                Get.currentRoute == TrudaAppPages.main) ||
                            Get.currentRoute == TrudaAppPages.main));
                  } else if (message.message == "call") {
                    Navigator.popUntil(
                        Get.context!,
                        (route) => ((Get.isDialogOpen != true &&
                                Get.isBottomSheetOpen != true &&
                                Get.isOverlaysOpen != true &&
                                Get.isSnackbarOpen != true &&
                                Get.currentRoute == TrudaAppPages.main) ||
                            Get.currentRoute == TrudaAppPages.main));
                    //打开首页hot
                    // Navigator.popUntil(
                    //     Get.context!,
                    //     (route) => ((Get.isDialogOpen != true &&
                    //             Get.isBottomSheetOpen != true &&
                    //             Get.isOverlaysOpen != true &&
                    //             Get.isSnackbarOpen != true &&
                    //             Get.currentRoute == TabRouter) ||
                    //         Get.currentRoute == TabRouter));
                    //
                    // Get.find<CblAppTabController>(
                    //         tag: CblAppTabController.TabControllerTag)
                    //     .indexChangeCallBack
                    //     ?.call(0);
                  } else if (message.message == "completeMaterial") {
                    Get.toNamed(TrudaAppPages.myInfo);
                  }
                }),
          },
          onWebViewCreated: (WebViewController controller) {
            //设置初始url
            _lastUrl = url;
            webViewController = controller;
          },
          onPageStarted: (url) {},
          onPageFinished: (url) {},
          navigationDelegate: (NavigationRequest request) async {
            // 不以http开头, 可能是要打开三方app,使用框架url_launcher试试
            if (!request.url.startsWith('http')) {
              TrudaLog.debug('blocking navigation to $request');
              // if (await canLaunch(request.url)) {
              //   launch(request.url);
              //   return NavigationDecision.prevent;
              // }
              // 这一步在未安装三方app时会抛异常，但网页结果是预想的
              // 未安装 dana:在输入手机号页面，gopay：在提示打开gopay页面
              if (await launch(request.url)) {
                return NavigationDecision.prevent;
              }
            }
            TrudaLog.debug('allowing navigation to $request');
            // return NavigationDecision.navigate;
            //已经被拦截过一次 表示referer已经放置 跳转通过
            if (_lastUrl == request.url) {
              return NavigationDecision.navigate;
            } else {
              //没有被拦截过 禁止跳转 放置referer 重新加载
              webViewController?.loadUrl(request.url, headers: {"referer": _lastUrl});
              _lastUrl = request.url;
              return NavigationDecision.prevent;
            }

          }),
    );
  }
}
