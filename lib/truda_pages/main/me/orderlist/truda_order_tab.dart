import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../../../../truda_routes/truda_pages.dart';
import '../../../../truda_widget/truda_app_bar.dart';
import 'truda_cost_list_page.dart';
import 'truda_order_list_page.dart';

class TrudaOrderTab extends StatefulWidget {
  TrudaOrderTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrudaOrderTabState();
}

class _TrudaOrderTabState extends State<TrudaOrderTab>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        RouteAware {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
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
      backgroundColor: TrudaColors.baseColorBlackBg,
      appBar: TrudaAppBar(
        backgroundColor: TrudaColors.white,
        title: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const BoxDecoration(),
          tabs: [
            Tab(
              text: TrudaLanguageKey.newhita_consumption_detail.tr,
            ),
            Tab(
              text: TrudaLanguageKey.newhita_order_details.tr,
            )
          ],
          controller: controller,
          labelStyle: const TextStyle(
              fontSize: 18,
              color: TrudaColors.textColor333,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            color: TrudaColors.textColor666,
          ),
          labelColor: TrudaColors.textColor333,
          unselectedLabelColor: TrudaColors.textColor666,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Image.asset('assets/images/newhita_conver_more.png'),
        //   )
        // ],
      ),
      body: TabBarView(
        controller: controller,
        children: [TrudaCostListPage(), TrudaOrderListPage()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
