import 'package:flutter/material.dart';

import '../truda_common/truda_colors.dart';

class NewHitaGradientButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const NewHitaGradientButton(
      {Key? key,
      required this.child,
      required this.onTap,
      this.padding,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          decoration: BoxDecoration(
              // 渐变色
              gradient: const LinearGradient(colors: [
                TrudaColors.baseColorGradient1,
                TrudaColors.baseColorGradient2,
              ]),
              borderRadius: BorderRadius.circular(50)),
          child: InkWell(
            splashColor: Colors.white54,
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            child: child,
          ),
        ),
      ),
    );
  }
}
