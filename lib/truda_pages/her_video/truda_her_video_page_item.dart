import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_entities/truda_host_entity.dart';
import 'package:truda/truda_http/truda_common_api.dart';
import 'package:truda/truda_pages/call/local/truda_local_controller.dart';
import 'package:truda/truda_pages/chat/truda_chat_controller.dart';
import 'package:truda/truda_pages/her_video/truda_cache_page.dart';
import 'package:truda/truda_pages/her_video/truda_video_progress.dart';
import 'package:truda/truda_pages/host/truda_host_controller.dart';
import 'package:truda/truda_utils/truda_log.dart';
import 'package:truda/truda_widget/truda_app_bar.dart';
import 'package:truda/truda_widget/truda_net_image.dart';

import '../../truda_dialogs/truda_dialog_confirm_hang.dart';
import '../../truda_dialogs/truda_sheet_host_video_option.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_routes/truda_pages.dart';
import '../../truda_utils/truda_format_util.dart';
import '../../truda_utils/truda_loading.dart';
import '../main/home/truda_host_widget.dart';

///
/// TikTok风格的一个视频页组件，覆盖在video上，提供以下功能：
/// 播放按钮的遮罩
/// 单击事件
/// 点赞事件回调（每次）
/// 长宽比控制
/// 底部padding（用于适配有沉浸式底部状态栏时）
///
class TrudaHerVideoPageItem extends StatefulWidget {
  final Widget? video;
  final double aspectRatio;
  final String? tag;
  final double bottomPadding;

  final bool hidePauseIcon;
  final TrudaHostDetail detail;

  final Function? onAddFavorite;
  final Function? onSingleTap;
  final StreamController<int> streamController;

  const TrudaHerVideoPageItem({
    Key? key,
    this.bottomPadding = 16,
    this.tag,
    this.onAddFavorite,
    this.onSingleTap,
    this.video,
    this.aspectRatio = 9 / 16.0,
    this.hidePauseIcon = false,
    required this.detail,
    required this.streamController,
  }) : super(key: key);

  @override
  State<TrudaHerVideoPageItem> createState() =>
      _TrudaHerVideoPageItemState();
}

class _TrudaHerVideoPageItemState extends State<TrudaHerVideoPageItem>
    with WidgetsBindingObserver {
  double progress = 0;
  double progressBuff = 0;
  int playStep = 0;
  int circle = 0;
  late List<TrudaHostMedia> videos = widget.detail.videos!;

  /// event bus 监听
  late final StreamSubscription<int> sub;
  late Function(double) callback;
  bool firstIn = true;
  late bool followed = widget.detail.followed == 1;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      widget.streamController.add(0);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    sub = widget.streamController.stream.listen((event) {
      if (event == 0) {}
    });

    callback = (d) {
      setState(() {
        firstIn = false;
        if (d == 2.0) {
          playStep++;
          if (videos.length == 1 || playStep >= videos.length || playStep > 2) {
            playStep = 0;
            circle++;
          }
          progress = 0;
        } else {
          progress = d;
        }
      });
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    TrudaLog.debug('_TikTokVideoPageState  dispose');
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            alignment: Alignment.center,
            child: TrudaCachePage(
              key: ValueKey('$circle:$playStep'),
              url: videos[playStep].path!,
              streamController: widget.streamController,
              callback: callback,
            ),
          ),
          if (firstIn)
            Positioned.fill(
              child: TrudaNetImage(
                widget.detail.portrait ?? '',
                placeholderAsset: 'assets/images_sized/newhita_home_girl.png',
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            top: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TrudaTikTokVideoProgress(
                          index: 0,
                          step: playStep,
                          progress: progress,
                          progressBuff: progressBuff,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                        height: 5,
                      ),
                      if (widget.detail.videos!.length > 1)
                        Expanded(
                          child: TrudaTikTokVideoProgress(
                            index: 1,
                            step: playStep,
                            progress: progress,
                            progressBuff: progressBuff,
                          ),
                        ),
                      const SizedBox(
                        width: 5,
                        height: 5,
                      ),
                      if (widget.detail.videos!.length > 2)
                        Expanded(
                          child: TrudaTikTokVideoProgress(
                            index: 2,
                            step: playStep,
                            progress: progress,
                            progressBuff: progressBuff,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      var result = await TrudaHostController.startMe(
                          widget.detail.userId!, widget.detail.portrait);
                      if (result == 1) {
                        Get.back(result: 1);
                      }
                    },
                    child: Container(
                        child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            TrudaHostController.startMe(
                                widget.detail.userId!, widget.detail.portrait);
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TrudaNetImage(
                                  widget.detail.portrait ?? "",
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
                                        widget.detail.nickname ?? "",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                            '${TrudaFormatUtil.getAge(DateTime.fromMillisecondsSinceEpoch(widget.detail.birthday ?? 0))}',
                                            style: const TextStyle(
                                                color: TrudaColors.white,
                                                fontSize: 12),
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
                        GestureDetector(
                            onTap: () async {
                              var result = await Get.toNamed(
                                TrudaAppPages.reportPageNew,
                                arguments: {
                                  'reportType': 0,
                                  'herId': widget.detail.userId!,
                                },
                              );
                              if (result == 1) {
                                Get.back(result: 1);
                              }
                            },
                            child: Image.asset(
                              'assets/images/newhita_call_report.png',
                              width: 34,
                              height: 34,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            // onTap: controller.clickHangUp,
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              'assets/images/newhita_call_leave.png',
                              width: 34,
                              height: 34,
                            )),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 15,
              right: 15,
              bottom: 14,
              child: Builder(builder: (context) {
                final hideCall = TrudaConstants.isFakeMode ||
                    widget.detail.isShowOnline != true;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () {
                                  TrudaChatController.startMe(
                                      widget.detail.userId!,
                                      detail: widget.detail);
                                },
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(end: 5),
                                  height: 52,
                                  decoration: hideCall
                                      ? BoxDecoration(
                                          gradient:
                                              const LinearGradient(colors: [
                                            TrudaColors.baseColorGradient1,
                                            TrudaColors.baseColorGradient2,
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        )
                                      : BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          gradient:
                                              const LinearGradient(colors: [
                                            TrudaColors.baseColorGradient1,
                                            TrudaColors.baseColorGradient2,
                                          ]),
                                        ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsetsDirectional.only(
                                            end: 10, start: 10),
                                        child: Image.asset(
                                          "assets/images/newhita_host_msg.png",
                                          width: 32,
                                          height: 32,
                                        ),
                                      ),
                                      if (hideCall)
                                        Text(
                                          TrudaLanguageKey
                                              .newhita_message_title.tr,
                                          style: const TextStyle(
                                              color: TrudaColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                    ],
                                  ),
                                ),
                              )),
                          hideCall
                              ? const SizedBox()
                              : Expanded(
                                  flex: 7,
                                  child: GestureDetector(
                                    onTap: () {
                                      TrudaLocalController.startMe(
                                          widget.detail.userId!,
                                          widget.detail.portrait);
                                    },
                                    child: AspectRatio(
                                      aspectRatio: 70 / 18,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          // color: TrudaColors.baseColorGreen,
                                          // borderRadius: BorderRadius.circular(30),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images_sized/newhita_host_bg_call.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                      end: 10),
                                              child: Image.asset(
                                                  "assets/images_ani/newhita_host_call.webp"),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  TrudaLanguageKey
                                                      .newhita_grade_video_chat
                                                      .tr,
                                                  style: const TextStyle(
                                                      color:
                                                          TrudaColors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                hideCall
                                                    ? const SizedBox()
                                                    : Text.rich(TextSpan(
                                                        text:
                                                            "${widget.detail.charge ?? '--'}",
                                                        style: const TextStyle(
                                                            color: TrudaColors
                                                                .white,
                                                            fontSize: 12),
                                                        children: [
                                                            WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .middle,
                                                                child: Image.asset(
                                                                    "assets/images/newhita_diamond_small.png")),
                                                            TextSpan(
                                                                text: TrudaLanguageKey
                                                                    .newhita_video_time_unit
                                                                    .tr),
                                                          ]))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                        ],
                      ),
                    ],
                  ),
                );
              })),
        ],
      ),
    );
    // 视频播放页
  }

  ///关注
  void handleFollow() {
    TrudaCommonApi.followHostOrCancel((widget.detail.userId ?? ""))
        .then((value) {
      widget.detail.followed = value;
      setState(() {
        followed = value == 1;
      });
    });
  }
}
