import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_http/truda_http_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_entities/truda_host_entity.dart';
import '../../../../truda_entities/truda_order_entity.dart';
import '../../../../truda_services/truda_storage_service.dart';
import '../../../../truda_utils/truda_loading.dart';

class TrudaCostListController extends GetxController {
  List<TrudaCostBean> dataList = [];
  var _page = 0;
  final _pageSize = 10;

  int currentMonthInt = 1;
  int lastMoth = 1;
  int lastlastMoth = 1;

  String currentMonthFormat = '';
  String lastMonthFormat = '';
  String lastLastMonthFormat = '';

  int choosedIndex = 0;
  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments as Map<String, dynamic>;
    // herId = arguments['herId']!;
    var formater = DateFormat('yyyy-MM-01');
    var timeNow = DateTime.now();
    // var timeNow = DateTime(2020, 1);
    DateTime lastMonthDate;
    DateTime lastLastMonthDate;
    currentMonthFormat = formater.format(timeNow);
    currentMonthInt = timeNow.month;

    lastMoth = currentMonthInt - 1;
    if (lastMoth <= 0) {
      lastMoth = 12 + lastMoth;
      lastMonthDate = DateTime(timeNow.year - 1, lastMoth);
    } else {
      lastMonthDate = DateTime(timeNow.year, lastMoth);
    }
    lastMoth = lastMonthDate.month;
    lastMonthFormat = formater.format(lastMonthDate);

    lastlastMoth = currentMonthInt - 2;
    if (lastlastMoth <= 0) {
      lastlastMoth = 12 + lastlastMoth;
      lastLastMonthDate = DateTime(timeNow.year - 1, lastlastMoth);
    } else {
      lastLastMonthDate = DateTime(timeNow.year, lastlastMoth);
    }
    lastlastMoth = lastLastMonthDate.month;
    lastLastMonthFormat = formater.format(lastLastMonthDate);
  }

  //TO DO 月份国际化
  String getMonth(int month) {
    String m = "";
    switch (month) {
      case 1:
        m = TrudaLanguageKey.newhita_month_1.tr;
        break;
      case 2:
        m = TrudaLanguageKey.newhita_month_2.tr;
        break;
      case 3:
        m = TrudaLanguageKey.newhita_month_3.tr;
        break;
      case 4:
        m = TrudaLanguageKey.newhita_month_4.tr;
        break;
      case 5:
        m = TrudaLanguageKey.newhita_month_5.tr;
        break;
      case 6:
        m = TrudaLanguageKey.newhita_month_6.tr;
        break;
      case 7:
        m = TrudaLanguageKey.newhita_month_7.tr;
        break;
      case 8:
        m = TrudaLanguageKey.newhita_month_8.tr;
        break;
      case 9:
        m = TrudaLanguageKey.newhita_month_9.tr;
        break;
      case 10:
        m = TrudaLanguageKey.newhita_month_10.tr;
        break;
      case 11:
        m = TrudaLanguageKey.newhita_month_11.tr;
        break;
      case 12:
        m = TrudaLanguageKey.newhita_month_12.tr;
        break;
    }
    return m;
  }

  String choosedMonth() {
    switch (choosedIndex) {
      case 0:
        return currentMonthFormat;
      case 1:
        return lastMonthFormat;
      case 2:
        return lastLastMonthFormat;
      default:
        return currentMonthFormat;
    }
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
    this.choosedIndex = index;
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
        TrudaHttpUrls.costListApi + choosedMonth(),
        data: {
          "page": _page,
          "pageSize": _pageSize,
        }, pageCallback: (has) {
      enablePullUp = has;
    }, errCallback: (err) {
      TrudaLoading.toast(err.message);
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
