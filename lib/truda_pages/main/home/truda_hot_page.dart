import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_pages/host/truda_host_controller.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:truda/truda_services/truda_app_info_service.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_utils/newhita_facebook_util.dart';
import '../../../truda_widget/newhita_net_image.dart';
import 'truda_host_widget.dart';
import 'truda_hot_controller.dart';

/// 这里他的state做了混入AutomaticKeepAliveClientMixin
/// 这样在TabBarView里面才能不会重复创建，不然会销毁的
class TrudaHotPage extends StatefulWidget {
  TrudaHotPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrudaHotPageState();
}

class _TrudaHotPageState extends State<TrudaHotPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int currentPageIndex = 0;
  List<Widget> countryTabs = [];
  late final TrudaHotController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(TrudaHotController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   toolbarHeight: 30,
      //   elevation: 0,
      //   titleSpacing: 4,
      //   backgroundColor: Colors.transparent,
      // ),
      body: Container(
        decoration: const BoxDecoration(
          color: TrudaColors.white,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(25), topStart: Radius.circular(25)),
        ),
        child: GetBuilder<TrudaHotController>(
            id: _controller.idList,
            builder: (controller) {
              return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: controller.enablePullUp,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  child: _controller.dataList.isEmpty
                      ? ListView(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: 300,
                              child: _controller.firstIn
                                  ? const CircularProgressIndicator()
                                  : Image.asset(
                                      'assets/images/newhita_base_empty.png',
                                      height: 100,
                                      width: 100,
                                    ),
                            )
                          ],
                        )
                      : CustomScrollView(
                          slivers: [
                            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 5),),
                            SliverToBoxAdapter(
                              child: TrudaBanner(),
                            ),
                            //卡片样式的item，意思就是一行可以排列多个
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 17 / 23),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    var bean = _controller.dataList[index];
                                    return TrudaHostWidget(
                                      detail: bean,
                                      callback: () {
                                        if (bean.videos?.isNotEmpty == true) {
                                          Get.toNamed(TrudaAppPages.herVideo,
                                              arguments: bean);
                                        } else {
                                          TrudaHostController.startMe(
                                              bean.userId!, bean.portrait);
                                        }
                                      },
                                    );
                                  },
                                  //item条数
                                  childCount: _controller.dataList.length,
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(
                                width: double.infinity,
                                height: 100,
                              ),
                            ),
                          ],
                        ));
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TrudaBanner extends GetView<TrudaHotController> {
  var currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaHotController>(
        id: controller.idBanner,
        builder: (controller) {
          if (controller.bannerList.isEmpty || TrudaConstants.isFakeMode) {
            return const SizedBox();
          }
          List<Widget> items = [];
          for (var bannerBean in controller.bannerList) {
            String cover = bannerBean.cover ?? "";
            items.add(GestureDetector(
              onTap: () async {
                if (bannerBean.link?.contains("/#") == true) {
                  //不做操作
                  return;
                }

                //跳转网页
                if (bannerBean.target == 0) {
                  if (await canLaunch(bannerBean.link ?? "")) {
                    launch(bannerBean.link ?? "");
                  }
                } else if (bannerBean.target == 1) {
                  //  打开app内页面
                  if (bannerBean.link?.contains("/user?id") == true) {
                    //  打开主播详情页
                    String? upid = bannerBean.link?.split("=").last;
                    if (upid != null) {
                      // CblRouterManager.pushNamed(UpCenterRouter, [upid, ""]);
                      TrudaHostController.startMe(upid, null);
                    }
                  } else if (bannerBean.link?.contains("/pay") == true) {
                    // todo
                    //  打开支付页面
                    // GetPlatform.isIOS
                    //     ? CblRouterManager.pushNamed(AppChargeRouter)
                    //     : CblRouterManager.pushNamed(GoogleChargeRouter);
                    Get.toNamed(TrudaAppPages.googleCharge);
                  } else if (bannerBean.link?.contains("/feedback") == true) {
                    // todo
                    //  打开客服
                    // CblRouterManager.pushNamed(ReportUpRouter);
                  } else if (bannerBean.link?.contains("/whatsApp=") == true) {
                    //  打开whatsapp
                    String? whatsappid = bannerBean.link?.split("=").last;
                    if (whatsappid != null) {
                      final info = await PackageInfo.fromPlatform();
                      var appVersion = TrudaAppInfoService.to.version;
                      var AppSystemVersionKey =
                          TrudaAppInfoService.to.AppSystemVersionKey;
                      var myId = TrudaMyInfoService.to.userLogin?.username ??
                          "unkown";
                      String url =
                          "https://wa.me/${whatsappid}/?text=AppName:${info.appName},appVersion:${appVersion},"
                          "System:${GetPlatform.isIOS ? 'iOS' : 'Android'}${AppSystemVersionKey},uid:$myId}";
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    }
                  } else if (bannerBean.link?.contains("play.google.com") ==
                      true) {
                    //打开google play
                    String? package = bannerBean.link?.split("=").last;
                    if (package != null) {
                      gotoGooglePlay(package);
                    }
                  } else if (bannerBean.link?.contains("/shareApp") == true) {
                    //打开google play
                    Get.toNamed(TrudaAppPages.invitePage);
                  }
                }
              },
              child: Container(
                color: Colors.transparent,
                child: AspectRatio(
                  aspectRatio: 346 / 122.0,
                  child: NewHitaNetImage(
                    cover,
                  ),
                ),
              ),
            ));
          }
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: 6),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          viewportFraction: 1,
                          aspectRatio: 346 / 122.0,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          onPageChanged:
                              (int index, CarouselPageChangedReason reason) {
                            // upListController.indicatorIndex.value = index;
                            currentIndex.value = index;
                          }),
                      items: items,
                    ),
                  ),
                ),
                Obx(() {
                  return Positioned(
                    bottom: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          controller.bannerList.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(currentIndex.value == entry.key
                                      ? 0.9
                                      : 0.4)),
                        );
                      }).toList(),
                    ),
                  );
                })
              ],
            ),
          );
        });
  }
}
