import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_common/truda_colors.dart';
import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_routes/newhita_pages.dart';
import '../../../truda_services/newhita_my_info_service.dart';
import '../../../truda_utils/newhita_log.dart';
import '../../vip/newhita_vip_controller.dart';
import 'newhita_jellyfish_game.dart';
import 'newhita_match_controller.dart';
import 'newhita_match_fake_controller.dart';

class NewHitaMatchPage extends StatefulWidget {
  // 每天免费次数
  static int totalMatchTimes = 10;

  // 今天次数
  static var todayMatchTimes = 0.obs;

  NewHitaMatchPage({Key? key}) : super(key: key);

  @override
  State<NewHitaMatchPage> createState() => _NewHitaMatchPageState();
}

class _NewHitaMatchPageState extends State<NewHitaMatchPage>
    with WidgetsBindingObserver, RouteAware {
  @override
  void initState() {
    super.initState();
    // 注册应用生命周期监听
    WidgetsBinding.instance?.addObserver(this);
    Wakelock.enable();

    if (NewHitaMyInfoService.to.config?.matchTimes is int) {
      NewHitaMatchPage.totalMatchTimes =
          NewHitaMyInfoService.to.config?.matchTimes ?? 10;
    }
  }

  /// 监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(':didChangeAppLifecycleState:$state');
    switch (state) {
      // 处于这种状态的应用程序应该假设他们可能在任何时候暂停
      case AppLifecycleState.inactive:
        // ios 退到桌面会到这里
        handleMusic(false);
        break;
      // 从后台切前台，界面可见
      case AppLifecycleState.resumed:
        NewHitaLog.debug("NewHitaMatchPage route=${Get.currentRoute}");
        if (Get.currentRoute != NewHitaAppPages.main) return;
        handleMusic(true);
        break;
      // 界面不可见，后台
      case AppLifecycleState.paused:
        handleMusic(false);
        break;
      // APP 结束时调用
      case AppLifecycleState.detached:
        break;
    }
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
    WidgetsBinding.instance?.removeObserver(this);
    Wakelock.disable();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    handleMusic(true);
    NewHitaLog.debug('NewHitaMatchPage didPopNext');
  }

  @override
  void didPushNext() {
    handleMusic(false);
    super.didPushNext();
    NewHitaLog.debug('NewHitaMatchPage didPushNext');
  }

  // 分为正常的模式和ios审核模式
  void handleMusic(bool play) {
    if (TrudaConstants.appMode == 2) {
      Get.find<NewHitaMatchFakeController>().setBgmPlay(play);
    } else {
      Get.find<NewHitaMatchController>().setBgmPlay(play);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 分为正常的模式和ios审核模式
    if (TrudaConstants.appMode != 2) {
      Get.put(NewHitaMatchController());
      return GetBuilder<NewHitaMatchController>(
        initState: (c) {
          NewHitaLog.debug('NewHitaMatchPage initState');
        },
        dispose: (c) {
          NewHitaLog.debug('NewHitaMatchPage dispose');
          Get.delete<NewHitaMatchController>();
        },
        builder: (contr) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                TrudaLanguageKey.newhita_match_poke.tr,
              ),
              // toolbarHeight: 0,
            ),
            extendBodyBehindAppBar: true,
            body: SizedBox.expand(
              child: Stack(
                children: [
                  GameWidget(game: JellyfishGame(contr.showMatched)),
                  PositionedDirectional(
                    start: 10,
                    end: 10,
                    bottom: 95,
                    child: Container(
                      decoration: BoxDecoration(
                        color: NewHitaMyInfoService.to.isVipNow
                            ? Colors.transparent
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!NewHitaMyInfoService.to.isVipNow)
                            Obx(() {
                              final total =
                                  NewHitaMatchPage.totalMatchTimes.toString();
                              var today = NewHitaMatchPage.totalMatchTimes -
                                  NewHitaMatchPage.todayMatchTimes.value;
                              if (today <= 0) {
                                today = 0;
                              }
                              return Text(
                                TrudaLanguageKey.newhita_vip_match_rule_1
                                    .trArgs([total, today.toString()]),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TrudaColors.white,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }),
                          if (!NewHitaMyInfoService.to.isVipNow &&
                              TrudaConstants.appMode != 2)
                            Text(
                              TrudaLanguageKey.newhita_vip_match_rule_2.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: TrudaColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          SizedBox(
                            height: 4,
                          ),
                          if (!NewHitaMyInfoService.to.isVipNow &&
                              TrudaConstants.appMode != 2)
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  NewHitaVipController.openDialog(
                                      createPath: TrudaChargePath
                                          .recharge_vip_dialog_match);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: Text(
                                    TrudaLanguageKey
                                        .newhita_vip_upgrade_now.tr,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: Color(0xffFFED1C)),
                                  ),
                                ),
                              ),
                            )
                          else
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                child: Text(
                                  TrudaLanguageKey
                                      .newhita_vip_already.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffFFED1C)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    // ios审核模式
    Get.put(NewHitaMatchFakeController());
    return GetBuilder<NewHitaMatchFakeController>(
      initState: (c) {
        NewHitaLog.debug('NewHitaMatchPage initState');
      },
      dispose: (c) {
        NewHitaLog.debug('NewHitaMatchPage dispose');
        Get.delete<NewHitaMatchFakeController>();
      },
      builder: (contr) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              TrudaLanguageKey.newhita_match_poke.tr,
            ),
            // toolbarHeight: 0,
            actions: [
              GestureDetector(
                onTap: () => Get.toNamed(NewHitaAppPages.createMoment),
                child: Center(
                    child: Image.asset(
                  'assets/images/newhita_moment_create.png',
                )),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images_sized/newhita_match_bg.webp',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned.fill(
                child: GameWidget(game: JellyfishGame(contr.showMatched)),
              ),
            ],
          ),
        );
      },
    );
  }
}
