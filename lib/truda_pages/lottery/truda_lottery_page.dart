import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_widget/newhita_app_bar.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_common/truda_language_key.dart';
import '../../truda_routes/truda_pages.dart';
import '../../truda_widget/pie_chart/newhita_pie_chart_widget.dart';
import 'truda_lottery_controller.dart';

class TrudaLotteryPage extends GetView<TrudaLotteryController> {
  TrudaLotteryPage({Key? key}) : super(key: key);
  final colorYellow1 = const Color(0xFFFFFCF1);
  final colorYellow2 = const Color(0xFFFEE7B1);
  final colorYellow3 = const Color(0xFFB4442D);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaLotteryController>(
      builder: (contr) {
        return Scaffold(
          backgroundColor: TrudaColors.baseColorBlackBg,
          appBar: NewHitaAppBar(
            title: Text(TrudaLanguageKey.newhita_lottery.tr),
            titleTextStyle: const TextStyle(
              fontSize: 18,
              color: TrudaColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images_sized/newhita_lottery_bg.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 90,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/newhita_lottery_title.png'),
                          //背景图片
                          fit: BoxFit.fill,
                          matchTextDirection: true),
                    ),
                    padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                    margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    constraints: BoxConstraints(minHeight: 40),
                    alignment: AlignmentDirectional.center,
                    child: AutoSizeText(
                      TrudaLanguageKey.newhita_lottery_times_get
                          .trArgs([controller.haveLotteryTimes.toString()]),
                      style: TextStyle(
                        color: colorYellow2,
                        fontSize: 12,
                      ),
                      minFontSize: 8,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: AspectRatio(
                      aspectRatio: 349 / 452,
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints constraints) {
                          // 根据设计图的比例计算出宽高
                          final fatherWidth = constraints.minWidth;
                          final toTop = fatherWidth * 37 / 349;
                          final toStart = fatherWidth * 43 / 349;
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                    'assets/images/newhita_lottery_lock.png'),
                              ),
                              PositionedDirectional(
                                top: toTop,
                                start: toStart,
                                end: toStart,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Positioned.fill(
                                        child: Builder(builder: (context) {
                                          final datas = controller.data;
                                          if (datas.isEmpty) {
                                            return const SizedBox();
                                          }
                                          var colors = <Color>[];
                                          for (var i = 0;
                                          i < datas.length;
                                          i++) {
                                            if (i % 2 == 0) {
                                              colors.add(colorYellow1);
                                            } else {
                                              colors.add(colorYellow2);
                                            }
                                          }
                                          final angle = 1 / datas.length;
                                          var angles = List.filled(
                                              datas.length, angle);
                                          var contents = datas.map((element) {
                                            // 奖品类型，0.谢谢参与，1.送钻石，2.送会员天数，3.送钻石加成卡
                                            if (element.drawType == 0) {
                                              return '${element.name}';
                                            } else if (element.drawType ==
                                                1) {
                                              return '${element.value ?? 0}';
                                            } else if (element.drawType ==
                                                3) {
                                              return '${element.value}%';
                                            }
                                            return '${element.name}';
                                          }).toList();
                                          return NewHitaPieChartWidget(
                                            angles,
                                            colors,
                                            radius: 130,
                                            contents: contents,
                                            images: contr.images,
                                            controller: contr.controller,
                                          );
                                        }),
                                      ),
                                      Image.asset(
                                          'assets/images/newhita_lottery_point.png'),
                                    ],
                                  ),
                                ),
                              ),
                              PositionedDirectional(
                                start: 30,
                                end: 30,
                                bottom: -20,
                                child: GestureDetector(
                                  onTap: contr.drawOne,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFBE4C5),
                                          Color(0xFFFFB859),
                                          Color(0xFFFFB859),
                                          Color(0xFFFBE4C5),
                                        ],
                                        // 渐变色结束点
                                        stops: [
                                          0,
                                          0.4,
                                          0.6,
                                          1,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: Color(0xFFFFEED6), width: 2),
                                    ),
                                    height: 50,
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      TrudaLanguageKey.newhita_lottery_now.tr,
                                      style: TextStyle(
                                        color: colorYellow3,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Obx(() {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 5, end: 5, top: 40),
                      child: Text(
                        TrudaLanguageKey.newhita_lottery_times_remain
                            .trArgs([controller.lastTimes.value.toString()]),
                        style: TextStyle(
                          color: colorYellow2,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () {
                      // Get.dialog(TrudaDialogLotteryTip());
                      Get.offNamed(TrudaAppPages.googleCharge);
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 15, end: 15, top: 20),
                      child: Text(
                        TrudaLanguageKey.newhita_lottery_qa.tr,
                        style: const TextStyle(
                          color: TrudaColors.white,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationThickness: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
