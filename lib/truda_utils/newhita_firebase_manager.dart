class NewHitaFirebaseManager {
  static Future<void> init() async {}

  static Future<String> getToken() async {
    return '';
  }
}

/// 这个注释上下是打包时要切换注释的，下面的是线上的
// import 'dart:convert';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:truda/truda_common/truda_constants.dart';
// import 'package:truda/truda_pages/chat/truda_chat_controller.dart';
//
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import '../truda_database/entity/truda_her_entity.dart';
// import '../truda_database/entity/truda_msg_entity.dart';
// import '../truda_entities/truda_host_entity.dart';
// import '../truda_http/truda_http_urls.dart';
// import '../truda_http/truda_http_util.dart';
// import '../truda_rtm/truda_rtm_msg_entity.dart';
// import '../truda_services/truda_my_info_service.dart';
// import '../truda_services/truda_storage_service.dart';
// import 'newhita_log.dart';
//
// /**
//  *
//  * 在登录后调用，一般在main 页面 初始化的时候调用
//  *  NotificationManager.init();
//    NotificationManager.getToken();
//  */
//
// ///FCM配置
//
// class NewHitaFirebaseManager {
//   static bool isAppFront = true;
//   static Future<String> getToken() async {
//     var token = await FirebaseMessaging.instance.getToken();
//     await updateToken(token ?? "");
//     return Future.value(token);
//   }
//
//   static Future<void> init() async {
//     ///初始化
//     await Firebase.initializeApp();
//
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {});
//
//     // var initializationSettingsAndroid =
//     //     const AndroidInitializationSettings('ic_app');
//     //
//     // var initializationSettingsIOS = const IOSInitializationSettings(
//     //     requestAlertPermission: true,
//     //     requestBadgePermission: true,
//     //     requestSoundPermission: true);
//     //
//     // FlutterLocalNotificationsPlugin().initialize(
//     //     InitializationSettings(
//     //         android: initializationSettingsAndroid,
//     //         iOS: initializationSettingsIOS),
//     //     onSelectNotification: _onSelectNotification);
//
//     ///ios , mac, web需要请求权限
//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     ///ios启用前台通知
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     ///前台消息
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       NewHitaLog.debug('firebase onMessage $message');
//       if (message.notification != null) {
//         // RemoteNotification? notification = message.notification;
//
//         ///显示通知
//         // if (notification != null &&
//         //     notification.android != null &&
//         //     !isAppFront) {
//         //   FlutterLocalNotificationsPlugin().show(
//         //       notification.hashCode,
//         //       notification.title,
//         //       notification.body,
//         //       NotificationDetails(
//         //         android: AndroidNotificationDetails(
//         //           channel.id,
//         //           channel.name,
//         //         ),
//         //       ),
//         //       payload: message.data.toString());
//         // }
//         setMessage(message);
//       }
//     });
//
//     ///后台消息
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     ///点击后台消息打开App
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       setMessage(message);
//       handleClickMess(message);
//
//       ///去聊天页面
//       NewHitaChatController.startMe(message.data["userId"]);
//     });
//
//     ///应用从终止状态打开
//     var m = await FirebaseMessaging.instance.getInitialMessage();
//     if (m != null) {
//       setMessage(m);
//       NewHitaChatController.startMe(m.data["userId"]);
//     }
//   }
//
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {}
//
//   static Future<dynamic> _onSelectNotification(String? payload) {
//     var data = jsonDecode(payload!);
//     NewHitaChatController.startMe(data["userId"]);
//     return Future.value("");
//   }
//
//   //处理推送点击回
//   static Future<void> handleClickMess(RemoteMessage msg) async {
//     String pid = "${msg.data["pid"]}";
//     NewHitaLog.debug("点击后台消息打开App pid = ${pid}");
//     if (pid.isNotEmpty) {
//       //推送点击回传 user/push/statistics/{pid}
//       NewHitaHttpUtil().post<void>(NewHitaHttpUrls.clickeFirebasePush + pid);
//     }
//   }
// }
//
// ///上传token
// updateToken(String token) async {
//   NewHitaLog.debug('firebase token=$token');
//   NewHitaHttpUtil().post<void>(
//     NewHitaHttpUrls.updateFirebaseToken + token,
//   );
// }
//
// ///RTM 插入消息
// void setMessage(RemoteMessage message) async {
//   var herId = message.data["userId"];
//   insertHerSendMsg(herId, message.notification?.body ?? "");
//   if (herId == NewHitaConstants.systemId) {
//     return;
//   }
//   requestSimpleUpInfo(herId);
// }
//
// requestSimpleUpInfo(String upid) async {
//   NewHitaHttpUtil().post<NewHitaHostDetail>(NewHitaHttpUrls.upDetailApi + upid,
//       errCallback: (err) {
//     NewHitaLog.debug(err);
//   }).then((value) {
//     var entity =
//         TrudaHerEntity(value.nickname ?? '', upid, portrait: value.portrait);
//     NewHitaStorageService.to.objectBoxMsg.putOrUpdateHer(entity);
//     NewHitaStorageService.to.eventBus.fire(entity);
//   });
// }
//
// void insertHerSendMsg(String herId, String text) {
//   final String myId = NewHitaMyInfoService.to.userLogin?.userId ?? "emptyId";
//   TrudaMsgEntity msgEntity = TrudaMsgEntity(myId, herId, 1, "",
//       DateTime.now().millisecondsSinceEpoch, '', NewHitaRTMMsgText.typeCode);
//   msgEntity.content = text;
//   NewHitaStorageService.to.objectBoxMsg.insertOrUpdateMsg(msgEntity);
// }
