import 'dart:async';

import 'package:flutter/material.dart';

enum TrudaClickType {
  /// 无限制
  none,

  /// 事件节流 在当前事件未执行完成时，该事件再次触发时会被忽略
  throttle,

  /// 指定时间节流 指定时间内（默认500ms）再次触发事件会被忽略
  throttleWithTimeout,

  /// 防抖
  /// 防抖是在事件触发时，不立即执行事件的目标操作逻辑，而是延迟指定时间再执行，
  /// 如果该时间内事件再次触发，则取消上一次事件的执行并重新计算延迟时间，
  /// 直到指定时间内事件没有再次触发时才执行事件的目标操作。
  debounce
}

/// 自定义点击控件
class TrudaClickWidget extends StatelessWidget {
  final Widget child;
  final Function? onTap;
  final TrudaClickType type;
  final int? timeout;

  const TrudaClickWidget(
      {Key? key,
      required this.child,
      this.onTap,
      this.type = TrudaClickType.throttleWithTimeout,
      this.timeout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: child,
      onTap: _getOnTap(),
    );
  }

  VoidCallback? _getOnTap() {
    if (type == TrudaClickType.throttle) {
      return onTap?.throttle();
    } else if (type == TrudaClickType.throttleWithTimeout) {
      return onTap?.throttleWithTimeout(timeout: timeout);
    } else if (type == TrudaClickType.debounce) {
      return onTap?.debounce(timeout: timeout);
    }
    return () => onTap?.call();
  }
}

/// 对Function进行扩展
extension TrudaFunctionExt on Function {
  VoidCallback throttle() {
    return TrudaFunctionProxy(this).throttle;
  }

  VoidCallback throttleWithTimeout({int? timeout}) {
    return TrudaFunctionProxy(this, timeout: timeout).throttleWithTimeout;
  }

  VoidCallback debounce({int? timeout}) {
    return TrudaFunctionProxy(this, timeout: timeout).debounce;
  }
}

/// 节流、防抖 实现方式
class TrudaFunctionProxy {
  static final Map<String, bool> _funcThrottle = {};
  static final Map<String, Timer> _funcDebounce = {};
  final Function? target;

  final int timeout;

  TrudaFunctionProxy(this.target, {int? timeout}) : timeout = timeout ?? 500;

  /// 点击的回调执行完才能响应下次
  void throttle() async {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      try {
        await target?.call();
      } catch (e) {
        rethrow;
      } finally {
        _funcThrottle.remove(key);
      }
    }
  }

  /// 指定时间后才能响应下次
  void throttleWithTimeout() {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      Timer(Duration(milliseconds: timeout), () {
        _funcThrottle.remove(key);
      });
      target?.call();
    }
  }

  /// 防抖，实现方式是点击后不立即执行先计时
  void debounce() {
    String key = hashCode.toString();
    Timer? timer = _funcDebounce[key];
    timer?.cancel();
    timer = Timer(Duration(milliseconds: timeout), () {
      Timer? t = _funcDebounce.remove(key);
      t?.cancel();
      target?.call();
    });
    _funcDebounce[key] = timer;
  }
}
