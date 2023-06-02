import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_http/truda_common_api.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_routes/newhita_pages.dart';

import '../../truda_database/entity/truda_her_entity.dart';
import '../../truda_entities/truda_host_entity.dart';
import '../../truda_entities/truda_moment_entity.dart';
import '../../truda_services/newhita_storage_service.dart';
import '../../truda_utils/newhita_loading.dart';
import 'dart:ui' as ui;

import '../../truda_utils/newhita_ui_image_util.dart';

class TrudaHostController extends GetxController {
  late String herId;
  String? portrait;
  TrudaHostDetail? detail;

  ui.Image? indicatorImage;
  List<TrudaMomentDetail> momentList = [];

  static Future<T?>? startMe<T>(String herId, String? portrait) async {
    Map<String, dynamic> map = {};
    map['herId'] = herId;
    map['portrait'] = portrait;
    return await Get.toNamed(NewHitaAppPages.hostDetail, arguments: map);
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments as Map<String, dynamic>;
    herId = arguments['herId']!;
    portrait = arguments['portrait'];
    _getHostDetail();
    _getMomentList();

    NewHitaUiImageUtil.getAssetImage(
        'assets/images_sized/newhita_circle_indicator.png')
        .then((value) {
      indicatorImage = value;
      update();
    });
  }

  void _getHostDetail() {
    NewHitaLoading.show();
    TrudaHttpUtil().post<TrudaHostDetail>(TrudaHttpUrls.upDetailApi + herId,
        data: {'vipVideo': 1}, errCallback: (err) {
      NewHitaLoading.toast(err.message);
      NewHitaLoading.dismiss();
    }).then((value) {
      detail = value;
      portrait = value.portrait ?? '';
      update();

      NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
          value.nickname ?? '', value.userId!,
          portrait: value.portrait));
      NewHitaLoading.dismiss();
    });
  }

  void handleFollow() {
    // NewHitaHttpUtil().post<int>(NewHitaHttpUrls.followUpApi + herId,
    //     errCallback: (err) {
    //   NewHitaLoading.toast(err.message);
    // }, showLoading: true).then((value) {
    //   detail?.followed = value;
    //   update();
    // });
    TrudaCommonApi.followHostOrCancel(herId).then((value) {
      detail?.followed = value;
      update();
    });
  }

  void handleBlack() {
    TrudaHttpUtil().post<int>(TrudaHttpUrls.blacklistActionApi + herId,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }).then((value) {
      update();
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
    });
  }

  Future _getMomentList() async {
    await TrudaHttpUtil().post<List<TrudaMomentDetail>>(TrudaHttpUrls.getMoments,
        data: {
          "page": 1,
          "pageSize": 20,
          "userId": herId,
        },
        pageCallback: (has) {}, errCallback: (err) {
      // NewHitaLoading.toast(err.message);
    }).then((value) {
      // 筛掉黑名单的动态
      final List<TrudaMomentDetail> result = [];
      for (var item in value) {
        if (!NewHitaStorageService.to.checkMomentReportList(item.momentId)) {
          result.add(item);
        }
      }
      momentList.clear();
      momentList.addAll(result);
      update();
    });
  }

  void priseMoment(String momentId, bool prise) {
    TrudaHttpUtil().post<int>(
        prise
            ? TrudaHttpUrls.momentsPraise + momentId
            : TrudaHttpUrls.momentsPraiseCancel + momentId, errCallback: (err) {
      // NewHitaLoading.toast(err.message);
    }, showLoading: false);
  }

  void reportMoment(String momentId, int index) async {
    var result = await Get.toNamed(
      NewHitaAppPages.reportPageNew,
      arguments: {
        'reportType': 1,
        'rId': momentId,
      },
    );
    if (result == 1) {
      momentList.removeAt(index);
      update();
    }
  }

  @override
  void onClose() {
    super.onClose();
    indicatorImage?.dispose();
  }
}
