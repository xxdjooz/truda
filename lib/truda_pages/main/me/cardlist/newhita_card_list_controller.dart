import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_card_entity.dart';
import 'package:truda/truda_http/newhita_http_urls.dart';
import 'package:truda/truda_http/newhita_http_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_utils/newhita_loading.dart';

class NewHitaCardListController extends GetxController {
  List<TrudaCardBean> dataList = [];

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    onRefresh();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    // monitor network fetch
    await getList();
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

  Future getList() async {
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await NewHitaHttpUtil().post<List<TrudaCardBean>>(NewHitaHttpUrls.toolsApi,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }, showLoading: true).then((value) {
      dataList.clear();
      dataList.addAll(value);
      update();
    }).catchError((e) {});
  }
}
