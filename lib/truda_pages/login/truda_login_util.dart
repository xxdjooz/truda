import '../../truda_common/truda_common_type.dart';

class TrudaLoginData {
  bool success = false;
  String? token;
  String id = '';
  String? nickname;
  String? cover;
}

class TrudaLoginUtil {
  void googleSignIn(TrudaCallback<TrudaLoginData> callback) async {
    callback.call(TrudaLoginData());
  }

  void facebookSignIn(TrudaCallback<TrudaLoginData> callback) async {
    callback.call(TrudaLoginData());
  }

  void appleSignIn(TrudaCallback<TrudaLoginData> callback) async {
    callback.call(TrudaLoginData());
  }
}

/// 这个注释上下是打包时要切换注释的，下面的是线上的
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:truda/truda_common/truda_common_type.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// import '../../truda_common/truda_language_key.dart';
// import '../../truda_services/truda_my_info_service.dart';
// import '../../truda_utils/newhita_loading.dart';
// import '../../truda_utils/newhita_log.dart';
//
// class TrudaLoginData {
//   bool success = false;
//   String? token;
//   String id = '';
//   String? nickname;
//   String? cover;
// }
//
// class TrudaLoginUtil {
//   GoogleSignIn? _googleSign;
//
//   void googleSignIn(TrudaCallback<NewHitaLoginData> callback) async {
//     var loginData = NewHitaLoginData();
//     _googleSign ??= GoogleSignIn();
//     try {
//       final isSigned = await _googleSign!.isSignedIn();
//       if (isSigned) {
//         await _googleSign!.signOut();
//       }
//       final result = await _googleSign!.signIn();
//       final googleAuth = await result?.authentication;
//
//       if (result?.id == null) {
//         NewHitaLoading.toast(TrudaLanguageKey.newhita_invoke_err.tr);
//         callback.call(loginData);
//       } else {
//         NewHitaLog.debug(googleAuth ?? 'googleSignIn err');
//         loginData.success = true;
//         loginData.token = googleAuth!.accessToken;
//         loginData.id = result!.id;
//         loginData.nickname = result.displayName;
//         loginData.cover = result.photoUrl;
//         callback.call(loginData);
//       }
//     } catch (error) {
//       if (GetPlatform.isAndroid) {
//         NewHitaLoading.toast(TrudaLanguageKey.newhita_invoke_err.tr);
//       } else {
//         NewHitaLoading.toast(TrudaLanguageKey.newhita_invoke_err.tr);
//       }
//       callback.call(loginData);
//     }
//   }
//
//   void facebookSignIn(TrudaCallback<NewHitaLoginData> callback) async {
//     var loginData = NewHitaLoginData();
//     // 后台配置的fb权限
//     String? permission = NewHitaMyInfoService.to.config?.fbPermission;
//     List<String>? list;
//     if (permission == null){
//       // fb接口默认这样的
//       list = const ['email', 'public_profile'];
//     } else if(permission.isEmpty){
//       list = [];
//     } else {
//       list = permission.split(',');
//     }
//     final LoginResult result = await FacebookAuth.instance.login(
//       permissions: list,
//     );
//
//     switch (result.status) {
//       case LoginStatus.success:
//         {
//           if (result.accessToken?.token == null) {
//             NewHitaLoading.toast(TrudaLanguageKey.newhita_invoke_err.tr);
//             callback.call(loginData);
//           } else {
//             loginData.success = true;
//             loginData.token = result.accessToken?.token;
//             callback.call(loginData);
//           }
//         }
//         break;
//       case LoginStatus.cancelled:
//         {
//           // BotToast.showText(text: "授权取消");
//           callback.call(loginData);
//         }
//         break;
//       default:
//         {
//           NewHitaLoading.toast(TrudaLanguageKey.newhita_invoke_err.tr);
//           callback.call(loginData);
//         }
//         break;
//     }
//   }
//
//   void appleSignIn(TrudaCallback<NewHitaLoginData> callback) async {
//     var loginData = NewHitaLoginData();
//     try {
//       final credential = await SignInWithApple.getAppleIDCredential(scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ]);
//       NewHitaLog.debug(credential);
//       String name =
//           (credential.givenName) ?? "" + (credential.familyName ?? "");
//       loginData.nickname = name;
//       loginData.token = credential.identityToken;
//       loginData.success = true;
//       callback.call(loginData);
//     } catch (e) {
//       NewHitaLog.debug(e);
//       if (e is SignInWithAppleAuthorizationException) {
//         switch (e.code) {
//           case AuthorizationErrorCode.canceled:
//             {}
//             break;
//           default:
//             {
//               NewHitaLoading.toast(TrudaLanguageKey.newhita_invoke_err.tr);
//             }
//             break;
//         }
//       }
//       callback.call(loginData);
//     }
//   }
// }
