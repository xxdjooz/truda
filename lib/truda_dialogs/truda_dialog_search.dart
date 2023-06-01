import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_common_dialog.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_entities/truda_host_entity.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';
import '../truda_pages/host/newhita_host_controller.dart';
import '../truda_utils/newhita_loading.dart';
import '../truda_widget/newhita_gradient_boder.dart';
import '../truda_widget/newhita_sheet_header.dart';

class TrudaDialogSearch extends StatefulWidget {
  static void openMe() {
    TrudaCommonDialog.bottomSheet(
      TrudaDialogSearch(),
    );
  }

  TrudaDialogSearch({Key? key}) : super(key: key);

  @override
  State<TrudaDialogSearch> createState() => _TrudaDialogSearchState();
}

class _TrudaDialogSearchState extends State<TrudaDialogSearch> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController nameTextController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  void search(String str) {
    NewHitaHttpUtil().post<TrudaHostDetail>(
      NewHitaHttpUrls.searchUpApi + str,
      doneCallback: (bool success, String message) {
        NewHitaLoading.dismiss();
      },
      showLoading: true,
    ).then((value) {
      NewHitaHostController.startMe(value.userId!, value.portrait);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const NewHitaSheetHeader(),
        ColoredBox(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsetsDirectional.only(start: 15, end: 5),
                margin: const EdgeInsetsDirectional.only(
                    top: 15, start: 15, end: 15, bottom: 5),
                decoration: const BoxDecoration(
                  color: TrudaColors.baseColorBg,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    // Image.asset("assets/images/newhita_search.png"),
                    Icon(Icons.search),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 16,
                          color: TrudaColors.textColor333,
                        ),
                        controller: nameTextController,
                        focusNode: nameFocusNode,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                TrudaLanguageKey.newhita_search_id_hint.tr,
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: TrudaColors.textColor333,
                            )),
                        onChanged: (str) {},
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          nameTextController.text = "";
                        },
                        icon: Image.asset(
                            "assets/images/newhita_close_black.png"))
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  search(nameTextController.text.trim());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.only(
                      start: 60, end: 60, bottom: 40, top: 20),
                  height: 42,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: Colors.black12, width: 1),
                      gradient: LinearGradient(colors: [
                        TrudaColors.baseColorGradient1,
                        TrudaColors.baseColorGradient2,
                      ]),
                      ),
                  child: Text(
                    TrudaLanguageKey.newhita_setting_search.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: TrudaColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
