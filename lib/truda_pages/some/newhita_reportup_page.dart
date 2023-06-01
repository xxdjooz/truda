import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_http/newhita_http_urls.dart';
import 'package:truda/truda_http/newhita_http_util.dart';
import 'package:truda/truda_routes/newhita_pages.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';

import '../../truda_utils/newhita_loading.dart';
import '../../truda_utils/newhita_log.dart';
import '../../truda_widget/newhita_decoration_bg.dart';

class NewHitaReportUpPage extends StatefulWidget {
  const NewHitaReportUpPage({Key? key}) : super(key: key);

  @override
  _NewHitaReportUpPageState createState() => _NewHitaReportUpPageState();
}

class _NewHitaReportUpPageState extends State<NewHitaReportUpPage> {
  String upid = (Get.arguments is String) ? Get.arguments : "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(TrudaLanguageKey.newhita_setting_opinions_complaints.tr),
      ),
      backgroundColor: TrudaColors.baseColorBlackBg,
      body: Container(
          decoration: const NewHitaDecorationBg(),
          width: double.infinity,
          height: double.infinity,
          child: NewHitaReportWdg(upid, null)),
    );
  }
}

class NewHitaReportWdg extends StatefulWidget {
  String upid;
  String? channelid;

  NewHitaReportWdg(this.upid, this.channelid);

  @override
  _NewHitaReportWdgState createState() => _NewHitaReportWdgState();
}

class _NewHitaReportWdgState extends State<NewHitaReportWdg> with RouteAware {
  int selectIndex = 0;
  List<String> reportList = [
    TrudaLanguageKey.newhita_report_text_1.tr,
    TrudaLanguageKey.newhita_report_text_2.tr,
    TrudaLanguageKey.newhita_report_text_3.tr,
    TrudaLanguageKey.newhita_report_text_4.tr,
    TrudaLanguageKey.newhita_report_text_5.tr,
    TrudaLanguageKey.newhita_report_text_6.tr,
  ];

  FocusNode? _focusNode;
  TextEditingController? _textEditingController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NewHitaAppPages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPushNext() {
    _focusNode?.unfocus();
    super.didPushNext();
  }

  @override
  void didPop() {
    _focusNode?.unfocus();
    super.didPop();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _textEditingController?.addListener(() {
      if ((_textEditingController?.text.length ?? 0) > 200) {
        _textEditingController?.text =
            _textEditingController?.text.substring(0, 200) ?? "";
        _textEditingController?.selection = TextSelection(
            baseOffset: _textEditingController?.text.length ?? 0,
            extentOffset: _textEditingController?.text.length ?? 0);
      }
    });
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _textEditingController?.dispose();
    NewHitaAppPages.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(
              start: 15, end: 15, bottom: 10, top: 10),
          child: Text(
            TrudaLanguageKey.newhita_report.tr,
            style: TextStyle(color: TrudaColors.textColor999, fontSize: 14),
          ),
        ),
        Container(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == reportList.length) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsetsDirectional.all(15),
                      padding: EdgeInsetsDirectional.only(
                          start: 15, end: 15, top: 7.5, bottom: 7.5),
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F3FF),
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(12))),
                      child: TextField(
                        minLines: 5,
                        maxLines: 10,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                        ],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                TrudaLanguageKey.newhita_not_exceed.trArgs(["200"]),
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF999999),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _focusNode?.unfocus();

                        if (selectIndex == -1) {
                          NewHitaLoading.toast(
                              TrudaLanguageKey.newhita_report_edit_topic.tr);
                          return;
                        }

                        // if ((_textEditingController?.text ?? "").length <= 0) {
                        //   showToast(TrudaLanguageKey.newhita_not_entered.tr);
                        //   return;
                        // }

                        NewHitaHttpUtil()
                            .post<void>(NewHitaHttpUrls.reportUpApi,
                                data: {
                                  "type": "2",
                                  "anchorUserId": widget.upid,
                                  "topic": reportList[selectIndex],
                                  "content": (_textEditingController
                                              ?.text.isNotEmpty ==
                                          true)
                                      ? _textEditingController?.text
                                      : "not input",
                                  "linkId": widget.channelid ?? ""
                                },
                                showLoading: true)
                            .then((value) {
                          NewHitaLoading.toast(
                              TrudaLanguageKey.newhita_base_success.tr);
                          Get.back(result: 1);

                          //通话中进行的举报操作 挂断通话
                          // if (Get.currentRoute == ChatRouter){
                          //   Get.find<NewHitaChatEngineController>(
                          //       tag: NewHitaChatEngineController.ChatControllerTag).hangoffCall?.call();
                          // }
                        });
                        // 举报后要拉黑
                        if (NewHitaStorageService.to.checkBlackList(widget.upid)) {
                          return;
                        }
                        NewHitaHttpUtil()
                            .post<int>(
                          NewHitaHttpUrls.blacklistActionApi + widget.upid,
                        )
                            .then((value) {
                          if (value == 1) {
                            NewHitaStorageService.to
                                .updateBlackList(widget.upid, true);
                          }
                          NewHitaLog.debug("拉黑");
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsetsDirectional.only(
                            start: 20, end: 20, bottom: 20, top: 20),
                        height: 52,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(52 * 0.5)),
                            gradient: LinearGradient(colors: [
                              TrudaColors.baseColorRed,
                              TrudaColors.baseColorOrange,
                            ])),
                        child: Text(
                          TrudaLanguageKey.newhita_base_confirm.tr,
                          style: TextStyle(
                              color: TrudaColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                setState(() {
                  // if (selectIndex == index) {
                  //   selectIndex = -1;
                  // } else {
                  //   selectIndex = index;
                  // }
                  selectIndex = index;
                });
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(
                    start: 15, end: 15, top: index == 0 ? 20 : 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reportList[index],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    if (index == selectIndex)
                      Icon(
                        Icons.check_box,
                        color: Colors.blue,
                      ),
                    if (index != selectIndex)
                      Icon(
                        Icons.check_box_outline_blank,
                        color: TrudaColors.white,
                      ),
                  ],
                ),
              ),
            );
          },
          itemCount: reportList.length + 1,
        ))
      ],
    );
  }
}
