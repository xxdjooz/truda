import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_entities/truda_host_entity.dart';
import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import '../truda_pages/host/truda_host_controller.dart';
import '../truda_utils/newhita_loading.dart';

class TrudaSheetSearch extends StatefulWidget {
  static void openMe() {
    Get.bottomSheet(
      TrudaSheetSearch(),
      // 不加这个默认最高屏幕一半
      isScrollControlled: true,
    );
  }

  TrudaSheetSearch({Key? key}) : super(key: key);

  @override
  State<TrudaSheetSearch> createState() => _TrudaSheetSearchState();
}

class _TrudaSheetSearchState extends State<TrudaSheetSearch> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController nameTextController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  void search(String str) {
    TrudaHttpUtil().post<TrudaHostDetail>(
      TrudaHttpUrls.searchUpApi + str,
      doneCallback: (bool success, String message) {
        NewHitaLoading.dismiss();
      },
      showLoading: true,
    ).then((value) {
      TrudaHostController.startMe(value.userId!, value.portrait);
    });
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
            const SizedBox(
              height: 20,
            ),
            Text(
              TrudaLanguageKey.newhita_setting_search.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: TrudaColors.textColor333,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsetsDirectional.only(start: 15, end: 5),
              margin: const EdgeInsetsDirectional.only(
                  top: 15, start: 15, end: 15, bottom: 5),
              decoration: const BoxDecoration(
                color: TrudaColors.baseColorBg,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
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
                          hintText: TrudaLanguageKey.newhita_search_id_hint.tr,
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: TrudaColors.textColor999,
                          )),
                      onChanged: (str) {},
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        nameTextController.text = "";
                      },
                      icon: Image.asset("assets/images/newhita_close_black.png"))
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
                    start: 60, end: 60, bottom: 20, top: 20),
                height: 42,
                decoration: BoxDecoration(
                    color: TrudaColors.baseColorGreen,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black12, width: 1)
                    // gradient: LinearGradient(colors: [
                    //   TrudaColors.baseColorRed,
                    //   TrudaColors.baseColorOrange,
                    // ]),
                    ),
                child: Text(
                  TrudaLanguageKey.newhita_base_confirm.tr,
                  style: const TextStyle(
                      color: TrudaColors.textColor666, fontSize: 16),
                ),
              ),
            ),
          ],
        ));
  }
}
