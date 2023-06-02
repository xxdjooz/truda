import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_utils/truda_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class TrudaSheetInviteMethod extends StatefulWidget {
  final String link;
  const TrudaSheetInviteMethod({Key? key, required this.link}) : super(key: key);

  @override
  State<TrudaSheetInviteMethod> createState() => _TrudaSheetInviteMethodState();
}

class _TrudaSheetInviteMethodState extends State<TrudaSheetInviteMethod> {
  @override
  void initState() {
    super.initState();
  }

  ///分享到whatsApp
  void shareWhatsApp() async {
    String url = "whatsapp://send?text=${widget.link}";
    if (await canLaunch(url)) {
      _addShareCount();
      launch(url);
      Get.back();
    } else {
      //没有安装 whatsApp 提示安装
      TrudaLoading.toast(
        TrudaLanguageKey.newhita_install_whatsapp.tr,
      );
    }
  }

  ///复制地址 分享
  void shareLink() {
    // log("============= sharelink $shareWebLink");
    Clipboard.setData(ClipboardData(text: widget.link));
    _addShareCount();
    TrudaLoading.toast(
      TrudaLanguageKey.newhita_base_success.tr,
    );
    Get.back();
  }

  ///记录分享次数
  void _addShareCount() {
    TrudaHttpUtil()
        .post<String>(TrudaHttpUrls.accumulateShareCount, errCallback: (err) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       TrudaColors.baseColorGradient1,
          //       TrudaColors.baseColorGradient2,
          //     ]),
          color: TrudaColors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(20), topEnd: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      shareWhatsApp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.only(
                          top: 10, bottom: 10, end: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/newhita_invite_whatsapp.png'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            TrudaLanguageKey.newhita_invite_to_whatsapp.tr,
                            style: TextStyle(color: TrudaColors.textColor333),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      shareLink();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.only(
                          top: 10, bottom: 10, end: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                              'assets/images/newhita_invite_link_copy.png'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            TrudaLanguageKey.newhita_invite_to_link.tr,
                            style: TextStyle(color: TrudaColors.textColor333),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Get.back();
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //     width: double.infinity,
            //     margin: const EdgeInsetsDirectional.only(
            //         start: 60, end: 60, bottom: 20, top: 20),
            //     height: 52,
            //     decoration: BoxDecoration(
            //         borderRadius:
            //             const BorderRadius.all(Radius.circular(52 * 0.5)),
            //         border: Border.all(color: Colors.white60, width: 1)
            //         // gradient: LinearGradient(colors: [
            //         //   TrudaColors.baseColorRed,
            //         //   TrudaColors.baseColorOrange,
            //         // ]),
            //         ),
            //     child: Text(
            //       TrudaLanguageKey.newhita_base_cancel.tr,
            //       style: const TextStyle(color: TrudaColors.white, fontSize: 16),
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}
