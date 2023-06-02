import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/host/truda_host_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../truda_common/truda_common_dialog.dart';
import '../truda_entities/truda_match_host_entity.dart';
import '../truda_http/truda_common_api.dart';
import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import '../truda_pages/call/local/truda_local_controller.dart';
import '../truda_pages/chat/truda_chat_controller.dart';
import '../truda_utils/newhita_format_util.dart';
import '../truda_utils/newhita_loading.dart';
import '../truda_utils/newhita_log.dart';
import '../truda_widget/newhita_net_image.dart';
import 'truda_sheet_host_option.dart';

class TrudaDialogMatchOne extends StatefulWidget {
  TrudaMatchHost detail;
  static bool matching = false;

  static Future checkToShow(TrudaMatchHost detail) async {
    matching = true;
    await TrudaCommonDialog.dialog(TrudaDialogMatchOne(
      detail: detail,
    ));
    matching = false;
  }

  TrudaDialogMatchOne({Key? key, required this.detail}) : super(key: key);

  @override
  _TrudaDialogMatchOneState createState() => _TrudaDialogMatchOneState();
}

class _TrudaDialogMatchOneState extends State<TrudaDialogMatchOne> {
  bool hadInit = false;
  VideoPlayerController? videoController;

  // 0匹配到，1匹配中，2匹配失败
  int matching = 1;
  bool playing = false;
  bool followed = false;
  late int matchPercent;

  @override
  void initState() {
    matchPercent = Random().nextInt(30) + 70;
    super.initState();
    initPlayer(widget.detail.video ?? '');
    followed = widget.detail.followed == 1;
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    videoController?.dispose();
    Wakelock.disable();
  }

  void initPlayer(String url) {
    videoController = VideoPlayerController.network(
      url,
      // 'https://wscdn.hanilink.com/users/111142380/upload/media/2022-05-24/_1653403481431_sendimg.mp4',
    );
    // videoController = VideoPlayerController.asset(
    //   'assets/green.mp4',
    // );
    videoController?.setLooping(false);
    videoController?.setVolume(0);
    videoController?.addListener(() {
      if (videoController!.value.isInitialized) {
        if (!playing && videoController!.value.position.inMilliseconds > 0) {
          setState(() {
            playing = true;
          });
        }
        if (videoController!.value.position ==
            videoController!.value.duration) {
          setState(() {
            playing = false;
          });
        }
      }
    });
    videoController?.initialize().then((value) {
      setState(() {});
    });
    videoController?.play();
  }

  void handleFollow() {
    TrudaCommonApi.followHostOrCancel(widget.detail.userId!,
        showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: AspectRatio(
              aspectRatio: 662 / 1000,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images_sized/newhita_match_video_bg.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: EdgeInsetsDirectional.only(
                  start: Get.width * 23 / 375,
                  end: Get.width * 23 / 375,
                  bottom: Get.width * 25 / 375,
                  top: Get.width * 68 / 375,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AspectRatio(
                      aspectRatio: 69 / 14,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images_sized/newhita_vip_center_right.png'))),
                        child: AutoSizeText(
                          TrudaLanguageKey.newhita_match_level
                              .trArgs([matchPercent.toString()]),
                          maxLines: 1,
                          maxFontSize: 14,
                          minFontSize: 8,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TrudaColors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox.expand(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            PositionedDirectional(
                              start: 0,
                              top: 0,
                              end: 0,
                              bottom: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ColoredBox(
                                    color: TrudaColors.white,
                                    child: (videoController != null && playing)
                                        ? Material(
                                            elevation: 0,
                                            child: FittedBox(
                                              // 这个做了满屏处理
                                              fit: BoxFit.cover,
                                              clipBehavior: Clip.hardEdge,
                                              child: SizedBox(
                                                width: videoController
                                                        ?.value.size.width ??
                                                    0,
                                                height: videoController
                                                        ?.value.size.height ??
                                                    0,
                                                child: VideoPlayer(
                                                    videoController!),
                                              ),
                                            ),
                                          )
                                        : NewHitaNetImage(
                                            widget.detail.portrait ?? "",
                                            placeholderAsset:
                                                "assets/images_sized/newhita_home_girl.png",
                                          )),
                              ),
                            ),
                            if (videoController?.value.isInitialized != true)
                              const CircularProgressIndicator(),
                            PositionedDirectional(
                                start: 10,
                                top: 10,
                                end: 10,
                                bottom: 10,
                                child: Column(
                                  children: [
                                    _detail(widget.detail),
                                    const Spacer(),
                                    Builder(builder: (context) {
                                      final hideCall =
                                          TrudaConstants.isFakeMode;
                                      var herOn = widget.detail.isShowOnline;
                                      if (hideCall) {
                                        herOn = false;
                                      }
                                      // herOn = !herOn;
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          herOn
                                              ? const SizedBox()
                                              : Expanded(
                                                  child: GestureDetector(
                                                  onTap: () {
                                                    Get.back();
                                                    TrudaChatController
                                                        .startMe(widget
                                                            .detail.userId!);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .only(end: 5),
                                                    height: 50,
                                                    decoration: herOn
                                                        ? BoxDecoration(
                                                            color: TrudaColors
                                                                .baseColorGreen,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          )
                                                        : BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                                    colors: [
                                                                  TrudaColors
                                                                      .baseColorGradient1,
                                                                  TrudaColors
                                                                      .baseColorGradient2,
                                                                ]), // 渐变色
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/newhita_host_msg.png",
                                                          width: 34,
                                                          height: 34,
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        if (!herOn)
                                                          Text(
                                                            TrudaLanguageKey
                                                                .newhita_message_title
                                                                .tr,
                                                            style: const TextStyle(
                                                                color:
                                                                    TrudaColors
                                                                        .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          !herOn
                                              ? const SizedBox()
                                              : Expanded(
                                                  flex: 4,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      TrudaLocalController
                                                          .startMe(
                                                              widget.detail
                                                                  .userId!,
                                                              widget.detail
                                                                  .portrait,
                                                              closeSelf: true);
                                                    },
                                                    child: AspectRatio(
                                                      aspectRatio: 70 / 18,
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          // color: TrudaColors.baseColorGreen,
                                                          // borderRadius: BorderRadius.circular(30),
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images_sized/newhita_host_bg_call.png'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              margin:
                                                                  EdgeInsetsDirectional
                                                                      .only(
                                                                          end:
                                                                              10),
                                                              child: Image.asset(
                                                                  "assets/images_ani/newhita_host_call.webp"),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  TrudaLanguageKey
                                                                      .newhita_grade_video_chat
                                                                      .tr,
                                                                  style: const TextStyle(
                                                                      color: TrudaColors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                hideCall
                                                                    ? const SizedBox()
                                                                    : Text.rich(TextSpan(
                                                                        text:
                                                                            "${widget.detail?.charge ?? '--'}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                TrudaColors.white,
                                                                            fontSize: 12),
                                                                        children: [
                                                                            WidgetSpan(
                                                                                alignment: PlaceholderAlignment.middle,
                                                                                child: Image.asset("assets/images/newhita_diamond_small.png")),
                                                                            TextSpan(text: TrudaLanguageKey.newhita_video_time_unit.tr),
                                                                          ]))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ],
                                      );
                                    }),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
            width: 20,
          ),
          GestureDetector(
            onTap: Get.back,
            child: Container(
              // decoration: BoxDecoration(
              //   color: Colors.white12,
              //   border: BorderDirectional(
              //     top: BorderSide(color: TrudaColors.white, width: 1),
              //     bottom: BorderSide(color: TrudaColors.white, width: 1),
              //     start: BorderSide(color: TrudaColors.white, width: 1),
              //     end: BorderSide(color: TrudaColors.white, width: 1),
              //   ),
              //   borderRadius: BorderRadiusDirectional.circular(30),
              // ),
              padding: const EdgeInsetsDirectional.only(
                  start: 20, end: 20, top: 10, bottom: 10),
              child: Image.asset('assets/images/newhita_close_white.png'),
            ),
          )
        ],
      ),
    );
  }

  Widget _detail(TrudaMatchHost detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
            TrudaHostController.startMe(detail.userId!, detail.portrait);
          },
          child: Container(
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NewHitaNetImage(
                  detail.portrait ?? "",
                  isCircle: true,
                  width: 36,
                  height: 36,
                  borderWidth: 1,
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 80),
                      child: Text(
                        detail.nickName ?? "",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/newhita_base_female.png',
                            width: 12,
                            height: 12,
                          ),
                          Text(
                            '${NewHitaFormatUtil.getAge(DateTime.fromMillisecondsSinceEpoch(detail.birthday ?? 0))}',
                            style: const TextStyle(
                                color: TrudaColors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   width: 4,
                // ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      followed = !followed;
                    });
                    handleFollow();
                  },
                  child: Image.asset(
                    followed
                        ? 'assets/images/newhita_call_followed.png'
                        : 'assets/images/newhita_call_follow.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                var result = await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return TrudaSheetHostOption(
                          herId: widget.detail.userId!);
                    });
                if (result == 1) {
                  Get.back(result: 1);
                }
              },
              child: Image.asset('assets/images/newhita_call_report.png'),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/newhita_moment_mute.png')
          ],
        ),
      ],
    );
  }
}
