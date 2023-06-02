// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_plugin_record/flutter_plugin_record.dart';
// import 'package:get/get.dart';
// import 'package:truda/truda_common/truda_language_key.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../truda_common/truda_colors.dart';
// import '../truda_utils/truda_format_util.dart';
// import '../truda_utils/truda_loading.dart';
// import '../truda_utils/truda_log.dart';
//
// typedef NewHitaUploadCallBack = Function(String duration, String localPath);
//
// class NewHitaVoiceRecordWidget extends StatefulWidget {
//   final Function? startRecord;
//   final Function? stopRecord;
//   final NewHitaUploadCallBack? uploadCallBack;
//   final EdgeInsets? margin;
//
//   /// startRecord 开始录制回调  stopRecord回调
//   const NewHitaVoiceRecordWidget(
//       {Key? key,
//       this.startRecord,
//       this.stopRecord,
//       this.uploadCallBack,
//       this.margin})
//       : super(key: key);
//
//   @override
//   _NewHitaVoiceRecordWidgetState createState() => _NewHitaVoiceRecordWidgetState();
// }
//
// class _NewHitaVoiceRecordWidgetState extends State<NewHitaVoiceRecordWidget> {
//   // 倒计时总时长
//   int _countTotal = 60;
//
//   // double starty = 0.0;
//   double offset = 0.0;
//   bool isUp = false;
//   String textShow = TrudaLanguageKey.newhita_enter_speck.tr;
//   String toastShow = TrudaLanguageKey.newhita_loosen_stop.tr;
//
//   // String voiceIco = "images/cbl_voice_volume_1.webp";
//
//   ///默认隐藏状态
//   bool voiceState = true;
//   FlutterPluginRecord? recordPlugin;
//   Timer? _timer;
//   int _count = 0;
//   OverlayEntry? overlayEntry;
//   bool canSend = false;
//   var dragToDeleteView = false;
//
//   @override
//   void initState() {
//     super.initState();
//     recordPlugin = FlutterPluginRecord();
//
//     _init();
//
//     ///初始化方法的监听
//     recordPlugin?.responseFromInit.listen((data) {
//       if (data) {
//         NewHitaLog.debug("初始化成功");
//       } else {
//         NewHitaLog.debug("初始化失败");
//       }
//     });
//
//     /// 开始录制或结束录制的监听
//     recordPlugin?.response.listen((data) {
//       if (data.msg == "onStop") {
//         ///结束录制时会返回录制文件的地址方便上传服务器
//         NewHitaLog.debug("canSend=$canSend onStop  " + data.path!);
//
//         // bool isUp = (offset != 0 && starty - offset > 100) ? true : false;
//
//         bool timeEnough =
//             data.audioTimeLength != null && (data.audioTimeLength! >= 1);
//
//         if (canSend) {
//           if (data.path != null && timeEnough) {
//             widget.uploadCallBack?.call(
//                 data.audioTimeLength?.toInt().toString() ?? "0", data.path!);
//             // CblOssUtil.uploadWithFilePath(data.path!, CblOssUploadType.record,
//             //     (path, partPath) {
//             //   NewHitaLog.debug("上传倒阿里云服务器的录音文件 ${path}");
//             //
//             //   widget.uploadCallBack?.call(path,
//             //       data.audioTimeLength?.toInt()?.toString() ?? "0", data.path!);
//             // });
//           } else if (timeEnough) {
//             NewHitaLoading.toast(TrudaLanguageKey.newhita_order_failed.tr);
//           }
//         }
//
//         if (widget.stopRecord != null)
//           widget.stopRecord!(data.path, data.audioTimeLength);
//       } else if (data.msg == "onStart") {
//         NewHitaLog.debug("onStart --");
//         if (widget.startRecord != null) widget.startRecord!();
//       }
//     });
//
//     ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
//     // recordPlugin!.responseFromAmplitude.listen((data) {
//     //   var voiceData = double.parse(data.msg ?? '');
//     //   setState(() {
//     //     if (voiceData > 0 && voiceData < 0.1) {
//     //       voiceIco = "images/cbl_voice_volume_2.webp";
//     //     } else if (voiceData > 0.2 && voiceData < 0.3) {
//     //       voiceIco = "images/cbl_voice_volume_3.webp";
//     //     } else if (voiceData > 0.3 && voiceData < 0.4) {
//     //       voiceIco = "images/cbl_voice_volume_4.webp";
//     //     } else if (voiceData > 0.4 && voiceData < 0.5) {
//     //       voiceIco = "images/cbl_voice_volume_5.webp";
//     //     } else if (voiceData > 0.5 && voiceData < 0.6) {
//     //       voiceIco = "images/cbl_voice_volume_6.webp";
//     //     } else if (voiceData > 0.6 && voiceData < 0.7) {
//     //       voiceIco = "images/cbl_voice_volume_7.webp";
//     //     } else if (voiceData > 0.7 && voiceData < 1) {
//     //       voiceIco = "images/cbl_voice_volume_7.webp";
//     //     } else {
//     //       voiceIco = "images/cbl_voice_volume_1.webp";
//     //     }
//     //     if (overlayEntry != null) {
//     //       overlayEntry!.markNeedsBuild();
//     //     }
//     //   });
//     //
//     //   NewHitaLog.debug("振幅大小   " + voiceData.toString() + "  " + voiceIco);
//     // });
//   }
//
//   ///显示录音悬浮布局
//   buildOverLayView(BuildContext context, {bool refresh = false}) {
//     if (overlayEntry != null && refresh) {
//       overlayEntry?.markNeedsBuild();
//       return;
//     }
//     overlayEntry?.remove();
//     overlayEntry = null;
//     if (overlayEntry == null) {
//       overlayEntry = OverlayEntry(builder: (content) {
//         // bool isUp = (offset != 0 && starty - offset > 100) ? true : false;
//         bool isUp = dragToDeleteView;
//         canSend = !isUp;
//         return IgnorePointer(
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             color: Colors.transparent,
//             child: Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Color(0xCC1A0035),
//                     borderRadius: BorderRadius.all(Radius.circular(20))),
//                 width: 174,
//                 height: 174,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Container(
//                       height: 54,
//                       alignment: Alignment.center,
//                       child: Text(
//                         // "${sprintf("%02i:%02i", [
//                         //       ,
//                         //
//                         //     ])}",
//                         // '${_count % 3600 ~/ 60}:${_count % 60}',
//                         NewHitaFormatUtil.getTimeStrFromSecond(_count.abs()),
//                         style: TextStyle(
//                           color: TrudaColors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: TrudaColors.baseColorBlackBg,
//                         borderRadius: BorderRadius.circular(12),
//                         // image: DecorationImage(
//                         //     fit: BoxFit.fill,
//                         //     image: isUp == true
//                         //         ? const AssetImage(
//                         //             "assets/images/.png")
//                         //         : const AssetImage(
//                         //             "assets/images/.png")),
//                       ),
//                       height: 90,
//                       width: 140,
//                       child: isUp == true
//                           ? Icon(
//                               Icons.close_rounded,
//                               color: Colors.white70,
//                               size: 70,
//                             )
//                           : Image.asset(
//                               "assets/newhita_chat_recording.webp",
//                               fit: BoxFit.contain,
//                             ),
//                     ),
//                     // Container(
//                     //   height: 50.w,
//                     //   alignment: Alignment.center,
//                     //   child: Text(
//                     //     toastShow,
//                     //     style: TextStyle(
//                     //       color: TrudaColors.white,
//                     //       fontSize: 12.sp,
//                     //     ),
//                     //   ),
//                     // )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       });
//       Overlay.of(context)!.insert(overlayEntry!);
//     }
//   }
//
//   void showVoiceView() {
//     setState(() {
//       textShow = TrudaLanguageKey.newhita_loosen_stop.tr;
//       voiceState = false;
//     });
//
//     ///显示录音悬浮布局
//     buildOverLayView(context);
//
//     start();
//   }
//
//   void hideVoiceView() {
//     if (_timer!.isActive) {
//       if (_count < 1) {
//         // showRecordToast(0);
//         isUp = true;
//       }
//       _timer?.cancel();
//       _count = 0;
//     }
//
//     setState(() {
//       textShow = TrudaLanguageKey.newhita_enter_speck.tr;
//       voiceState = true;
//     });
//
//     stop();
//     if (overlayEntry != null) {
//       overlayEntry?.remove();
//       overlayEntry = null;
//     }
//     offset = 0;
//     if (isUp) {
//       NewHitaLog.debug("取消发送");
//     } else {
//       NewHitaLog.debug("进行发送");
//     }
//   }
//
//   void moveVoiceView() {
//     if (_timer?.isActive != true) {
//       return;
//     }
//     // bool isUpNow = starty - offset > 100;
//     bool isUpNow = dragToDeleteView;
//     if (isUp == isUpNow) return;
//     // print(offset - start);
//     setState(() {
//       isUp = isUpNow;
//       NewHitaLog.debug("moveVoiceView--setState isUp=$isUp offset=$offset");
//       if (isUp) {
//         textShow = TrudaLanguageKey.newhita_cancel_send.tr;
//         toastShow = textShow;
//       } else {
//         textShow = TrudaLanguageKey.newhita_loosen_stop.tr;
//         toastShow = TrudaLanguageKey.newhita_voice_send.tr;
//       }
//       buildOverLayView(context, refresh: true);
//     });
//   }
//
//   ///初始化语音录制的方法
//   void _init() async {
//     // recordPlugin?.initRecordMp3();
//     recordPlugin?.init();
//   }
//
//   ///开始语音录制的方法
//   void start() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String finalPath = directory.path +
//         "/" +
//         DateTime.now().millisecondsSinceEpoch.toString() +
//         ".wav";
//     recordPlugin?.startByWavPath(finalPath);
//   }
//
//   ///停止语音录制的方法
//   void stop() {
//     recordPlugin?.stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return Container(
//     //   child: GestureDetector(
//     //     onLongPressStart: (details) {
//     //       starty = details.globalPosition.dy;
//     //       _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
//     //         _count++;
//     //         NewHitaLog.debug('_count is 👉 $_count');
//     //         if (_count == _countTotal) {
//     //           hideVoiceView();
//     //           recordPlugin?.stop();
//     //         } else {
//     //           buildOverLayView(context, refresh: true);
//     //         }
//     //       });
//     //       showVoiceView();
//     //     },
//     //     onLongPressEnd: (details) {
//     //       hideVoiceView();
//     //     },
//     //     onLongPressMoveUpdate: (details) {
//     //       offset = details.globalPosition.dy;
//     //       moveVoiceView();
//     //     },
//     //     child: Stack(
//     //       alignment: AlignmentDirectional.center,
//     //       children: [
//     //         Container(
//     //           width: 76,
//     //           height: 76,
//     //           margin: EdgeInsetsDirectional.only(bottom: 15),
//     //           child: voiceState == false
//     //               ? Image.asset("assets/images/.png")
//     //               : Image.asset("assets/images/.png"),
//     //         ),
//     //         Positioned(
//     //           bottom: 20,
//     //           child: Text(
//     //             textShow,
//     //             textAlign: TextAlign.center,
//     //             style: TextStyle(
//     //               color: Color(0xFF999999),
//     //               fontSize: 12,
//     //             ),
//     //           ),
//     //         )
//     //       ],
//     //     ),
//     //   ),
//     // );
//
//     return SizedBox.expand(
//       child: Stack(
//         alignment: AlignmentDirectional.center,
//         children: [
//           Draggable<int>(
//             childWhenDragging: Container(
//               width: 76,
//               height: 76,
//               margin: EdgeInsetsDirectional.only(bottom: 15),
//               // child: Image.asset("assets/images/.png"),
//             ),
//             feedback: SizedBox(),
//             child: Container(
//               width: 76,
//               height: 76,
//               margin: EdgeInsetsDirectional.only(bottom: 15),
//               // child: voiceState == false
//               //     ? Image.asset("assets/images/.png")
//               //     : Image.asset("assets/images/.png"),
//             ),
//             data: 123,
//             onDragStarted: () {
//               NewHitaLog.debug('NewHitaVoiceRecordWidget onDragStarted');
//               _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
//                 _count++;
//                 // NewHitaLog.debug('_count is 👉 $_count');
//                 if (_count == _countTotal) {
//                   hideVoiceView();
//                   recordPlugin?.stop();
//                 } else {
//                   buildOverLayView(context, refresh: true);
//                 }
//               });
//               showVoiceView();
//             },
//             onDragUpdate: (detail) {
//               // NewHitaLog.debug('message onDragUpdate $detail');
//             },
//             onDraggableCanceled: (v, offset) {
//               NewHitaLog.debug(
//                   'NewHitaVoiceRecordWidget onDraggableCanceled $offset');
//             },
//             onDragCompleted: () {
//               NewHitaLog.debug('NewHitaVoiceRecordWidget 到这里说明拖到了删除区');
//               hideVoiceView();
//             },
//             onDragEnd: (detail) {
//               NewHitaLog.debug('NewHitaVoiceRecordWidget 拖动结束 $detail');
//               hideVoiceView();
//             },
//           ),
//           Positioned(
//             bottom: 20,
//             child: Text(
//               textShow,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Color(0xFF999999),
//                 fontSize: 12,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             right: 40,
//             child: DragTarget<int>(
//               onAccept: (i) {
//                 NewHitaLog.debug('NewHitaVoiceRecordWidget onAccept');
//               },
//               onWillAccept: (i) {
//                 NewHitaLog.debug('NewHitaVoiceRecordWidget onWillAccept');
//                 return true;
//               },
//               onAcceptWithDetails: (i) {
//                 NewHitaLog.debug('NewHitaVoiceRecordWidget onAcceptWithDetails');
//                 hideVoiceView();
//               },
//               onLeave: (i) {
//                 NewHitaLog.debug('NewHitaVoiceRecordWidget onLeave');
//               },
//               onMove: (i) {
//                 // NewHitaLog.debug('message onMove');
//               },
//               builder: (BuildContext context, List<int?> candidateData,
//                   List<dynamic> rejectedData) {
//                 NewHitaLog.debug('NewHitaVoiceRecordWidget builder ${candidateData}');
//                 dragToDeleteView = candidateData.isNotEmpty;
//                 // moveVoiceView();
//                 Future.delayed(Duration(milliseconds: 50), () {
//                   moveVoiceView();
//                 });
//                 return SizedBox();
//                 // return dragToDeleteView
//                 //     ? Image.asset(
//                 //         "assets/images/.png")
//                 //     : Image.asset("assets/images/.png");
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     recordPlugin?.dispose();
//     _timer?.cancel();
//     super.dispose();
//     if (overlayEntry != null) {
//       overlayEntry?.remove();
//       overlayEntry = null;
//     }
//   }
// }
