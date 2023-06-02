import 'package:flutter/material.dart';

class TrudaLineButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const TrudaLineButton(
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
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(50)),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            child: child,
          ),
        ),
      ),
    );
  }
}
