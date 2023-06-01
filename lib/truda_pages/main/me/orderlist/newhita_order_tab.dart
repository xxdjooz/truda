import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../../../../truda_routes/newhita_pages.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import 'newhita_cost_list_page.dart';
import 'newhita_order_list_page.dart';

class NewHitaOrderTab extends StatefulWidget {
  NewHitaOrderTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewHitaOrderTabState();
}

class _NewHitaOrderTabState extends State<NewHitaOrderTab>
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
    NewHitaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    NewHitaAppPages.observer.unsubscribe(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    NewHitaLog.debug('NewHitaMsgTab didPopNext');
    // 发现Get.bottomSheet的弹窗关闭也会走到这里
  }

  @override
  Widget build(BuildContext context) {
    NewHitaLog.debug("NewHitaMsgPage build");
    return Scaffold(
      backgroundColor: TrudaColors.baseColorBlackBg,
      appBar: NewHitaAppBar(
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
        children: [NewHitaCostListPage(), NewHitaOrderListPage()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
