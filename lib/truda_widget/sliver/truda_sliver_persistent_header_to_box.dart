import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'truda_extra_info_constraints.dart';

typedef TrudaSliverPersistentHeaderToBoxBuilder = Widget Function(
  BuildContext context,
  double maxExtent,
  bool fixed,
);

/// A sliver like [SliverPersistentHeader], the difference is [TrudaSliverPersistentHeaderToBox]
/// can contain a box widget and use the height of its child directly.
/// 和 [SliverPersistentHeader]功能类似，但不同是[TrudaSliverPersistentHeaderToBox]
/// 能够直接包含一个盒模型子组件（Box widget），并且高度会使用子组件高度。
class TrudaSliverPersistentHeaderToBox extends StatelessWidget {
  TrudaSliverPersistentHeaderToBox({
    Key? key,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        super(key: key);

  const TrudaSliverPersistentHeaderToBox.builder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final TrudaSliverPersistentHeaderToBoxBuilder builder;

  @override
  Widget build(BuildContext context) {
    return _TrudaSliverPersistentHeaderToBox(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return builder(
            context,
            constraints.maxHeight,
            (constraints as TrudaExtraInfoBoxConstraints<bool>).extra,
          );
        },
      ),
    );
  }
}

class _TrudaSliverPersistentHeaderToBox extends SingleChildRenderObjectWidget {
  const _TrudaSliverPersistentHeaderToBox({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderTrudaSliverPersistentHeaderToBox();
  }
}

class _RenderTrudaSliverPersistentHeaderToBox extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child!.layout(
      TrudaExtraInfoBoxConstraints(
        // 只要constraints.scrollOffset不为0，则表示已经有内容在当前Sliver下面了（重叠了）
        constraints.scrollOffset != .0,
        constraints.asBoxConstraints(
          // 我们将剩余的可绘制空间作为 header 的最大高度约束传递给 LayoutBuilder
          maxExtent: constraints.remainingPaintExtent,
        ),
      ),
      //我们要根据child大小来确定Sliver大小，所以后面需要用到child的size信息
      parentUsesSize: true,
    );

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintOrigin: 0, // 固定，如果不想固定应该传 - constraints.scrollOffset
      paintExtent: childExtent,
      maxPaintExtent: childExtent,
    );
  }

  // 重要，如果没有重写则不会响应事件，点击测试中会用到。关于点击测试我们会在本书面介绍,
  // 读者现在只需要知道该函数应该返回 paintOrigin 的位置即可。
  @override
  double childMainAxisPosition(RenderBox child) => 0.0;
}
