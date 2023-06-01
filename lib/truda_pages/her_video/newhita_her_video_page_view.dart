import 'dart:async';

import 'package:disable_screenshots/disable_screenshots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_services/newhita_host_video_service.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:wakelock/wakelock.dart';

import '../../truda_entities/truda_host_entity.dart';
import '../../truda_routes/newhita_pages.dart';
import 'newhita_her_video_page_item.dart';

/// https://static.ybhospital.net/test-video-4.mp4
class NewHitaHerVideoPageView extends StatefulWidget {
  NewHitaHerVideoPageView({Key? key}) : super(key: key);

  @override
  _NewHitaHerVideoPageViewState createState() => _NewHitaHerVideoPageViewState();
}

class _NewHitaHerVideoPageViewState extends State<NewHitaHerVideoPageView>
    with WidgetsBindingObserver, RouteAware {
  late PageController _pageController;

  List<TrudaHostDetail> videoDataList = [];
  final StreamController<int> _streamController =
      StreamController.broadcast(sync: false);
  var currentPage = 0;
  bool? hadShowDrag;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _streamController.add(0);
    }
  }

  @override
  void didPushNext() {
    super.didPushNext();
    NewHitaLog.debug('_HerVideoPageState didPushNext');
    _streamController.add(0);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    NewHitaLog.debug('_HerVideoPageState didPopNext');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册页面路由监听
    NewHitaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    DisableScreenshots().disableScreenshots(false);
    Wakelock.disable();
    super.dispose();
    _streamController.close();
    // 移除页面路由监听
    NewHitaAppPages.observer.unsubscribe(this);
  }

  @override
  void initState() {
    videoDataList = NewHitaHostVideoService.to.dataList;
    var initIndex = 0;
    var host = Get.arguments;
    if (host != null) {
      TrudaHostDetail detail = host as TrudaHostDetail;
      for (var index = 0; index < videoDataList.length; index++) {
        var video = videoDataList[index];
        NewHitaLog.debug(
            '_HerVideoPageState initState video.userId=${video.userId}  detail.userId=${detail.userId}');
        if (video.userId == detail.userId) {
          initIndex = index;
          break;
        }
      }
    }
    NewHitaLog.debug('_HerVideoPageState initState initIndex=$initIndex');
    _pageController = PageController(initialPage: initIndex);
    WidgetsBinding.instance!.addObserver(this);
    DisableScreenshots().disableScreenshots(true);
    Wakelock.enable();

    super.initState();

    _pageController.addListener(() {
      var p = _pageController.page!;
      NewHitaLog.debug('NewHitaHerVideoPage2 _pageController $p');
      if (p % 1 == 0) {
        // loadIndex(p ~/ 1);
        final lastPage = currentPage;
        currentPage = p ~/ 1;
        if (_checkNeeLoadMore(currentPage, lastPage)) {
          NewHitaHostVideoService.to.getMore().then((value) {
            setState(() {});
          });
        }
      }
      if (hadShowDrag != true && (p % 1 > 0.5)) {
        setState(() {
          hadShowDrag = true;
          NewHitaStorageService.to.prefs
              .setBool(TrudaConstants.hadShowDragTip, true);
        });
      }
    });

    hadShowDrag =
        NewHitaStorageService.to.prefs.getBool(TrudaConstants.hadShowDragTip);

    Future.delayed(Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (videoDataList.length < 3) {
        NewHitaHostVideoService.to.getMore().then((value) {
          setState(() {});
        });
      }
    });
  }

  bool _checkNeeLoadMore(int currentPage, int lastPage) {
    if (videoDataList.length == 1) {
      return true;
    }
    if (videoDataList.length == 2 && currentPage == 1) {
      return true;
    }
    if (videoDataList.length > 2 &&
        currentPage > lastPage &&
        currentPage == videoDataList.length - 2) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    // 组合
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PageView.builder(
          // key: Key('HerVideoPage'),
          physics: NewHitaQuickerScrollPhysics(),
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: videoDataList.length,
          itemBuilder: (context, i) {
            var detail = videoDataList[i];
            return NewHitaHerVideoPageItem(
              detail: detail,
              streamController: _streamController,
            );
          },
        ),
        if (hadShowDrag != true)
          IgnorePointer(
            child: Center(
              child: Image.asset(
                'assets/images_ani/newhita_video_fling.webp',
                height: 200,
              ),
            ),
          ),
      ],
    );
  }
}

class NewHitaQuickerScrollPhysics extends BouncingScrollPhysics {
  const NewHitaQuickerScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  NewHitaQuickerScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NewHitaQuickerScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.2,
        stiffness: 300.0,
        ratio: 1.1,
      );
}
