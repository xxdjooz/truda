import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrudaCommonDialog {
  static Future<T?> dialog<T>(
    Widget widget, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    GlobalKey<NavigatorState>? navigatorKey,
    Object? arguments,
    Duration? transitionDuration,
    Curve? transitionCurve,
    String? name,
    RouteSettings? routeSettings,
  }) {
    return Get.dialog(
      widget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black87,
      useSafeArea: useSafeArea,
    );
  }
  static Future<T?> bottomSheet<T>(
    Widget widget, {
    Color? barrierColor,
    RouteSettings? routeSettings,
  }) {
    return Get.bottomSheet(
      widget,
      barrierColor: barrierColor ?? Colors.black87,
    );
  }
}
