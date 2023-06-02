import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:truda/truda_http/truda_common_api.dart';
import 'package:wakelock/wakelock.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_constants.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_entities/truda_moment_entity.dart';
import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import '../truda_pages/call/local/truda_local_controller.dart';
import '../truda_pages/chat/truda_chat_controller.dart';
import '../truda_pages/host/truda_host_controller.dart';
import '../truda_pages/main/home/truda_host_widget.dart';
import '../truda_pages/some/truda_media_view_page.dart';
import '../truda_routes/truda_pages.dart';
import '../truda_utils/truda_format_util.dart';
import '../truda_utils/truda_loading.dart';
import '../truda_widget/truda_net_image.dart';
import 'truda_dialog_match_one.dart';

class TrudaDialogMatchMoment extends StatefulWidget {
  TrudaMomentDetail detail;

  static Future checkToShow(TrudaMomentDetail detail) async {
    TrudaDialogMatchOne.matching = true;
    await TrudaCommonDialog.dialog(TrudaDialogMatchMoment(
      detail: detail,
    ));
    TrudaDialogMatchOne.matching = false;
  }

  TrudaDialogMatchMoment({Key? key, required this.detail}) : super(key: key);

  @override
  _TrudaDialogMatchMomentState createState() => _TrudaDialogMatchMomentState();
}

class _TrudaDialogMatchMomentState extends State<TrudaDialogMatchMoment> {
  bool hadInit = false;
  bool followed = false;

  @override
  void initState() {
    super.initState();
    // initPlayer(widget.detail.video ?? '');
    followed = widget.detail.followed == 1;
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
  }

  void handleFollow() {
    TrudaCommonApi.followHostOrCancel(widget.detail.userId!, showLoading: false);
  }

  void priseMoment(String momentId, bool prise) {
    TrudaHttpUtil().post<int>(
        prise
            ? TrudaHttpUrls.momentsPraise + momentId
            : TrudaHttpUrls.momentsPraiseCancel + momentId, errCallback: (err) {
      // NewHitaLoading.toast(err.message);
    }, showLoading: false);
  }

  void reportMoment(String momentId) async {
    var result = await Get.toNamed(
      TrudaAppPages.reportPageNew,
      arguments: {
        'reportType': 1,
        'rId': momentId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Stack(
              alignment: AlignmentDirectional.center,
              clipBehavior: Clip.none,
              children: [
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  end: 0,
                  bottom: 0,
                  // child: Image.asset(
                  //   'assets/newhita_mock_moment_bg.webp',
                  //   fit: BoxFit.fill,
                  // ),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      centerSlice: Rect.fromLTWH(50, 50, 218, 324),
                      image: AssetImage('assets/newhita_mock_moment_bg.webp'),
                    )),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 30, 10, 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [_moment(widget.detail), _wBottomButton()],
                  ),
                ),
                PositionedDirectional(
                  top: -46,
                  child: Image.asset(
                    'assets/images/newhita_mock_moment_top.png',
                    width: 104,
                    height: 84,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
            width: 20,
          ),
          GestureDetector(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsetsDirectional.only(
                  start: 20, end: 20, top: 10, bottom: 10),
              child: Image.asset('assets/images/newhita_close_white.png'),
            ),
          )
        ],
      ),
    );
  }

  Widget _moment(TrudaMomentDetail bean) {
    String? updateTime;
    var time = DateTime.fromMillisecondsSinceEpoch(bean.createdAt ?? 0);
    updateTime = DateFormat('yyyy.MM.dd HH:mm').format(time);
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 10),
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: TrudaColors.white,
        borderRadius: BorderRadius.circular(14),
        // border: Border(
        //     top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () async {
              var result =
                  await TrudaHostController.startMe(bean.userId!, bean.portrait);
              if (result == 1) {
                Get.back(result: 1);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TrudaNetImage(
                          bean.portrait ?? "",
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsetsDirectional.only(start: 5, end: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (bean.nickname ?? "--"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: TrudaColors.textColor000,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        updateTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: TrudaColors.textColor999, fontSize: 12),
                      ),
                    ],
                  ),
                )),
                GestureDetector(
                  onTap: () async {
                    var result = await Get.toNamed(
                      TrudaAppPages.reportPageNew,
                      arguments: {
                        'reportType': 1,
                        'rId': widget.detail.momentId ?? '',
                      },
                    );
                    if (result == 1) {
                      Get.back(result: 1);
                    }
                  },
                  child: Image.asset(
                    'assets/images/newhita_call_report.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
          ),
          if (bean.content != null && bean.content!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                bean.content ?? '',
                style: const TextStyle(
                  color: TrudaColors.textColor333,
                  fontSize: 16,
                ),
              ),
            ),
          if (bean.medias?.isNotEmpty == true)
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 0,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4,
                crossAxisSpacing: 5,
                crossAxisCount: bean.medias!.length == 1 ? 2 : 3,
              ),
              itemCount: bean.medias!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var media = bean.medias![index];
                var heroId = bean.createdAt ?? index;
                return GestureDetector(
                  onTap: () {
                    TrudaMediaViewPage.startMe(context,
                        path: media.mediaUrl ?? '',
                        cover: media.screenshotUrl,
                        type: media.mediaType,
                        heroId: heroId);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: heroId,
                        child: TrudaNetImage(
                          media.mediaType == 1
                              ? media.screenshotUrl!
                              : media.mediaUrl!,
                          radius: 14,
                        ),
                      ),
                      if (media.mediaType == 1)
                        Image.asset('assets/images/newhita_base_video_play.png'),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _wBottomButton() {
    return Builder(builder: (context) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              TrudaChatController.startMe(widget.detail.userId!);
            },
            child: Container(
              margin: EdgeInsetsDirectional.only(end: 5),
              height: 52,
              decoration: BoxDecoration(
                color: TrudaColors.baseColorPink,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/newhita_host_msg.webp",
                      width: 34,
                      height: 34,
                    ),
                  ),
                  Text(
                    TrudaLanguageKey.newhita_message_title.tr,
                    style: const TextStyle(
                        color: TrudaColors.textColor333,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )),
          GestureDetector(
            onTap: (){
              handleFollow();
              setState(() {
                followed = !followed;
              });
            },
            child: followed
                ? Image.asset(
                    "assets/images/newhita_mock_moment_heart.png",
                    width: 52,
                    height: 52,
                  )
                : Image.asset(
                    "assets/images/newhita_mock_moment_heart_red.png",
                    width: 52,
                    height: 52,
                  ),
          ),
        ],
      );
    });
  }
}
