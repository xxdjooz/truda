import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_language_key.dart';
import 'truda_facebook_util.dart';
import 'truda_log.dart';

/// 被叫页面初始化完成后，先调askCallPermission提示需要权限
/// 点击拨打按钮或者被叫页面的接听按钮，先调checkCallPermission检查权限
class TrudaPermissionHandler {
  /// 每次打开app时检查下这个通知权限
  static void checkNotificationPermission() {
    // 这个通知权限一般默认有
    Permission.notification.request().then((value) {
      TrudaLog.debug(value);
      if (value != PermissionStatus.granted) {
        showPermissionNotify();
      }
    });
  }

  /// 打开被叫页面时先调这个检查权限，
  static Future<bool> askCallPermission({Function? cancelPermission}) async {
    // Map status = await [Permission.camera, Permission.microphone].request();
    // 这里有个坑，永久拒绝时，
    // Permission.camera.status这样得到的是denied，
    // 而不是permanentlyDenied，
    // request()方法返回的结果才能知道是permanentlyDenied
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    List<Permission> permissions = [];
    if (cameraStatus != PermissionStatus.granted) {
      permissions.add(Permission.camera);
    }
    if (microphoneStatus != PermissionStatus.granted) {
      permissions.add(Permission.microphone);
    }
    if (permissions.isNotEmpty) {
      showAskPermissionAlert(permissions, cancelPermission);
      return false;
    }
    return true;
  }

  /// 点击拨打按钮或者点击接听时先调这个，在.then((value){})的value为true时再真正拨打或接听
  static Future<bool> checkCallPermission(
      {Function? cancelPermission, bool hadTip = false}) async {
    Map status = await [Permission.camera, Permission.microphone].request();
    var cameraStatus = status[Permission.camera];
    var microphoneStatus = status[Permission.microphone];
    List<Permission> permissions = [];
    if (cameraStatus == PermissionStatus.permanentlyDenied) {
      permissions.add(Permission.camera);
    }
    if (microphoneStatus == PermissionStatus.permanentlyDenied) {
      permissions.add(Permission.microphone);
    }
    // 有永久拒绝的，提示去设置页面
    if (permissions.isNotEmpty) {
      showPermissionSetting(permissions, cancelPermission);
      return false;
    }

    if (cameraStatus != PermissionStatus.granted) {
      permissions.add(Permission.camera);
    }
    if (microphoneStatus != PermissionStatus.granted) {
      permissions.add(Permission.microphone);
    }
    // 有拒绝的，提示获取权限
    if (permissions.isNotEmpty && !hadTip) {
      showAskPermissionAlert(permissions, cancelPermission);
      return false;
    }
    return true;
  }

  // 提示需要权限
  static void showAskPermissionAlert(
    List<Permission> permissions,
    Function? cancelPermission,
  ) {
    if (permissions.length <= 0) {
      return;
    }

    String content = "";
    String camera = TrudaLanguageKey.newhita_base_camera.tr;
    String mic = TrudaLanguageKey.newhita_base_mic.tr;
    String store = TrudaLanguageKey.newhita_base_store.tr;
    for (int i = 0; i < permissions.length; i++) {
      Permission permission = permissions[i];
      if (permission == Permission.camera) {
        content = (content.isNotEmpty) ? (content + "/") + camera : camera;
      } else if (permission == Permission.microphone) {
        content = (content.isNotEmpty) ? (content + "/") + mic : mic;
      } else if (permission == Permission.storage) {
        content = (content.isNotEmpty) ? (content + "/") + store : store;
      }
    }

    Get.defaultDialog(
        title: TrudaLanguageKey.newhita_video_permission.tr,
        titleStyle: TextStyle(fontSize: 16),
        middleText: TrudaLanguageKey.newhita_open_permission.trArgs(["${content}"]),
        middleTextStyle: TextStyle(fontSize: 14),
        contentPadding:
            EdgeInsetsDirectional.only(start: 20, end: 20, top: 20, bottom: 20),
        radius: 12,
        cancel: TextButton(
            onPressed: () {
              Get.back();
              cancelPermission?.call();
            },
            child: Text(
              TrudaLanguageKey.newhita_base_cancel.tr,
              style: TextStyle(fontSize: 16),
            )),
        confirm: TextButton(
            onPressed: () {
              Get.back();
              checkCallPermission(hadTip: true);
            },
            child: Text(
              TrudaLanguageKey.newhita_base_confirm.tr,
              style: TextStyle(fontSize: 16, color: Color(0xFFD7B189)),
            )));
  }

  // 提示需要到设置页设置权限,
  static void showPermissionSetting(
      List<Permission> permissions, Function? cancelPermission) {
    if (permissions.length <= 0) {
      return;
    }

    String content = "";
    String camera = TrudaLanguageKey.newhita_base_camera.tr;
    String mic = TrudaLanguageKey.newhita_base_mic.tr;
    String store = TrudaLanguageKey.newhita_base_store.tr;
    for (int i = 0; i < permissions.length; i++) {
      Permission permission = permissions[i];
      if (permission == Permission.camera) {
        content = (content.isNotEmpty) ? (content + "/") + camera : camera;
      } else if (permission == Permission.microphone) {
        content = (content.isNotEmpty) ? (content + "/") + mic : mic;
      } else if (permission == Permission.storage) {
        content = (content.isNotEmpty) ? (content + "/") + store : store;
      }
    }

    Get.defaultDialog(
        title: TrudaLanguageKey.newhita_base_permissions_to_setting.tr,
        titleStyle: TextStyle(fontSize: 16),
        middleText: TrudaLanguageKey.newhita_open_permission.trArgs(["${content}"]),
        middleTextStyle: TextStyle(fontSize: 14),
        contentPadding:
            EdgeInsetsDirectional.only(start: 20, end: 20, top: 20, bottom: 20),
        radius: 12,
        cancel: TextButton(
            onPressed: () {
              Get.back();
              cancelPermission?.call();
            },
            child: Text(
              TrudaLanguageKey.newhita_base_cancel.tr,
              style: TextStyle(fontSize: 16),
            )),
        confirm: TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text(
              TrudaLanguageKey.newhita_mine_setting.tr,
              style: TextStyle(fontSize: 16, color: Color(0xFFD7B189)),
            )));
  }

  // 提示去设置页打开通知权限
  static void showPermissionNotify() {
    TrudaCommonDialog.dialog(Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(
                    start: 20, end: 20, top: 80, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: TrudaColors.baseColorGradient2, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: TrudaColors.baseColorBg, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images_sized/newhita_notify.png',
                            height: 34,
                            width: 34,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            TrudaLanguageKey.newhita_main_notify_title.tr,
                            style: TextStyle(
                              fontSize: 15,
                              color: TrudaColors.textColor333,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Image.asset(
                            'assets/images_ani/newhita_open_notify.webp',
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        TrudaLanguageKey.newhita_main_notify_content.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: TrudaColors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      // padding: EdgeInsets.symmetric(horizontal: 30),
                      onTap: () {
                        Get.back();
                        // openAppSettings();
                        askNotification();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              TrudaColors.baseColorGradient1,
                              TrudaColors.baseColorGradient2,
                            ]), // 渐变色
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          TrudaLanguageKey.newhita_base_confirm.tr,
                          style:
                              TextStyle(color: TrudaColors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Material(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                              color: TrudaColors.textColor666.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50)),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                TrudaLanguageKey.newhita_think_again.tr,
                                style: TextStyle(
                                    color: TrudaColors.baseColorGradient1, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PositionedDirectional(
                top: -50,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/newhita_base_logo.png',
                    width: 96,
                    height: 96,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // 提示去设置页打开通知权限
  // static void showPermissionNotify() {
  //   Get.dialog(Center(
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 30),
  //       child: SizedBox(
  //         width: double.infinity,
  //         child: Stack(
  //           children: [
  //             Container(
  //               padding: EdgeInsetsDirectional.only(
  //                   start: 20, end: 20, top: 20, bottom: 20),
  //               decoration: BoxDecoration(
  //                 color: TrudaColors.white,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Container(
  //                   //   padding:
  //                   //       EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  //                   //   decoration: BoxDecoration(
  //                   //     border:
  //                   //         Border.all(color: TrudaColors.baseColorBg, width: 1),
  //                   //     borderRadius: BorderRadius.circular(12),
  //                   //   ),
  //                   //   child: Row(
  //                   //     children: [
  //                   //       Image.asset(
  //                   //         'assets/images/linda_notify.png',
  //                   //         height: 34,
  //                   //       ),
  //                   //       SizedBox(
  //                   //         width: 10,
  //                   //       ),
  //                   //       Text(
  //                   //         TrudaLanguageKey.newhita_main_notify_title.tr,
  //                   //         style: TextStyle(
  //                   //           fontSize: 15,
  //                   //           color: TrudaColors.textColor333,
  //                   //         ),
  //                   //       ),
  //                   //       Expanded(child: SizedBox()),
  //                   //       Image.asset(
  //                   //         'assets/linda_open_notify.webp',
  //                   //         height: 24,
  //                   //       ),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //                   Center(
  //                     child: Text(
  //                       TrudaLanguageKey.newhita_main_notify_title.tr,
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         color: TrudaColors.textColor333,
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding:
  //                         EdgeInsets.symmetric(vertical: 10, horizontal: 0),
  //                     child: Text(
  //                       TrudaLanguageKey.newhita_main_notify_content.tr,
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         color: TrudaColors.textColor666,
  //                       ),
  //                     ),
  //                   ),
  //                   NewHitaGradientButton(
  //                     padding: EdgeInsets.symmetric(horizontal: 30),
  //                     onTap: () {
  //                       Get.back();
  //                       askNotification();
  //                     },
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       padding: EdgeInsets.symmetric(vertical: 10),
  //                       child: Text(
  //                         TrudaLanguageKey.newhita_base_confirm.tr,
  //                         style: TextStyle(color: TrudaColors.white, fontSize: 20),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // PositionedDirectional(
  //             //   top: -80,
  //             //   child: ClipRRect(
  //             //     child: Image.asset(
  //             //       'assets/newhita_base_logo_big.png',
  //             //       width: 116,
  //             //       height: 116,
  //             //     ),
  //             //     borderRadius: BorderRadius.circular(20),
  //             //   ),
  //             // ),
  //           ],
  //           alignment: AlignmentDirectional.topCenter,
  //           clipBehavior: Clip.none,
  //         ),
  //       ),
  //     ),
  //   ));
  // }

  static Future<bool> checkMicphoneAndStoragePermission(
      {Function? cancelPermission}) async {
    Map status = await [Permission.microphone, Permission.storage].request();
    var microphone = status[Permission.microphone];
    var storageStatus = status[Permission.storage];

    if (microphone != PermissionStatus.granted ||
        storageStatus != PermissionStatus.granted) {
      List<Permission> permissions = [];

      if (microphone == PermissionStatus.permanentlyDenied) {
        permissions.add(Permission.microphone);
      }
      if (storageStatus == PermissionStatus.permanentlyDenied) {
        permissions.add(Permission.storage);
      }

      showPermissionSetting(permissions, cancelPermission);

      return false;
    }
    return true;
  }
}
