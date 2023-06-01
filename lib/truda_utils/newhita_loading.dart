import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NewHitaLoading {
  NewHitaLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 35.0
      ..lineWidth = 2
      ..radius = 10.0
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..progressColor = Colors.white
      ..backgroundColor = Colors.white.withOpacity(0.3)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.transparent
      ..userInteractions = true
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.custom;
  }

  static void show({String? text, bool dismissOnTap = true}) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.dismissOnTap = dismissOnTap;
    EasyLoading.show(status: text);
  }

  static void toast(
      String text, {
        Duration? duration,
        EasyLoadingToastPosition? position,
      }) {
    EasyLoading.showToast(text, toastPosition: position);
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }
}
