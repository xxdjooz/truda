import 'package:flutter/material.dart';

import '../truda_common/truda_colors.dart';
import 'truda_home_indicator.dart';

class TrudaHomeTabBar extends TabBar {
  TrudaHomeTabBar(
      {Key? key, required List<Widget> tabs, final TabController? controller})
      : super(
          key: key,
          tabs: tabs,
          controller: controller,
          labelStyle: const TextStyle(
              fontSize: 18,
              color: TrudaColors.white,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              const TextStyle(fontSize: 16, color: Colors.white38),
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: TrudaHomeTabIndicator(),
          indicatorWeight: 0,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          // indicatorPadding:
          //     EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        );

  @override
  Size get preferredSize => Size.fromHeight(30);
}
