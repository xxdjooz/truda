import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';

import '../truda_common/truda_colors.dart';

class TrudaHostTabBar extends TabBar {
  TrudaHostTabBar({Key? key, final TabController? controller})
      : super(
          key: key,
          tabs: [
            Tab(
              // height: 30,
              child: Container(
                alignment: Alignment.center,
                // margin: const EdgeInsetsDirectional.only(end: 10),
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.white24, width: 1),
                //     borderRadius: BorderRadius.circular(20)),
                child: Text(TrudaLanguageKey.newhita_details_album.tr,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.white70)),
              ),
            ),
            Tab(
              // height: 30,
              child: Container(
                alignment: Alignment.center,
                // margin: const EdgeInsetsDirectional.only(end: 10),
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.white24, width: 1),
                //     borderRadius: BorderRadius.circular(20)),
                child: Text(TrudaLanguageKey.newhita_video_easy_photos.tr,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.white70)),
              ),
            ),
          ],
          controller: controller,
          labelStyle: const TextStyle(
              fontSize: 18,
              color: TrudaColors.white,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              const TextStyle(fontSize: 16, color: Colors.white38),
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const TrudaHostTabIndicator(),
          indicatorWeight: 0,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          // indicatorPadding:
          //     EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        );

  // @override
  // Size get preferredSize => Size.fromHeight(46);
}

class TrudaHostTabIndicator extends Decoration {
  const TrudaHostTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  })  : assert(borderSide != null),
        assert(insets != null);

  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is TrudaHostTabIndicator) {
      return TrudaHostTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is TrudaHostTabIndicator) {
      return TrudaHostTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TrudaHostTabPainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _TrudaHostTabPainter extends BoxPainter {
  _TrudaHostTabPainter(this.decoration, VoidCallback? onChanged)
      : assert(decoration != null),
        super(onChanged);

  final TrudaHostTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // assert(configuration != null);
    // assert(configuration.size != null);
    // final Rect rect = offset & configuration.size!;
    // final TextDirection textDirection = configuration.textDirection!;
    // final Rect indicator = decoration
    //     ._indicatorRectFor(rect, textDirection)
    //     .deflate(decoration.borderSide.width / 2.0);
    // final Paint paint = decoration.borderSide.toPaint()
    //   ..strokeCap = StrokeCap.square;
    // canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);

    assert(configuration != null);
    assert(configuration.size != null);
    Rect re = offset & configuration.size!;
    // 这里缩小1是因为有遮挡
    Rect rect =
        Rect.fromLTRB(re.left + 1, re.top + 1, re.right - 1, re.bottom - 1);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(30.0));
    // Gradient gradient = const LinearGradient(
    //     colors: [TrudaColors.baseColorRed, TrudaColors.baseColorOrange]);
    canvas.drawRRect(
        rrect,
        Paint()
          ..color = Colors.white60
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);
  }
}
