import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../truda_utils/newhita_loading.dart';
import '../truda_utils/newhita_log.dart';

typedef NewHitaUploadCallBack = Function(String duration, String localPath);

class NewHitaVoiceWidgetRecord extends StatefulWidget {
  final Function? startRecord;
  final Function? stopRecord;
  final NewHitaUploadCallBack? uploadCallBack;
  final EdgeInsets? margin;

  /// startRecord 开始录制回调  stopRecord回调
  const NewHitaVoiceWidgetRecord(
      {Key? key,
      this.startRecord,
      this.stopRecord,
      this.uploadCallBack,
      this.margin})
      : super(key: key);

  @override
  _NewHitaVoiceWidgetRecordState createState() => _NewHitaVoiceWidgetRecordState();
}

class _NewHitaVoiceWidgetRecordState extends State<NewHitaVoiceWidgetRecord> {
  // 倒计时总时长
  int _countTotal = 60;

  bool isUp = false;
  String textShow = TrudaLanguageKey.newhita_enter_speck.tr;
  String toastShow = TrudaLanguageKey.newhita_loosen_stop.tr;

  // 0默认状态，1按住状态，2拖到删除状态
  int pressStatus = 0;

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry? overlayEntry;
  bool canSend = false;
  var dragToDeleteView = false;
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();

  bool _mRecorderIsInited = false;
  StreamSubscription? _recorderSubscription;
  final Codec _codec = Codec.pcm16WAV;
  String _mPath = '';
  int seconds = 0;
  String text = '00:00';

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder!.openRecorder();
    await _mRecorder!
        .setSubscriptionDuration(const Duration(milliseconds: 100));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  @override
  void initState() {
    super.initState();
    openTheRecorder();
  }

  ///显示录音悬浮布局
  buildOverLayView(BuildContext context, {bool refresh = false}) {
    if (overlayEntry != null && refresh) {
      overlayEntry?.markNeedsBuild();
      return;
    }
    overlayEntry?.remove();
    overlayEntry = null;
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (content) {
        // bool isUp = (offset != 0 && starty - offset > 100) ? true : false;
        bool isUp = dragToDeleteView;
        canSend = !isUp;
        return IgnorePointer(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: pressStatus == 2
                        ? TrudaColors.baseColorRed.withOpacity(0.8)
                        : Colors.black87,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text,
                      style: const TextStyle(
                        color: TrudaColors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: Color(0xFFE19EFF),
                        borderRadius: BorderRadius.circular(12),
                        // image: DecorationImage(
                        //     fit: BoxFit.fill,
                        //     image: isUp == true
                        //         ? const AssetImage(
                        //             "assets/images/.png")
                        //         : const AssetImage(
                        //             "assets/images/.png")),
                      ),
                      height: 70,
                      width: 70,
                      child: isUp == true
                          ? Image.asset(
                              "assets/images/newhita_chat_recorder_loose.png",
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              "assets/newhita_chat_recording.webp",
                              fit: BoxFit.contain,
                            ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        textShow,
                        style: TextStyle(
                          color: TrudaColors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context)!.insert(overlayEntry!);
    }
  }

  void showVoiceView() {
    setState(() {
      textShow = TrudaLanguageKey.newhita_loosen_stop.tr;
      voiceState = false;
      pressStatus = 1;
    });

    ///显示录音悬浮布局
    buildOverLayView(context);

    record();
  }

  void hideVoiceView() {
    if (seconds < 1) {
      // showRecordToast(0);
      isUp = true;
    }

    setState(() {
      textShow = TrudaLanguageKey.newhita_enter_speck.tr;
      voiceState = true;
      pressStatus = 0;
    });

    stopRecorder();
    Timer.run(() {
      if (overlayEntry != null) {
        overlayEntry?.remove();
        overlayEntry = null;
      }
    });

    if (isUp) {
      NewHitaLog.debug("取消发送");
    } else {
      NewHitaLog.debug("进行发送");
    }
  }

  void moveVoiceView() {
    bool isUpNow = dragToDeleteView;
    if (isUp == isUpNow) return;
    setState(() {
      isUp = isUpNow;
      NewHitaLog.debug("moveVoiceView--setState isUp=$isUp ");
      if (isUp) {
        textShow = TrudaLanguageKey.newhita_cancel_send.tr;
        toastShow = textShow;
        pressStatus = 2;
      } else {
        textShow = TrudaLanguageKey.newhita_loosen_stop.tr;
        toastShow = TrudaLanguageKey.newhita_voice_send.tr;
        pressStatus = 1;
      }
      buildOverLayView(context, refresh: true);
    });
  }

  void record() async {
    Directory directory = await getApplicationDocumentsDirectory();
    _mPath = directory.path +
        "/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".wav";
    await _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: AudioSource.microphone,
      bitRate: 8000,
      numChannels: 1,
      sampleRate: (_codec == Codec.pcm16) ? 44000 : 8000,
    )
        .then((value) {
      setState(() {});
      if (widget.startRecord != null) widget.startRecord!();

      _recorderSubscription = _mRecorder!.onProgress!.listen((e) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds,
            isUtc: true);

        seconds = e.duration.inSeconds;
        text = DateFormat('mm:ss').format(date);
        NewHitaLog.debug(
            'NewHitaVoiceRecordWidget onProgress seconds=$seconds txt=$text');

        if (seconds == _countTotal) {
          hideVoiceView();
          stopRecorder();
        } else {
          buildOverLayView(context, refresh: true);
        }
      });
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      NewHitaLog.debug(
          'NewHitaVoiceRecordWidget stopRecorder canSend=$canSend seconds=$seconds _mPath=$_mPath');
      bool timeEnough = seconds >= 1;
      if (canSend) {
        if (_mPath.isNotEmpty && timeEnough) {
          widget.uploadCallBack?.call(seconds.toString(), _mPath);
        } else if (timeEnough) {
          NewHitaLoading.toast(TrudaLanguageKey.newhita_order_failed.tr);
        }
      }

      if (widget.stopRecord != null) {
        widget.stopRecord!(_mPath, seconds);
      }

      if (_recorderSubscription != null) {
        _recorderSubscription!.cancel();
        _recorderSubscription = null;
      }

      if (overlayEntry != null) {
        overlayEntry?.remove();
        overlayEntry = null;
      }
    });
  }

  final itKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        key: itKey,
        alignment: AlignmentDirectional.center,
        children: [
          GestureDetector(
            onPanDown: (d) {
              NewHitaLog.debug('NewHitaVoiceRecordWidget pan onPanDown');
              dragToDeleteView = false;
              isUp = false;
              NewHitaLog.debug('NewHitaVoiceRecordWidget GestureDetector onTapDown');
              showVoiceView();
            },
            onPanUpdate: (detail) {
              RenderBox renderBox =
                  itKey.currentContext!.findRenderObject() as RenderBox;
              Offset offset = renderBox.localToGlobal(Offset.zero);
              var rect = offset & renderBox.size;
              bool contain = rect.contains(detail.globalPosition);
              NewHitaLog.debug(
                  'NewHitaVoiceRecordWidget 拖动 ${detail.globalPosition}  $contain');
              dragToDeleteView = !contain;

              moveVoiceView();
            },
            onPanStart: (d) {
              NewHitaLog.debug('NewHitaVoiceRecordWidget pan onPanStart');
            },
            onPanEnd: (detail) {
              NewHitaLog.debug('NewHitaVoiceRecordWidget pan onPanEnd');
              hideVoiceView();
              // RenderBox renderBox =
              //     itKey.currentContext!.findRenderObject() as RenderBox;
              // Offset offset = renderBox.localToGlobal(Offset.zero);
              // var rect = offset & renderBox.size;
              // bool contain = rect.contains(detail.offset);
              // NewHitaLog.debug('NewHitaVoiceRecordWidget 拖动结束 $detail  $contain');
              // dragToDeleteView = !contain;
            },
            onPanCancel: () {
              NewHitaLog.debug('NewHitaVoiceRecordWidget pan onPanCancel');
              hideVoiceView();
            },
            // onTapDown: (d) {

            // },
            // onTapUp: (d) {
            //   NewHitaLog.debug('NewHitaVoiceRecordWidget GestureDetector onTapUp');
            //   hideVoiceView();
            // },
            // onTapCancel: () {
            //   NewHitaLog.debug(
            //       'NewHitaVoiceRecordWidget GestureDetector onTapCancel');
            //   hideVoiceView();
            //   dragToDeleteView = true;
            // },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (pressStatus == 0)
                    Image.asset(
                      "assets/images/newhita_chat_recorder_btn.png",
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    )
                  else if (pressStatus == 1)
                    Image.asset(
                      "assets/images/newhita_chat_recorder_ing.png",
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    )
                  else
                    Image.asset(
                      "assets/images/newhita_chat_recorder_cancel.png",
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Text(
                    textShow,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: TrudaColors.textColor333,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mRecorder!.closeRecorder();
    _mRecorder = null;

    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
    super.dispose();
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }
}
