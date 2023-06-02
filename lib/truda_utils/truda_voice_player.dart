import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart' as sound;

/// 铃声的播放器
class TrudaAudioCenter2 {
  static final _audioCallingCenter = TrudaAudioCenter2._intal();

  TrudaAudioCenter2._intal();

  factory TrudaAudioCenter2() {
    return _audioCallingCenter;
  }

  final sound.FlutterSoundPlayer _mPlayer = sound.FlutterSoundPlayer();

  static playRing({bool isCome = false}) async {
    Uint8List dataBuffer = (await rootBundle
            .load(isCome ? "assets/newhita_call.mp3" : "assets/newhita_call.mp3"))
        .buffer
        .asUint8List();
    _audioCallingCenter._mPlayer.setVolume(1);
    await _audioCallingCenter._mPlayer.openPlayer();
    _audioCallingCenter._playBgm(dataBuffer, 3);
  }

  void _playBgm(Uint8List dataBuffer, int times) async {
    await _mPlayer.startPlayer(
        fromDataBuffer: dataBuffer,
        sampleRate: 8000,
        codec: sound.Codec.mp3,
        whenFinished: () async {
          times--;
          if (times >= 1) {
            await _mPlayer.seekToPlayer(const Duration());
            _playBgm(dataBuffer, times);
          }
        });
  }

  static stopPlayRing() {
    if (_audioCallingCenter._mPlayer.isPlaying) {
      _audioCallingCenter._mPlayer.stopPlayer();
    }
    _audioCallingCenter._mPlayer.closePlayer();
  }
}

/// 记录播放地址的播放器
class TrudaAudioPlayer extends AudioPlayer {
  factory TrudaAudioPlayer() {
    return _audioCallingCenter;
  }

  static final _audioCallingCenter = TrudaAudioPlayer._intal();

  TrudaAudioPlayer._intal() {}
  String _currentUrl = "-9999999999999999";

  String get currentUrl {
    return _currentUrl;
  }

  _resetCurrentUrl() {
    _currentUrl = "-9999999999999999";
  }

  void stopAndReset() {
    stop();
    _resetCurrentUrl();
  }

  Future<void> playUrl(
    String url, {
    bool? isLocal,
    double volume = 1.0,
    Duration? position,
  }) {
    _currentUrl = url;
    return super.play(UrlSource(url), volume: volume, position: position);
  }
}
