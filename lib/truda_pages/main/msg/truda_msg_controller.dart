import 'dart:async';

import 'package:get/get.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../../../truda_common/truda_constants.dart';
import '../../../truda_common/truda_language_key.dart';
import '../../../truda_database/entity/truda_conversation_entity.dart';
import '../../../truda_database/entity/truda_her_entity.dart';
import '../../../truda_database/entity/truda_msg_entity.dart';
import '../../../truda_http/truda_http_urls.dart';
import '../../../truda_http/truda_http_util.dart';
import '../../../truda_services/newhita_event_bus_bean.dart';
import '../../../truda_utils/ad/newhita_ads_native_utils.dart';
import '../../../truda_utils/ad/newhita_ads_rewarded_utils.dart';
import '../../../truda_utils/ad/newhita_ads_utils.dart';
import '../../../truda_utils/newhita_loading.dart';

class TrudaMsgController extends GetxController {
  /// 加载会话列表时的最下面一条的时间戳，根据这个分页加载
  var time = DateTime.now().millisecondsSinceEpoch;
  final dataList = <TrudaConversationEntity>[].obs;

  /// event bus 监听
  late final StreamSubscription<TrudaMsgEntity> sub;
  late final StreamSubscription<TrudaHerEntity> subHer;
  late final StreamSubscription<NewHitaEventMsgClear> subClear;

  ///激励广告工具类
  late NewHitaAdsRewardedUtils rewardedUtils;

  ///本地广告工具类
  late NewHitaAdsNativeUtils nativeUtils;
  // 上次加载广告时间
  var lastLoadReward = 0;
  @override
  void onInit() {
    super.onInit();
    NewHitaLog.good("NewHitaMsgController onInit()");

    rewardedUtils = NewHitaAdsRewardedUtils(
        NewHitaAdsUtils.getAdCode(NewHitaAdsUtils.REWARD_ONE_MESSAGE_CHAT), () {
      lastLoadReward = DateTime.now().millisecondsSinceEpoch;
      update();
    });
    nativeUtils = NewHitaAdsNativeUtils(
        NewHitaAdsUtils.getAdCode(NewHitaAdsUtils.NATIVE_CONVERSATION_LIST), () {
      update();
    });


  }

  void _reloadAdReward() {
    // var nowTime = DateTime.now().millisecondsSinceEpoch;
    // if (nowTime - lastLoadReward > 2 * 60 * 1000) {
    //   lastLoadReward = nowTime;
    //   rewardedUtils.hasAdReady();
    // }
  }

  @override
  void onReady() {
    super.onReady();

    /// event bus 监听
    sub = NewHitaStorageService.to.eventBus.on<TrudaMsgEntity>().listen((event) {
      _getList();
    });
    subHer = NewHitaStorageService.to.eventBus.on<TrudaHerEntity>().listen((event) {
      _getList();
    });
    subClear =
        NewHitaStorageService.to.eventBus.on<NewHitaEventMsgClear>().listen((event) {
      NewHitaLog.good("NewHitaMsgController subClear");
      _getList();
    });

    if (TrudaConstants.appMode != 0) {
      NewHitaStorageService.to.objectBoxMsg.make10000().then((value) {
        NewHitaLog.good("NewHitaMsgController make10000 = $value");
      }).whenComplete(() => _getList());
    } else {
      _getList();
    }
  }

  Future refresh() async {
    _getList();
  }

  void _getList() {
    dataList.clear();
    time = DateTime.now().millisecondsSinceEpoch;
    var list = NewHitaStorageService.to.objectBoxMsg.queryHostCon(time);
    NewHitaLog.debug("NewHitaMsgController _getList() length=${list.length}");
    dataList.addAll(list);
    // update(['list']);

    _reloadAdReward();
  }


  void handleBlack(String herId) {
    if (herId == TrudaConstants.serviceId){
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      NewHitaStorageService.to.updateBlackList(herId, true);
      NewHitaStorageService.to.objectBoxMsg.make10000().then((value) {
        NewHitaLog.good("NewHitaMsgController make10000 = $value");
      }).whenComplete(() => _getList());
      return;
    }
    TrudaHttpUtil().post<int>(TrudaHttpUrls.blacklistActionApi + herId,
        errCallback: (err) {
          NewHitaLoading.toast(err.message);
        }).then((value) {
      NewHitaLoading.toast(TrudaLanguageKey.newhita_base_success.tr);
      NewHitaStorageService.to.updateBlackList(herId, value == 1);
      refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
    subHer.cancel();
    subClear.cancel();

    nativeUtils.closeSub();
    rewardedUtils.closeSub();
  }
}
