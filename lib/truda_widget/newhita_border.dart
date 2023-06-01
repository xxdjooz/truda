import 'package:flutter/cupertino.dart';

class NewHitaBorder extends BorderDirectional {
  @override
  final BorderSide top;
  @override
  final BorderSide bottom;
  @override
  final BorderSide start;
  @override
  final BorderSide end;

  const NewHitaBorder({
    this.top = BorderSide.none,
    this.bottom = BorderSide.none,
    this.start = BorderSide.none,
    this.end = BorderSide.none,
  });

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    // paintBorder(canvas, rect,
    //     top: top, right: right, bottom: bottom, left: left);

    BorderSide left, right;
    assert(textDirection != null,
        'Non-uniform BorderDirectional objects require a TextDirection when painting.');
    switch (textDirection!) {
      case TextDirection.rtl:
        left = end;
        right = start;
        break;
      case TextDirection.ltr:
        left = start;
        right = end;
        break;
    }

    final Paint paint = Paint()..strokeWidth = left.width;
    final Path path = Path();

    paint.color = left.color;
    path.reset();
    path.moveTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.top);
    // if (left.width == 0.0) {
    //   paint.style = PaintingStyle.stroke;
    // } else {
    //   paint.style = PaintingStyle.fill;
    //   path.lineTo(rect.left + left.width, rect.top + top.width);
    //   path.lineTo(rect.left + left.width, rect.bottom - bottom.width);
    // }
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(_convertDotterPath(path), paint);
  }

  //把实线Path转换成虚线Path
  Path _convertDotterPath(Path path) {
    //→核心方法
    Path targetPath = Path(); //虚线
    int dottedLength = 15; //每根虚线的长度
    int dottedGap = 10; //每根虚线的间距
    for (var metric in path.computeMetrics()) {
      double distance = 0;
      bool isDrawDotted = true;
      while (distance < metric.length) {
        if (isDrawDotted) {
          targetPath.addPath(
              metric.extractPath(distance, distance + dottedLength),
              Offset.zero);
          distance += dottedLength;
        } else {
          distance += dottedGap;
        }
        isDrawDotted = !isDrawDotted;
      }
    }
    return targetPath;
  }
}
