import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/chat/truda_chat_controller.dart';
import 'package:truda/truda_utils/truda_some_extension.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../call/local/truda_local_controller.dart';
import '../../host/truda_host_controller.dart';

class TrudaHostWidget extends StatelessWidget {
  final TrudaHostDetail detail;
  final VoidCallback? callback;

  const TrudaHostWidget({Key? key, required this.detail, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (callback == null) {
          TrudaHostController.startMe(detail.userId!, detail.portrait);
        } else {
          callback?.call();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: NewHitaNetImage(
              detail.portrait ?? "",
              radius: 10,
              placeholderAsset: "assets/images_sized/newhita_home_girl.png",
            ),
          ),
          // PositionedDirectional(
          //   top: 10,
          //   start: 10,
          //   child: NewHitaNetImage(
          //     detail.area?.path ?? "",
          //     radius: 9,
          //     width: 18,
          //     height: 18,
          //   ),
          // ),
          PositionedDirectional(
            top: 7,
            start: 7,
            child: TrudaHostStateWidget(
              isDoNotDisturb: detail.isDoNotDisturb ?? 0,
              isOnline: detail.isOnline ?? 0,
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black26,
                  ],
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   children: [
                        //     NewHitaNetImage(
                        //       detail.area?.path ?? "",
                        //       radius: 9,
                        //       width: 18,
                        //       height: 18,
                        //     ),
                        //     const SizedBox(
                        //       width: 4,
                        //       height: 4,
                        //     ),
                        //     Text(
                        //       detail.area?.title ?? "",
                        //       style:
                        //           TextStyle(fontSize: 12, color: Colors.white),
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     NewHitaHostStateWidget(
                        //       isDoNotDisturb: detail.isDoNotDisturb ?? 0,
                        //       isOnline: detail.isOnline ?? 0,
                        //     ),
                        //   ],
                        // )

                        Text(
                          (detail.nickname ?? "").replaceNumByStar(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!TrudaConstants.isFakeMode)
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text.rich(TextSpan(
                                  text: "${detail.charge ?? '--'}",
                                  style: const TextStyle(
                                      color: TrudaColors.white, fontSize: 12),
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Image.asset(
                                          "assets/images/newhita_diamond_small.png",
                                          height: 12,
                                          width: 12,
                                        )),
                                    TextSpan(
                                        text: TrudaLanguageKey
                                            .newhita_video_time_unit.tr),
                                  ]))),
                      ],
                    ),
                  ),
                  (detail.isShowOnline && !TrudaConstants.isFakeMode)
                      ? GestureDetector(
                          onTap: () {
                            TrudaLocalController.startMe(
                                detail.userId!, detail.portrait);
                          },
                          //     Image.asset(
                          //   "assets/images/newhita_host_call.png",
                          //   width: 46,
                          //   height: 46,
                          //   fit: BoxFit.fill,
                          // ),
                          child: Image.asset(
                            "assets/images_ani/newhita_call_pick.webp",
                            width: 42,
                            height: 42,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            TrudaChatController.startMe(detail.userId!,
                                detail: detail);
                          },
                          child: Container(
                            // padding: const EdgeInsets.all(7),
                            // decoration: const BoxDecoration(
                            //   color: TrudaColors.baseColorPink,
                            //   shape: BoxShape.circle,
                            // ),
                            child: Image.asset(
                              "assets/images/newhita_home_msg.png",
                              width: 42,
                              height: 42,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          // PositionedDirectional(
          //     bottom: 80,
          //     end: 10,
          //     child: GestureDetector(
          //         onTap: () {
          //           NewHitaChatController.startMe(detail.userId!);
          //         },
          //         child: Image.asset("assets/images/newhita_home_msg.png"))),
        ],
      ),
    );
  }
}

class TrudaHostStateWidget extends StatelessWidget {
  // 0,是否免打扰
  final int isDoNotDisturb;

  // 0离线 1在线 2忙线
  final int isOnline;
  final int style;

  const TrudaHostStateWidget({
    Key? key,
    required this.isDoNotDisturb,
    required this.isOnline,
    this.style = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isOn = isDoNotDisturb == 0 ? isOnline : 0;
    if (style == 0) {
      String pic;
      if (isOn == 0) {
        pic = 'assets/images/newhita_base_offline.png';
      } else if (isOn == 1) {
        pic = 'assets/images/newhita_base_online.png';
      } else {
        pic = 'assets/images/newhita_base_busy.png';
      }
      return Image.asset(
        pic,
        width: 20,
        height: 20,
        fit: BoxFit.fill,
      );
    } else {
      Color color;
      String state;
      if (isOn == 0) {
        color = Colors.grey;
        state = TrudaLanguageKey.newhita_base_offline.tr;
      } else if (isOn == 1) {
        color = const Color(0xFF44ff7c);
        state = TrudaLanguageKey.newhita_base_online.tr;
      } else {
        color = const Color(0xFFFF295D);
        state = TrudaLanguageKey.newhita_base_busy.tr;
      }
      return Container(
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: color,
                  // border: Border.all(color: TrudaColors.white, width: 1),
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 3),
            Text(
              state,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      );
    }
  }
}
