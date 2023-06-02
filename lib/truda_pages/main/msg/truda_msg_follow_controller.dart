import 'dart:async';

import 'package:get/get.dart';
import 'package:truda/truda_services/truda_storage_service.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../../../truda_database/entity/truda_conversation_entity.dart';
import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_database/entity/truda_msg_entity.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_services/truda_event_bus_bean.dart';
import '../../../truda_utils/truda_loading.dart';

class TrudaMsgFollowController extends GetxController {
  /// 加载会话列表时的最下面一条的时间戳，根据这个分页加载
  var time = DateTime.now().millisecondsSinceEpoch;
  final dataList = <TrudaConversationEntity>[].obs;
  List<TrudaHostDetail> focusUpList = []; // 缓存我的关注
  /// event bus 监听
  late final StreamSubscription<TrudaMsgEntity> sub;
  late final StreamSubscription<TrudaHerEntity> subHer;
  late final StreamSubscription<TrudaEventMsgClear> subClear;
  @override
  void onInit() {
    super.onInit();
    TrudaLog.good("NewHitaMsgController onInit()");
    // _getList();

    /// event bus 监听
    sub = TrudaStorageService.to.eventBus.on<TrudaMsgEntity>().listen((event) {
      _getList();
    });
    subHer = TrudaStorageService.to.eventBus.on<TrudaHerEntity>().listen((event) {
      _getList();
    });
    subClear =
        TrudaStorageService.to.eventBus.on<TrudaEventMsgClear>().listen((event) {
      _getList();
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadFollow(loadUper: true);
  }

  void loadFollow({bool loadUper = false}) {
    if (!loadUper && focusUpList.isNotEmpty) {
      _getList();
      return;
    }
    TrudaHttpUtil()
        .post<List<TrudaHostDetail>>(TrudaHttpUrls.followUpListApi + "1", data: {
      "page": 1,
      "pageSize": 100,
    }, pageCallback: (has) {
      // enablePullUp = has;
    }, errCallback: (err) {
      TrudaLoading.toast(err.message);
      // refreshController.refreshCompleted();
    }).then((value) {
      focusUpList.clear();
      focusUpList.addAll(value);
      _getList();
    });
  }

  Future refresh() async {
    loadFollow(loadUper: true);
  }

  void _getList() {
    dataList.clear();
    time = DateTime.now().millisecondsSinceEpoch;
    var list = TrudaStorageService.to.objectBoxMsg.queryHostCon(time);
    TrudaLog.debug("NewHitaMsgController _getList() length=${list.length}");
    // dataList.addAll(list);
    // update(['list']);
    focusUpList.forEach((uper) {
      list.forEach((talk) {
        if (uper.userId == talk.herId) {
          dataList.add(talk);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
    subHer.cancel();
    subClear.cancel();
  }
}
