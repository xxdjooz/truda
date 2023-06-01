import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_entities/truda_lottery_entity.dart';
import '../truda_widget/newhita_gradient_button.dart';

// 抽奖结果
class TrudaDialogLotteryGet extends StatelessWidget {
  TrudaLotteryBean bean;

  TrudaDialogLotteryGet({
    Key? key,
    required this.bean,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = bean.name ?? '';
    if (bean.drawType == 3) {
      final str = '${bean.value}%';
      name = TrudaLanguageKey.newhita_lottery_diamond_card.trArgs([str, str]);
    }
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsetsDirectional.only(top: 30, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 30,
                ),
                Positioned.fill(
                    child:
                        Image.asset('assets/images/newhita_lottery_get_bg.png')),
                Column(
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: NewHitaNetImage(bean.icon ?? '')),
                    if (bean.drawType != 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Text(
                          TrudaLanguageKey.newhita_lottery_congratulation_get
                              .trArgs(['']),
                          style: TextStyle(
                            color: TrudaColors.baseColorYellow,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: TrudaColors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                PositionedDirectional(
                    end: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: Get.back,
                      child: Container(
                        padding: EdgeInsetsDirectional.only(
                            start: 10, end: 10, top: 10, bottom: 10),
                        child: Image.asset(
                          'assets/images/newhita_close_white.png',
                          width: 26,
                          height: 26,
                        ),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: NewHitaGradientButton(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFFDEB0),
                              Color(0xffFFA733),
                            ],
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                          ),
                          border: Border.all(
                            color: TrudaColors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        TrudaLanguageKey.newhita_base_confirm.tr,
                        style: TextStyle(
                            color: const Color(0xFFB4442D), fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
