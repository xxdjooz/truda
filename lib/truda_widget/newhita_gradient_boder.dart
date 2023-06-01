import 'dart:math';

import 'package:flutter/material.dart';

class NewHitaGradientBoder extends StatefulWidget {
  // 矩形 长、宽、边框宽度，其中长、宽已包含边框宽度
  final double? width;
  final double? height;
  final double border;
  final double? borderRadius;
  final Widget child;
  final Color? colorSolid;
  final bool circling;
  final List<Color> colors;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const NewHitaGradientBoder({
    Key? key,
    this.width,
    this.height,
    this.circling = false,
    this.colorSolid,
    this.borderRadius,
    this.padding,
    this.margin,
    required this.border,
    required this.colors,
    required this.child,
  }) : super(key: key);

  @override
  State<NewHitaGradientBoder> createState() => _NewHitaGradientBoderState();
}

class _NewHitaGradientBoderState extends State<NewHitaGradientBoder>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    if (widget.circling) {
      controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              // 创建 painter
              painter: NewHitaGradientBoundPainter(
                colors: widget.colors,
                animation: animation.value,
                border: widget.border,
                borderRadius: widget.borderRadius,
              ),
              // child 内容铺满容器并居中
              child: Container(
                margin: EdgeInsets.all(widget.border),
                padding: widget.padding ?? EdgeInsets.zero,
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.colorSolid ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
                ),
                child: widget.child,
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// 渐变边框核心绘图逻辑
class NewHitaGradientBoundPainter extends CustomPainter {
  final List<Color> colors;
  final double animation;
  final double border;
  final double? borderRadius;

  const NewHitaGradientBoundPainter({
    Key? key,
    required this.colors,
    required this.animation,
    required this.border,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // 这个border需要加粗一些，因为会有缝隙
    final double border = this.border + 4;
    // 向里面画，不然会画出去
    final rect = Rect.fromLTWH(
      border / 2,
      border / 2,
      size.width - border,
      size.height - border,
    );
    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        transform: GradientRotation(animation * 2 * pi),
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = border;
    //
    final rRect =
        RRect.fromRectAndRadius(rect, Radius.circular(borderRadius ?? 0));
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant NewHitaGradientBoundPainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.animation != animation;
  }
}
