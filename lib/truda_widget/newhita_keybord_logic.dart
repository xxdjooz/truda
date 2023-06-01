import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

import '../truda_utils/newhita_log.dart';

/// class _NewHitaDemoViewState extends State<DemoView> with WidgetsBindingObserver, KeyboardLogic {
/// 监听键盘弹出
mixin NewHitaKeyboardLogic<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;
    final temp = keyboardVisible;
    if (_keyboardVisible == temp) return;
    _keyboardVisible = temp;
    onKeyboardChanged(keyboardVisible);
    NewHitaLog.debug('NewHitaKeyboardLogic bottom = ${getKeyBordHeight()}');
  }

  double getKeyBordHeight() {
    var wb = WidgetsBinding.instance;
    if (wb != null) {
      var bottom = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance!.window.viewInsets,
        WidgetsBinding.instance!.window.devicePixelRatio,
      ).bottom;
      return math.max(bottom, 278);
    }
    return 278;
  }

  void onKeyboardChanged(bool visible);

  bool get keyboardVisible =>
      EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance!.window.viewInsets,
        WidgetsBinding.instance!.window.devicePixelRatio,
      ).bottom >
      100;
}
