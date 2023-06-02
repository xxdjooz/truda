import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_charge_path.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/chargedialog/truda_charge_dialog_manager.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:truda/truda_widget/gift/newhita_gift_data_helper.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_services/newhita_my_info_service.dart';

typedef NewHitaGiftChoose = Function(TrudaGiftEntity entity);

/// 送礼物弹窗列表
class NewHitaLianGiftListView extends StatefulWidget {
  late NewHitaGiftChoose choose;

  // 主播id
  String? herId;
  bool? isChatOrCall;

  NewHitaLianGiftListView({
    Key? key,
    required this.choose,
    this.herId,
    this.isChatOrCall,
  }) : super(key: key);

  @override
  State<NewHitaLianGiftListView> createState() => _NewHitaLianGiftListViewState();
}

class _NewHitaLianGiftListViewState extends State<NewHitaLianGiftListView>
    with SingleTickerProviderStateMixin {
  List<TrudaGiftEntity>? list;
  List<TrudaGiftEntity> vipList = [];
  int selectedIndex = 0;
  late final TabController _tabController;
  CarouselController carouselController = CarouselController();

  void click(int index, bool vip) {
    if (index == selectedIndex) {
      Get.back();
      if (vip) {
        widget.choose.call(vipList[index]);
      } else {
        widget.choose.call(list![index]);
      }
      NewHitaLog.debug('NewHitaLianGiftListView click ${list![index].name}');
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: TrudaConstants.appMode != 2 ? 2 : 1, vsync: this);
    getGift();
    _tabController.addListener(() {
      setState(() {
        currentIndex2 = 0;
        currentIndex1 = 0;
      });
    });
  }

  void getGift() {
    NewHitaGiftDataHelper.getGifts().then((value) {
      setState(() {
        list = value;
        // ios审核模式不要vip
        if (TrudaConstants.appMode == 2){
          list = value?.where((e) => e.vipVisible != 1).toList();
        }

        // 非vip
        if (list?.isNotEmpty == true) {
          for (var gift in list!) {
            if (gift.vipVisible == 1) {
              vipList.add(gift);
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const pageSize = 8;
    var pageCount = ((list?.length ?? 0) / pageSize).ceil();
    var lastPageSize = (list?.length ?? 0) % pageSize;
    if (lastPageSize == 0) {
      lastPageSize = pageSize;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        // gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       TrudaColors.baseColorGradient1,
        //       TrudaColors.baseColorGradient2,
        //     ]),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(14),
          topEnd: Radius.circular(14),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: TrudaColors.white,
            // indicator: TrudaHostDetailIndicator(),
            labelPadding: EdgeInsetsDirectional.only(start: 10, end: 10),
            tabs: [
              Tab(text: TrudaLanguageKey.newhita_gift_all.tr),
              if (TrudaConstants.appMode != 2)
              Tab(text: TrudaLanguageKey.newhita_gift_vip.tr),
            ],
            controller: _tabController,
            labelStyle: const TextStyle(
                fontSize: 14,
                color: TrudaColors.textColor333,
                fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              color: TrudaColors.textColor666,
            ),
            labelColor: TrudaColors.white,
            unselectedLabelColor: TrudaColors.white.withOpacity(0.8),
          ),
          ColoredBox(
            color: TrudaColors.baseColorBg.withOpacity(0.5),
            child: SizedBox(
              width: double.infinity,
              height: 0.5,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          pageCount == 0
              ? const SizedBox(
                  height: 100,
                )
              : AspectRatio(
                  aspectRatio: 18 / 13,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _getGiftList(list, false),
                      if (TrudaConstants.appMode != 2)
                      _getGiftList(vipList, true),
                    ],
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/newhita_diamond_small.png"),
                    AutoSizeText(
                      (NewHitaMyInfoService
                                  .to.myDetail?.userBalance?.remainDiamonds ??
                              0)
                          .toString(),
                      maxLines: 1,
                      minFontSize: 10,
                      style: TextStyle(
                          color: TrudaColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    TrudaChargeDialogManager.showChargeDialog(
                        TrudaChargePath.gift_send_no_money,
                        upid: widget.herId);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            TrudaColors.baseColorGradient1,
                            TrudaColors.baseColorGradient2,
                          ]),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          TrudaLanguageKey.newhita_recharge.tr,
                          style: TextStyle(
                            color: TrudaColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  var currentIndex1 = 0;
  var currentIndex2 = 0;

  Widget _getGiftList(List<TrudaGiftEntity>? list, bool vip) {
    const pageSize = 8;
    var pageCount = ((list?.length ?? 0) / pageSize).ceil();
    var lastPageSize = (list?.length ?? 0) % pageSize;
    if (lastPageSize == 0) {
      lastPageSize = pageSize;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          itemCount: pageCount,
          carouselController: carouselController,
          options: CarouselOptions(
              aspectRatio: 18 / 11,
              // height: 240,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                setState(() {
                  if (vip) {
                    currentIndex2 = index;
                  } else {
                    currentIndex1 = index;
                  }
                });
              }),
          itemBuilder: (BuildContext context, int indexOut, int realIndex) {
            NewHitaLog.debug(
                'CarouselSlider indexOut=$indexOut realIndex=$realIndex');
            NewHitaLog.debug(
                'CarouselSlider pageCount=$pageCount lastPageSize=$lastPageSize pageSize=$pageSize');
            return GridView.builder(
              shrinkWrap: true,
              itemCount: indexOut == pageCount - 1 ? lastPageSize : pageSize,
              itemBuilder: (context, index) {
                var ind = indexOut * pageSize + index;
                var gift = list![ind];

                bool needVip = gift.vipVisible == 1;
                NewHitaLog.debug('CarouselSlider ind=$ind');
                return GestureDetector(
                  onTap: () {
                    click(ind, vip);
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: selectedIndex == ind
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: TrudaColors.baseColorTheme, width: 1))
                            : const BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 4),
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: NewHitaNetImage(gift.icon ?? '')),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsetsDirectional.only(
                                    top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsetsDirectional.only(end: 4),
                                      width: 13,
                                      height: 13,
                                      child: Image.asset(
                                          "assets/images/newhita_diamond_small.png"),
                                    ),
                                    Text(
                                      gift.diamonds.toString(),
                                      style: TextStyle(
                                          color: TrudaColors.white,
                                          fontSize: 14),
                                    )
                                  ],
                                )),
                            selectedIndex == ind
                                ? Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 19,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          TrudaColors.baseColorGradient1,
                                          TrudaColors.baseColorGradient2,
                                        ]),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8))),
                                    child: Text(
                                      TrudaLanguageKey.newhita_gift_send.tr,
                                      style: const TextStyle(
                                          color: TrudaColors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      if (needVip)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Image.asset(
                              'assets/images/newhita_host_vip_user.png'),
                        ),
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 9 / 11,
              ),
            );
          },
        ),
        if (list != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.filled(pageCount, 0).asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(
                        (vip ? currentIndex2 : currentIndex1) == entry.key
                            ? 0.9
                            : 0.4)),
              );
            }).toList(),
          ),
      ],
    );
  }
}
