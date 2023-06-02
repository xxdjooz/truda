import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_pages/main/home/truda_home_ios_controller.dart';
import 'package:truda/truda_pages/main/home/truda_home_page.dart';
import 'package:truda/truda_pages/main/moment/newhita_moment_list_page.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_routes/newhita_pages.dart';
import '../../../truda_widget/newhita_image_indicator.dart';
import 'truda_follow_page.dart';

class TrudaHomeIosPage extends StatefulWidget {
  TrudaHomeIosPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrudaHomeIosPageState();
}

class _TrudaHomeIosPageState extends State<TrudaHomeIosPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;
  final TrudaHomeIosController _homeController =
      Get.put(TrudaHomeIosController());
  int currentPageIndex = 0;
  var showAction = true.obs;
  ui.Image? indicator;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (currentPageIndex == _tabController.index) return;
      currentPageIndex = _tabController.index;
      showAction.value = currentPageIndex == 0;
    });

    getAssetImage('assets/images_sized/newhita_circle_indicator.png').then((value) {
      setState(() {
        indicator = value;
      });
    });
  }

  // https://blog.csdn.net/lal95828/article/details/108567013
  //方法2.1：获取本地图片  返回ui.Image 需要传入BuildContext context
  Future<ui.Image> getAssetImage2(String asset, BuildContext context,
      {width, height}) async {
    ByteData data = await DefaultAssetBundle.of(context).load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  //方法2.2：获取本地图片 返回ui.Image 不需要传入BuildContext context
  Future<ui.Image> getAssetImage(String asset, {width, height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
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
          indicator: indicator == null ? null : NewHitaImageIndicator(indicator!),
          tabs: [
            Tab(text: TrudaLanguageKey.newhita_home_tab_hot.tr),
            Tab(text: TrudaLanguageKey.newhita_home_tab_follow.tr)
          ],
          controller: _tabController,
          labelStyle: const TextStyle(
            fontSize: 18,
            color: TrudaColors.textColor333,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            color: TrudaColors.textColor666,
          ),
          labelColor: TrudaColors.textColor333,
          unselectedLabelColor: TrudaColors.textColor666,
        ),
        actions: [
          GestureDetector(
            child: Image.asset('assets/images/newhita_moment_create.png'),
            onTap: () {
              Get.toNamed(NewHitaAppPages.createMoment);
            },
          ),
          // const SizedBox(
          //   width: 10,
          // )
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
        children: [NewHitaMomentListPage(iosMock:true), TrudaFollowPage()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
