import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../../../truda_dialogs/truda_sheet_msg_option.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_utils/truda_ui_image_util.dart';
import '../../../truda_widget/newhita_image_indicator.dart';
import '../home/truda_home_page.dart';
import 'truda_msg_page.dart';

class TrudaMsgTab extends StatefulWidget {
  TrudaMsgTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrudaMsgTabState();
}

class _TrudaMsgTabState extends State<TrudaMsgTab>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        RouteAware {
  late final TabController controller;
  ui.Image? indicator;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 1, vsync: this);
    TrudaUiImageUtil.getAssetImage('assets/images_sized/newhita_circle_indicator.png')
        .then((value) {
      setState(() {
        indicator = value;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TrudaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    TrudaAppPages.observer.unsubscribe(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    TrudaLog.debug('NewHitaMsgTab didPopNext');
    // 发现Get.bottomSheet的弹窗关闭也会走到这里
  }

  @override
  Widget build(BuildContext context) {
    TrudaLog.debug("NewHitaMsgPage build");
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
          indicator: indicator == null ? null : NewHitaImageIndicator(indicator!),
          tabs: [
            Tab(text: TrudaLanguageKey.newhita_base_message.tr),
            // Tab(text: TrudaLanguageKey.newhita_home_tab_follow.tr)
          ],
          controller: controller,
          labelStyle: const TextStyle(
              fontSize: 24,
              color: TrudaColors.white,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              const TextStyle(fontSize: 20, color: Colors.white38),
          labelColor: TrudaColors.white,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return TrudaSheetMsgOption();
                  });
            },
            child: Image.asset(
              'assets/images/newhita_conver_more.png',
              width: 48,
              height: 48,
            ),
          ),
          const SizedBox(width: 15),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: TabBarView(
        controller: controller,
        children: [
          TrudaMsgPage(),
          // NewHitaMsgFollowPage(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
