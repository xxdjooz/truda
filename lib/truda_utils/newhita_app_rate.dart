import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_http/newhita_http_urls.dart';
import 'package:truda/truda_pages/chargedialog/newhita_charge_dialog_manager.dart';
import 'package:truda/truda_utils/newhita_third_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../truda_common/truda_colors.dart';
import '../truda_http/newhita_http_util.dart';

class NewHitaAppRate {
  static void rateApp(String msg) async {
    //用户打开了充值弹窗 屏蔽评分弹窗
    if (NewHitaChargeDialogManager.isShowingChargeDialog) {
      return;
    }

    if (msg == "0") {
      if (GetPlatform.isIOS == true) {
        //苹果仿真内部评分
        showFakeRateApp();
      } else {
        //安卓弹老样式 自定义评分弹窗
        // showRateApp(ignore: false);
        //安卓仿真内部评分
        showGoogleRate();
      }
    } else {
      try {
        NewHitaThirdUtil.askReview();
      } catch (e) {
        //无法弹出内部评分
        if (GetPlatform.isIOS) {
          if (await canLaunch( // todo ios
              "itms-apps://itunes.apple.com/app/idxxxxx?action=write-review")) {
            launch(
                "itms-apps://itunes.apple.com/app/idxxxxx?action=write-review");
          }
        } else if (GetPlatform.isAndroid) {
          if (await canLaunch(
              "https://play.google.com/store/apps/details?id=com.hitawula.newhita")) {
            launch(
                "https://play.google.com/store/apps/details?id=com.hitawula.newhita");
          }
        }
      }
    }
  }

  // google的
  static void showGoogleRate() {
    Get.bottomSheet(const NewHitaGoogleRate());
  }

  // ios的
  static void showFakeRateApp() {
    Get.bottomSheet(Container(
      width: 270,
      padding: EdgeInsetsDirectional.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xFAFFFFFF), borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/newhita_base_logo.png",
                    fit: BoxFit.contain,
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 15, start: 20, end: 20),
            child: Text(
              TrudaLanguageKey.newhita_fake_rate_tip.trArgs([TrudaConstants.appName]),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 5, start: 20, end: 20),
            child: Text(
              TrudaLanguageKey.newhita_fake_rate_content.tr,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          NewHitaBottomBtns((action, rate) {
            Get.back();

            // if (action == false) {
            //   HiHttpManager.postRequest(HiHttpUrls.updateRatedApp, (a) {},
            //       (e) {}, {"rating": -1, "remark": ""}, false);
            // } else {
            //   HiHttpManager.postRequest(HiHttpUrls.updateRatedApp, (a) {},
            //       (e) {}, {"rating": rate, "remark": ""}, false);
            // }
          }),
        ],
      ),
    ));
  }
}

typedef NewHitaRateBtnAction = Function(bool, double);

class NewHitaBottomBtns extends StatefulWidget {
  NewHitaRateBtnAction actionFun;

  NewHitaBottomBtns(this.actionFun);

  @override
  _NewHitaBottomBtnsState createState() => _NewHitaBottomBtnsState();
}

class _NewHitaBottomBtnsState extends State<NewHitaBottomBtns> {
  double minRating = 0;
  double currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(top: 30, start: 0, end: 0),
          height: 0.5,
          color: Color.fromARGB(180, 182, 187, 200),
        ),
        Container(
          alignment: Alignment.center,
          height: 40,
          child: RatingBar(
            initialRating: 0,
            minRating: minRating,
            maxRating: 5,
            glow: false,
            direction: Axis.horizontal,
            allowHalfRating: false,
            unratedColor: Colors.blue,
            glowColor: Colors.transparent,
            itemCount: 5,
            itemSize: 25,
            itemPadding: EdgeInsets.symmetric(horizontal: 5),
            ratingWidget: RatingWidget(
              full: Icon(
                Icons.star,
                color: Colors.blue,
              ),
              empty: Icon(
                Icons.star_border_sharp,
                color: Colors.blue,
              ),
              half: Icon(
                Icons.star_half_sharp,
                color: Colors.blue,
              ),
            ),
            onRatingUpdate: (rating) {
              currentRating = rating;
              if (minRating == 0) {
                setState(() {
                  minRating = 1;
                  currentRating = 1;
                });
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 0, end: 0),
          height: 0.5,
          color: Color.fromARGB(180, 182, 187, 200),
        ),
        Container(
          alignment: Alignment.center,
          height: 40,
          child: minRating == 0
              ? Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              widget.actionFun.call(false, 0);
                            },
                            child: Text(
                              TrudaLanguageKey.newhita_fake_rate_late.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                              textAlign: TextAlign.center,
                            )))
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              widget.actionFun.call(false, 0);
                            },
                            child: Text(
                              TrudaLanguageKey.newhita_fake_rate_cancel.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                              textAlign: TextAlign.center,
                            ))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              widget.actionFun.call(true, currentRating);
                            },
                            child: Text(
                              TrudaLanguageKey.newhita_fake_rate_submit.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                              textAlign: TextAlign.center,
                            ))),
                  ],
                ),
        )
      ],
    );
  }
}

/// google打分
class NewHitaGoogleRate extends StatefulWidget {
  const NewHitaGoogleRate({Key? key}) : super(key: key);

  @override
  State<NewHitaGoogleRate> createState() => _NewHitaGoogleRateState();
}

class _NewHitaGoogleRateState extends State<NewHitaGoogleRate> {
  TextEditingController _textEditingController = TextEditingController();

  int _step = 0;
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TrudaColors.white,
      child: _step == 2
          ? Container(
              height: 300,
              padding: EdgeInsetsDirectional.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TrudaLanguageKey.newhita_google_rate_thank.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  Image.asset(
                    'assets/images_sized/newhita_google_play_rate_done.png',
                    width: 100,
                    height: 100,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        TrudaLanguageKey.newhita_base_confirm.tr,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images_sized/newhita_google_play.png',
                        width: 26,
                        height: 26,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Google play',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.black12,
                ),
                if (_step == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/newhita_base_logo.png',
                                width: 60,
                                height: 60,
                              ),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NewHita',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  TrudaLanguageKey.newhita_google_rate_tip.tr,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: RatingBar(
                            initialRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: Colors.green,
                              ),
                              half: Icon(
                                Icons.star,
                                color: Colors.green,
                              ),
                              empty: Icon(
                                Icons.star_border_sharp,
                                color: Colors.green,
                              ),
                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                                _step = 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_step == 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/newhita_base_logo.png',
                              width: 60,
                              height: 60,
                            ),
                            Expanded(
                              child: RatingBar(
                                wrapAlignment: WrapAlignment.spaceAround,
                                initialRating: _rating,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  ),
                                  half: Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  ),
                                  empty: Icon(
                                    Icons.star_border_sharp,
                                    color: Colors.green,
                                  ),
                                ),
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLength: 500,
                          maxLines: 10,
                          minLines: 1,
                          controller: _textEditingController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                              ),
                              labelText:
                                  TrudaLanguageKey.newhita_google_rate_label.tr,
                              labelStyle: TextStyle(color: Colors.green),
                              helperText:
                                  TrudaLanguageKey.newhita_google_rate_optional.tr,
                              helperStyle: TextStyle(color: Colors.grey),
                              // suffixText: "suffix",
                              // suffixIcon: Icon(Icons.done),
                              // suffixStyle: TextStyle(color: Colors.green),
                              // counterText: "20",
                              counterStyle: TextStyle(color: Colors.grey),
                              // prefixText: "ID",
                              // prefixStyle: TextStyle(color: Colors.blue),
                              // prefixIcon: Icon(Icons.language),
                              fillColor: TrudaColors.white,
                              filled: true,
                              //  errorText: "error",
                              //  errorMaxLines: 1,
                              //  errorStyle: TextStyle(color: Colors.red),
                              //  errorBorder: UnderlineInputBorder(),
                              hintText:
                                  TrudaLanguageKey.newhita_google_rate_hint.tr,
                              hintMaxLines: 1,
                              hintStyle: TextStyle(color: Colors.black38),
                              // icon: Icon(Icons.assignment_ind),
                              iconColor: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: TrudaColors.white,
                            primary: Colors.black,
                            side: BorderSide(color: Colors.grey, width: 1),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10))),
                            elevation: 2,
                            // shadowColor: Colors.orangeAccent,
                          ),
                          child: Text(
                            TrudaLanguageKey.newhita_google_rate_cancel.tr,
                            style: TextStyle(color: Colors.green),
                          ),
                          autofocus: false,
                          onPressed: () {
                            Get.back();
                            NewHitaHttpUtil().post(NewHitaHttpUrls.updateRatedApp,
                                data: {"rating": -1, "remark": ''});
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextButton(
                          style: _step == 1
                              ? TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  primary: TrudaColors.white,
                                  elevation: 2,
                                  shadowColor: Colors.green)
                              : TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  primary: TrudaColors.white,
                                  elevation: 2,
                                  shadowColor: Colors.green),
                          child: Text(
                            TrudaLanguageKey.newhita_report_submit.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_step == 0) return;
                            setState(() {
                              _step = 2;
                            });
                            NewHitaHttpUtil().post(NewHitaHttpUrls.updateRatedApp,
                                data: {
                                  "rating": _rating,
                                  "remark": _textEditingController.text
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
