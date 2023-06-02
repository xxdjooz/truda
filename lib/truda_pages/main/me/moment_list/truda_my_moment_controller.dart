import 'package:get/get.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:truda/truda_services/truda_my_info_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_entities/truda_link_content_entity.dart';
import '../../../../truda_utils/newhita_loading.dart';

class TrudaMyMomentController extends GetxController {
  List<TrudaLinkContent> dataList = [];
  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    onRefresh();
  }

  bool enablePullUp = false;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    // monitor network fetch
    // _page = 0;
    // enablePullUp = true;
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
    final myId = TrudaMyInfoService.to.myDetail?.userId ?? '';
    // var areaCode = NewHitaStorageService.to.getAreaCode();
    await TrudaHttpUtil().post<List<TrudaLinkContent>>(
      '${TrudaHttpUrls.getLinkContent}$myId/-1',
      // data: {
      //   "page": _page,
      //   "pageSize": _pageSize,
      // },
      errCallback: (err) {
        NewHitaLoading.toast(err.message);
      },
      showLoading: true,
    ).then((value) {
      dataList.clear();
      dataList.addAll(value);
      update();
    });
  }

  void removeBlack(String rId) {
    TrudaHttpUtil().post<void>(TrudaHttpUrls.delContent + rId,
        errCallback: (err) {
      NewHitaLoading.toast(err.message);
    }, showLoading: true).then((value) {
      onRefresh();
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
    });
  }
}
