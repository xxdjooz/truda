import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_call_record_entity.dart';
import 'package:truda/truda_http/newhita_http_urls.dart';
import 'package:truda/truda_http/newhita_http_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_utils/newhita_loading.dart';

class NewHitaCallListController extends GetxController {
  List<TrudaCallRecordEntity> dataList = [];
  // List<TrudaCallEntity> dataList = [];
  var _page = 0;
  final _pageSize = 10;

  // 0 刚进入， 1有数据，2无数据
  var loadState = 0;

  /// 加载会话列表时的最下面一条的时间戳，根据这个分页加载
  var time = DateTime.now().millisecondsSinceEpoch;
  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
  }

  @override
  void onReady() {
    super.onReady();
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

  // Future _getList(bool refresh) async {
  //   if (refresh) {
  //     time = DateTime.now().millisecondsSinceEpoch;
  //     dataList.clear();
  //   } else {
  //     time = dataList.last.dateInsert;
  //   }
  //   var list = NewHitaStorageService.to.objectBoxCall.queryCallHistory(time);
  //   NewHitaLog.debug("NewHitaCallListController _getList() length=${list.length}");
  //   dataList.addAll(list);
  //   if (dataList.isEmpty) {
  //     loadState = 2;
  //   } else {
  //     loadState = 1;
  //   }
  //   update();
  // }

  Future getList() async {
    _page++;
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await NewHitaHttpUtil()
        .post<List<TrudaCallRecordEntity>?>(NewHitaHttpUrls.calllistApi, data: {
      "page": _page,
      "pageSize": _pageSize,
    }, pageCallback: (has) {
      enablePullUp = has;
    }, errCallback: (err) {
      NewHitaLoading.toast(err.message);
      if (_page == 1) {
        refreshController.refreshCompleted();
      } else {
        refreshController.loadComplete();
      }
    }).then((value) {
      if (_page == 1) {
        dataList.clear();
      }
      if (value != null) {
        loadState = 1;
        dataList.addAll(value);
        update();
      } else {
        if (_page == 1) {
          loadState = 2;
          update();
        }
      }
    }).catchError((e) {
      if (e == 0) {
        if (_page == 1) {
          loadState = 2;
          refreshController.refreshCompleted();
        } else {
          refreshController.loadComplete();
        }
        update();
      }
    });
  }
}
