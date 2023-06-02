import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_pages/main/home/truda_hot_page.dart';
import 'package:truda/truda_pages/main/home/truda_online_page.dart';
import 'package:truda/truda_pages/main/home/truda_page_index_manager.dart';

import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_common_dialog.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_dialogs/truda_dialog_country_choose.dart';
import '../../../truda_dialogs/truda_dialog_invite_for_diamond.dart';
import '../../../truda_utils/truda_ui_image_util.dart';
import '../../../truda_widget/truda_image_indicator.dart';
import '../../../truda_widget/truda_net_image.dart';
import '../../chargedialog/truda_charge_dialog_manager.dart';
import 'truda_follow_page.dart';
import 'truad_home_controller.dart';

class TrudaHomePage extends StatefulWidget {
  TrudaHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrudaHomePageState();
}

class _TrudaHomePageState extends State<TrudaHomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;
  final TrudaHomeController _homeController =
      Get.put(TrudaHomeController());
  int currentPageIndex = 0;
  var showChooseCountry = true.obs;
  ui.Image? indicator;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (currentPageIndex == _tabController.index) return;
      currentPageIndex = _tabController.index;
      showChooseCountry.value = currentPageIndex == 0;
      TrudaPageIndexManager.setHomeIndex(_tabController.index);
    });

    TrudaUiImageUtil.getAssetImage(
            'assets/images_sized/newhita_circle_indicator.png')
        .then((value) {
      setState(() {
        indicator = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        elevation: 0,
        title: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
          indicator:
              indicator == null ? null : TrudaImageIndicator(indicator!),
          tabs: [
            Tab(text: TrudaLanguageKey.newhita_home_tab_hot.tr),
            // Tab(text: TrudaLanguageKey.newhita_base_online.tr),
            Tab(text: TrudaLanguageKey.newhita_home_tab_follow.tr)
          ],
          controller: _tabController,
          labelStyle: const TextStyle(
            fontSize: 24,
            color: TrudaColors.textColor333,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 18,
            color: TrudaColors.textColor666,
          ),
          labelColor: TrudaColors.white,
          unselectedLabelColor: TrudaColors.white.withOpacity(0.5),
        ),
        actions: [
          Obx(() {
            return Visibility(
              visible: showChooseCountry.value,
              child: GestureDetector(onTap: () {
                var list = _homeController.areaList;
                var curArea = _homeController.areaCode;
                if (list.isEmpty) return;
                TrudaCommonDialog.dialog(
                  TrudaDialogCountryChoose(
                    areaList: list,
                    curArea: curArea,
                    callback: (area) {
                      _homeController.onCountryChoose(area);
                    },
                  ),
                );
              }, child: Center(
                child: Obx(() {
                  var area = _homeController.area.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      // gradient: RadialGradient(
                      //   colors: [Colors.transparent, Colors.lightGreenAccent],
                      //   // center: Alignment(-0.7, -0.6),
                      //   radius: 0.9,
                      //   tileMode: TileMode.clamp,
                      //   // stops: [0.5, 0.7],
                      // ),
                      color: Colors.white12,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        if (area == null)
                          Image.asset(
                            'assets/images/newhita_home_country.png',
                            width: 22,
                            height: 22,
                          ),
                        Visibility(
                          visible: area != null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TrudaNetImage(
                                area?.path ?? "",
                                // radius: 9,
                                width: 22,
                                height: 22,
                                isCircle: true,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  area?.title ?? "",
                                  // "aa aa aa aa",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: TrudaColors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/images/newhita_home_arrow_down.png',
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ),
                  );
                }),
              )),
            );
          }),
          const SizedBox(
            width: 10,
          ),
        ],
        // bottom: showCountry
        //     ? PreferredSize(
        //         preferredSize: const Size.fromHeight(50),
        //         child: Container(
        //           height: 50,
        //           color: Colors.yellow,
        //           alignment: AlignmentDirectional.topStart,
        //           child: SizedBox(
        //             height: 20,
        //             width: 40,
        //             child: Container(
        //               color: Colors.green,
        //             ),
        //           ),
        //         ))
        //     : const PreferredSize(
        //         preferredSize: Size.fromHeight(0),
        //         child: SizedBox(
        //           height: 0,
        //         )),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TrudaMainFloat(),
          // NewHitaOnlinePage(),
          TrudaFollowPage()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TrudaMainFloat extends StatefulWidget {
  TrudaMainFloat({Key? key}) : super(key: key);

  @override
  State<TrudaMainFloat> createState() => _TrudaMainFloatState();
}

class _TrudaMainFloatState extends State<TrudaMainFloat> {
  late Offset _offset;

  @override
  void initState() {
    super.initState();
    _offset = Offset(15, Get.width - 65);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  var chargeWidget = GestureDetector(
      onTap: () {
        TrudaChargeDialogManager.showChargeDialog(
          TrudaChargePath.home_float_recharge,
        ).then((value) {
          if (GetPlatform.isAndroid) {
            TrudaDialogInvite.checkToShow();
          }
        });
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 10),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/images_ani/newhita_home_charge.webp",
              fit: BoxFit.contain,
              width: 80,
              height: 80,
            ),
            Positioned(
              bottom: -9,
              child: Container(
                padding:
                    EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      TrudaColors.baseColorGradient1,
                      TrudaColors.baseColorGradient2,
                    ]),
                    borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(10))),
                child: Text(
                  TrudaLanguageKey.newhita_recharge_recharge.tr,
                  style: TextStyle(
                    color: TrudaColors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        textDirection: TextDirection.ltr,
        children: [
          Positioned.fill(child: TrudaHotPage()),
          if (!TrudaConstants.isFakeMode)
            Transform.translate(
                offset: _offset,
                // left: toLeft,
                // top: toTop,
                // bottom: toBottom,
                child: Draggable(
                  feedback: chargeWidget,
                  // 拖动中显示的控件
                  child: chargeWidget,
                  // 子控件
                  childWhenDragging: Container(),
                  // 拖动中的子控件，这样可以类似被拖走效果
                  onDragStarted: () {},
                  //这个是没有移动到目标时的回调，本来也没有设置目标
                  onDraggableCanceled: (Velocity velocity, Offset offset) {
                    //松手的时候，把自己移动到做拖动时的位置
                    // 下面的计算我也挺蒙的，这个offset应该是在全屏的位置
                    //计算偏移量需要注意减去AppBar高度和全局topPadding高度
                    setState(() {
                      // 全局topPadding高度
                      double statusBarHeight =
                          MediaQuery.of(context).padding.top;
                      // AppBar 高度
                      double appBarHeight = kToolbarHeight;
                      double y = offset.dy - appBarHeight - statusBarHeight;
                      double x = offset.dx - 14; // 这个14.w是前面Container有个margin
                      double maxX = context.width - 80 - 28;
                      if (x < 0) {
                        x = 0;
                      } else if (x > maxX) {
                        x = maxX;
                      }
                      double maxY = context.height - 80 - 200;
                      if (y < 0) {
                        y = 0;
                      } else if (y > maxY) {
                        y = maxY;
                      }
                      _offset = Offset(x, y);
                    });
                  },
                ))
        ],
      ),
    );
  }
}
