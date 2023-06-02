import 'package:get/get.dart';
import 'package:truda/truda_services/newhita_storage_service.dart';

import '../../../truda_database/entity/truda_conversation_entity.dart';
import '../../../truda_entities/truda_hot_entity.dart';
import 'truda_hot_controller.dart';
import 'truda_online_controller.dart';

class TrudaHomeController extends GetxController {
  List<TrudaAreaData> areaList = [];
  int areaCode = -1;
  var area = Rx<TrudaAreaData?>(null);
  @override
  void onInit() {
    super.onInit();
  }

  void setAreaData(List<TrudaAreaData> list, int curAreaCode) {
    areaList.clear();
    areaList.addAll(list);
    areaCode = curAreaCode;
    try {
      if (curAreaCode != -1) {
        for (var a in areaList) {
          if (a.areaCode == curAreaCode) {
            area.value = a;
            break;
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void onCountryChoose(TrudaAreaData area) {
    areaCode = area.areaCode ?? -1;
    this.area.value = area;
    try {
      Get.find<TrudaHotController>().onCountryChoose(areaCode);
      Get.find<TrudaOnlineController>().onCountryChoose(areaCode);
    } catch (e) {
      print(e);
    }
  }
}
