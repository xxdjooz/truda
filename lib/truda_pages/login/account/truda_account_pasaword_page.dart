import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:truda/truda_widget/newhita_app_bar.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_routes/newhita_pages.dart';
import '../../../truda_services/newhita_my_info_service.dart';
import '../../../truda_services/newhita_storage_service.dart';
import '../../../truda_utils/newhita_loading.dart';

// 修改密码
class TrudaAccountPasswordPage extends StatefulWidget {
  const TrudaAccountPasswordPage({Key? key}) : super(key: key);

  @override
  _TrudaAccountPasswordPageState createState() =>
      _TrudaAccountPasswordPageState();
}

class _TrudaAccountPasswordPageState
    extends State<TrudaAccountPasswordPage> with RouteAware {
  TextEditingController _textEditingController =
      TextEditingController(text: "");
  TextEditingController _textEditingController2 =
      TextEditingController(text: "");
  TextEditingController _textEditingController3 =
      TextEditingController(text: "");

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
          _textEditingController.text = list[1];
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NewHitaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  @override
  void dispose() {
    super.dispose();
    NewHitaAppPages.observer.unsubscribe(this);
  }

  void accountLogin() {
    if (_textEditingController.text.length <= 0) {
      NewHitaLoading.toast(
        TrudaLanguageKey.newhita_prompt_password.tr,
        position: EasyLoadingToastPosition.top,
      );
      return;
    }
    if (_textEditingController2.text.length <= 0) {
      NewHitaLoading.toast(
        TrudaLanguageKey.newhita_visitor_pw_enter.tr,
        position: EasyLoadingToastPosition.top,
      );
      return;
    }
    if (_textEditingController3.text.length <= 0) {
      NewHitaLoading.toast(
        TrudaLanguageKey.newhita_visitor_pw_enter_again.tr,
        position: EasyLoadingToastPosition.top,
      );
      return;
    }
    if (_textEditingController3.text.length !=
        _textEditingController2.text.length) {
      NewHitaLoading.toast(
        TrudaLanguageKey.newhita_visitor_pw_different.tr,
        position: EasyLoadingToastPosition.top,
      );
      return;
    }
    final oriPassword = _textEditingController.text;
    final newPassword = _textEditingController2.text;

    TrudaHttpUtil()
        .post<void>(TrudaHttpUrls.changePassword,
            data: {
              "oriPassword": oriPassword,
              "newPassword": newPassword,
            },
            showLoading: true)
        .then((value) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      Get.back();
      // 修改本地存储的密码
      var visitorAccount = NewHitaStorageService.to.prefs
          .getString(TrudaConstants.keyVisitorAccount);
      if (visitorAccount?.isNotEmpty == true) {
        var list = visitorAccount!.split(TrudaConstants.visitorAccountSplit);
        if (list.isNotEmpty && list.length == 2) {
          final myUserName = NewHitaMyInfoService.to.myDetail?.username;
          if (list[0] == myUserName) {
            NewHitaStorageService.to.prefs.setString(
                TrudaConstants.keyVisitorAccount,
                '$myUserName${TrudaConstants.visitorAccountSplit}$newPassword');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NewHitaAppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            TrudaLanguageKey.newhita_visitor_pw_change.tr,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: Padding(
          padding: EdgeInsets.fromLTRB(15, 75, 15, 45),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
              ),
              // Text(TrudaLanguageKey.newhita_login_account.tr,
              //     style: TextStyle(color: Colors.white, fontSize: 12)),
              CustomRoundedTextField(
                controller: _textEditingController,
                isPassword: true,
                hintText: TrudaLanguageKey.newhita_prompt_password.tr,
              ),
              // Text(TrudaLanguageKey.newhita_login_account.tr,
              //     style: TextStyle(color: Colors.white, fontSize: 12)),
              Container(
                height: 10,
              ),
              CustomRoundedTextField(
                controller: _textEditingController2,
                isPassword: true,
                hintText: TrudaLanguageKey.newhita_visitor_pw_enter.tr,
              ),
              // Text(TrudaLanguageKey.newhita_login_password.tr,
              //     style: TextStyle(color: Colors.white, fontSize: 12)),
              CustomRoundedTextField(
                controller: _textEditingController3,
                isPassword: true,
                hintText:
                    TrudaLanguageKey.newhita_visitor_pw_enter_again.tr,
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            TrudaColors.baseColorGradient1,
                            TrudaColors.baseColorGradient2,
                          ],
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/newhita_base_button_big.webp'),
                        ),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            accountLogin();
                          }, //
                          child: Center(
                            child: Text(
                              TrudaLanguageKey.newhita_base_confirm.tr,
                              style:
                                  TextStyle(color: TrudaColors.white, fontSize: 20),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(child: Text("")),
            ],
          ),
        ));
  }
}

class CustomRoundedTextField extends StatefulWidget {
  final label;
  final onChange;
  final isPassword;
  final bottomPadding;
  final textCapitalization;
  final inputType;
  final controller;
  final iconData;
  final hintText;

  CustomRoundedTextField(
      {this.iconData,
      this.controller,
      this.inputType = TextInputType.text,
      this.label,
      this.onChange,
      this.isPassword = false,
      this.bottomPadding = 16,
      this.hintText = '',
      this.textCapitalization = TextCapitalization.none});

  @override
  _CustomRoundedTextFieldState createState() => _CustomRoundedTextFieldState();
}

class _CustomRoundedTextFieldState extends State<CustomRoundedTextField> {
  bool _showPwd = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        textCapitalization: widget.textCapitalization,
        obscureText: widget.isPassword && !_showPwd,
        style: TextStyle(fontSize: 15, color: TrudaColors.textColor333),
        maxLength: 15,
        decoration: InputDecoration(
          counterText: '',
          hintText: widget.hintText,
          hintStyle: TextStyle(color: TrudaColors.textColor666),
          fillColor: Colors.white12,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: widget.label,
          labelStyle: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          suffixStyle: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _showPwd
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: TrudaColors.baseColorTheme,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPwd = !_showPwd;
                    });
                  })
              : null,
        ),
        onChanged: widget.onChange,
      ),
    );
  }
}
