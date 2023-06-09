import 'package:get/get.dart';
import 'package:truda/truda_entities/truda_invite_entity.dart';

import '../../truda_http/truda_http_urls.dart';
import '../../truda_http/truda_http_util.dart';

class TrudaInviteController extends GetxController {
  TrudaInviteBean? inviteBean;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future getData() async {
    await TrudaHttpUtil()
        .post<TrudaInviteBean>(
      TrudaHttpUrls.getInviteInfo,
    )
        .then((value) {
      if (value.portraits == null || value.portraits!.isEmpty) {
        // 搞个默认头像
        value.portraits = [
          '',
          // 'https://wscdn.hanilink.com/assets/images/1622622454124.jpg',
          // '',
          // '',
        ];
      }
      inviteBean = value;
      update();
    });
  }
}
