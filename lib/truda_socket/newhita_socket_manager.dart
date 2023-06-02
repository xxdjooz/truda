import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:truda/truda_common/truda_common_type.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_http/truda_http_urls.dart';
import 'package:truda/truda_pages/charge/success/newhita_success_controller.dart';
import 'package:truda/truda_widget/gift/newhita_gift_data_helper.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../truda_routes/newhita_pages.dart';
import '../truda_rtm/newhita_rtm_msg_entity.dart';
import '../truda_services/newhita_app_info_service.dart';
import '../truda_services/newhita_event_bus_bean.dart';
import '../truda_services/newhita_my_info_service.dart';
import '../truda_services/newhita_storage_service.dart';
import '../truda_utils/newhita_log.dart';
import 'newhita_socket_entity.dart';

class NewHitaSocketManager extends GetxService {
  static NewHitaSocketManager get to => Get.find();
  late IOWebSocketChannel channel;
  late Timer _timer;
  bool _connected = false;

  // 关闭socket分为真死和假死
  // 假死是需要重连的
  bool dying = false;

  // 审核模式没有做链接
  Future<NewHitaSocketManager> init() async {
    if (TrudaConstants.appMode > 0) {
      NewHitaLog.debug('isFakeMode 不初始化');
      return this;
    }
    NewHitaLog.debug('NewHitaSocketManager --------------------> 初始化');
    Map<String, dynamic> headers = {};
    NewHitaAppInfoService appInfo = NewHitaAppInfoService.to;
    String userAgent =
        "${TrudaConstants.appNameLower},${appInfo.version},${appInfo.deviceModel},${appInfo.AppSystemVersionKey},${appInfo.channelName},${appInfo.buildNumber}";
    headers["User-Agent"] = userAgent;
    // 这个socket框架自己往user-agent里面放东西，所以用了其他的字段放我们的
    headers["flutter-user-agent"] = userAgent;
    headers["user-id"] = NewHitaMyInfoService.to.userLogin?.userId ?? "";
    headers["user-language"] = Get.deviceLocale?.languageCode ?? "en";
    headers["device-id"] = appInfo.deviceIdentifier;
    NewHitaLog.debug("socket connecting");
    channel = IOWebSocketChannel.connect(TrudaHttpUrls.getSocketBaseUrl(),
        headers: headers, pingInterval: const Duration(seconds: 20));
    _connected = true;
    channel.stream.listen((message) {
      // NewHitaLog.debug(message);
      _handleMessage(message);
    }, onDone: () {
      // 发现在网络问题后，会走到这里
      // 有时网络问题，到了onDone。有时却onDone，onError一起调！！
      NewHitaLog.debug("socket connect onDone");
      _connected = false;
      reConnect();
    }, onError: (err) {
      NewHitaLog.debug("socket connect onError !!");
      _connected = false;
    }, cancelOnError: false);

    _timer = Timer.periodic(const Duration(milliseconds: 30000), (timer) async {
      if (NewHitaAppPages.isAppBackground) return;
      if (_connected) {
        sendHeartbeat();
      } else {
        reConnect();
      }
    });
    return this;
  }

  void reConnect() {
    if (dying) {
      return;
    }
    if (NewHitaAppPages.isAppBackground) return;
    breakenSocket(dying: false);
    _timer.cancel();
    Future.delayed(const Duration(seconds: 2), () {
      if (NewHitaMyInfoService.to.myDetail == null) return;
      init();
    });
  }

  void sendHeartbeat() {
    Map heartbeat = {"optType": "heartbeat"};
    String heartbeatText = const JsonEncoder().convert(heartbeat);
    channel.sink.add(heartbeatText);
  }

  //通知服务器用户进行了录屏操作 服务器下发logout操作并进行惩罚
  void sendScreenshots(String channelId) {
    Map heartbeat = {"optType": "screenshotPunish", "data": channelId};
    String heartbeatText = const JsonEncoder().convert(heartbeat);
    channel.sink.add(heartbeatText);
  }

  //每次打开登录页面就会销毁当前链接 打开首页又会重新创建新的链接
  void breakenSocket({bool dying = true}) {
    this.dying = dying;
    channel.sink.close(status.normalClosure);
    _timer.cancel();
    NewHitaLog.debug('socket ------------> breakenSocket');
  }

  /// 压缩字符串，有加密作用
  String _zipStr(String str) {
    return base64Encode(zlib.encode(utf8.encode(str)));
  }

  static const heartbeat = 'heartbeat';
  static const logout = 'logout';
  static const anchorOnline = 'anchorOnline';
  static const beginCall = 'beginCall';
  static const orderResult = 'orderResult';
  static const cardCountChanged = 'cardCountChanged';

  void _handleMessage(String msg) {
    /// data字符窜有我们定义的消息
    // NewHitaLog.debug('socket 消息 ---> $msg');
    NewHitaSocketEntity entity = NewHitaSocketEntity.fromJson(json.decode(msg));
    if (entity.optType == heartbeat) {
      return;
    }
    if (entity.optType == logout) {
      NewHitaAppPages.logout();
      return;
    }
    // 主播上线了
    if (entity.optType == anchorOnline) {
      return;
    }
    if (entity.data == null || entity.data!.isEmpty) {
      return;
    }
    var data = json.decode(entity.data!);
    switch (entity.optType) {
      // 主播状态
      case NewHitaSocketHostState.typeCode:
        {
          NewHitaSocketHostState entity = NewHitaSocketHostState.fromJson(data);
          NewHitaStorageService.to.eventBus.fire(entity);
        }
        break;
      // 余额变动
      /// 只要有余额变动就会发这个，rtm的27消息也一样
      case NewHitaSocketBalance.typeCode:
        {
          NewHitaSocketBalance entity = NewHitaSocketBalance.fromJson(data);
          var changeState = -1;
          var myDiamonds =
              NewHitaMyInfoService.to.myDetail?.userBalance?.remainDiamonds ?? 0;
          var newDiamonds = entity.diamonds;
          var price = NewHitaMyInfoService.to.config?.chargePrice ?? 60;
          if (myDiamonds >= price && newDiamonds < price) {
            // 我的钻石从60以上掉到60以下的情况
            // NewHitaHttpUtil().post(NewHitaHttpUrls.initRobotApi);
            changeState = 1;
          } else if (myDiamonds < price && newDiamonds >= price) {
            // 我的钻石从60以下升高到到60以上的情况
            changeState = 0;
          }
          // 更新缓存信息
          NewHitaMyInfoService.to.handleBalanceChange(entity);

          if (changeState > -1) {
            NewHitaStorageService.to.eventBus
                .fire(NewHitaEventCanCallStateChange(changeState));
          }

          // 通知监听者
          for (var listener in _balanceListener) {
            listener.call(entity);
          }

          if (entity.diamonds > 0) {
            NewHitaGiftDataHelper.checkGiftDownload();
          }
        }
        break;
      //
      case beginCall:
        {
          NewHitaRTMMsgBeginCall entity = NewHitaRTMMsgBeginCall.fromJson(data);
          NewHitaStorageService.to.eventBus.fire(entity);
        }
        break;
      //
      case orderResult:
        {
          var jsonMap = json.decode(entity.data!);
          // 充值成功
          if (jsonMap['orderStatus'] == 1) {
            var lottery = 0;
            // 抽奖次数
            if (jsonMap['drawCount'] is int) {
              lottery = jsonMap['drawCount'];
            }
            NewHitaSuccessController.startMeCheck(lottery: lottery);
            // 更新缓存信息
            NewHitaMyInfoService.to.saveHadCharge();
            NewHitaStorageService.to.eventBus.fire(eventBusRefreshMe);
          }
        }
        break;
      //
      case cardCountChanged:
        var jsonMap = json.decode(entity.data!);
        // 体验卡数量变动
        if (jsonMap['callCardCount'] is int) {
          var changeState = 0;
          int newCardCount = jsonMap['callCardCount'];
          final myCard = NewHitaMyInfoService.to.myDetail?.callCardCount ?? 0;
          if (newCardCount >= 1 && myCard < 1) {
            changeState = 2;
          } else if (newCardCount < 1 && myCard >= 1) {
            changeState = 3;
          }
          NewHitaMyInfoService.to.myDetail?.callCardCount = newCardCount;
          // 这里判断是否发生有无体验卡的逻辑和发送事件的时机还真蛋疼！
          if (changeState > 0) {
            NewHitaStorageService.to.eventBus
                .fire(NewHitaEventCanCallStateChange(changeState));
          }

          NewHitaStorageService.to.eventBus.fire(eventBusRefreshMe);
        }
        break;
    }
  }

  final List<TrudaCallback<NewHitaSocketBalance>> _balanceListener = [];

  void addBalanceListener(TrudaCallback<NewHitaSocketBalance> callback) {
    if (!_balanceListener.contains(callback)) {
      _balanceListener.add(callback);
    }
  }

  void removeBalanceListener(TrudaCallback<NewHitaSocketBalance> callback) {
    _balanceListener.remove(callback);
  }
}
