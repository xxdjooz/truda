import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_routes/truda_pages.dart';
import 'package:truda/truda_services/truda_storage_service.dart';

import '../../truda_common/truda_common_dialog.dart';
import '../../truda_common/truda_constants.dart';
import '../../truda_dialogs/truda_dialog_confirm.dart';
import '../../truda_utils/newhita_loading.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_widget/newhita_app_bar.dart';

class TrudaReportNewPage extends StatelessWidget {
  const TrudaReportNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: NewHitaAppBar(
        title: Text(TrudaLanguageKey.newhita_setting_opinions_complaints.tr),
      ),
      backgroundColor: TrudaColors.baseColorBlackBg,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: TrudaReportNewWidget(arguments)),
    );
  }
}

class TrudaReportNewWidget extends StatefulWidget {
  Map<String, dynamic> arguments;

  TrudaReportNewWidget(this.arguments);

  @override
  _TrudaReportNewWidgetState createState() => _TrudaReportNewWidgetState();
}

class _TrudaReportNewWidgetState extends State<TrudaReportNewWidget>
    with RouteAware {
  int selectIndex = 0;
  List<String> reportList = [
    TrudaLanguageKey.newhita_new_report_content_1.tr,
    TrudaLanguageKey.newhita_new_report_content_2.tr,
    TrudaLanguageKey.newhita_new_report_content_3.tr,
    TrudaLanguageKey.newhita_new_report_content_4.tr,
    TrudaLanguageKey.newhita_new_report_content_5.tr,
    TrudaLanguageKey.newhita_new_report_content_6.tr,
    TrudaLanguageKey.newhita_new_report_content_7.tr,
    TrudaLanguageKey.newhita_new_report_content_8.tr,
    TrudaLanguageKey.newhita_new_report_content_9.tr,
    TrudaLanguageKey.newhita_new_report_content_10.tr,
    TrudaLanguageKey.newhita_new_report_content_12.tr,
    TrudaLanguageKey.newhita_new_report_content_13.tr,
    TrudaLanguageKey.newhita_new_report_content_14.tr,
    TrudaLanguageKey.newhita_new_report_content_11.tr,
  ];

  // 0举报主播，1举报动态，2举报封面视频或主播图片视频
  int reportType = 0;
  String herId = '';
  String rId = '';

  @override
  void initState() {
    super.initState();
    reportType = widget.arguments['reportType'] ??= 0;
    herId = widget.arguments['herId'] ??= '';
    rId = widget.arguments['rId'] ??= '';
  }

  void _confirmReport() {
    // if (selectIndex == -1) {
    //   NewHitaLoading.toast(
    //       TrudaLanguageKey.newhita_report_edit_topic.tr);
    //   return;
    // }
    // if ((_textEditingController?.text ?? "").length <= 0) {
    //   showToast(TrudaLanguageKey.newhita_not_entered.tr);
    //   return;
    // }
    if (reportType == 3) {
      Get.dialog(TrudaDialogConfirm(
        title: TrudaLanguageKey.newhita_new_report_thanks.tr,
        onlyConfirm: true,
        showSuccessIcon: true,
        callback: (int callback) {},
      )).then((value) {
        Get.back(result: 1);
      });
      return;
    }
    if (reportType == 1) {
      TrudaStorageService.to.updateMomentReportList(rId);
      Get.dialog(TrudaDialogConfirm(
        title: TrudaLanguageKey.newhita_new_report_thanks.tr,
        onlyConfirm: true,
        showSuccessIcon: true,
        callback: (int callback) {},
      )).then((value) {
        Get.back(result: 1);
      });
      return;
    }
    if (reportType == 2) {
      TrudaStorageService.to.updateMediaReportList(rId);
      TrudaCommonDialog.dialog(TrudaDialogConfirm(
        title: TrudaLanguageKey.newhita_new_report_thanks.tr,
        onlyConfirm: true,
        showSuccessIcon: true,
        callback: (int callback) {},
      )).then((value) {
        Get.back(result: 1);
      });
      return;
    }

    TrudaHttpUtil()
        .post<void>(TrudaHttpUrls.reportUpApi,
            data: {
              "type": "2",
              "anchorUserId": herId,
              "topic": reportList[selectIndex],
              "content": "not input",
              "linkId": rId,
            },
            showLoading: true)
        .then((value) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      TrudaCommonDialog.dialog(TrudaDialogConfirm(
        title: TrudaLanguageKey.newhita_new_report_thanks.tr,
        onlyConfirm: true,
        showSuccessIcon: true,
        callback: (int callback) {},
      )).then((value) {
        Get.back(result: 1);
      });
    });
    // 举报后要拉黑
    if (TrudaStorageService.to.checkBlackList(herId)) {
      return;
    }
    TrudaHttpUtil()
        .post<int>(
      TrudaHttpUrls.blacklistActionApi + herId,
    )
        .then((value) {
      if (value == 1) {
        TrudaStorageService.to.updateBlackList(herId, true);
      }
      NewHitaLog.debug("拉黑");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TrudaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPushNext() {
    super.didPushNext();
  }

  @override
  void didPop() {
    super.didPop();
  }

  @override
  void dispose() {
    TrudaAppPages.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: TrudaColors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          margin: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                    start: 15, end: 15, bottom: 10, top: 10),
                child: Text(
                  TrudaLanguageKey.newhita_new_report_title_1.tr,
                  style:
                      TextStyle(color: TrudaColors.textColor999, fontSize: 14),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.only(
                  start: 15,
                  end: 15,
                  bottom: 10,
                ),
                child: Text(
                  TrudaLanguageKey.newhita_new_report_title_2
                      .trArgs([TrudaConstants.appName]),
                  style:
                      TextStyle(color: TrudaColors.textColor999, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            color: TrudaColors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          margin: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsetsDirectional.only(
                      start: 15,
                      end: 15,
                      top: index == 0 ? 20 : 10,
                      bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          reportList[index],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TrudaColors.textColor333),
                        ),
                      ),
                      if (index == selectIndex)
                        Image.asset(
                          'assets/images/newhita_base_checked.png',
                        ),
                      if (index != selectIndex)
                        Image.asset(
                          'assets/images/newhita_base_check.png',
                          color: TrudaColors.textColor999,
                        ),
                    ],
                  ),
                ),
              );
            },
            itemCount: reportList.length,
          ),
        )),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _confirmReport,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.only(
                      start: 20, end: 20, bottom: 20, top: 20),
                  height: 52,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(52 * 0.5)),
                    gradient: LinearGradient(colors: [
                      TrudaColors.baseColorGradient1,
                      TrudaColors.baseColorGradient2,
                    ]),
                  ),
                  child: Text(
                    TrudaLanguageKey.newhita_base_confirm.tr,
                    style: const TextStyle(
                        color: TrudaColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
