import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_entities/truda_order_entity.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../truda_widget/newhita_app_bar.dart';
import 'truda_invite_bonus_controller.dart';

class TrudaInviteBonusPage extends GetView<TrudaInviteBonusController> {
  TrudaInviteBonusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaInviteBonusController>(builder: (contro) {
      return Scaffold(
        appBar: NewHitaAppBar(
          title: Text(TrudaLanguageKey.newhita_invite_diamonds.tr),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: GetBuilder<TrudaInviteBonusController>(builder: (controller) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: controller.enablePullUp,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: controller.dataList.isEmpty
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
                : ListView.builder(
                    itemCount: controller.dataList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var bean = controller.dataList[index];
                      String? updateTime;
                      var time = DateTime.fromMillisecondsSinceEpoch(
                          bean.updatedAt ?? 0);
                      updateTime =
                          DateFormat('yyyy.MM.dd HH:mm').format(time);
                      return TrudaCostItem(bean);
                    }),
          );
        }),
      );
    });
  }
}

class TrudaCostItem extends StatelessWidget {
  TrudaCostBean costBean;

  TrudaCostItem(this.costBean);

  @override
  Widget build(BuildContext context) {
    String costType = "";
    switch (costBean.depletionType ?? 0) {
      case 0:
        {
          costType = TrudaLanguageKey.newhita_other_expense.tr;
        }
        break;
      case 1:
        {
          costType = TrudaLanguageKey.newhita_video_consumption.tr;
        }
        break;
      case 2:
        {
          costType = TrudaLanguageKey.newhita_audio_consumer.tr;
        }
        break;
      case 3:
        {
          costType = TrudaLanguageKey.newhita_present_consumption.tr;
        }
        break;
      case 4:
        {
          costType = TrudaLanguageKey.newhita_message_deduction.tr;
        }
        break;
      case 5:
        {
          costType = TrudaLanguageKey.newhita_sign_in_to_give.tr;
        }
        break;
      case 6:
        {
          costType = "punish";
        }
        break;
      case 7:
        {
          costType = "settlement";
        }
        break;
      case 11:
        {
          costType = TrudaLanguageKey.newhita_diamond_increase.tr;
        }
        break;
      case 12:
        {
          costType = TrudaLanguageKey.newhita_recharge.tr;
        }
        break;
      case 13:
        {
          costType = TrudaLanguageKey.newhita_subscription.tr;
        }
        break;
      // case 14:
      //   {
      //     costType = TrudaLanguageKey.newhita_offline_top_up.tr;
      //   }
      //   break;
      case 14:
        {
          costType = TrudaLanguageKey.newhita_offline_top_up.tr;
        }
        break;
      case 15:
        {
          costType = TrudaLanguageKey.newhita_diamond_increase.tr;
        }
        break;
      case 16:
        {
          costType = "Award";
        }
        break;
      case 10:
        {
          costType = TrudaLanguageKey.newhita_invite_bonus_charge
              .trArgs([costBean.inviterNickname ?? '']);
        }
        break;
      case 19:
        {
          costType = TrudaLanguageKey.newhita_invite_bonus
              .trArgs([costBean.inviterNickname ?? '']);
        }
        break;
    }

    return Container(
      padding: EdgeInsetsDirectional.only(start: 15, end: 15, top: 10),
      child: Container(
          padding: EdgeInsetsDirectional.only(
              start: 10, end: 10, top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: TrudaColors.white,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      costType,
                      style: TextStyle(
                          color: TrudaColors.textColor333, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "${costBean.type == 2 ? '+' : '-'}${costBean.diamonds ?? '--'}",
                        style: TextStyle(
                            // color: Color(
                            //     costBean.type == 2 ? 0xFFFF3581 : 0xFF16C0FF),
                            color: TrudaColors.textColor333,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 5,
                        ),
                        child: Image.asset(
                          "assets/images/newhita_diamond_small.png",
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    (costBean.createdAt != null)
                        ? DateFormat('yyyy.MM.dd HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                costBean.createdAt ?? 0))
                        : "--",
                    style:
                        TextStyle(color: TrudaColors.textColor999, fontSize: 12),
                  ),
                  // Text(
                  //   TrudaLanguageKey.newhita_base_balance
                  //       .trArgs(["${costBean.afterChange ?? '--'}"]),
                  //   style:
                  //       TextStyle(color: TrudaColors.textColor999, fontSize: 12),
                  // ),
                  const SizedBox(),
                ],
              ),
              if (costBean.inviteeRepeat == 1)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    TrudaLanguageKey.newhita_invite_repeat.tr,
                    style: TextStyle(
                      color: TrudaColors.baseColorRed,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
