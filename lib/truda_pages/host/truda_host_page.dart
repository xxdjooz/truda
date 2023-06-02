import 'dart:ui';
import 'package:disable_screenshots/disable_screenshots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_charge_path.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_dialogs/truda_sheet_host_option.dart';
import 'package:truda/truda_pages/call/local/truda_local_controller.dart';
import 'package:truda/truda_pages/host/truda_host_detail_indicator.dart';
import 'package:truda/truda_pages/vip/truda_vip_controller.dart';
import 'package:truda/truda_utils/newhita_format_util.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:truda/truda_utils/newhita_some_extension.dart';
import 'package:intl/intl.dart';

import '../../truda_common/truda_common_dialog.dart';
import '../../truda_common/truda_constants.dart';
import '../../truda_dialogs/truda_dialog_confirm.dart';
import '../../truda_entities/truda_host_entity.dart';
import '../../truda_routes/truda_pages.dart';
import '../../truda_services/truda_my_info_service.dart';
import '../../truda_services/truda_storage_service.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_utils/newhita_ui_image_util.dart';
import '../../truda_widget/newhita_avatar_with_bg.dart';
import '../../truda_widget/newhita_border.dart';
import '../../truda_widget/newhita_image_indicator.dart';
import '../../truda_widget/newhita_net_image.dart';
import '../../truda_widget/sliver/newhita_sliver_header_delegate.dart';
import '../chat/truda_chat_controller.dart';
import '../main/home/truda_host_widget.dart';
import '../some/truda_media_view_page.dart';
import 'truda_host_contribute_view.dart';
import 'truda_host_controller.dart';

class TrudaHostPage extends StatefulWidget {
  TrudaHostPage({Key? key}) : super(key: key);

  @override
  State<TrudaHostPage> createState() => _TrudaHostPageState();
}

class _TrudaHostPageState extends State<TrudaHostPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // 初始化插件
  final DisableScreenshots _plugin = DisableScreenshots();

  final canScreenshot = true.obs;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didUpdateWidget(covariant TrudaHostPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaHostController>(builder: (_controller) {
      // DefaultTabController 这个是给tabbar和pagview的，竟然放这里！
      return Scaffold(
        backgroundColor: TrudaColors.white,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        leadingWidth: 100,
                        leading: GestureDetector(
                          child: Container(
                            padding:
                                const EdgeInsetsDirectional.only(start: 15),
                            alignment: AlignmentDirectional.centerStart,
                            child: Image.asset(
                              'assets/images/newhita_host_back.png',
                              matchTextDirection: true,
                            ),
                          ),
                          onTap: () {
                            Get.back();
                          },
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () async {
                              var result = await Get.toNamed(
                                TrudaAppPages.reportPageNew,
                                arguments: {
                                  'reportType': 0,
                                  'herId': _controller.herId,
                                },
                              );
                              if (result == 1) {
                                Get.back(result: 1);
                              }
                            },
                            child: Image.asset(
                                'assets/images/newhita_host_report.png'),
                          ),
                          GestureDetector(
                            child: Image.asset(
                                'assets/images/newhita_host_black.png'),
                            onTap: () async {
                              if (_controller.detail == null) return;
                              var result = await showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return TrudaSheetHostOption(
                                        herId: _controller.detail!.userId!);
                                  });
                              NewHitaLog.debug(
                                  'NewHitaHostPage showModalBottomSheet result=$result');
                              if (result == 1) {
                                Get.back(result: 1);
                              }
                            },
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // )
                        ],
                        expandedHeight: 380,
                        backgroundColor: TrudaColors.white,
                        // foregroundColor: TrudaColors.white,
                        shadowColor: Colors.transparent,
                        // title: const Text('CustomScrollView 测试'),
                        flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: SizedBox(
                              height: 380,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  NewHitaNetImage(_controller.portrait!,
                                      placeholderAsset:
                                          'assets/images_sized/newhita_home_girl.png'),
                                  PositionedDirectional(
                                      start: 0,
                                      end: 0,
                                      bottom: 60,
                                      child: Container(
                                        height: 80,
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                          begin: AlignmentDirectional.topCenter,
                                          end:
                                              AlignmentDirectional.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black54,
                                          ],
                                        )),
                                      )),
                                  PositionedDirectional(
                                    start: 15,
                                    end: 0,
                                    bottom: 90,
                                    child: Row(
                                      children: [
                                        NewHitaAvatarWithBg(
                                          url: _controller.detail?.portrait ??
                                              "",
                                          width: 64,
                                          height: 64,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_controller.detail != null)
                                    PositionedDirectional(
                                        end: 15,
                                        bottom: 90,
                                        child: GestureDetector(
                                          // onTap: _controller.handleFollow,
                                          onTap: () {
                                            if (_controller.detail!.followed ==
                                                1) {
                                              TrudaCommonDialog.dialog(
                                                  TrudaDialogConfirm(
                                                title: TrudaLanguageKey
                                                    .newhita_details_tip.tr,
                                                callback: (i) {
                                                  _controller.handleFollow();
                                                },
                                              ));
                                            } else {
                                              _controller.handleFollow();
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: _controller
                                                          .detail!.followed ==
                                                      1
                                                  ? TrudaColors.white
                                                  : TrudaColors
                                                      .baseColorTheme,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: _controller
                                                        .detail!.followed ==
                                                    1
                                                ? Row(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/newhita_host_followed.png'),
                                                      const SizedBox(
                                                        width: 4,
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        TrudaLanguageKey
                                                            .newhita_details_following
                                                            .tr,
                                                        style: const TextStyle(
                                                          color: TrudaColors
                                                              .baseColorTheme,
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/newhita_host_follow.png'),
                                                      const SizedBox(
                                                        width: 4,
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        TrudaLanguageKey
                                                            .newhita_details_follow
                                                            .tr,
                                                        style: const TextStyle(
                                                          color: TrudaColors
                                                              .white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                          ),
                                        )),
                                ],
                              ),
                            )),
                        pinned: true,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(60),
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: TrudaColors.white,
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(20),
                                topEnd: Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: _detailInfo(_controller),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsetsDirectional.only(
                              top: 0, bottom: 10, start: 14, end: 14),
                          color: TrudaColors.white,
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _controller.detail?.intro ?? '--',
                                style: TextStyle(
                                    color: TrudaColors.textColor333,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                width: 4,
                                height: 4,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ..._getLables(_controller.detail),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: NewHitaSliverHeaderDelegate.fixedHeight(
                          height: kTextTabBarHeight,
                          child: Builder(builder: (context) {
                            NewHitaLog.debug(
                                'NewHitaHostPage ${_controller.indicatorImage == null}');
                            return ColoredBox(
                              color: TrudaColors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TabBar(
                                  isScrollable: true,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 6),
                                  // indicator: TrudaHostDetailIndicator(),
                                  indicator: _controller.indicatorImage == null
                                      ? null
                                      : NewHitaImageIndicator(
                                          _controller.indicatorImage!,
                                          colorFilter:
                                              TrudaColors.baseColorTheme,
                                        ),
                                  tabs: [
                                    Tab(
                                        text: TrudaLanguageKey
                                            .newhita_details_album.tr),
                                    Tab(
                                        text: TrudaLanguageKey
                                            .newhita_story.tr),
                                    if (!TrudaConstants.isFakeMode)
                                      Tab(
                                          text: TrudaLanguageKey
                                              .newhita_contribute_weekly.tr)
                                  ],
                                  controller: _tabController,
                                  labelStyle: const TextStyle(
                                      fontSize: 16,
                                      color: TrudaColors.textColor333,
                                      fontWeight: FontWeight.bold),
                                  unselectedLabelStyle: const TextStyle(
                                    fontSize: 16,
                                    color: TrudaColors.textColor666,
                                  ),
                                  labelColor: TrudaColors.textColor333,
                                  unselectedLabelColor:
                                      TrudaColors.textColor666,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      _mediaList(_controller),
                      _momentList(_controller),
                      if (!TrudaConstants.isFakeMode)
                        TrudaHostContributeView(
                          herId: _controller.herId,
                        ),
                    ],
                  ),
                )),
          ],
        ),
        bottomNavigationBar: _wBottomButton(_controller),
      );
    });
  }

  Widget _wBottomButton(TrudaHostController _controller) {
    return Builder(builder: (context) {
      final hideCall = TrudaConstants.isFakeMode ||
          _controller.detail?.isShowOnline != true;
      // final hideCall = NewHitaConstants.isFakeMode;
      // 按电话背景比聊天背景宽度比 7：3算
      final callBgW = (context.width - 40) * 7 / 10;
      final callBgH = callBgW * 18 / 70;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    TrudaChatController.startMe(_controller.herId,
                        detail: _controller.detail);
                  },
                  child: Container(
                    height: callBgH,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            TrudaColors.baseColorGradient1,
                            TrudaColors.baseColorGradient2,
                          ]),
                      // color: TrudaColors.baseColorPink,
                      // border: Border.all(
                      //   color: TrudaColors.white,
                      //   width: 1,
                      // ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/newhita_host_msg.png",
                            width: 34,
                            height: 34,
                          ),
                        ),
                        if (hideCall)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              TrudaLanguageKey.newhita_message_title.tr,
                              style: const TextStyle(
                                  color: TrudaColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                      ],
                    ),
                  ),
                )),
            if (!hideCall) const SizedBox(width: 10),
            hideCall
                ? const SizedBox()
                : Expanded(
                    flex: 7,
                    child: GestureDetector(
                      onTap: () {
                        TrudaLocalController.startMe(
                            _controller.herId, _controller.portrait);
                      },
                      child: AspectRatio(
                        aspectRatio: 70 / 18,
                        child: Container(
                          decoration: const BoxDecoration(
                            // color: TrudaColors.baseColorGreen,
                            // borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images_sized/newhita_host_bg_call.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                margin: EdgeInsetsDirectional.only(end: 10),
                                child: Image.asset(
                                    "assets/images_ani/newhita_host_call.webp"),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    TrudaLanguageKey
                                        .newhita_grade_video_chat.tr,
                                    style: const TextStyle(
                                        color: TrudaColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  hideCall
                                      ? const SizedBox()
                                      : Text.rich(TextSpan(
                                          text:
                                              "${_controller.detail?.charge ?? '--'}",
                                          style: const TextStyle(
                                              color: TrudaColors.white,
                                              fontSize: 12),
                                          children: [
                                              WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Image.asset(
                                                      "assets/images/newhita_diamond_small.png")),
                                              TextSpan(
                                                  text: TrudaLanguageKey
                                                      .newhita_video_time_unit
                                                      .tr),
                                            ]))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
          ],
        ),
      );
    });
  }

  Widget _detailInfo(TrudaHostController _controller) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  (_controller.detail?.nickname ?? '--').replaceNumByStar(),
                  style: const TextStyle(
                    color: TrudaColors.textColor333,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TrudaHostStateWidget(
                  isDoNotDisturb: _controller.detail?.isDoNotDisturb ?? 0,
                  isOnline: _controller.detail?.isOnline ?? 0,
                  style: 1,
                ),
              ],
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: _controller.detail?.username ?? '--'));
                  NewHitaLoading.toast(
                      TrudaLanguageKey.newhita_base_success.tr);
                },
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  // decoration: BoxDecoration(
                  //     color: TrudaColors.baseColorBg,
                  //     borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ID:${_controller.detail?.username ?? '--'}',
                        style: const TextStyle(
                            color: TrudaColors.textColor999, fontSize: 14),
                      ),
                      Image.asset(
                        'assets/images/newhita_host_copy.png',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _getLables(TrudaHostDetail? detail) {
    List<Widget> list = [];
    if (detail == null) return list;
    list.add(Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0xFFFF51A8).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/newhita_base_female.png',
            width: 10,
            height: 10,
          ),
          Text(
            '${NewHitaFormatUtil.getAge(DateTime.fromMillisecondsSinceEpoch(detail.birthday ?? 0))}',
            style: const TextStyle(color: Color(0xFFFF51A8), fontSize: 12),
          ),
        ],
      ),
    ));
    return list;
  }

  Widget _mediaList(TrudaHostController _controller) {
    return Builder(builder: (context) {
      var allList = _controller.detail?.medias ?? <TrudaHostMedia>[];
      var itemList = <TrudaHostMedia>[];
      for (var media in allList) {
        // 黑名单
        if (TrudaStorageService.to
            .checkMediaReportList((media.mid ?? 0).toString())) {
          continue;
        }
        // ios审核模式
        if (media.vipVisible == 1 && TrudaConstants.appMode == 2) {
          continue;
        }
        itemList.add(media);
      }
      return itemList.isEmpty
          ? ListView(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 150,
                  child: Image.asset(
                    'assets/images/newhita_base_empty.png',
                    height: 100,
                    width: 100,
                  ),
                )
              ],
            )
          : MasonryGridView.count(
              padding: EdgeInsets.symmetric(horizontal: 15),
              // 纵向元素间距
              mainAxisSpacing: 10,
              // 横向元素间距
              crossAxisSpacing: 10,
              //本身不滚动，让外面的singlescrollview来滚动
              // physics:const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              //收缩，让元素宽度自适应
              // 展示几列
              crossAxisCount: 3,
              // 元素总个数
              itemCount: itemList.length,
              // 单个子元素
              itemBuilder: (BuildContext context, int index) {
                var bean = itemList[index];
                // 这个用于过渡动画
                var heroId = bean.mid ?? index;
                bool needVip = bean.vipVisible == 1;
                return GestureDetector(
                  onTap: () {
                    var canNot = needVip && !TrudaMyInfoService.to.isVipNow;
                    // LindaMediaViewPage.startMe(context,
                    //     path: bean.path ?? '',
                    //     cover: bean.cover,
                    //     type: bean.type,
                    //     heroId: heroId);
                    if (canNot) {
                      TrudaCommonDialog.dialog(TrudaDialogConfirm(
                        callback: (i) {
                          TrudaVipController.openDialog(
                              createPath: TrudaChargePath
                                  .recharge_vip_dialog_anchor_details);
                        },
                        title: TrudaLanguageKey.newhita_vip_for_photo.tr,
                        content: TrudaLanguageKey.newhita_vip_upgrade_ask.tr,
                      ));
                      return;
                    }
                    var viewList = <TrudaHostMedia>[];
                    for (var media in itemList) {
                      if (media.vipVisible == 1 &&
                          !TrudaMyInfoService.to.isVipNow) {
                        continue;
                      }
                      viewList.add(media);
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TrudaMediaPage.hostMedia(
                                  list: viewList,
                                  position: viewList.indexOf(bean),
                                ))).then((value) {
                      if (value == 1) {
                        _controller.update();
                      }
                    });
                  },
                  child: Hero(
                    tag: heroId,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (needVip && !TrudaMyInfoService.to.isVipNow)
                          ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(14),
                            child: ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              // 注意这里vip图片path会返回N/A
                              child: NewHitaNetImage(bean.type == 1
                                  ? bean.cover ?? ''
                                  : _controller.detail?.portrait ?? ''),
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(14),
                            child: NewHitaNetImage(
                              bean.type == 1
                                  ? bean.cover ?? ''
                                  : bean.path ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (bean.type == 1)
                          Image.asset(
                              'assets/images/newhita_base_video_play.png'),
                        if (needVip)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Image.asset(
                                'assets/images/newhita_host_vip_user.png'),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }

  Widget _momentList(TrudaHostController _controller) {
    return ListView.builder(
        itemCount: _controller.momentList.length,
        padding: const EdgeInsets.all(15),
        itemBuilder: (context, index) {
          var bean = _controller.momentList[index];
          String? updateTime;
          var time = DateTime.fromMillisecondsSinceEpoch(bean.createdAt ?? 0);
          updateTime = DateFormat('MM/dd').format(time);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: DateFormat('MM').format(time),
                          style: const TextStyle(
                              color: TrudaColors.textColor333,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: DateFormat('/dd').format(time),
                          style: const TextStyle(
                              color: TrudaColors.textColor333,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: TrudaColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (bean.content != null && bean.content!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                bean.content ?? '',
                                style: const TextStyle(
                                  color: TrudaColors.textColor000,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          if (bean.medias?.isNotEmpty == true)
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 0,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 5,
                                crossAxisCount:
                                    bean.medias!.length == 1 ? 2 : 3,
                              ),
                              itemCount: bean.medias!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                var media = bean.medias![index];
                                var heroId = (bean.createdAt ??
                                        DateTime.now().millisecondsSinceEpoch) +
                                    index;
                                return GestureDetector(
                                  onTap: () {
                                    // NewHitaMediaViewPage.startMe(context,
                                    //     path: media.mediaUrl ?? '',
                                    //     cover: media.screenshotUrl,
                                    //     type: media.mediaType,
                                    //     heroId: heroId);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                TrudaMediaPage.momentMedia(
                                                  list: bean.medias!,
                                                  position: index,
                                                )));
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Hero(
                                        tag: heroId,
                                        child: NewHitaNetImage(
                                          media.mediaType == 1
                                              ? media.screenshotUrl!
                                              : media.mediaUrl!,
                                          radius: 8,
                                        ),
                                      ),
                                      if (media.mediaType == 1)
                                        Image.asset(
                                            'assets/images/newhita_base_video_play.png'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  var hadPraised = bean.praised == 1;
                                  if (hadPraised) {
                                    bean.praised = 0;
                                    bean.praiseCount =
                                        (bean.praiseCount ?? 1) - 1;
                                  } else {
                                    bean.praised = 1;
                                    bean.praiseCount =
                                        (bean.praiseCount ?? 0) + 1;
                                  }
                                  _controller.priseMoment(
                                      bean.momentId ?? '', !hadPraised);
                                  _controller.update();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        bean.praised == 1
                                            ? 'assets/images/newhita_moment_heart_red.png'
                                            : 'assets/images/newhita_moment_heart.png',
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        (bean.praiseCount ?? 0).toString(),
                                        style: const TextStyle(
                                            color: TrudaColors.textColor999,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _controller.reportMoment(
                                      bean.momentId!, index);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/newhita_moment_report.png',
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        TrudaLanguageKey
                                            .newhita_report_title.tr,
                                        style: const TextStyle(
                                            color: TrudaColors.textColor999,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }
}
