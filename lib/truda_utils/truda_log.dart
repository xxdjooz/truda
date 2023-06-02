import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as logger;
import 'package:logger/logger.dart';

class TrudaLog {
  static logger.Logger? _loggerInstance;

  static logger.Logger get _logger => _loggerInstance ??= logger.Logger(
          printer: PrettyPrinter(
        stackTraceBeginIndex: 2,
        methodCount: 3,
        errorMethodCount: 8,
      ));
  static logger.Logger? _loggerInstance2;
  // 搞一个能打印很长的
  static logger.Logger get _logger2 => _loggerInstance2 ??= logger.Logger(
        printer: PrettyPrinter(
          stackTraceBeginIndex: 2,
          methodCount: 3,
          errorMethodCount: 8,
        ),
        output: TrudaConsoleOutput(),
      );

  static void longLog(dynamic message) {
    _logger2.d(message);
  }

  static void debug(Object message) {
    _logger.d(message);
  }

  static void good(Object message) {
    _logger.v(message);
  }

  static void cry(Object message) {
    _logger.e(message);
  }
}

class TrudaConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(printWrapped);
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  // This works too.
  void printWrapped2(String text) => debugPrint(text, wrapWidth: 1024);
}
