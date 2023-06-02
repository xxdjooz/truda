import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_entities/truda_contribute_entity.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../../truda_common/truda_language_key.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_utils/newhita_loading.dart';

class TrudaContributeController extends GetxController
    with StateMixin<List<TrudaContributeBean>> {
  // List<NewHitaContributeBean> dataList = [];
  late String herId;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  Future getList() async {
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await TrudaHttpUtil().post<List<TrudaContributeBean>>(
        TrudaHttpUrls.getExpendRanking + herId, errCallback: (err) {
      NewHitaLoading.toast(err.message);
      change(null, status: RxStatus.empty());
    }).then((value) {
      change(value,
          status: value.isEmpty ? RxStatus.empty() : RxStatus.success());
    });
  }
}

class TrudaContributeView extends GetView<TrudaContributeController> {
  String herId;

  TrudaContributeView({Key? key, required this.herId}) : super(key: key);

  Color getColor(int index) {
    return index == 0
        ? TrudaColors.baseColorGreen
        : index == 1
            ? TrudaColors.baseColorBlue
            : index == 2
                ? TrudaColors.baseColorPink
                : TrudaColors.textColor666;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TrudaContributeController()..herId = herId);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: TrudaColors.white,
        borderRadius: BorderRadiusDirectional.circular(14),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  child: AutoSizeText(
                    TrudaLanguageKey.newhita_contribute_weekly.tr,
                    style: const TextStyle(
                        color: TrudaColors.textColor333,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    minFontSize: 8,
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        TrudaLanguageKey.newhita_contribute_rank.tr,
                        style: const TextStyle(
                          color: TrudaColors.textColor666,
                          fontSize: 10,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 60),
                        child: Text(
                          TrudaLanguageKey.newhita_contribute_value.tr,
                          style: const TextStyle(
                            color: TrudaColors.textColor666,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          ColoredBox(
            color: Color(0xffEEECF8),
            child: SizedBox(
              width: double.infinity,
              height: 1,
            ),
          ),
          Expanded(
            child: controller.obx(
              (state) => ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state?.length ?? 0,
                itemBuilder: (context, index) {
                  var bean = state![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: TextStyle(
                            fontSize: 20,
                            color: getColor(index),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        NewHitaNetImage(
                          bean.portrait ?? '',
                          width: 30,
                          height: 30,
                          isCircle: true,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          bean.nickname ?? '--',
                          style: TextStyle(
                            fontSize: 16,
                            color: TrudaColors.textColor333,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          (bean.amount ?? 0).toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: TrudaColors.baseColorOrange,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onLoading: Center(child: CircularProgressIndicator()),
              onEmpty: Center(
                  child: Image.asset(
                'assets/images/newhita_base_empty.png',
                height: 100,
                width: 100,
              )),
              onError: (error) => Text('err'),
            ),
          ),
        ],
      ),
    );
  }
}
