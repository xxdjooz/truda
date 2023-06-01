import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/login/account/newhita_account_login_page.dart';
import 'package:truda/truda_pages/splash/newhita_splash_page.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_facebook_util.dart';

import '../../truda_common/truda_colors.dart';
import '../some/newhita_web_page.dart';
import 'newhita_login_agree_dialog.dart';
import 'newhita_login_controller.dart';

class NewHitaLoginPage extends StatefulWidget {
  NewHitaLoginPage({Key? key}) : super(key: key);

  @override
  State<NewHitaLoginPage> createState() => _NewHitaLoginPageState();
}

class _NewHitaLoginPageState extends State<NewHitaLoginPage> {
  final _checked = false.obs;
  final scrollController = ScrollController();
  late double picHeight;
  final isIosFakeMode = TrudaConstants.appMode == 2;

  // 1057628
  final TextEditingController _textEditingController = TextEditingController(
      text: NewHitaStorageService.to.prefs.getString("test_google_id") ?? "");

  @override
  void initState() {
    super.initState();

    if (!isIosFakeMode) {
      Timer.run(() {
        _scrollBg();
      });
    }
  }

  void _scrollBg() {
    // Timer.periodic(Duration(milliseconds: 32), (timer) {
    //   scrollController.jumpTo(scrollController.offset + 2);
    // });
    scrollController.jumpTo(0);
    scrollController
        .animateTo(
      picHeight,
      duration: const Duration(seconds: 10),
      curve: Curves.linear,
    )
        .then((value) {
      if (mounted) {
        _scrollBg();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    picHeight = context.width * 1624 / 750;
    return GetBuilder<NewHitaLoginController>(builder: (controller) {
      return Scaffold(
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/newhita_login_bg.webp'),
          //     fit: BoxFit.fitWidth,
          //   ),
          // ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: isIosFakeMode
                      ? Image.asset(
                          'assets/newhita_login_ios.webp',
                          fit: BoxFit.fill,
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: 3,
                          itemExtent: picHeight,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.asset(
                              'assets/images_sized/newhita_login_bg.webp',
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                ),
              ),
              Container(
                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: isIosFakeMode
                  //       ? [
                  //           Colors.transparent,
                  //           Colors.transparent,
                  //         ]
                  //       : [
                  //           Colors.black54,
                  //           Colors.black87,
                  //         ],
                  // )),
                  ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            child: Image.asset(
                              'assets/images/newhita_login_logo.png',
                              width: 125,
                              height: 125,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onDoubleTap: () {
                            getFacebookKey();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          'assets/images/newhita_login_name.png',
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Text(
                        //   NewHitaAppInfoService.to.version,
                        //   style: TextStyle(color: Colors.white70),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        _TestLogin(controller),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      if (GetPlatform.isIOS) _appleLogin(controller),
                      GestureDetector(
                        onTap: () {
                          if (TrudaConstants.isTestMode) {
                            return;
                          }
                          if (!_checked.value) {
                            showAgreeDialog(() {
                              _checked.value = true;
                              controller.googleSignIn();
                            });
                            return;
                          }
                          controller.googleSignIn();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          margin: EdgeInsetsDirectional.only(
                              start: 30, end: 40, bottom: 10),
                          decoration: BoxDecoration(
                            color: TrudaColors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              PositionedDirectional(
                                start: 15,
                                child: Image.asset(
                                  'assets/images/newhita_login_google.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              Text(
                                TrudaLanguageKey.newhita_google_sign.tr,
                                style: TextStyle(
                                    color: TrudaColors.textColor333,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (NewHitaMyInfoService.to.config?.showFbLogin == true)
                        GestureDetector(
                          onTap: () {
                            if (TrudaConstants.isTestMode) {
                              return;
                            }
                            if (!_checked.value) {
                              showAgreeDialog(() {
                                _checked.value = true;
                                controller.facebookSignIn();
                              });
                              return;
                            }
                            controller.facebookSignIn();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            margin: EdgeInsetsDirectional.only(
                                start: 30, end: 30, bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xff3B5998),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                PositionedDirectional(
                                  start: 15,
                                  child: Image.asset(
                                    'assets/images/newhita_login_facebook.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                Text(
                                  TrudaLanguageKey.newhita_fb_sign.tr,
                                  style: TextStyle(
                                      color: TrudaColors.white, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                      if (!GetPlatform.isIOS) _accountLogin(),
                      if (!GetPlatform.isIOS) _visitorLogin(controller),
                      Container(
                        margin: EdgeInsetsDirectional.only(end: 41, top: 40),
                        child: Text.rich(
                          TextSpan(children: [
                            WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    _checked.value = !_checked.value;
                                  },
                                  child: Container(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: 22,
                                      end: 5,
                                      top: 9,
                                      bottom: 7,
                                    ),
                                    color: Colors.transparent,
                                    child: Obx(() {
                                      return _checked.value == true
                                          ? Image.asset(
                                              'assets/images/newhita_base_checked.png',
                                            )
                                          : Image.asset(
                                              'assets/images/newhita_base_check.png',
                                            );
                                    }),
                                  ),
                                ),
                                alignment: PlaceholderAlignment.middle),
                            TextSpan(
                              text: TrudaLanguageKey.newhita_login_agree_1.tr,
                              children: [
                                const TextSpan(text: ' '),
                                TextSpan(
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    text: TrudaLanguageKey
                                        .newhita_login_privacy_policy.tr,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NewHitaWebPage.startMe(
                                            TrudaConstants.privacyPolicy,
                                            true);
                                      }),
                                const TextSpan(text: ' '),
                                TextSpan(
                                    text: TrudaLanguageKey
                                        .newhita_login_agree_2.tr),
                                const TextSpan(text: ' '),
                                TextSpan(
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    text: TrudaLanguageKey
                                        .newhita_login_terms_service.tr,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NewHitaWebPage.startMe(
                                            TrudaConstants.agreement, true);
                                      }),
                                const TextSpan(text: ' '),
                                TextSpan(
                                    text: TrudaLanguageKey
                                        .newhita_login_agree_3.tr),
                              ],
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            )
                          ]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 登录
  Widget _appleLogin(NewHitaLoginController controller) {
    return GestureDetector(
      onTap: () {
        // if (NewHitaConstants.isTestMode) {
        //   return;
        // }
        if (!_checked.value) {
          showAgreeDialog(() {
            _checked.value = true;
            controller.appleSignIn();
          });
          return;
        }
        controller.appleSignIn();
      },
      child: Container(
        width: double.infinity,
        height: 48,
        margin: EdgeInsetsDirectional.only(start: 40, end: 40, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          // image: DecorationImage(
          //   image: AssetImage(
          //     'assets/images/newhita_login_bg_google.png',
          //   ),
          //   fit: BoxFit.fill,
          // ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            PositionedDirectional(
              start: 20,
              child: Image.asset(
                'assets/images/newhita_login_apple.png',
                color: Colors.black,
                width: 30,
                height: 30,
              ),
            ),
            Text(
              TrudaLanguageKey.newhita_apple_sign.tr,
              style: TextStyle(color: Colors.black, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  /// 账号登录
  Widget _accountLogin() {
    return GetPlatform.isIOS == true
        ? const SizedBox()
        : GestureDetector(
            onTap: () {
              Get.to(const NewHitaAccountLoginPage());
            },
            child: Container(
              width: double.infinity,
              height: 48,
              margin:
                  EdgeInsetsDirectional.only(start: 30, end: 30, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  PositionedDirectional(
                    start: 15,
                    child: Image.asset(
                      'assets/images/newhita_login_account.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Text(
                    TrudaLanguageKey.newhita_login_username.tr,
                    style: TextStyle(color: TrudaColors.white, fontSize: 14),
                  )
                ],
              ),
            ),
          );
  }

  /// 快捷登录
  Widget _visitorLogin(NewHitaLoginController controller) {
    return GetPlatform.isIOS == true
        ? const SizedBox()
        : GestureDetector(
            onTap: () {
              if (!_checked.value) {
                showAgreeDialog(() {
                  _checked.value = true;
                  controller.visitorSignIn();
                });
                return;
              }
              controller.visitorSignIn();
            },
            child: Container(
              width: double.infinity,
              height: 48,
              margin:
                  EdgeInsetsDirectional.only(start: 30, end: 30, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  PositionedDirectional(
                    start: 15,
                    child: Image.asset(
                      'assets/images/newhita_login_visitor.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Text(
                    TrudaLanguageKey.newhita_visitor_login.tr,
                    style: TextStyle(color: TrudaColors.white, fontSize: 14),
                  )
                ],
              ),
            ),
          );
  }

  Widget _TestLogin(NewHitaLoginController controller) {
    String mode = "线上环境";
    switch (NewHitaStorageService.to.getTestStyle) {
      case 0:
        mode = "线上环境";
        break;
      case 1:
        mode = "预发布环境";
        break;
      case 2:
        mode = "测试环境";
        break;
      default:
        mode = "线上环境";
        break;
    }
    return !TrudaConstants.haveTestLogin
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: TrudaColors.white,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(start: 30, end: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(mode),
                      ),
                      IconButton(
                          onPressed: () async {
                            showModeChange();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.black38,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                ),
                Container(
                  padding: const EdgeInsetsDirectional.only(start: 30, end: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "输入一串随机数字",
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            if (_textEditingController.text.length <= 0) {
                              return;
                            }
                            String str = _textEditingController.text;
                            // if (!_checked) {
                            //   showAgreeDialog(() {
                            //     loginTestGoogle(str);
                            //   });
                            //   return;
                            // }
                            controller.testLoginGoogle(str);
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  //  切换环境
  void showModeChange() {
    Get.bottomSheet(
      Container(
          decoration: BoxDecoration(
              color: Color(0xFFF5F3FF),
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20), topEnd: Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  NewHitaStorageService.to.saveTestStyle(0);
                  Get.offAll(NewHitaSplashPage());
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                      color: TrudaColors.white,
                      borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(20),
                          topEnd: Radius.circular(20))),
                  child: Text(
                    "线上环境",
                    style: TextStyle(
                        color: TrudaColors.textColor333, fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  NewHitaStorageService.to.saveTestStyle(1);
                  Get.offAll(NewHitaSplashPage());
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: TrudaColors.white,
                  ),
                  child: Text(
                    "预发布环境",
                    style: TextStyle(
                        color: TrudaColors.textColor333, fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  NewHitaStorageService.to.saveTestStyle(2);
                  Get.offAll(NewHitaSplashPage());
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: TrudaColors.white,
                  ),
                  child: Text(
                    "测试环境",
                    style: TextStyle(
                        color: TrudaColors.textColor333, fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(top: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: TrudaColors.white,
                  ),
                  child: Text(
                    TrudaLanguageKey.newhita_base_cancel.tr,
                    style: TextStyle(
                        color: TrudaColors.textColor333, fontSize: 16),
                  ),
                ),
              ),
            ],
          )),
      barrierColor: Colors.transparent,
    );
  }
}
