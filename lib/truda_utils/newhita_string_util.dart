import 'dart:math';
/// 获取指定长度的，从指定字符串随机取出的字符串
String getRandomString(int length, String str) {
  return String.fromCharCodes(Iterable.generate(
      length, (_) => str.codeUnitAt(Random().nextInt(str.length))));
}
