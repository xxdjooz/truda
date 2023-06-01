import 'dart:convert';

import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_info_entity.dart';
import 'package:truda/truda_services/newhita_app_info_service.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';

import '../generated/json/base/json_convert_content.dart';
import '../truda_entities/truda_config_entity.dart';
import '../truda_entities/truda_leval_entity.dart';
import '../truda_entities/truda_login_entity.dart';
import '../truda_socket/newhita_socket_entity.dart';

class NewHitaMyInfoService extends GetxService {
  static NewHitaMyInfoService get to => Get.find();
  static const userLoginData = 'userLoginData';
  String? authorization;
  TrudaConfigData? config;

  TrudaLoginToken? token;
  String? enterTheSystem;
  TrudaLoginUser? userLogin;
  TrudaInfoDetail? _myDetail;

  List<TrudaLevalBean>? levalList;
  List<String>? sensitiveList;

  /// 当前正在和谁发消息
  String? chattingWithHer;

  RxInt msgUnreadNum = 0.obs;
  RxInt haveLotteryTimes = 0.obs;

  Future<NewHitaMyInfoService> init() async {
    String? str = NewHitaStorageService.to.prefs.getString(userLoginData);
    if (str != null && str.isNotEmpty) {
      try {
        TrudaLogin login = JsonConvert.fromJsonAsT<TrudaLogin>(jsonDecode(str))!;
        setLoginData(login);
      } catch (e) {
        print(e);
      }
    }
    return this;
  }

  TrudaInfoDetail? get myDetail => _myDetail;

  set setMyDetail(TrudaInfoDetail value) {
    _myDetail = value;
    haveLotteryTimes.value = value.rechargeDrawCount ?? 0;
  }

  ///用户是否又未使用体验卡   true : 有   false: 没有
  bool isHaveCallCard() {
    return (_myDetail?.callCardCount ?? 0) > 0;
  }

  bool get isVipNow {
    if (_myDetail == null) return false;
    if (_myDetail!.isVip != 1) return false;
    return true;
  }

  int getLastShowLeval() {
    if (myDetail == null) {
      return 100;
    }
    return NewHitaStorageService.to.prefs
            .getInt((myDetail?.userId ?? '') + 'leval') ??
        1;
  }

  void saveLastLeval(int leval) {
    NewHitaStorageService.to.prefs
        .setInt((myDetail?.userId ?? '') + 'leval', leval);
  }

  // 收到socket余额变动消息
  void handleBalanceChange(NewHitaSocketBalance entity) {
    NewHitaLog.debug('handleBalanceChange $entity');
    _myDetail?.userBalance?.remainDiamonds = entity.diamonds;
    _myDetail?.userBalance?.expLevel = entity.expLevel;
  }

  // 消耗体验卡后减去数量
  // void subtractCard() {
  //   NewHitaLog.debug('subtractCard ');
  //   var myCard = _myDetail?.callCardCount ?? 0;
  //   myCard -= 1;
  //   if (myCard < 0) return;
  //   _myDetail?.callCardCount = myCard;
  // }

  // 登录后设置这个登录信息
  void setLoginData(TrudaLogin theLogin) {
    token = theLogin.token;
    enterTheSystem = theLogin.enterTheSystem;
    userLogin = theLogin.user;
    authorization = token?.authorization;
    String str = jsonEncode(theLogin.toJson());
    NewHitaStorageService.to.prefs.setString(userLoginData, str);
  }

  String? getLevalUrl() {
    if (config?.leveldetailurl == null || myDetail == null) {
      return null;
    }
    return '${config?.leveldetailurl}?areaCode=${myDetail?.areaCode ?? '1'}'
        '&expe=${myDetail?.userBalance?.expLevel ?? 0}'
        '&appName=${NewHitaAppInfoService.to.channelName}';
  }

  TrudaLevalBean? getMyLeval() {
    if (levalList == null || levalList!.isEmpty || myDetail == null) {
      return null;
    }
    var myExp = myDetail!.userBalance?.expLevel ?? 0;
    TrudaLevalBean? bean;
    for (var element in levalList!) {
      if (myExp >= (element.howExp ?? 0)) {
        bean = element;
      }
    }
    return bean;
  }

  TrudaLevalBean? getLeval(int? exp) {
    if (levalList == null || levalList!.isEmpty || exp == null) {
      return null;
    }
    // var myExp = myDetail!.userBalance?.expLevel ?? 0;
    TrudaLevalBean? bean;
    for (var element in levalList!) {
      if (exp >= (element.howExp ?? 0)) {
        bean = element;
      }
    }
    return bean;
  }

  bool getIsHadCharge() {
    if (myDetail == null) {
      return false;
    }
    if ((myDetail?.userBalance?.totalRecharge ?? 0) > 0) {
      return true;
    }
    return NewHitaStorageService.to.prefs
            .getBool((myDetail?.userId ?? '') + 'hadCharge') ??
        false;
  }

  void saveHadCharge() {
    NewHitaStorageService.to.prefs
        .setBool((myDetail?.userId ?? '') + 'hadCharge', true);
  }

  void clear() {
    authorization = null;
    // config = null;
    token = null;
    enterTheSystem = null;
    userLogin = null;
    _myDetail = null;
    chattingWithHer = null;
  }
}
