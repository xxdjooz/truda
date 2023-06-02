import 'package:flutter/material.dart';

import '../../truda_common/truda_colors.dart';

class TrudaHostDetailIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TrudaHomeIndicatorPainter(this, onChanged);
  }
}

class _TrudaHomeIndicatorPainter extends BoxPainter {
  final TrudaHostDetailIndicator binIndicator;

  _TrudaHomeIndicatorPainter(this.binIndicator, VoidCallback? onChanged);

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
      ..color = TrudaColors.baseColorGreen
      ..invertColors = false;

    double circleRadius = 11;
    double xPoint = configuration.textDirection == TextDirection.ltr
        ? offset.dx + circleRadius
        : configuration.size!.width - circleRadius + offset.dx;

    // canvas.drawCircle(
    //     Offset(xPoint, circleRadius + offset.dy), circleRadius, paint);

    // offset & configuration.size! 可以得到一个Rect
    // canvas.drawArc(offset & configuration.size!, math.pi / 180 * 60,
    //     math.pi / 180 * 60, false, paint);

    var rect = Rect.fromLTWH(offset.dx + (configuration.size!.width - 40) / 2,
        offset.dy + configuration.size!.height - 26, 40, 10);
    // canvas.drawArc(rect, math.pi / 180 * 60, math.pi / 180 * 60, false, paint);
    canvas.drawRect(rect, paint);
    // canvas.drawRect(offset & configuration.size!, paint);
  }
}
