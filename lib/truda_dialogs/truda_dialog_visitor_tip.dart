import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import '../truda_common/truda_colors.dart';
import '../truda_widget/newhita_gradient_boder.dart';

// 访客登录提示保存账号密码
class TrudaVisitorTip extends StatefulWidget {
  String account;
  String password;

  TrudaVisitorTip({
    Key? key,
    required this.account,
    required this.password,
  }) : super(key: key);

  static Future checkToShow() async {
    if (TrudaConstants.isFakeMode) {
      return;
    }
    if (NewHitaMyInfoService.to.myDetail?.boundGoogle != 0) {
      return;
    }
    var hadSave = NewHitaStorageService.to.prefs.getBool('VisitorImageSave');
    if (hadSave == true) {
      return;
    }
    // 存储的有账号密码直接去登录
    var visitorAccount = NewHitaStorageService.to.prefs
        .getString(TrudaConstants.keyVisitorAccount);
    if (visitorAccount?.isNotEmpty == true) {
      var list = visitorAccount!.split(TrudaConstants.visitorAccountSplit);
      if (list.isNotEmpty && list.length == 2) {
        await Get.dialog(TrudaVisitorTip(
          account: list[0],
          password: list[1],
        ));
      }
    }
  }

  @override
  _TrudaVisitorTipState createState() => _TrudaVisitorTipState();
}

class _TrudaVisitorTipState extends State<TrudaVisitorTip> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // https://blog.csdn.net/qq_41326577/article/details/124381005
  // 动态申请权限，ios 要在info.plist 上面添加
  /// 动态申请权限，需要区分android和ios，很多时候它两配置权限时各自的名称不同
  /// 此处以保存图片需要的配置为例
  Future<bool> requestPermission() async {
    late PermissionStatus status;
    // 1、读取系统权限的弹框
    if (Platform.isIOS) {
      status = await Permission.photosAddOnly.request();
    } else {
      status = await Permission.storage.request();
    }
    // 2、假如你点not allow后，下次点击不会在出现系统权限的弹框（系统权限的弹框只会出现一次），
    // 这时候需要你自己写一个弹框，然后去打开app权限的页面
    if (status != PermissionStatus.granted) {
      // showCupertinoDialog(
      //     context: context,
      //     builder: (context) {
      //       return CupertinoAlertDialog(
      //         title: const Text('You need to grant album permissions'),
      //         content: const Text(
      //             'Please go to your mobile phone to set the permission to open the corresponding album'),
      //         actions: <Widget>[
      //           CupertinoDialogAction(
      //             child: const Text('cancle'),
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //           ),
      //           CupertinoDialogAction(
      //             child: const Text('confirm'),
      //             onPressed: () {
      //               Navigator.pop(context);
      //               // 打开手机上该app权限的页面
      //               openAppSettings();
      //             },
      //           ),
      //         ],
      //       );
      //     });
      return false;
    } else {
      return true;
    }
  }

  // 保存图片的权限校验
  void checkPermission(Function fun) async {
    bool mark = await requestPermission();
    if (mark) {
      fun();
    } else {
      Get.back();
    }
  }

  // 保存APP里的图片
  Future saveAssetsImg() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      if (result['isSuccess']) {
        NewHitaStorageService.to.prefs.setBool('VisitorImageSave', true);
        NewHitaLoading.toast(TrudaLanguageKey.newhita_save_success.tr);
      } else {}
      NewHitaLog.debug(result['isSuccess']);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                NewHitaGradientBoder(
                  border: 3,
                  colors: const [
                    TrudaColors.baseColorGradient1,
                    TrudaColors.baseColorGradient2,
                  ],
                  borderRadius: 20,
                  colorSolid: Colors.white,
                  margin: const EdgeInsets.only(left: 10, top: 40, right: 10),
                  padding: const EdgeInsets.only(left: 20, top: 80, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          TrudaConstants.appName,
                          style: TextStyle(
                            color: TrudaColors.textColorTitle,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        TrudaLanguageKey.newhita_visitor_disclaimer_content.tr,
                        style: TextStyle(
                          color: TrudaColors.textColor666,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(TrudaLanguageKey.newhita_login_account.tr,
                          style: TextStyle(
                              color: TrudaColors.textColorTitle, fontSize: 12)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          widget.account,
                          style: TextStyle(
                              color: TrudaColors.textColorTitle, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(TrudaLanguageKey.newhita_login_password.tr,
                          style: TextStyle(
                              color: TrudaColors.textColorTitle, fontSize: 12)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          widget.password,
                          style: TextStyle(
                              color: TrudaColors.textColorTitle, fontSize: 16),
                        ),
                      ),

                      Container(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xffFFC0F4), width: 1),
                    image: const DecorationImage(
                        image: AssetImage(
                      'assets/newhita_base_logo.png',
                    )),
                  ),
                  height: 105,
                  width: 105,
                ),
              ],
            ),
          ),
          Container(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              checkPermission(saveAssetsImg);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    TrudaColors.baseColorGradient1,
                    TrudaColors.baseColorGradient2,
                  ]), // 渐变色
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                TrudaLanguageKey.newhita_save_image.tr,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          Container(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Image.asset('assets/images/newhita_close_white.png')
              ),
            ),
          ),
        ],
      ),
    );
  }
}
