import 'package:flutter/material.dart';
import 'package:truda/truda_common/truda_colors.dart';

class TrudaStickyDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  TrudaStickyDelegate(
      {required this.child, this.decoration, this.padding, this.margin});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: TrudaColors.baseColorBlackBg,
      child: Container(
        padding: padding,
        decoration: decoration,
        margin: margin,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
