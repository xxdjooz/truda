import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_moment_entity.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_utils/newhita_loading.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_routes/truda_pages.dart';
import '../../../truda_services/truda_storage_service.dart';

class TrudaMomentListController extends GetxController {
  List<TrudaMomentDetail> dataList = [];
  var _page = 0;
  final _pageSize = 10;
  bool justOpen = true;

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    onRefresh();
  }

  @override
  void onReady() {
    super.onReady();
  }

  bool enablePullUp = true;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    // monitor network fetch
    _page = 0;
    enablePullUp = true;
    await getList();
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    await getList();
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    refreshController.loadComplete();
  }

  Future getList() async {
    _page++;
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await TrudaHttpUtil().post<List<TrudaMomentDetail>>(
      TrudaHttpUrls.getMoments,
      data: {
        "page": _page,
        "pageSize": _pageSize,
      },
      pageCallback: (has) {
        enablePullUp = has;
      },
      errCallback: (err) {
        NewHitaLoading.toast(err.message);
        if (_page == 1) {
          refreshController.refreshCompleted();
        } else {
          refreshController.loadComplete();
        }
        NewHitaLog.debug('errCallback');
      },
      doneCallback: (suc, msg) {
        justOpen = false;
      },
    ).then((value) {
      if (_page == 1) {
        dataList.clear();
        dataList.addAll(value);
        update();
      } else {
        // 去重
        for (var an in value) {
          if (!dataList.contains(an)) {
            dataList.add(an);
          }
        }
        update();
      }
      NewHitaLog.debug('then');
    }).whenComplete(() {
      NewHitaLog.debug('whenComplete');
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

// void removeBlack(String herId) {
//   NewHitaHttpUtil().post<int>(NewHitaHttpUrls.blacklistActionApi + herId,
//       errCallback: (err) {
//     NewHitaLoading.toast(err.message);
//   }, showLoading: true).then((value) {
//     onRefresh();
//     NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
//     NewHitaStorageService.to.updateBlackList(herId, value == 1);
//   });
// }
  void reportMoment(String momentId, int index) async {
    var result = await Get.toNamed(
      TrudaAppPages.reportPageNew,
      arguments: {
        'reportType': 1,
        'rId': momentId,
      },
    );
    if (result == 1) {
      dataList.removeAt(index);
      update();
    }
  }

  void blackMoment(String momentId, int index) {
    TrudaStorageService.to.updateMomentReportList(momentId);
    dataList.removeAt(index);
    update();
  }

  void handleBlack(String herId) {
    TrudaHttpUtil().post<int>(TrudaHttpUrls.blacklistActionApi + herId,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }).then((value) {
      onRefresh();
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      TrudaStorageService.to.updateBlackList(herId, value == 1);
    });
  }
}
