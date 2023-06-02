import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_pages/main/home/truda_page_index_manager.dart';
import 'package:truda/truda_pages/main/newhita_main_controller.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_socket/newhita_socket_manager.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_routes/newhita_pages.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_utils/newhita_pay_cache_manager.dart';
import '../../truda_widget/newhita_decoration_bg.dart';
import 'home/truda_home_page.dart';
import 'match/truda_match_page.dart';
import 'me/newhita_me_page.dart';
import 'moment/newhita_moment_list_page.dart';
import 'msg/newhita_msg_tab.dart';

class NewHitaMainPage extends StatefulWidget {
  NewHitaMainPage({Key? key}) : super(key: key);

  @override
  State<NewHitaMainPage> createState() => _NewHitaMainPageState();
}

class _NewHitaMainPageState extends State<NewHitaMainPage>
    with RouteAware, WidgetsBindingObserver {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NewHitaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void initState() {
    super.initState();
    NewHitaPayCacheManager.clearValidOrder();
    //App 的⽣命周期
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    NewHitaLog.debug('NewHitaMainPage dispose');
    NewHitaAppPages.observer.unsubscribe(this);
    //App 的⽣命周期
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    NewHitaLog.debug('NewHitaMainPage didPopNext');
    // 发现Get.bottomSheet的弹窗关闭也会走到这里
    NewHitaPayCacheManager.checkOrderList();
    TrudaPageIndexManager.setMainShow(true);
  }

  @override
  void didPushNext() {
    super.didPushNext();
    TrudaPageIndexManager.setMainShow(false);
  }

  //App 的⽣命周期
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    NewHitaLog.debug('NewHitaMainPage didChangeAppLifecycleState $state');
    if (state == AppLifecycleState.paused) {
      // went to Background
      NewHitaAppPages.isAppBackground = true;
      NewHitaSocketManager.to.breakenSocket(dying: false);
    }
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
      NewHitaAppPages.isAppBackground = false;
      NewHitaSocketManager.to.init();
    }
    if (state == AppLifecycleState.inactive) {}
  }

  var lastClickTime = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewHitaMainController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          var nowTime = DateTime.now().millisecondsSinceEpoch;
          if (nowTime - lastClickTime < 800 && lastClickTime != 0) {
            return true;
          }
          lastClickTime = nowTime;
          return false;
        },
        child: Scaffold(
          backgroundColor: TrudaColors.baseColorBlackBg,
          body: Container(
            decoration: const NewHitaDecorationBg(),
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView(
                  pageSnapping: false,
                  scrollBehavior: null,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    TrudaHomePage(),
                    NewHitaMomentListPage(),
                    TrudaMatchPage(),
                    NewHitaMsgTab(),
                    NewHitaMePage(),
                  ],
                  controller: controller.pageController,
                  // onPageChanged: controller.handlePageChanged,
                ),
                PositionedDirectional(
                    start: 10,
                    end: 10,
                    bottom: 10,
                    child: Obx(() {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BottomNavigationBar(
                          backgroundColor: const Color(0xFF26073E),
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              activeIcon: Image.asset(
                                  'assets/images/newhita_main_home_s.png'),
                              icon: Image.asset(
                                  'assets/images/newhita_main_home.png'),
                              label: '',
                              backgroundColor: Colors.black12,
                            ),
                            BottomNavigationBarItem(
                              activeIcon: Image.asset(
                                  'assets/images/newhita_main_discover_s.png'),
                              icon: Image.asset(
                                  'assets/images/newhita_main_discover.png'),
                              label: '',
                              backgroundColor: Colors.black12,
                            ),
                            BottomNavigationBarItem(
                              activeIcon: Image.asset(
                                  'assets/images/newhita_main_play_s.png'),
                              icon: Image.asset(
                                  'assets/images/newhita_main_play.png'),
                              label: '',
                              backgroundColor: Colors.black12,
                            ),
                            BottomNavigationBarItem(
                              activeIcon: NewHitaMsgNum(
                                checked: true,
                              ),
                              icon: NewHitaMsgNum(
                                checked: false,
                              ),
                              label: '',
                              backgroundColor: Colors.black12,
                            ),
                            BottomNavigationBarItem(
                              activeIcon: Image.asset(
                                  'assets/images/newhita_main_me_s.png'),
                              icon: Image.asset(
                                  'assets/images/newhita_main_me.png'),
                              label: '',
                              backgroundColor: Colors.black12,
                            ),
                          ],
                          currentIndex: controller.currentIndex.value,
                          // fixedColor: AppColors.primaryElement,
                          type: BottomNavigationBarType.fixed,
                          onTap: controller.handleNavBarTap,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                        ),
                      );
                    })),
              ],
            ),
          ),
          // bottomNavigationBar: ,
        ),
      );
    });
  }
}

class NewHitaMsgNum extends StatefulWidget {
  bool checked;

  NewHitaMsgNum({Key? key, required this.checked}) : super(key: key);

  @override
  State<NewHitaMsgNum> createState() => _NewHitaMsgNumState();
}

class _NewHitaMsgNumState extends State<NewHitaMsgNum> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.checked
              ? 'assets/images/newhita_main_msg_s.png'
              : 'assets/images/newhita_main_msg.png'),
        ),
      ),
      alignment: AlignmentDirectional.topEnd,
      child: Obx(() {
        var num = NewHitaMyInfoService.to.msgUnreadNum.value;
        // NewHitaLog.debug('_NewHitaMsgNumState num=$num');
        if (num > 0) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
            child: Text(
              '$num',
              style: TextStyle(color: TrudaColors.white, fontSize: 12),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
