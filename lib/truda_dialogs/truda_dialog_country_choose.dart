import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:truda/truda_common/truda_charge_path.dart';
import 'package:truda/truda_pages/vip/truda_vip_controller.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_common_type.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_entities/truda_hot_entity.dart';
import '../truda_services/truda_my_info_service.dart';
import '../truda_widget/truda_gradient_boder.dart';
import '../truda_widget/truda_net_image.dart';

class TrudaDialogCountryChoose extends StatelessWidget {
  List<TrudaAreaData> areaList;
  TrudaCallback<TrudaAreaData> callback;
  int curArea;

  TrudaDialogCountryChoose({
    Key? key,
    required this.areaList,
    required this.curArea,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var levalbean = TrudaMyInfoService.to.getMyLeval();
    var myLeval = levalbean?.grade ?? 0;
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Container(
        // width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: 30,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          color: TrudaColors.white,
          // border: Border.all(
          //   color: TrudaColors.baseColorBorder,
          //   width: 1,
          // ),
          borderRadius:
              BorderRadiusDirectional.vertical(bottom: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              children: areaList
                  .map(
                    (e) => Builder(
                      builder: (context) {
                        var area = e;
                        bool isCur = area.areaCode == curArea;
                        bool isVip = TrudaMyInfoService.to.isVipNow;
                        bool can = area.canChoose == 1;
                        return Opacity(
                          opacity: (!isVip && !can) ? 0.7 : 1,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              if (!isVip && !can) {
                                showLevalWarn();
                                return;
                              }
                              callback.call(area);
                            },
                            child: Container(
                              decoration: isCur
                                  ? BoxDecoration(
                                      color: TrudaColors.baseColorTheme,
                                      // border: Border.all(
                                      //   color: Colors.white54,
                                      //   width: 1,
                                      //   style: BorderStyle.solid,
                                      // ),
                                      borderRadius: BorderRadius.circular(30),
                                    )
                                  : BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      if (!isVip && !can)
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.all(
                                                  3),
                                          child: Image.asset(
                                            'assets/images/newhita_area_lock.png',
                                            width: 16,
                                            height: 16,
                                          ),
                                        )
                                      else
                                        TrudaNetImage(
                                          area.path ?? "",
                                          width: 22,
                                          height: 22,
                                          isCircle: true,
                                          borderWidth: 1,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    area.title ?? "",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isCur
                                          ? TrudaColors.white
                                          : TrudaColors.textColor666,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // if (isCur)
                                  //   Image.asset(
                                  //       'assets/images/newhita_home_country_choosed.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void showLevalWarn() {
    TrudaCommonDialog.dialog(Center(
      child: TrudaGradientBoder(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsetsDirectional.only(top: 30, bottom: 20),
          border: 3,
          colors: const [
            TrudaColors.baseColorGradient1,
            TrudaColors.baseColorGradient2,
          ],
          borderRadius: 20,
          colorSolid: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                TrudaLanguageKey.newhita_vip_for_location.tr,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: TrudaColors.textColor333, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  // var levalUrl = NewHitaMyInfoService.to.getLevalUrl();
                  // if (levalUrl != null) {
                  //   NewHitaWebPage.startMe(levalUrl, true);
                  // }
                  TrudaVipController.openDialog(
                      createPath: TrudaChargePath.recharge_choose_area);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin:
                      EdgeInsetsDirectional.only(top: 20, start: 10, end: 10),
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(42 * 0.5)),
                    gradient: LinearGradient(colors: [
                      TrudaColors.baseColorGradient1,
                      TrudaColors.baseColorGradient2,
                    ]),
                  ),
                  child: Text(
                    TrudaLanguageKey.newhita_base_confirm.tr,
                    style: TextStyle(
                        color: TrudaColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
