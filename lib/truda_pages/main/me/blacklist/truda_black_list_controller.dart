import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_constants.dart';
import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_entities/truda_host_entity.dart';
import '../../../../truda_services/truda_storage_service.dart';
import '../../../../truda_utils/truda_loading.dart';

class TrudaBlackListController extends GetxController {
  List<TrudaHostDetail> dataList = [];
  var _page = 0;
  final _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    onRefresh();
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
    await TrudaHttpUtil().post<List<TrudaHostDetail>>(
      TrudaHttpUrls.blacklistApi,
      data: {
        "page": _page,
        "pageSize": _pageSize,
      },
      pageCallback: (has) {
        enablePullUp = has;
      },
      errCallback: (err) {
        TrudaLoading.toast(err.message);
        if (_page == 1) {
          refreshController.refreshCompleted();
        } else {
          refreshController.loadComplete();
        }
      },
      showLoading: true,
    ).then((value) {
      if (_page == 1) {
        dataList.clear();
        dataList.addAll(value);
        if (TrudaStorageService.to
            .checkBlackList(TrudaConstants.serviceId)) {
          var ser = TrudaHostDetail();
          ser.userId = TrudaConstants.serviceId;
          ser.nickname = TrudaConstants.appName;
          dataList.insert(0, ser);
        }
        update();
      } else {
        dataList.addAll(value);
        update();
      }
    });
  }

  void removeBlack(String herId) {
    if (herId == TrudaConstants.serviceId) {
      TrudaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      TrudaStorageService.to.updateBlackList(herId, false);
      onRefresh();
      return;
    }
    TrudaHttpUtil().post<int>(TrudaHttpUrls.blacklistActionApi + herId,
        errCallback: (err) {
      TrudaLoading.toast(err.message);
    }, showLoading: true).then((value) {
      onRefresh();
      TrudaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      TrudaStorageService.to.updateBlackList(herId, value == 1);
    });
  }
}
