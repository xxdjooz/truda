import '../../truda_entities/truda_charge_quick_entity.dart';
import '../../truda_entities/truda_hot_entity.dart';
import '../../truda_http/newhita_http_urls.dart';
import '../../truda_http/newhita_http_util.dart';

class NewHitaPayCountriesUtil {
  static List<TrudaAreaData>? areaList;

  static Future<List<TrudaAreaData>> getCountries() async {
    if (areaList?.isNotEmpty == true) {
      return areaList!;
    }
    areaList = await NewHitaHttpUtil().post<List<TrudaAreaData>>(
        NewHitaHttpUrls.getPayCountry, errCallback: (err) {
      // NewHitaLoading.toast(err.message);
    });
    return areaList!;
  }

  static Future<TrudaPayQuickCommodite> getCountryProduct(
      String productId, String countryCode) async {
    return await NewHitaHttpUtil().post<TrudaPayQuickCommodite>(
      NewHitaHttpUrls.getCountryProduct + '/$productId/$countryCode',
      errCallback: (err) {
        // NewHitaLoading.toast(err.message);
      },
      showLoading: true,
    );
  }
}
