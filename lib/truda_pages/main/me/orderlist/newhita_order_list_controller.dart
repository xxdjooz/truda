import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_entities/truda_host_entity.dart';
import '../../../../truda_entities/truda_order_entity.dart';
import '../../../../truda_services/newhita_storage_service.dart';
import '../../../../truda_utils/newhita_loading.dart';

class NewHitaOrderListController extends GetxController {
  List<TrudaOrderData> dataList = [];
  var _page = 0;
  final _pageSize = 10;
  int choosedIndex = 0;
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

  void onRefresh({int index = 0}) async {
    choosedIndex = index;
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
    await TrudaHttpUtil()
        .post<List<TrudaOrderData>>(TrudaHttpUrls.orderListApi, data: {
      "page": _page,
      "pageSize": _pageSize,
      // -1所有 0.待支付订单，1.完成订单，2.失败订单
      "orderType": choosedIndex - 1,
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
    }).catchError((err) {
      if (err == 0) {
        if (_page == 1) {
          dataList.clear();
        }
        update();
      }
    });
  }
}
