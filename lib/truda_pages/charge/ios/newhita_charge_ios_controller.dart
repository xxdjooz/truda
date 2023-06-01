import 'dart:async';

import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../truda_common/truda_charge_path.dart';
import '../../../truda_database/entity/truda_order_entity.dart';
import '../../../truda_entities/truda_charge_entity.dart';
import '../../../truda_entities/truda_charge_quick_entity.dart';
import '../../../truda_entities/truda_info_entity.dart';
import '../../../truda_entities/truda_lottery_user_entity.dart';
import '../../../truda_http/newhita_http_urls.dart';
import '../../../truda_http/newhita_http_util.dart';
import '../../../truda_services/newhita_event_bus_bean.dart';
import '../../../truda_services/newhita_my_info_service.dart';
import '../../../truda_services/newhita_storage_service.dart';
import '../../../truda_utils/newhita_loading.dart';
import '../../../truda_utils/newhita_log.dart';
import '../../../truda_widget/lottery_winner/newhita_lottery_show_player.dart';
import '../../some/newhita_web_page.dart';
import '../newhita_charge_new_channel_dialog.dart';
import '../newhita_in_app_purchase_apple.dart';

class NewHitaChargeIosController extends GetxController {
  static const idMoreList = 'idMoreList';
  List<TrudaPayChannelBean> dataList = [];
  bool googleOnly = true;
  var test = false.obs;

  bool firstIn = true;

  List<TrudaPayQuickCommodite>? allProducts;
  TrudaPayQuickCommodite? cutCommodite;

  TrudaPayQuickCommodite? choosedCommodite;

  NewHitaLotteryWinnerController lotteryController = NewHitaLotteryWinnerController();
  Timer? showTimer;
  List<TrudaLotteryUser> users = [];

  @override
  void onInit() {
    super.onInit();

    if(!TrudaConstants.isFakeMode) {
      _getDrawUser();
    }
  }

  @override
  void onReady() {
    super.onReady();
    getDatas();
    firstIn = false;
    NewHitaAppleInAppPurchase.fixNoEndPurchase();
    NewHitaAppleInAppPurchase.resultStream.listen((event) {
      NewHitaLoading.dismiss();
      if (event == 0) {
        refreshMe();
      }
    });
  }

  Future refreshMe() async {
    NewHitaLog.debug('NewHitaMeController refreshMe()');
    await NewHitaHttpUtil()
        .post<TrudaInfoDetail>(
      NewHitaHttpUrls.userInfoApi,
      showLoading: true,
    )
        .then((value) {
      NewHitaMyInfoService.to.setMyDetail = value;
      update();
      NewHitaStorageService.to.eventBus.fire(eventBusUpdateMe);
    });
  }

  void getDatas() {
    NewHitaHttpUtil().post<TrudaPayQuickData>(
      NewHitaHttpUrls.getCompositeProduct + '2',
      errCallback: (err) {
        NewHitaLoading.toast(err.message);
      },
    ).then((value) {
      allProducts = value.normalProducts;
      cutCommodite = value.discountProduct;
      update();
      // _tryCorrectGooglePrice();
    });
  }

  // 修正一下Google渠道的显示价格
  void _tryCorrectGooglePrice() {
    // List<NewHitaPayQuickCommodite> allList = [];
    //
    // if (allProducts != null) {
    //   allList.addAll(allProducts!);
    // }
    // if (cutCommodite != null) {
    //   allList.add(cutCommodite!);
    // }
    // for (var comm in allList) {
    //   if (comm.channelPays != null) {
    //     for (var channel in comm.channelPays!) {
    //       if (channel.payType == 1) {
    //         NewHitaGoogleBilling.correctQuickGooglePrice(channel).then((value) {
    //           // 正在选择渠道的时候刷新页面
    //           if (value && choosedCommodite != null) {
    //             update();
    //           }
    //         });
    //         continue;
    //       }
    //     }
    //   }
    // }
  }

  // void getDatas() {
  //   NewHitaHttpUtil().post<List<NewHitaPayChannelBean>>(
  //     NewHitaHttpUrls.payListApi + "/1/USD",
  //     errCallback: (err) {
  //       NewHitaLoading.toast(err.message);
  //     },
  //   ).then((value) {
  //     for (var element in value) {
  //       if (element.isExpand == 1) {
  //         element.openMenu = true;
  //       }
  //     }
  //     dataList.clear();
  //     NewHitaGoogleBilling.correctGooglePrice(value).then((v) {
  //       dataList.addAll(value);
  //       googleOnly = dataList.length == 1;
  //       update();
  //     });
  //   });
  // }

  void chooseCommodite(TrudaPayQuickCommodite element) {
    choosedCommodite = element;
    if (element.channelPays?.length == 1) {
      createOrder(element, element.channelPays![0]);
      return;
    }

    Get.bottomSheet(NewHitaChargeChannelDialog(
      payCommodite: element,
      callback: (comm, channel, countryCode) {
        createOrder(comm, channel, countryCode: countryCode);
      },
    ));
  }

  void createOrder(TrudaPayQuickCommodite element, TrudaPayQuickChannel channel,
      {int? countryCode}) {
    NewHitaHttpUtil()
        .post<TrudaCreateOrderBean>(
      NewHitaHttpUrls.createOrderApi,
      data: {
        "productCode": channel.productCode ?? "",
        "storeCode": channel.storeCode ?? "",
        "channelType": channel.channelType ?? "",
        "payType": channel.payType ?? "",
        "currencyCode": channel.currency ?? "",
        "currencyFee": channel.currencyPrice ?? "",
        "refereeUserId": "",
        "createPath": TrudaChargePath.android_recharge_center,
        if (countryCode != null) "countryCode": countryCode,
      },
      showLoading: true,
    )
        .then((value) {
      // 放进数据库
      NewHitaStorageService.to.objectBoxOrder.putOrUpdateOrder(NewHitaOrderEntity(
        userId: NewHitaMyInfoService.to.myDetail?.userId ?? '',
        orderNo: value.orderNo,
        productId: channel.productCode ?? "",
        price: channel.uploadUsd == 1
            ? (channel.price ?? 0).toString()
            : (channel.currencyPrice ?? 0).toString(),
        currency: channel.uploadUsd == 1 ? "USD" : channel.currency,
        payType: (channel.payType ?? 0).toString(),
        type: 'Diamond',
        payTime: '',
        orderCreateTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ));
      if (channel.payType == 2) {
        NewHitaAppleInAppPurchase.checkPurchaseAndPay(
            value.productCode!, value.orderNo!, (success) {});
      } else if (channel.browserOpen == 1) {
        openInOutBrowser(value.payUrl!);
      } else {
        NewHitaWebPage.startMe(value.payUrl!, false);
      }
    });
  }

  void openInOutBrowser(String url) async {
    if (await canLaunch(url)) {
      launch((url));
    }
  }

  void _getDrawUser() {
    NewHitaHttpUtil().post<List<TrudaLotteryUser>>(NewHitaHttpUrls.getDrawUser,
        errCallback: (err) {
          var bean = TrudaLotteryUser();
          bean.nickname = "haha";
          bean.name = "hehe";
          lotteryController.showOne(bean);
        }).then((value) {
      users = value;
      if (users.isNotEmpty) {
        var bean = value.removeAt(0);
        lotteryController.showOne(bean);
      }
      showTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (users.isNotEmpty) {
          var bean = value.removeAt(0);
          lotteryController.showOne(bean);
        } else {
          showTimer?.cancel();
          showTimer = null;
        }
      });
    }).catchError((e) {});
  }

  @override
  void onClose() {
    super.onClose();
    showTimer?.cancel();
  }
}
