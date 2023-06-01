import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_utils/newhita_check_calling_util.dart';

import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_constants.dart';
import '../truda_entities/truda_leval_entity.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';
import '../truda_pages/some/newhita_web_page.dart';
import '../truda_services/newhita_my_info_service.dart';
import '../truda_widget/newhita_net_image.dart';

//用户升级提示
class TrudaUserLevelUpdate extends StatelessWidget {
  static void checkToShow(int expLevel) async {
    if (TrudaConstants.isFakeMode) {
      return;
    }
    // NewHitaInfoDetail myDetail;
    // try {
    //   myDetail = await NewHitaHttpUtil().post<NewHitaInfoDetail>(
    //     NewHitaHttpUrls.userInfoApi,
    //   );
    // } catch (e) {
    //   print(e);
    //   return;
    // }
    NewHitaMyInfoService.to.myDetail?.expLevel = expLevel;
    var leval = NewHitaMyInfoService.to.getMyLeval();
    if (NewHitaCheckCallingUtil.checkCalling()) {
      return;
    }
    int lastLeval = NewHitaMyInfoService.to.getLastShowLeval();
    if (leval == null || lastLeval == 100) {
      return;
    }
    if ((leval.grade ?? 0) <= lastLeval) {
      return;
    }
    NewHitaMyInfoService.to.saveLastLeval(leval.grade!);

    // 每次等级变动都调一下，领取奖励
    NewHitaHttpUtil()
        .post<void>(NewHitaHttpUrls.getLevelUpdateGiftApi, errCallback: (e) {});
    TrudaCommonDialog.dialog(TrudaUserLevelUpdate(leval));
  }

  TrudaLevalBean expLevel;

  TrudaUserLevelUpdate(this.expLevel);

  @override
  Widget build(BuildContext context) {
    // NewHitaLevelRuleData? levelRuleData = null;
    // NewHitaLocalStore.levelList?.forEach((element) {
    //   if (levelRuleData == null && element.grade == level) {
    //     levelRuleData = element;
    //   }
    // });

    double windowWidth = Get.width - 60;
    double levelupWidth = windowWidth - 30;
    double levelupHeight = 245 * levelupWidth / 790;
    double levelupContentWidth = 475 * levelupWidth / 790;

    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsetsDirectional.only(start: 30, end: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(
                  top: levelupHeight * 0.5, start: 20, end: 20, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: levelupContentWidth,
                    child: AutoSizeText(
                      TrudaLanguageKey.newhita_level_congratulations.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: TrudaColors.textColor333),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text("lv.${expLevel.grade ?? 1}",
                      style: TextStyle(
                          fontSize: 30, color: TrudaColors.textColor333)),
                  NewHitaNetImage(
                    expLevel.awardIcon ?? "",
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(top: 15),
                    child: Text(
                      expLevel.awardName ?? "--",
                      style: TextStyle(color: TrudaColors.textColor333),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      var levalUrl = NewHitaMyInfoService.to.getLevalUrl();
                      if (levalUrl != null) {
                        NewHitaWebPage.startMe(levalUrl, false);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      margin: EdgeInsetsDirectional.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: TrudaColors.baseColorGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        TrudaLanguageKey.newhita_check_rights.tr,
                        style: TextStyle(
                            color: TrudaColors.textColor333, fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //       color: TrudaColors.baseColorRed, width: 1),
                      //   borderRadius: BorderRadiusDirectional.all(
                      //     Radius.circular(25),
                      //   ),
                      // ),
                      child: Text(
                        TrudaLanguageKey.newhita_has_known.tr,
                        style: TextStyle(
                            color: TrudaColors.textColor333, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
