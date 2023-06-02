import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// 把图片绘制到Indicator
class TrudaImageIndicator extends Decoration {
  final ui.Image indicator;
  final Color? colorFilter;

  const TrudaImageIndicator(this.indicator, {this.colorFilter});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TrudaImageIndicatorPainter(
        this, indicator, colorFilter, onChanged);
  }
}

class _TrudaImageIndicatorPainter extends BoxPainter {
  final TrudaImageIndicator binIndicator;
  final ui.Image indicator;
  final Color? colorFilter;

  _TrudaImageIndicatorPainter(this.binIndicator, this.indicator,
      this.colorFilter, VoidCallback? onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 3.0
      // ..style = PaintingStyle.fill
      ..invertColors = false;
    if (colorFilter != null) {
      paint.colorFilter = ColorFilter.mode(colorFilter!, BlendMode.srcIn);
    }
    double circleRadius = 11;
    double xPoint = configuration.textDirection == TextDirection.ltr
        ? offset.dx + circleRadius
        : configuration.size!.width - circleRadius + offset.dx;

    // canvas.drawCircle(
    //     Offset(xPoint, circleRadius + offset.dy), circleRadius, paint);

    // offset & configuration.size! 可以得到一个Rect
    // canvas.drawArc(offset & configuration.size!, math.pi / 180 * 60,
    //     math.pi / 180 * 60, false, paint);

    // canvas.drawArc(rect, math.pi / 180 * 60, math.pi / 180 * 60, false, paint);
    // canvas.drawOval(rect, paint);
    // canvas.drawRect(offset & configuration.size!, paint);

    // var rect = Rect.fromLTWH(offset.dx + (configuration.size!.width - 40) / 2,
    //     offset.dy + configuration.size!.height - 30, 40, 20);
    // 这样算出来的是总的矩形
    final rectAll = offset & configuration.size!;
    final rectDraw = Rect.fromCenter(
      center: rectAll.center,
      width: rectAll.width,
      height: rectAll.height / 2,
    );
    canvas.drawImageRect(
        indicator,
        Rect.fromLTWH(
            0, 0, indicator.width.toDouble(), indicator.height.toDouble()),
        // rect,
        rectDraw,
        paint);
  }
}
