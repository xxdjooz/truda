import 'dart:math';

import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_pages/login/truda_login_to_main_api.dart';
import 'package:truda/truda_pages/login/truda_login_util.dart';
import 'package:truda/truda_utils/truda_loading.dart';

import '../../truda_common/truda_constants.dart';
import '../../truda_entities/truda_login_entity.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_services/truda_storage_service.dart';
import '../../truda_utils/truda_check_app_update.dart';
import '../../truda_utils/truda_string_util.dart';

class TrudaLoginController extends GetxController {
  bool _logining = false;

  // 用来获取随机头像 ，后端会拼上域名
  static const _heads = [
    "users/awss3/manage/upload/default1.png",
    "users/awss3/manage/upload/default2.png",
    "users/awss3/manage/upload/default3.png",
    "users/awss3/manage/upload/default4.png",
    "users/awss3/manage/upload/default5.png",
  ];
  TrudaLoginUtil loginUtil = TrudaLoginUtil();

  // 用来获取随机名字
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  final Random _rnd = Random();

  /// 测试登录
  void testLoginGoogle(String str) {
    var config =
        TrudaHttpUtil().post<TrudaLogin>(TrudaHttpUrls.googleLoginApi, data: {
      "id": str,
      "cover": _heads[_rnd.nextInt(5)],
      "nickname": "newhita_${getRandomString(5, _chars)}",
    }, errCallback: (err) {
      TrudaLoading.toast(err.toString());
    }, showLoading: true);
    config.then((value) {
      TrudaStorageService.to.prefs.setString("test_google_id", str);
      whenGotLoginToMain(value);
    });
  }

  @override
  void onReady() {
    super.onReady();
    TrudaCheckAppUpdate.check();
  }

  void googleSignIn() {
    if (_logining) {
      return;
    }
    _logining = true;
    loginUtil.googleSignIn((callback) {
      if (callback.success) {
        _loginGoogle(
            callback.token, callback.id, callback.nickname, callback.cover);
      }
      _logining = false;
    });
  }

  /// google登录
  void _loginGoogle(String? token, String id, String? nickname, String? cover) {
    var config =
        TrudaHttpUtil().post<TrudaLogin>(TrudaHttpUrls.googleLoginApi, data: {
      "id": id,
      "cover": cover ?? _heads[_rnd.nextInt(5)],
      "token": token ?? "",
      "nickname": nickname ?? "newhita_${getRandomString(5, _chars)}",
    }, errCallback: (err) {
      TrudaLoading.toast(err.toString());
    }, doneCallback: (success, re) {
      _logining = false;
    }, showLoading: true);
    config.then((value) {
      whenGotLoginToMain(value);
    });
  }

  void facebookSignIn() async {
    _logining = true;
    loginUtil.facebookSignIn((callback) {
      if (callback.success) {
        _loginFacebook(callback.token);
      }
      _logining = false;
    });
  }

  /// google登录
  void _loginFacebook(String? accessToken) {
    var config =
        TrudaHttpUtil().post<TrudaLogin>(TrudaHttpUrls.facebookLoginApi, data: {
      "accessToken": accessToken ?? "",
    }, errCallback: (err) {
      TrudaLoading.toast(err.toString());
    }, doneCallback: (success, re) {
      _logining = false;
    }, showLoading: true);
    config.then((value) {
      whenGotLoginToMain(value);
    });
  }

  void appleSignIn() async {
    _logining = true;
    loginUtil.appleSignIn((callback) {
      if (callback.success) {
        _loginApple(callback.token, callback.nickname);
      }
      _logining = false;
    });
  }

  /// Apple登录
  void _loginApple(String? token, String? nickname) {
    var config =
    TrudaHttpUtil().post<TrudaLogin>(TrudaHttpUrls.appleLoginApi, data: {
      "identityToken": token ?? "",
      "nickname": nickname ?? "gora_${getRandomString(5, _chars)}",
    }, errCallback: (err) {
      TrudaLoading.toast(err.toString());
    }, doneCallback: (success, re) {
      _logining = false;
    }, showLoading: true);
    config.then((value) {
      whenGotLoginToMain(value);
    });
  }


  void visitorSignIn() {
    // 存储的有账号密码直接去登录
    var visitorAccount = TrudaStorageService.to.prefs
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
          whenGotLoginToMain(value);
        });
        return;
      }
    }
    _newVisitor();
  }

  void _newVisitor() {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    const nums = '1234567890';
    // 密码自己做一个
    final pw = getRandomString(4, chars) + getRandomString(4, nums);
    TrudaHttpUtil()
        .post<TrudaLogin>(TrudaHttpUrls.appRegister,
        data: {
          "password": pw,
          "attribution": '',
        },
        showLoading: true)
        .then((value) {
      whenGotLoginToMain(value);

      TrudaStorageService.to.prefs.setString(
          TrudaConstants.keyVisitorAccount,
          '${value.user!.username}${TrudaConstants.visitorAccountSplit}$pw');
    });
  }
}
