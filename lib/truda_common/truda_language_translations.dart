import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'language/truda_language_ar.dart';
import 'language/truda_language_en.dart';
import 'language/truda_language_es.dart';
import 'language/truda_language_hi.dart';
import 'language/truda_language_ind.dart';
import 'language/truda_language_pt.dart';
import 'language/truda_language_th.dart';
import 'language/truda_language_tr.dart';

class TrudaTrans extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      "en": truda_language_en,
      "ar": truda_language_ar,
      "es": truda_language_es,
      "hi": truda_language_hi,
      "id": truda_language_ind,
      "pt": truda_language_pt,
      "tr": truda_language_tr,
      "th": truda_language_th,
    };
  }
}
