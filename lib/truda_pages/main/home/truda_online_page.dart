import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_widget/newhita_home_tab_bar.dart';
import 'truda_host_widget.dart';
import 'truda_hot_controller.dart';
import 'truda_online_controller.dart';

class TrudaOnlinePage extends StatefulWidget {
  TrudaOnlinePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrudaOnlinePageState();
}

class _TrudaOnlinePageState extends State<TrudaOnlinePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int currentPageIndex = 0;
  List<Widget> countryTabs = [];
  late final TrudaOnlineController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(TrudaOnlineController());
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
              topEnd: Radius.circular(20),
              topStart: Radius.circular(20)),
        ),
        child: GetBuilder<TrudaOnlineController>(
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
                            child: Image.asset(
                              'assets/images/newhita_base_empty.png',
                              height: 100,
                              width: 100,
                            ),
                          )
                        ],
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 17 / 23),
                        itemCount: _controller.dataList.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          var bean = _controller.dataList[index];
                          return TrudaHostWidget(
                            detail: bean,
                          );
                        }),
              );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
