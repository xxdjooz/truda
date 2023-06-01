import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:truda/truda_utils/newhita_check_calling_util.dart';

import '../truda_common/truda_common_dialog.dart';
import '../truda_entities/truda_info_entity.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';

//新用户福利(体验卡)
class NewTrudaUserCardsTip extends StatefulWidget {
  static checkToShow() {
    if (TrudaConstants.isFakeMode) {
      return;
    }
    if (NewHitaMyInfoService.to.myDetail?.created == 1) {
      Future.delayed(Duration(seconds: 10), () async {
        TrudaInfoDetail myDetail;
        try {
          myDetail = await NewHitaHttpUtil().post<TrudaInfoDetail>(
            NewHitaHttpUrls.userInfoApi,
          );
        } catch (e) {
          print(e);
          return;
        }
        if ((myDetail.callCardUsedCount ?? 1) <= 0 &&
            (myDetail.callCardCount ?? 0) > 0 &&
            !NewHitaCheckCallingUtil.checkCalling()) {
          TrudaCommonDialog.dialog(NewTrudaUserCardsTip(
              myDetail.callCardCount!, myDetail.callCardDuration));
        }
      });
    }
  }

  int cardNum;
  int? callCardDuration;

  NewTrudaUserCardsTip(this.cardNum, this.callCardDuration);

  @override
  _NewTrudaUserCardsTipState createState() => _NewTrudaUserCardsTipState();
}

class _NewTrudaUserCardsTipState extends State<NewTrudaUserCardsTip> {
  Timer? _timer;
  bool isDiamondCard = false;
  late String name;
  late String content;

  @override
  void initState() {
    super.initState();
    //15s后 如果用户体验卡提示弹窗还在则自动关闭
    _timer = Timer(Duration(seconds: 15), () {});

    var percent = isDiamondCard
        ? TrudaLanguageKey.newhita_base_percent_location
            .trArgs([(widget.callCardDuration ?? 0).toString()])
        : '';
    name = isDiamondCard
        ? TrudaLanguageKey.newhita_card_diamond_bonus.trArgs([percent])
        : TrudaLanguageKey.newhita_vido_tx.tr;
    content = isDiamondCard
        ? TrudaLanguageKey.newhita_card_diamond_bonus_intro.trArgs([percent])
        : TrudaLanguageKey.newhita_vido_info
            .trArgs(["${(widget.callCardDuration ?? 15000) ~/ 1000.0}"]);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsetsDirectional.all(8),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/images_sized/newhita_new_user_bg.png',
          ),
          fit: BoxFit.fill,
          matchTextDirection: true,
        )),
        child: Container(
          padding: const EdgeInsetsDirectional.only(
            start: 10,
            end: 10,
            top: 30,
            bottom: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                TrudaLanguageKey.newhita_level_congratulations.tr,
                style: const TextStyle(
                    color: TrudaColors.textColor333,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                TrudaLanguageKey.newhita_dialog_new_user_title.tr,
                style: const TextStyle(
                  color: TrudaColors.textColor333,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: 20, bottom: 20),
                child: Text.rich(
                  TextSpan(
                      text: TrudaLanguageKey.newhita_dialog_new_user_tip.tr,
                      children: [
                        TextSpan(
                            text: TrudaLanguageKey
                                .newhita_dialog_call_experience_card
                                .trArgs(["${widget.cardNum}"]),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TrudaColors.baseColorRed)),
                        TextSpan(
                          text:
                              "\n${TrudaLanguageKey.newhita_dialog_new_user_tip_2.tr}",
                        )
                      ]),
                  style: TextStyle(
                      color: TrudaColors.textColor333, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 556 / 250,
                    child: Image.asset(
                      'assets/images_sized/newhita_new_user_card.png',
                      width: double.infinity,
                      matchTextDirection: true,
                    ),
                  ),
                  PositionedDirectional(
                    start: Get.width * 100 / 375,
                    end: 0,
                    top: 0,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              color: TrudaColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          content,
                          style: const TextStyle(
                              color: TrudaColors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsetsDirectional.only(top: 15, bottom: 15),
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(52 * 0.5)),
                  //     gradient: LinearGradient(colors: [
                  //       TrudaColors.baseColorRed,
                  //       TrudaColors.baseColorOrange,
                  //     ])),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        TrudaColors.baseColorGradient1,
                        TrudaColors.baseColorGradient2,
                      ]), // 渐变色
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    TrudaLanguageKey.newhita_base_confirm.tr,
                    style: TextStyle(
                        color: TrudaColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
