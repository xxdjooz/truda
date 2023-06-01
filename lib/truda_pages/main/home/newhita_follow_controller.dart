import 'dart:async';

import 'package:get/get.dart';
import 'package:truda/truda_pages/main/home/newhita_page_index_manager.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../truda_database/entity/truda_conversation_entity.dart';
import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_entities/truda_hot_entity.dart';
import '../../../truda_http/newhita_http_urls.dart';
import '../../../truda_http/newhita_http_util.dart';
import '../../../truda_socket/newhita_socket_entity.dart';
import '../../../truda_utils/newhita_loading.dart';

class NewHitaFollowController extends GetxController {
  List<TrudaHostDetail> dataList = [];
  var _page = 0;
  final _pageSize = 10;

  /// event bus 监听
  late final StreamSubscription<NewHitaSocketHostState> sub;
  var shouldReload = false;
  @override
  void onInit() {
    super.onInit();
    getList();

    /// event bus 监听 在线状态
    sub = NewHitaStorageService.to.eventBus
        .on<NewHitaSocketHostState>()
        .listen((event) {
      bool needRefresh = false;
      for (TrudaHostDetail her in dataList) {
        if (her.userId == event.userId) {
          her.isOnline = event.isOnline;
          her.isDoNotDisturb = event.isDoNotDisturb;
          needRefresh = true;
          break;
        }
      }
      if (needRefresh) {
        update();
      }
    });

    // 监听本页面被显示
    ever<bool>(NewHitaPageIndexManager.followShow, (o) {
      NewHitaLog.debug('follow show $o');
      if (o){
        if (shouldReload){
          onRefresh();
        }
      }
    });
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

  //
  Future getList() async {
    _page++;
    await NewHitaHttpUtil()
        .post<List<TrudaHostDetail>>(NewHitaHttpUrls.followUpListApi + "1", data: {
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
        dataList.addAll(value);
        if (value.isEmpty) {
          // NewHitaLoading.toast('empty');
        }
      } else {
        dataList.addAll(value);
      }
      update();
      saveHostSimpleInfo(value);
    });
  }

  void saveHostSimpleInfo(List<TrudaHostDetail>? anchorLists) {
    if (anchorLists == null || anchorLists.isEmpty) return;
    for (TrudaHostDetail her in anchorLists) {
      NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
          her.nickname ?? '', her.userId!,
          portrait: her.portrait));
    }
  }

  @override
  void onClose() {
    super.onClose();
    sub.cancel();
  }
}
