import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_services/truda_my_info_service.dart';
import '../../../truda_widget/newhita_sheet_header.dart';

class TrudaSheetChargeSuccess extends StatefulWidget {
  final int lottery;

  TrudaSheetChargeSuccess({Key? key, required this.lottery})
      : super(key: key);

  @override
  State<TrudaSheetChargeSuccess> createState() =>
      _TrudaSheetChargeSuccessState();
}

class _TrudaSheetChargeSuccessState extends State<TrudaSheetChargeSuccess> {
  @override
  void initState() {
    super.initState();
    TrudaMyInfoService.to.haveLotteryTimes.value =
        TrudaMyInfoService.to.haveLotteryTimes.value + widget.lottery;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const NewHitaSheetHeader(),
        Container(
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [
              //       TrudaColors.baseColorGradient1,
              //       TrudaColors.baseColorGradient2,
              //     ]),
              color: TrudaColors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images_sized/newhita_success.png',
                  width: 70,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    TrudaLanguageKey.newhita_recommend_title.tr,
                    style: const TextStyle(
                      color: TrudaColors.textColor333,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                  child: Text(
                    TrudaLanguageKey.newhita_recommend_title_1.tr,
                    style: TextStyle(
                      color: TrudaColors.textColor333,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                  child: Text(
                    TrudaLanguageKey.newhita_recommend_cotent.tr,
                    style: TextStyle(
                      color: TrudaColors.textColor333,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                  child: Text(
                    TrudaLanguageKey.newhita_lottery_charge_draw
                        .trArgs([widget.lottery.toString()]),
                    style: TextStyle(
                      color: TrudaColors.baseColorRedLight,
                      fontSize: 12,
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 345 / 130,
                  child: Container(
                      // padding: EdgeInsets.symmetric(
                      //     vertical: 10, horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/newhita_lottery_charge.png'),
                            //背景图片
                            fit: BoxFit.fill,
                            matchTextDirection: true),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  TrudaLanguageKey
                                      .newhita_lottery_charge_tip.tr,
                                  style: const TextStyle(
                                      color: TrudaColors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          )),
                          const AspectRatio(
                            aspectRatio: 1,
                            child: SizedBox(),
                          ),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(TrudaAppPages.lotteryPage);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin:
                        const EdgeInsetsDirectional.only(bottom: 20, top: 10),
                    height: 52,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(52 * 0.5)),
                      gradient: LinearGradient(colors: [
                        TrudaColors.baseColorGradient1,
                        TrudaColors.baseColorGradient2,
                      ]),
                    ),
                    child: Text(
                      TrudaLanguageKey.newhita_lottery_go.tr,
                      style: const TextStyle(
                          color: TrudaColors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
