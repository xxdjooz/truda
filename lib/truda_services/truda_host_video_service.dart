import 'package:get/get.dart';

import '../truda_database/entity/truda_her_entity.dart';
import '../truda_entities/truda_host_entity.dart';
import '../truda_entities/truda_hot_entity.dart';
import '../truda_http/truda_http_urls.dart';
import '../truda_http/truda_http_util.dart';
import 'truda_storage_service.dart';

class TrudaHostVideoService extends GetxService {
  static TrudaHostVideoService get to => Get.find();

  List<TrudaHostDetail> dataList = [];
  int currentPage = 0; // 从1开始第一页
  int areaCode = -1;
  Future<TrudaHostVideoService> init() async {
    return this;
  }

  void handleData(List<TrudaHostDetail> list, int currentPage, int areaCode) {
    this.currentPage = currentPage;
    this.areaCode = areaCode;
    dataList.clear();
    for (var host in list) {
      if (host.videos != null && host.videos!.isNotEmpty) {
        dataList.add(host);
      }
    }
  }

  Future<List<TrudaHostDetail>> getMore() async {
    var data = await TrudaHttpUtil().post<TrudaUpListData>(
        TrudaHttpUrls.upListApi + areaCode.toString(),
        data: {
          "page": currentPage++,
          "pageSize": 10,
          // 这个字段使接口返回videos
          "isShowResource": 1,
          "onlyVideo": 1,
        }, pageCallback: (has) {
      // enablePullUp = has;
    }, errCallback: (err) {
      // NewHitaLoading.toast(err.message);
    });
    areaCode = data.curAreaCode ?? -1;
    List<TrudaHostDetail> result = [];
    for (var an in data.anchorLists!) {
      if (an.videos != null &&
          an.videos!.isNotEmpty &&
          !dataList.contains(an)) {
        result.add(an);
      }
    }
    saveHostSimpleInfo(data.anchorLists);
    dataList.addAll(result);
    return result;
  }

  void saveHostSimpleInfo(List<TrudaHostDetail>? anchorLists) {
    if (anchorLists == null || anchorLists.isEmpty) return;
    for (TrudaHostDetail her in anchorLists) {
      TrudaStorageService.to.objectBoxMsg.putOrUpdateHer(TrudaHerEntity(
          her.nickname ?? '', her.userId!,
          portrait: her.portrait));
    }
  }
}
