import 'package:get/get.dart';

// 主页面各页面切换监听

// 对obs做监听的worker:
// ever(followShow, (callback) => null); // 每次变化
// once(followShow, (callback) => null); // 首次变化
// debounce(followShow, (callback) => null, time: Duration(seconds: 1));// 变化后延迟
// interval(followShow, (callback) => null, time: Duration(seconds: 1));// 间隔时间后
class TrudaPageIndexManager {
  // 主页面的tab
  static int _mainIndex = 0;
  // home的tab
  static int _homeIndex = 0;
  // 主页面的显隐
  static bool _mainShow = true;

  // 关注页面的显隐
  static RxBool followShow = false.obs;

  // 主页面显示被切换
  static void setMainShow(bool show) {
    _mainShow = show;
    if (_mainShow && _mainIndex == 0 && _homeIndex == 1) {
      followShow.value = true;
    } else {
      followShow.value = false;
    }
  }

  // 主页面的tab被切换
  static void setMainIndex(int index) {
    _mainIndex = index;
    if (_mainIndex == 0 && _homeIndex == 1) {
        followShow.value = true;
    } else {
      followShow.value = false;
    }
  }

  // home的tab被切换
  static void setHomeIndex(int index) {
    _homeIndex = index;
    if (_homeIndex == 1) {
      followShow.value = true;
    } else {
      followShow.value = false;
    }
  }

// 对obs做监听的worker:
// ever(followShow, (callback) => null);
// once(followShow, (callback) => null);
// debounce(followShow, (callback) => null, time: Duration(seconds: 1));
// interval(followShow, (callback) => null, time: Duration(seconds: 1));
}
