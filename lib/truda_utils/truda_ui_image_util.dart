import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrudaUiImageUtil {
  // 获取图片 本地为false 网络为true
  static Future<ui.Image> loadImage(var path, bool isUrl) async {
    ImageStream stream;
    if (isUrl) {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(path, bundle: rootBundle)
          .resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(ImageStreamListener(listener));
    }

    stream.addListener(ImageStreamListener(listener));
    return completer.future;
  }

  /// 通过assets路径，获取资源图片
  static Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  // https://blog.csdn.net/lal95828/article/details/108567013
  //方法2.1：获取本地图片  返回ui.Image 需要传入BuildContext context
  static Future<ui.Image> getAssetImage2(String asset, BuildContext context,
      {width, height}) async {
    ByteData data = await DefaultAssetBundle.of(context).load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  //方法2.2：获取本地图片 返回ui.Image 不需要传入BuildContext context
  static Future<ui.Image> getAssetImage(String asset, {width, height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
