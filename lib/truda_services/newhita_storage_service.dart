import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_database/truda_object_box_order.dart';
import 'package:truda/truda_services/newhita_my_info_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../truda_database/truda_object_box_call.dart';
import '../truda_database/truda_object_box_msg.dart';
import '../objectbox.g.dart';

class NewHitaStorageService extends GetxService {
  static NewHitaStorageService get to => Get.find();
  late final SharedPreferences prefs;
  late final EventBus eventBus;
  late final TrudaObjectBoxMsg objectBoxMsg;
  late final TrudaObjectBoxCall objectBoxCall;
  late final TrudaObjectBoxOrder objectBoxOrder;
  // late final List<String> blackList;
  List<String>? _momentReportList;
  List<String>? _myBlackList;
  List<String>? _mediaReportList;

  static const keyHadSetGender = "keyHadSetGender";
  static const keyAreaCode = "keyAreaCode";
  static const appTestStyle = "appTestStyle";

  Future<NewHitaStorageService> init() async {
    prefs = await SharedPreferences.getInstance();
    eventBus = EventBus();
    final store = await openStore();
    objectBoxMsg = TrudaObjectBoxMsg.create(store);
    objectBoxCall = TrudaObjectBoxCall.create(store);
    objectBoxOrder = TrudaObjectBoxOrder.create(store);
    // blackList = prefs.getStringList(NewHitaConstants.blackList) ?? [];
    return this;
  }

  //test mode 0线上，1预发布，2测试
  void saveTestStyle(int mode) {
    prefs.setInt(appTestStyle, mode);
  }

  int get getTestStyle {
    int? show = prefs.getInt(appTestStyle);
    return show ?? (TrudaConstants.isTestMode ? 0 : 0);
  }

  int getAreaCode() {
    return prefs.getInt(
            keyAreaCode + (NewHitaMyInfoService.to.userLogin?.userId ?? "")) ??
        -1;
  }

  void saveAreaCode(int code) {
    prefs.setInt(
        keyAreaCode + (NewHitaMyInfoService.to.userLogin?.userId ?? ""), code);
  }

  bool getHadSetGender() {
    return prefs.getBool(
            keyHadSetGender + (NewHitaMyInfoService.to.userLogin?.userId ?? "")) ??
        false;
  }

  void saveHadSetGender() {
    prefs.setBool(
        keyHadSetGender + (NewHitaMyInfoService.to.userLogin?.userId ?? ""), true);
  }

  // bool checkBlackList(String? herId) {
  //   if (herId == null || herId.isEmpty) return false;
  //   return blackList.contains(herId);
  // }
  //
  // bool updateBlackList(String? herId, bool add) {
  //   if (herId == null || herId.isEmpty) return false;
  //   if (!add) {
  //     blackList.remove(herId);
  //     prefs.setStringList(NewHitaConstants.blackList, blackList);
  //     return false;
  //   } else {
  //     blackList.add(herId);
  //     prefs.setStringList(NewHitaConstants.blackList, blackList);
  //     return true;
  //   }
  // }

  bool checkBlackList(String? herId) {
    var blackListKey = '${NewHitaMyInfoService.to.myDetail?.userId}-blackListKey';
    _myBlackList ??= prefs.getStringList(blackListKey) ?? [];
    if (herId == null || herId.isEmpty) return false;
    return _myBlackList!.contains(herId);
  }

  bool updateBlackList(String? herId, bool add) {
    var blackListKey = '${NewHitaMyInfoService.to.myDetail?.userId}-blackListKey';
    _myBlackList ??= prefs.getStringList(blackListKey) ?? [];
    if (herId == null || herId.isEmpty) return false;
    if (!add) {
      _myBlackList!.remove(herId);
      prefs.setStringList(blackListKey, _myBlackList!);
      return false;
    } else {
      _myBlackList!.add(herId);
      prefs.setStringList(blackListKey, _myBlackList!);
      return true;
    }
  }

  // 检查动态是否被拉黑
  bool checkMomentReportList(String? rId) {
    var momentReportListKey =
        '${NewHitaMyInfoService.to.myDetail?.userId}-momentReportListKey';
    _momentReportList ??= prefs.getStringList(momentReportListKey) ?? [];
    if (rId == null || rId.isEmpty) return false;
    return _momentReportList!.contains(rId);
  }

  // 拉黑动态
  bool updateMomentReportList(String? rId, {bool add = true}) {
    var momentReportListKey =
        '${NewHitaMyInfoService.to.myDetail?.userId}-momentReportListKey';
    _momentReportList ??= prefs.getStringList(momentReportListKey) ?? [];
    if (rId == null || rId.isEmpty) return false;
    if (!add) {
      _momentReportList!.remove(rId);
      prefs.setStringList(momentReportListKey, _momentReportList!);
      return false;
    } else {
      _momentReportList!.add(rId);
      prefs.setStringList(momentReportListKey, _momentReportList!);
      return true;
    }
  }

  // 检查主播媒体资源是否被拉黑
  bool checkMediaReportList(String? rId) {
    var mediaReportListKey =
        '${NewHitaMyInfoService.to.myDetail?.userId}-mediaReportListKey';
    _mediaReportList ??= prefs.getStringList(mediaReportListKey) ?? [];
    if (rId == null || rId.isEmpty) return false;
    return _mediaReportList!.contains(rId);
  }

  // 拉黑主播媒体资源
  bool updateMediaReportList(String? rId, {bool add = true}) {
    var mediaReportListKey =
        '${NewHitaMyInfoService.to.myDetail?.userId}-mediaReportListKey';
    _mediaReportList ??= prefs.getStringList(mediaReportListKey) ?? [];
    if (rId == null || rId.isEmpty) return false;
    if (!add) {
      _mediaReportList!.remove(rId);
      prefs.setStringList(mediaReportListKey, _mediaReportList!);
      return false;
    } else {
      _mediaReportList!.add(rId);
      prefs.setStringList(mediaReportListKey, _mediaReportList!);
      return true;
    }
  }
}
