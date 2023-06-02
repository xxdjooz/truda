import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_entities/truda_order_entity.dart';
import '../../../../truda_utils/newhita_loading.dart';

class TrudaInviteBonusController extends GetxController {
  List<TrudaCostBean> dataList = [];
  var _page = 0;
  final _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    onRefresh();
  }

  bool enablePullUp = true;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh({int index = 0}) async {
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
    await TrudaHttpUtil().post<List<TrudaCostBean>>(
        TrudaHttpUrls.costListApi,
        data: {
          "page": _page,
          "pageSize": _pageSize,
          "depletionTypes": [10, 19],
        }, pageCallback: (has) {
      enablePullUp = has;
    }, errCallback: (err) {
      NewHitaLoading.toast(err.message);
      if (_page == 1) {
        refreshController.refreshCompleted();
      } else {
        refreshController.loadComplete();
      }
    }, showLoading: true).then((value) {
      if (_page == 1) {
        dataList.clear();
        dataList.addAll(value);
        update();
      } else {
        dataList.addAll(value);
        update();
      }
    });
  }
}
