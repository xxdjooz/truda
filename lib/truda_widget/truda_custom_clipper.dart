import 'dart:math';

import 'package:flutter/material.dart';

// 作者：张风捷特烈
// 链接：https://juejin.cn/post/7149007816118763527
// 给出一个半透明遮罩，随着进度的增加，遮罩逐渐减少的进度表现形式
// ValueNotifier<double> uploadProgress = ValueNotifier<double>(0);
// ValueListenableBuilder(
//     valueListenable: uploadProgress,
//     builder: (_, double value, child) {
//       return
//       Stack(
//         alignment: Alignment.center,
//         children: [
//           buildImage(),
//           if (value != 0) buildMask(value),
//           if (value != 0) buildText(value)
//         ],
//       );
//     })),
//
// Widget buildImage()=> Image.asset(
//   'assets/bg_5.jpg',
//   width: 150,
//   height: 150,
//   fit: BoxFit.cover,
// );
//
// Widget buildMask(double value)=> ClipPath(
//   clipper: ProgressClipper(progress: value),
//   child: Container(
//     width: 150,
//     height: 150,
//     color: Colors.black.withOpacity(0.7),
//   ),
// );
//
// Widget buildText(double value)=> Text(
//   "${(uploadProgress.value * 100).toInt()} %",
//   style: TextStyle(color: Color(0xffEDFBFF), fontSize: 24),
// );
// 随着进度的增加，扫描式地减少
class TrudaProgressClipper extends CustomClipper<Path> {
  final double progress;

  TrudaProgressClipper({this.progress = 0});

  @override
  Path getClip(Size size) {
    if (progress == 0) {
      return Path();
    }
    // 红色区域
    Path zone = Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    // 蓝色弧线
    double outRadius = sqrt(
        size.width / 2 * size.width / 2 + size.height / 2 * size.height / 2);
    Path path = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..relativeLineTo(0, -size.height / 2)
      ..arcTo(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: outRadius,
              height: outRadius),
          -pi / 2,
          2 * pi * progress,
          false);
    return Path.combine(PathOperation.xor, path, zone);
  }

  @override
  bool shouldReclip(covariant TrudaProgressClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}

// 阴影区域圆形缩减的效果
class TrudaCircleProgressClipper extends CustomClipper<Path> {
  final double progress;

  TrudaCircleProgressClipper({this.progress = 0});

  @override
  Path getClip(Size size) {
    if (progress == 0) {
      return Path();
    }
    double outSide = sqrt(size.width * size.width + size.height * size.height);
    Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: outSide * (1 - progress),
        height: outSide * (1 - progress));

    Path path = Path()..addOval(rect);
    return path;
  }

  @override
  bool shouldReclip(covariant TrudaCircleProgressClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}

// 让遮罩以矩形的方式逐渐缩减
class TrudaRectProgressClipper extends CustomClipper<Path> {
  final double progress;

  TrudaRectProgressClipper({this.progress = 0});

  @override
  Path getClip(Size size) {
    if (progress == 0) {
      return Path();
    }
    Rect rect = Rect.fromPoints(
      Offset.zero,
      Offset(size.width, size.height * (1 - progress)),
    );

    Path path = Path()..addRect(rect);
    return path;
  }

  @override
  bool shouldReclip(covariant TrudaRectProgressClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}
