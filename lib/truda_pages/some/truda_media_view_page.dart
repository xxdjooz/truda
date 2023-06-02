import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:truda/truda_entities/truda_moment_entity.dart';
import 'package:truda/truda_widget/truda_app_bar.dart';
import 'package:wakelock/wakelock.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_entities/truda_host_entity.dart';
import '../../truda_routes/truda_pages.dart';
import '../../truda_utils/truda_log.dart';
import '../../truda_widget/truda_net_image.dart';
import '../../truda_widget/truda_player_android.dart';

class TrudaMediaPage extends StatefulWidget {
  int position;
  List<TrudaMediaViewBean> beanList = [];

  TrudaMediaPage.hostMedia({
    Key? key,
    required List<TrudaHostMedia> list,
    required this.position,
  })  : beanList = list
            .map((item) => TrudaMediaViewBean(
                (item.mid ?? 0).toString(),
                item.path ?? '',
                item.cover,
                item.type ?? 0,
                item.mid ?? 0,
                true))
            .toList(),
        super(key: key);

  TrudaMediaPage.momentMedia({
    Key? key,
    required List<TrudaMomentMedia> list,
    required this.position,
  })  : beanList = list
            .map((item) => TrudaMediaViewBean(
                item.mediaId ?? '',
                item.mediaUrl ?? '',
                item.screenshotUrl,
                item.mediaType ?? 0,
                0,
                true))
            .toList(),
        super(key: key);

  @override
  State<TrudaMediaPage> createState() =>
      _TrudaMediaPageState();
}

class _TrudaMediaPageState
    extends State<TrudaMediaPage>
    with WidgetsBindingObserver, RouteAware {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  // 这个给子控件发送事件，控制停止播放
  final StreamController<int> _streamController =
  StreamController.broadcast(sync: false);
  @override
  void initState() {
    super.initState();
    _current = widget.position;
    // 注册应用生命周期监听
    WidgetsBinding.instance?.addObserver(this);
    Wakelock.enable();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册页面路由监听
    TrudaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    // 移除生命周期监听
    WidgetsBinding.instance?.removeObserver(this);

    // 移除页面路由监听
    TrudaAppPages.observer.unsubscribe(this);
    Wakelock.disable();
    _streamController.close();
  }

  /// 监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(':didChangeAppLifecycleState:$state');
    switch (state) {
    // 处于这种状态的应用程序应该假设他们可能在任何时候暂停
      case AppLifecycleState.inactive:
        break;
    // 从后台切前台，界面可见
      case AppLifecycleState.resumed:
        break;
    // 界面不可见，后台
      case AppLifecycleState.paused:
      // if (playing) _controller.pause();
        _streamController.add(0);
        break;
    // APP 结束时调用
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didPushNext() {
    super.didPushNext();
    TrudaLog.debug('LindaMediaViewPage didPushNext');
    // if (playing) _controller.pause();
    _streamController.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: NewHitaAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: TrudaColors.baseColorBlackBg,
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final double height = MediaQuery.of(context).size.height;
                return CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    initialPage: widget.position,
                    height: height,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: widget.beanList.length > 2,
                    // autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: widget.beanList.map((item) {
                    return Container(
                      child: Center(
                          child: TrudaMediaViewPage(
                        bean: item,
                            stream: _streamController.stream,
                      )),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.beanList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: _current == entry.key ? 12.0 : 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white12
                              : Colors.white70)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TrudaMediaViewBean {
  String? mId;
  String path;
  String? cover;
  int type;
  int heroId;
  bool noAppBar;

  TrudaMediaViewBean(
      this.mId, this.path, this.cover, this.type, this.heroId, this.noAppBar);
}

class TrudaMediaViewPage extends StatefulWidget {
  // String path;
  // String? cover;
  // int type;
  // int heroId;
  // bool noAppBar;
  TrudaMediaViewBean bean;
  Stream? stream;

  TrudaMediaViewPage({
    Key? key,
    required this.bean,
    this.stream,
    // this.cover,
    // this.noAppBar = false,
    // this.type = 0,
    // this.heroId = 0,
  }) : super(key: key);

  @override
  State<TrudaMediaViewPage> createState() => _TrudaMediaViewPageState();

  static void startMe(BuildContext context,
      {required int heroId,
      String? mId,
      required String path,
      String? cover,
      int? type}) {
    var bean = TrudaMediaViewBean(mId, path, cover, type ?? 0, heroId, false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TrudaMediaViewPage(
          bean: bean,
          // cover: cover,
          // heroId: heroId,
          // type: type ?? 0,
        ),
      ),
    );
  }
}

class _TrudaMediaViewPageState extends State<TrudaMediaViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.bean.noAppBar
          ? TrudaAppBar(
              actions: [
                if (widget.bean.mId != null)
                  GestureDetector(
                    child: Image.asset('assets/images/newhita_host_report.png'),
                    onTap: () async {
                      var result = await Get.toNamed(
                        TrudaAppPages.reportPageNew,
                        arguments: {
                          'reportType': 2,
                          'rId': widget.bean.mId,
                        },
                      );
                      if (result == 1) {
                        Get.back(result: 1);
                      }
                    },
                  ),
              ],
            )
          : TrudaAppBar(
              actions: [
                if (widget.bean.mId != null)
                  GestureDetector(
                    child: Image.asset('assets/images/newhita_host_report.png'),
                    onTap: () async {
                      var result = await Get.toNamed(
                        TrudaAppPages.reportPageNew,
                        arguments: {
                          'reportType': 2,
                          'rId': widget.bean.mId,
                        },
                      );
                      if (result == 1) {
                        Get.back(result: 1);
                      }
                    },
                  ),
              ],
            ),
      extendBodyBehindAppBar: true,
      backgroundColor: TrudaColors.textColor000,
      body: Hero(
        tag: widget.bean.heroId,
        child: SizedBox.expand(
            child: widget.bean.type == 0
                ? TrudaNetImage(
              widget.bean.path,
              fit: BoxFit.contain,
            )
                : TrudaPlayerAndroid(
              cover: widget.bean.cover,
              path: widget.bean.path,
              stream: widget.stream,
            )),
      ),
    );
  }

}
