import 'dart:convert';

import 'package:get/get.dart';
import 'package:truda/truda_dialogs/truda_dialog_confirm.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../truda_common/truda_common_dialog.dart';
import '../truda_entities/truda_config_entity.dart';
import '../truda_services/newhita_app_info_service.dart';
import 'newhita_facebook_util.dart';

class NewHitaCheckAppUpdate {
  static void check() async {
    final str = NewHitaMyInfoService.to.config?.appUpdate ?? '';
    if (str.isEmpty) return;
    TrudaAppUpdate? update;
    try {
      update = TrudaAppUpdate.fromJson(json.decode(str));
    } catch (e) {
      print(e);
    }
    if (update == null) return;
    NewHitaLog.debug(update.content ?? 'aa');
    if (update.isShow != true || update.url == null) return;
    TrudaCommonDialog.dialog(
      TrudaDialogConfirm(
        callback: (i) {
          _handle(update!.url!, update.type!);
        },
        title: update.title ?? '',
        content: update.content ?? '',
      ),
    );
  }

  // 1 google, 2 url
  static void _handle(String url, int type) async {
    if (url.contains("/#") == true) {
      //不做操作
      return;
    }

    //跳转网页
    if (type == 2) {
      if (await canLaunch(url)) {
        launch(url);
      }
    } else if (type == 1) {
      if (url.contains("/feedback") == true) {
        // todo
        //  打开客服
        // CblRouterManager.pushNamed(ReportUpRouter);
      } else if (url.contains("/whatsApp=") == true) {
        //  打开whatsapp
        String? whatsappid = url.split("=").last;
        if (whatsappid != null) {
          final info = await PackageInfo.fromPlatform();
          var appVersion = NewHitaAppInfoService.to.version;
          var AppSystemVersionKey = NewHitaAppInfoService.to.AppSystemVersionKey;
          var myId = NewHitaMyInfoService.to.userLogin?.username ?? "unkown";
          String url =
              "https://wa.me/${whatsappid}/?text=AppName:${info.appName},appVersion:${appVersion},"
              "System:${GetPlatform.isIOS ? 'iOS' : 'Android'}${AppSystemVersionKey},uid:$myId}";
          if (await canLaunch(url)) {
            launch(url);
          }
        }
      } else if (url.contains("play.google.com") == true) {
        //打开google play
        String? package = url.split("=").last;
        if (package != null) {
          gotoGooglePlay(package);
        }
      }
    }
  }
}
