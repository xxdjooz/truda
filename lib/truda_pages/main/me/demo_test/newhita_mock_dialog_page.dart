import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_dialogs/truda_dialog_confirm.dart';
import 'package:truda/truda_entities/truda_match_host_entity.dart';
import 'package:truda/truda_pages/vip/newhita_vip_controller.dart';

import '../../../../truda_common/truda_common_dialog.dart';
import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_dialogs/truda_dialog_bind_tip.dart';
import '../../../../truda_dialogs/truda_dialog_call_sexy.dart';
import '../../../../truda_dialogs/truda_dialog_confirm_black.dart';
import '../../../../truda_dialogs/truda_dialog_confirm_hang.dart';
import '../../../../truda_dialogs/truda_dialog_create_moment.dart';
import '../../../../truda_dialogs/truda_dialog_first_tip.dart';
import '../../../../truda_dialogs/truda_dialog_invite_for_diamond.dart';
import '../../../../truda_dialogs/truda_dialog_level_up.dart';
import '../../../../truda_dialogs/truda_dialog_lottery_get.dart';
import '../../../../truda_dialogs/truda_dialog_match_one.dart';
import '../../../../truda_dialogs/truda_dialog_new_user.dart';
import '../../../../truda_dialogs/truda_dialog_vip_diamond_get.dart';
import '../../../../truda_dialogs/truda_dialog_visitor_tip.dart';
import '../../../../truda_entities/truda_leval_entity.dart';
import '../../../../truda_entities/truda_lottery_entity.dart';
import '../../../../truda_services/newhita_storage_service.dart';
import '../../../../truda_utils/newhita_app_rate.dart';
import '../../../../truda_utils/newhita_permission_handler.dart';
import '../../../../truda_widget/newhita_gradient_boder.dart';
import '../../../call/newhita_count_20.dart';
import '../../../charge/success/newhita_success_controller.dart';
import '../../../vip/newhita_vip_dialog.dart';

class NewHitaMockDailogPage extends StatefulWidget {
  const NewHitaMockDailogPage({Key? key}) : super(key: key);

  @override
  State<NewHitaMockDailogPage> createState() => _NewHitaMockDailogPageState();
}

class _NewHitaMockDailogPageState extends State<NewHitaMockDailogPage> {
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
    Directionality.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: () {
                    TrudaCommonDialog.dialog(TrudaDialogConfirm(
                      title: 'hahahahaha',
                      onlyConfirm: true,
                      callback: (int callback) {},
                    ));
                  },
                  child: const Text('确认弹窗样式'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaCommonDialog.dialog(TrudaFirstTip());
                  },
                  child: const Text('文明弹窗'),
                ),
                OutlinedButton(
                  onPressed: () {
                    // NewHitaAppRate.showFakeRateApp();
                    NewHitaAppRate.showGoogleRate();
                  },
                  child: const Text('app评分'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.dialog(TrudaDialogConfirmHang(
                      title: TrudaLanguageKey.newhita_call_hang_up_tip.tr,
                      callback: (i) {},
                      isPick: false,
                    ));
                  },
                  child: const Text('确认挂电话'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaCommonDialog.dialog(TrudaDialogVipDiamondGet(
                      diamond: 7,
                    ));
                  },
                  child: const Text('vip领取钻石'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.bottomSheet(
                      NewHitaVipDialog(
                        createPath: '',
                      ),
                      // 不加这个默认最高屏幕一半
                      isScrollControlled: true,
                    );
                  },
                  child: const Text('vip充值弹窗'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaStorageService.to.prefs
                        .setInt(TrudaDialogInvite.strInviteOthers, 2);
                    TrudaDialogInvite.checkToShow();
                  },
                  child: const Text('邀请领取钻石'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaSuccessController.startMeCheck(lottery: 2);
                  },
                  child: const Text('充值成功'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaCommonDialog.dialog(
                        TrudaUserLevelUpdate(TrudaLevalBean()
                          ..grade = 10
                          ..awardName = 'haha'));
                  },
                  child: const Text('等级提升'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.bottomSheet(NewHitaCount20(
                      leftSecond: 20,
                      callback: (go) {},
                    ));
                  },
                  child: const Text('电话20s倒计时'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaDialogCallSexy.checkToShow((i) {});
                  },
                  child: const Text('电话鉴黄'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaCommonDialog.dialog(NewTrudaUserCardsTip(3, null));
                  },
                  child: const Text('新用户送卡'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaCommonDialog.dialog(TrudaDialogConfirmBlack(
                      callback: (i) {},
                      userId: '',
                      portrait:
                          'https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG',
                    ));
                  },
                  child: const Text('拉黑用户'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaLotteryBean bean = TrudaLotteryBean();
                    TrudaCommonDialog.dialog(
                      TrudaDialogLotteryGet(
                        bean: bean,
                      ),
                      barrierColor: Colors.black87,
                    );
                  },
                  child: const Text('抽奖结果'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaCommonDialog.dialog(TrudaDialogCreateMoment());
                  },
                  child: const Text('发动态提醒'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaMatchHost host = TrudaMatchHost();
                    host.portrait =
                        "https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG";
                    host.userId = '';
                    host.nickName = 'test aa aa aa aa';
                    host.userId = '107780488';
                    // host.username = '1057644';
                    host.isOnline = 1;
                    host.video =
                        'https://yesme-public.oss-cn-hongkong.aliyuncs.com/app/testMp4.mp4';
                    TrudaDialogMatchOne.checkToShow(host);
                  },
                  child: const Text('匹配到一个主播'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaPermissionHandler.showPermissionNotify();
                  },
                  child: const Text('通知权限'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.dialog(TrudaVisitorTip(
                      account: 'aaabbb',
                      password: '111222',
                    ));
                  },
                  child: const Text('游客保存账号图片'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.dialog(TrudaBindTip());
                  },
                  child: const Text('绑定谷歌提醒'),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
