import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_pages/login/account/truda_account_register_page.dart';

import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_dialogs/truda_dialog_visitor_tip.dart';
import '../../../truda_entities/truda_info_entity.dart';
import '../../../truda_entities/truda_login_entity.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_routes/newhita_pages.dart';
import '../../../truda_rtm/newhita_rtm_manager.dart';
import '../../../truda_services/newhita_my_info_service.dart';
import '../../../truda_services/newhita_storage_service.dart';
import '../../../truda_utils/newhita_loading.dart';
import '../../../truda_utils/newhita_log.dart';
import '../../../truda_widget/newhita_app_bar.dart';
import '../../some/newhita_web_page.dart';
import '../truda_login_agree_dialog.dart';
import '../truda_login_to_main_api.dart';

class TrudaAccountLoginPage extends StatefulWidget {
  const TrudaAccountLoginPage({Key? key}) : super(key: key);

  @override
  _TrudaAccountLoginPageState createState() =>
      _TrudaAccountLoginPageState();
}

class _TrudaAccountLoginPageState extends State<TrudaAccountLoginPage>
    with RouteAware {
  bool _checked = TrudaConstants.agree == true;
  TextEditingController _textEditingController =
      TextEditingController(text: "");
  TextEditingController _textEditingController2 =
      TextEditingController(text: "");
  FocusNode focusNode_1 = FocusNode();
  FocusNode focusNode_2 = FocusNode();

  @override
  void initState() {
    super.initState();
    // 存储的有账号密码直接去登录
    var visitorAccount = NewHitaStorageService.to.prefs
        .getString(TrudaConstants.keyVisitorAccount);
    if (visitorAccount?.isNotEmpty == true) {
      var list = visitorAccount!.split(TrudaConstants.visitorAccountSplit);
      if (list.isNotEmpty && list.length == 2) {
        setState(() {
          _textEditingController.text = list[0];
          _textEditingController2.text = list[1];
        });
      }
    }
  }
  // 密码可见
  bool _isObscure = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NewHitaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    setState(() {
      _checked = TrudaConstants.agree == true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    NewHitaAppPages.observer.unsubscribe(this);
  }

  void accountLogin() {
    if (_textEditingController.text.length <= 0) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_prompt_username.tr);
      return;
    }
    if (_textEditingController2.text.length <= 0) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_prompt_password.tr);
      return;
    }
    TrudaHttpUtil()
        .post<TrudaLogin>(TrudaHttpUrls.accountLogin,
            data: {
              "username": _textEditingController.text,
              "password": _textEditingController2.text,
            },
            showLoading: true)
        .then((value) {
      whenGotLoginToMain(value);
    });
  }
  void _getDetail() {
    NewHitaLoading.show();
    NewHitaLog.debug('NewHitaMeController refreshMe()');
    TrudaHttpUtil().post<TrudaInfoDetail>(TrudaHttpUrls.userInfoApi,
        errCallback: (err) {
          NewHitaLoading.dismiss();
        }).then((value) {
      NewHitaLoading.dismiss();
      //线上版本
      if (value.startBirthday == "fail" &&
          value.timeBirthday == false &&
          value.stateGender == 0) {
        TrudaConstants.isFakeMode = false;
        // 审核模式不要开启rtm
        NewHitaRtmManager.init().then((value) {
          NewHitaRtmManager.connectRTM();
        });
      } else {
        TrudaConstants.isFakeMode = true;
      }
      NewHitaMyInfoService.to.setMyDetail = value;

      // NewHitaRtmManager.connectRTM();
      // 先检查保存用户登录的账号密码
      TrudaVisitorTip.checkToShow().then((value) {
        Get.offAllNamed(NewHitaAppPages.main);
      });
    });
  }
  void visitorSignIn() {
    // 存储的有账号密码直接去登录
    var visitorAccount = NewHitaStorageService.to.prefs
        .getString(TrudaConstants.keyVisitorAccount);
    if (visitorAccount?.isNotEmpty == true) {
      var list = visitorAccount!.split(TrudaConstants.visitorAccountSplit);
      if (list.isNotEmpty && list.length == 2) {
        TrudaHttpUtil().post<TrudaLogin>(
          TrudaHttpUrls.accountLogin,
          data: {
            "username": list[0],
            "password": list[1],
          },
          showLoading: true,
          errCallback: (e) {
            _newVisitor();
          },
        ).then((value) {
          NewHitaMyInfoService.to.setLoginData(value);
          _getDetail();
        });
        return;
      }
    }
    _newVisitor();
  }

  final Random _rnd = Random();

  void _newVisitor() {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    const nums = '1234567890';
    // 密码自己做一个
    final pw = _getRandomString(4, chars) + _getRandomString(4, nums);
    TrudaHttpUtil()
        .post<TrudaLogin>(TrudaHttpUrls.appRegister,
        data: {
          "password": pw,
          "attribution": '',
        },
        showLoading: true)
        .then((value) {
      NewHitaMyInfoService.to.setLoginData(value);
      _getDetail();

      NewHitaStorageService.to.prefs.setString(
          TrudaConstants.keyVisitorAccount,
          '${value.user!.username}${TrudaConstants.visitorAccountSplit}$pw');
    });
  }

  String _getRandomString(int length, String str) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => str.codeUnitAt(_rnd.nextInt(str.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffD8ABFF),
          Colors.white,
        ],
      )),
      child: Scaffold(
          appBar: NewHitaAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: Text(TrudaLanguageKey.newhita_login_username.tr),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: TrudaColors.transparent,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 75, 15, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/newhita_login_logo.png',
                    width: 125,
                    height: 125,
                  ),
                  Container(
                    height: 40,
                  ),
                  // Text(TrudaLanguageKey.newhita_login_account.tr,
                  //     style:
                  //         TextStyle(color: TrudaColors.textColor333, fontSize: 12)),
                  GestureDetector(
                    onTap: () {
                      if (focusNode_2.hasFocus) {
                        focusNode_2.unfocus();
                      }
                      if (!focusNode_1.hasFocus) {
                        focusNode_1.requestFocus();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: TextField(
                        controller: _textEditingController,
                        // maxLength: 15,
                        style: TextStyle(color: TrudaColors.textColor000),
                        decoration: InputDecoration(
                          hintText: TrudaLanguageKey.newhita_prompt_username.tr,
                          hintStyle: const TextStyle(
                            color: TrudaColors.textColor999,
                          ),
                          suffixIcon: Image.asset('assets/images/newhita_account_name.png'),
                          border: InputBorder.none,
                        ),
                        focusNode: focusNode_1,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  // Text(TrudaLanguageKey.newhita_login_password.tr,
                  //     style:
                  //         TextStyle(color: TrudaColors.textColor333, fontSize: 12)),
                  GestureDetector(
                    onTap: () {
                      if (focusNode_1.hasFocus) {
                        focusNode_1.unfocus();
                      }
                      if (!focusNode_2.hasFocus) {
                        focusNode_2.requestFocus();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      width: double.infinity,
                      child: TextField(
                        controller: _textEditingController2,
                        // maxLength: 15,
                        style: TextStyle(
                          color: TrudaColors.textColor000,
                        ),
                        decoration: InputDecoration(
                          hintText: TrudaLanguageKey.newhita_prompt_password.tr,
                          hintStyle: TextStyle(color: TrudaColors.textColor999),
                          suffixIcon: GestureDetector(
                              child: _isObscure
                                  ? Image.asset('assets/images/newhita_account_eye_c.png')
                                  : Image.asset('assets/images/newhita_account_eye_o.png'),
                              onTap: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          border: InputBorder.none,
                        ),
                        focusNode: focusNode_2,
                        obscureText: _isObscure,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                          margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              TrudaColors.baseColorGradient1,
                              TrudaColors.baseColorGradient2,
                            ]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: GestureDetector(
                              onTap: () {
                                if (!_checked) {
                                  showAgreeDialog(() {
                                    accountLogin();
                                  });
                                  return;
                                }
                                accountLogin();
                              }, //
                              child: Center(
                                child: Text(
                                  TrudaLanguageKey.newhita_login_username.tr,
                                  style: TextStyle(
                                    color: TrudaColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                          margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
                          // decoration: BoxDecoration(
                          //     borderRadius: const BorderRadius.all(
                          //       Radius.circular(40.0),
                          //     ),
                          //     color: HexColor("#FF6CB2")),
                          child: GestureDetector(
                              onTap: () {
                                visitorSignIn();
                              }, //
                              child: Text(
                                TrudaLanguageKey.newhita_login_register.tr,
                                style: TextStyle(
                                  color: TrudaColors.baseColorTheme,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height - 600),
                  Container(
                    margin: EdgeInsetsDirectional.only(end: 41, top: 0),
                    child: Text.rich(
                      TextSpan(children: [
                        WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _checked = !_checked;
                                });
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.only(
                                  start: 22,
                                  end: 5,
                                  top: 9,
                                  bottom: 7,
                                ),
                                color: Colors.transparent,
                                child: _checked == true
                                    ? Image.asset(
                                        'assets/images/newhita_base_checked.png',
                                      )
                                    : Image.asset(
                                        'assets/images/newhita_base_check.png',
                                      ),
                              ),
                            ),
                            alignment: PlaceholderAlignment.middle),
                        const TextSpan(text: ' '),
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
                                        TrudaConstants.privacyPolicy, true);
                                  }),
                            const TextSpan(text: ' '),
                            TextSpan(
                                text:
                                    TrudaLanguageKey.newhita_login_agree_2.tr),
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
                                text:
                                    TrudaLanguageKey.newhita_login_agree_3.tr),
                          ],
                          style: TextStyle(
                            color: TrudaColors.textColor333,
                            fontSize: 12,
                          ),
                        )
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
