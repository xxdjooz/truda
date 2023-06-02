import 'dart:convert';

import '../../generated/json/base/json_convert_content.dart';
import '../../truda_common/truda_constants.dart';
import '../../truda_entities/truda_gift_entity.dart';
import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';
import '../../truda_services/truda_storage_service.dart';
import '../../truda_utils/newhita_log.dart';
import '../newhita_cache_manager.dart';

class NewHitaGiftDataHelper {
  static Future<List<TrudaGiftEntity>?> getGifts({bool vip = false}) async {
    List<TrudaGiftEntity>? listStore;
    List<TrudaGiftEntity> vipList = [];
    String? giftsJson =
        TrudaStorageService.to.prefs.getString(TrudaConstants.giftsJson);
    if (giftsJson != null && giftsJson.isNotEmpty) {
      listStore = jsonConvert
          .convertListNotNull<TrudaGiftEntity>(json.decode(giftsJson));
    }
    if (listStore != null && listStore.isNotEmpty) {
      NewHitaLog.debug('NewHitaGiftDataHelper Store');
    } else {
      var list = await TrudaHttpUtil().post<List<TrudaGiftEntity>>(
          TrudaHttpUrls.allGiftListApi, errCallback: (err) {
        // NewHitaLoading.toast(err.message);
      });
      if (list.isNotEmpty) {
        String jsonGifts = json.encode(list);
        TrudaStorageService.to.prefs
            .setString(TrudaConstants.giftsJson, jsonGifts);
      }
      listStore = list;
    }

    if (!vip) {
      return listStore;
    } else {
      // 非vip
      for (var gift in listStore) {
        if (gift.vipVisible == 1) {
          vipList.add(gift);
        }
      }
      return vipList;
    }
  }

  static checkGiftDownload() {
    getGifts().then((value) {
      if (value == null || value.isEmpty) return;
      for (var gift in value) {
        NewHitaGiftCacheManager.instance
            .getSingleFile(gift.animEffectUrl ?? '')
            .then((value) {
          NewHitaLog.debug('checkGiftDownload getSingleFile ${value.path}');
        });
      }
    });
  }
}
