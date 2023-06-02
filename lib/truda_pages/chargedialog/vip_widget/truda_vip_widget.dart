import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_pages/chargedialog/vip_widget/truda_vip_widget_controller.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_services/truda_my_info_service.dart';

class TrudaVipWidget extends GetView<TrudaVipWidgetController> {
  TrudaVipWidget({Key? key, this.createPath = ''}) : super(key: key);
  final String createPath;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<TrudaVipWidgetController>(
        () => TrudaVipWidgetController()..createPath = createPath);
    return GetBuilder<TrudaVipWidgetController>(builder: (contr) {
      if (!contr.showMe) return const SizedBox();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  TrudaLanguageKey.newhita_charge_quick_vip.tr,
                  style: const TextStyle(
                    color: TrudaColors.textColorTitle,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Builder(builder: (context) {
                    final text =
                        TrudaLanguageKey.newhita_charge_quick_diamond_per.trArgs([
                      (TrudaMyInfoService.to.config?.vipDailyDiamonds ?? 10)
                          .toString(),
                    ]);
                    final texts = text.split('钻');
                    return Text.rich(
                      TextSpan(
                        text: "",
                        style: TextStyle(
                            color: TrudaColors.baseColorTheme, fontSize: 12),
                        children: [
                          TextSpan(text: texts[0]),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Image.asset(
                              "assets/images/newhita_diamond_small.png",
                              width: 12,
                              height: 12,
                            ),
                          ),
                          TextSpan(text: texts[1]),
                        ],
                      ),
                    );
                  }),
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Text(
                    TrudaLanguageKey.newhita_charge_quick_vip_benefit.tr,
                    style: const TextStyle(
                      color: TrudaColors.textColor666,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 10,
              childAspectRatio: 105 / 145,
              crossAxisCount: 3,
            ),
            itemCount: TrudaVipWidgetController.payQuickData?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _getVipItem(index, contr);
            },
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _getVipItem(int index, TrudaVipWidgetController controller) {
    return Builder(builder: (context) {
      var list = TrudaVipWidgetController.payQuickData!;
      var bean = list[index];
      return GestureDetector(
        onTap: () {
          controller.chooseCommdite(bean);
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: TrudaColors.baseColorItem,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images_sized/newhita_me_vip.png',
                      height: 24,
                    ),
                    const SizedBox(height: 10),
                    AutoSizeText(
                      TrudaLanguageKey.newhita_vip_days
                          .trArgs([(bean.vipDays ?? 0).toString()]),
                      maxLines: 1,
                      maxFontSize: 14,
                      minFontSize: 8,
                      style: const TextStyle(
                        color: TrudaColors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text.rich(
                      TextSpan(
                        text: "",
                        style: TextStyle(
                            color: TrudaColors.baseColorTheme, fontSize: 12),
                        children: [
                          TextSpan(text: " +"),
                          TextSpan(
                            text: "${bean.value}",
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Image.asset(
                              "assets/images/newhita_diamond_small.png",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const AspectRatio(
                    //   aspectRatio: 210 / 84,
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AspectRatio(
                aspectRatio: 210 / 84,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images_sized/newhita_vip_selected.png",
                      ),
                    ),
                  ),
                  alignment: Alignment(0.0, 0.2),
                  child: AutoSizeText(
                    bean.showPrice,
                    maxLines: 2,
                    maxFontSize: 14,
                    minFontSize: 8,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TrudaColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
