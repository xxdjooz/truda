import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:truda/truda_utils/newhita_ai_help_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../truda_services/truda_app_info_service.dart';

// 服务
class TrudaShowService extends StatefulWidget {
  static checkToShow() {
    Get.bottomSheet(TrudaShowService());
  }

  @override
  _TrudaShowServiceState createState() => _TrudaShowServiceState();
}

class _TrudaShowServiceState extends State<TrudaShowService> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var whatsappNum = TrudaMyInfoService.to.config?.whatsapp;
    return Container(
        // decoration: BoxDecoration(
        // gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       TrudaColors.baseColorGradient1,
        //       TrudaColors.baseColorGradient2,
        //     ]),
        // borderRadius: BorderRadiusDirectional.only(
        //     topStart: Radius.circular(20), topEnd: Radius.circular(20))),
        decoration: BoxDecoration(
          color: TrudaColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            whatsappNum != null
                ? GestureDetector(
                    onTap: () async {
                      final info = await PackageInfo.fromPlatform();
                      var appVersion = TrudaAppInfoService.to.version;
                      var AppSystemVersionKey =
                          TrudaAppInfoService.to.AppSystemVersionKey;
                      var myId =
                          TrudaMyInfoService.to.userLogin?.username ?? "unkown";
                      String url =
                          "https://wa.me/${whatsappNum}/?text=AppName:${info.appName},appVersion:${appVersion},"
                          "System:${GetPlatform.isIOS ? 'iOS' : 'Android'}${AppSystemVersionKey},uid:$myId}";
                      if (await canLaunch(url)) {
                        launch(url);
                      }

                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(20),
                              topEnd: Radius.circular(20))),
                      child: Text(
                        "WhatsApp:+${whatsappNum}",
                        style: TextStyle(
                            color: TrudaColors.textColor333, fontSize: 16),
                      ),
                    ),
                  )
                : Container(
                    height: 10,
                    color: Colors.transparent,
                  ),
            GestureDetector(
              onTap: () {
                //  aihelp
                NewHitaAihelpManager.enterMinAIHelp(
                    TrudaMyInfoService.to.getMyLeval()?.grade ?? 1, 0);
                Get.back();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                child: Text(
                  TrudaLanguageKey.newhita_mine_customer_service.tr,
                  style:
                      TextStyle(color: TrudaColors.textColor333, fontSize: 16),
                ),
              ),
            ),
            const ColoredBox(
              color: TrudaColors.baseColorBg,
              child: SizedBox(
                width: double.infinity,
                height: 10,
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
                child: Text(
                  TrudaLanguageKey.newhita_base_cancel.tr,
                  style:
                      TextStyle(color: TrudaColors.textColor333, fontSize: 16),
                ),
              ),
            ),
          ],
        ));
  }
}
