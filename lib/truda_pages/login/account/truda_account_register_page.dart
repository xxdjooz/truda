import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_routes/truda_pages.dart';

import '../../../truda_entities/truda_login_entity.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_utils/truda_loading.dart';
import '../../../truda_widget/newhita_app_bar.dart';
import '../../some/truda_web_page.dart';
import '../truda_login_agree_dialog.dart';
import '../truda_login_to_main_api.dart';

class TrudaAccountRegisterPage extends StatefulWidget {
  const TrudaAccountRegisterPage({Key? key}) : super(key: key);

  @override
  _TrudaAccountRegisterPageState createState() =>
      _TrudaAccountRegisterPageState();
}

class _TrudaAccountRegisterPageState extends State<TrudaAccountRegisterPage>
    with RouteAware {
  bool _checked = TrudaConstants.agree == true;
  TextEditingController _textEditingController =
      TextEditingController(text: "");
  TextEditingController _textEditingController2 =
      TextEditingController(text: "");
  FocusNode focusNode_1 = FocusNode();
  FocusNode focusNode_2 = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TrudaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
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
    TrudaAppPages.observer.unsubscribe(this);
  }

  void accountRegister() {
    if (_textEditingController.text.length <= 0) {
      TrudaLoading.toast(TrudaLanguageKey.newhita_prompt_username.tr);
      return;
    }
    if (_textEditingController2.text.length <= 0) {
      TrudaLoading.toast(TrudaLanguageKey.newhita_prompt_password.tr);
      return;
    }
    if (_textEditingController2.text.length <= 5) {
      TrudaLoading.toast(TrudaLanguageKey.newhita_invalid_password.tr);
      return;
    }
    // NewHitaHttpManager.postRequest<NewHitaNetCodeEntity>(
    //     NewHitaHttpUrls.auditModeRegister, (localUserEntity) async {
    //   if (localUserEntity is NewHitaNetCodeEntity) {
    //     if (localUserEntity.code == 0) {
    //       accountLogin();
    //     } else {
    //       NewHitaLoading.toast(
    //           localUserEntity.message ?? TrudaLanguageKey.newhita_err_unknown);
    //     }
    //   }
    // }, (error) {
    //   ShowError();
    // }, {
    //   "username": _textEditingController.text,
    //   "password": _textEditingController2.text,
    // }, true);

    TrudaHttpUtil()
        .post<void>(TrudaHttpUrls.auditModeRegister,
            data: {
              "username": _textEditingController.text,
              "password": _textEditingController2.text,
            },
            showLoading: true)
        .then((value) {
      accountLogin();
    });
  }

  void accountLogin() {
    if (_textEditingController.text.length <= 0) {
      return;
    }
    if (_textEditingController2.text.length <= 0) {
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
            title: Text(TrudaLanguageKey.newhita_login_username_register.tr),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: TrudaColors.transparent,
          body: Padding(
            padding: EdgeInsets.fromLTRB(15, 75, 15, 45),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: TextField(
                      controller: _textEditingController,
                      // maxLength: 15,
                      style: TextStyle(color: TrudaColors.textColor000),
                      decoration: InputDecoration.collapsed(
                        hintText: TrudaLanguageKey.newhita_prompt_username.tr,
                        hintStyle: const TextStyle(
                          color: TrudaColors.textColor999,
                        ),
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
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    width: double.infinity,
                    child: TextField(
                      controller: _textEditingController2,
                      // maxLength: 15,
                      style: TextStyle(
                        color: TrudaColors.textColor000,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: TrudaLanguageKey.newhita_prompt_password.tr,
                        hintStyle: TextStyle(color: TrudaColors.textColor999),
                      ),
                      focusNode: focusNode_2,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
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
                                  accountRegister();
                                });
                                return;
                              }
                              accountRegister();
                            }, //
                            child: Center(
                              child: Text(
                                TrudaLanguageKey.newhita_login_register_and_login.tr,
                                style: const TextStyle(
                                    color: TrudaColors.white, fontSize: 20),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: Text("")),
                Container(
                  margin: EdgeInsetsDirectional.only(end: 41, top: 40),
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
                      TextSpan(
                        text: TrudaLanguageKey.newhita_login_agree_1.tr,
                        children: [
                          const TextSpan(text: ' '),
                          TextSpan(
                              style:
                                  TextStyle(decoration: TextDecoration.underline),
                              text: TrudaLanguageKey.newhita_login_privacy_policy.tr,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  TrudaWebPage.startMe(
                                      TrudaConstants.privacyPolicy, true);
                                }),
                          const TextSpan(text: ' '),
                          TextSpan(text: TrudaLanguageKey.newhita_login_agree_2.tr),
                          const TextSpan(text: ' '),
                          TextSpan(
                              style:
                                  TextStyle(decoration: TextDecoration.underline),
                              text: TrudaLanguageKey.newhita_login_terms_service.tr,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  TrudaWebPage.startMe(
                                      TrudaConstants.agreement, true);
                                }),
                          const TextSpan(text: ' '),
                          TextSpan(text: TrudaLanguageKey.newhita_login_agree_3.tr),
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
          )),
    );
  }
}
