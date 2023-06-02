import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_constants.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import '../truda_pages/login/truda_login_util.dart';
import '../truda_services/truda_my_info_service.dart';
import '../truda_utils/truda_loading.dart';
import '../truda_widget/truda_gradient_boder.dart';

//提醒绑定弹窗
class TrudaBindTip extends StatefulWidget {
  static Future checkToShow() async {
    if (TrudaConstants.isFakeMode) {
      return;
    }
    if (TrudaMyInfoService.to.myDetail?.boundGoogle != 0) {
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    await Get.dialog(TrudaBindTip());
  }

  @override
  _TrudaBindTipState createState() => _TrudaBindTipState();
}

class _TrudaBindTipState extends State<TrudaBindTip> {
  @override
  void initState() {
    super.initState();
  }

  bool _logining = false;
  TrudaLoginUtil loginUtil = TrudaLoginUtil();

  void googleSignIn() {
    if (_logining) {
      return;
    }
    _logining = true;
    loginUtil.googleSignIn((callback) {
      if (callback.success) {
        _loginGoogle(
            callback.token, callback.id, callback.nickname, callback.cover);
      } else {
        TrudaLoading.toast(TrudaLanguageKey.newhita_err_unknown.tr);
      }
      _logining = false;
    });
  }

  /// google登录
  void _loginGoogle(String? token, String id, String? nickname, String? cover) {
    var config =
        TrudaHttpUtil().post<void>(TrudaHttpUrls.bindGoogle, data: {
      "id": id,
      "cover": cover ?? '',
      "token": token ?? '',
      "nickname": nickname ?? '',
    }, errCallback: (err) {
      TrudaLoading.toast(err.toString());
    }, doneCallback: (success, re) {
      _logining = false;
    }, showLoading: true);
    config.then((value) {
      TrudaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      Get.back();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          TrudaGradientBoder(
            border: 3,
            colors: const [
              TrudaColors.baseColorGradient1,
              TrudaColors.baseColorGradient2,
            ],
            borderRadius: 20,
            colorSolid: Colors.white,
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  TrudaLanguageKey.newhita_visitor_disclaimer.tr,
                  style: TextStyle(color: TrudaColors.textColor333, fontSize: 20, fontWeight: FontWeight.bold,),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  TrudaLanguageKey.newhita_visitor_disclaimer_content.tr,
                  style: TextStyle(color: TrudaColors.textColor333, fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    googleSignIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      // 渐变色
                        gradient: const LinearGradient(colors: [
                          TrudaColors.baseColorGradient1,
                          TrudaColors.baseColorGradient2,
                        ]),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      TrudaLanguageKey.newhita_visitor_bind_google.tr,
                      style: TextStyle(
                          color: TrudaColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    TrudaLanguageKey.newhita_base_confirm.tr,
                    style: TextStyle(color: TrudaColors.textColor333, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images_sized/newhita_bind_google.png",
            fit: BoxFit.fill,
            width: 115,
            height: 115,
          ),
        ],
      ),
    );
  }
}
