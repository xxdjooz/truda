import 'package:flutter/widgets.dart';

typedef NewHitaSliverHeaderBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

/// Delegate helper for [SliverPersistentHeader].
/// [SliverPersistentHeader] 的帮助类，用于快速创建delegate 。
/// SliverPersistentHeader(
///     pinned: true, // 粘顶
///     delegate: NewHitaSliverHeaderDelegate.fixedHeight(
///       height: 50,
///       child: ColoredBox(
///         color: Colors.green,
///       ),
///     ),
///   ),
class NewHitaSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  // child 为 header
  NewHitaSliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  //最大和最小高度相同
  NewHitaSliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  //需要自定义builder时使用
  NewHitaSliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final NewHitaSliverHeaderBuilder builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    //测试代码：如果在调试模式，且子组件设置了key，则打印日志
    assert(() {
      if (child.key != null) {
        debugPrint(
            '${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(NewHitaSliverHeaderDelegate old) {
    // return old.maxExtent != maxExtent || old.minExtent != minExtent;
    // 这里原作者写法在里面widget需要更新时不能更新
    return true;
  }
}
