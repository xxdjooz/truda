import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_services/newhita_host_video_service.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_entities/truda_banner_entity.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_entities/truda_hot_entity.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_socket/newhita_socket_entity.dart';
import 'truad_home_controller.dart';

class TrudaHotController extends GetxController {
  final String idTab = 'idTab';
  final String idList = 'idList';
  final String idBanner = 'idBanner';
  List<TrudaHostDetail> dataList = [];
  List<TrudaBannerBean> bannerList = [];
  var _page = 0;
  final _pageSize = 30;
  int areaCode = -1;

  /// event bus 监听
  late final StreamSubscription<NewHitaSocketHostState> sub;
  bool firstIn = true;

  bool enablePullUp = true;
  late final RefreshController refreshController;
  @override
  void onInit() {
    super.onInit();

    /// event bus 监听
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
        update([idList]);
      }
    });
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void onReady() {
    super.onReady();
    getList();
    firstIn = false;
  }

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

  void onCountryChoose(int code) {
    areaCode = code;
    refreshController.requestRefresh();
  }

  Future getList() async {
    _page++;
    if (_page == 1) {
      getBanners();
    }
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await TrudaHttpUtil().post<TrudaUpListData>(
        TrudaHttpUrls.upListApi + areaCode.toString(),
        data: {
          "page": _page,
          "pageSize": _pageSize,
          // 这个字段使接口返回videos
          "isShowResource": 1,
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
        dataList.addAll(value.anchorLists!);
        update([idList]);
        Get.find<TrudaHomeController>()
            .setAreaData(value.areaList!, value.curAreaCode ?? -1);
        update([idTab]);
        areaCode = value.curAreaCode ?? -1;
      } else {
        // dataList.addAll(value.anchorLists!);
        // 去重
        for (var an in value.anchorLists!) {
          if (!dataList.contains(an)) {
            dataList.add(an);
          }
        }
        update([idList]);
      }
      saveHostSimpleInfo(value.anchorLists);
      NewHitaHostVideoService.to.handleData(dataList, _page, areaCode);
    });
  }

  void getBanners() {
    TrudaHttpUtil()
        .post<List<TrudaBannerBean>>(TrudaHttpUrls.bannerApi,
            errCallback: (err) {})
        .then((value) {
      bannerList = value;
      update([idBanner]);
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
