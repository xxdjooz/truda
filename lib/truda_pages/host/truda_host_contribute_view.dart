import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_entities/truda_contribute_entity.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

import '../../truda_common/truda_language_key.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_utils/truda_loading.dart';

class TrudaHostContributeController extends GetxController
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
      TrudaLoading.toast(err.message);
      change(null, status: RxStatus.empty());
    }).then((value) {
      change(value,
          status: value.isEmpty ? RxStatus.empty() : RxStatus.success());
    });
  }
}

class TrudaHostContributeView
    extends GetView<TrudaHostContributeController> {
  String herId;

  TrudaHostContributeView({Key? key, required this.herId}) : super(key: key);

  Color getColor(int index) {
    return index == 0
        ? TrudaColors.baseColorGreen
        : index == 1
            ? TrudaColors.baseColorBlue
            : index == 2
                ? TrudaColors.baseColorPink
                : TrudaColors.baseColorTheme;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TrudaHostContributeController()..herId = herId);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: TrudaColors.white,
        borderRadius: BorderRadiusDirectional.circular(14),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  TrudaLanguageKey.newhita_contribute_rank.tr,
                  style: const TextStyle(
                    color: TrudaColors.textColor999,
                    fontSize: 12,
                  ),
                ),
                Text(
                  TrudaLanguageKey.newhita_contribute_value.tr,
                  style: const TextStyle(
                    color: TrudaColors.textColor999,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: controller.obx(
              (state) => ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: state?.length ?? 0,
                itemBuilder: (context, index) {
                  var bean = state![index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                        colors: [
                          TrudaColors.transparent,
                          TrudaColors.baseColorGradient2.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        if (index == 0)
                          Image.asset(
                            'assets/images_sized/newhita_contribution_1.png',
                            height: 30,
                            width: 30,
                          )
                        else if (index == 1)
                          Image.asset(
                            'assets/images_sized/newhita_contribution_2.png',
                            height: 30,
                            width: 30,
                          )
                        else if (index == 2)
                          Image.asset(
                            'assets/images_sized/newhita_contribution_3.png',
                            height: 30,
                            width: 30,
                          )
                        else
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: TrudaColors.baseColorGradient2.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                color: getColor(index),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        // const SizedBox(
                        //   width: 5,
                        // ),
                        // NewHitaNetImage(
                        //   bean.portrait ?? '',
                        //   width: 30,
                        //   height: 30,
                        //   isCircle: true,
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            (bean.nickname ?? '--'),
                            style: TextStyle(
                              fontSize: 16,
                              color: TrudaColors.textColor333,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // const Spacer(),
                        // Image.asset('assets/images/newhita_host_contribute.png'),
                        Text(
                          (bean.amount ?? 0).toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: TrudaColors.baseColorGradient2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onLoading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(),
              ),
              onEmpty: Image.asset(
                'assets/images/newhita_base_empty.png',
                height: 100,
                width: 100,
              ),
              onError: (error) => Text('err'),
            ),
          ),
        ],
      ),
    );
  }
}
