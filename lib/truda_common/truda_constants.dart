import 'package:get/get_utils/src/platform/platform.dart';

class TrudaConstants {
  // flutter dart 混淆
  // flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>
  // flutter build apk --obfuscate --split-debug-info=./obfuse
  // flutter build appbundle --obfuscate --split-debug-info=./obfuse
  /// true 测试模式 能切换环境，发包要注意改成: false
  static bool isTestMode = true;
  static bool haveTestLogin = true;

  // adjust默认值，
  static const String adjustId = 'fqbxa6sx0hkw';
  static const String adjustEventKey = 'u0m2sn';
  static const String adjustIdIos = '';
  static const String adjustEventKeyIos = '';
  static const String sentryDsn = '';

  static const appName = 'Hita';
  static const appNameLower = 'hitab';

  static const privacyPolicy =
      "https://hitalinks.com/page/Privacy_Policy.html";
  static const agreement = "https://hitalinks.com/page/agreement.html";
  static bool agree = false; //
  // 当前是审核模式？
  static bool _isFakeMode = false;
  // getter
  static bool get isFakeMode {
    // todo 这里测试用
    // return true;
    return TrudaConstants._isFakeMode;
  }
  // setter
  static set isFakeMode(bool fakeMode){
    TrudaConstants._isFakeMode = fakeMode;
  }
  /// 0正常模式，1安卓审核模式，2苹果审核模式
  /// 正常模式：底部先首页后匹配，首页分热门主播、在线主播、关注
  /// 安卓审核模式：去掉了匹配，隐藏打电话按钮
  /// 苹果审核模式：底部先匹配，后首页。首页分动态、关注
  static int get appMode {
    // todo 这里测试用
    // return 1;
    if (TrudaConstants.isFakeMode) {
      if (GetPlatform.isAndroid) {
        return 1;
      } else if (GetPlatform.isIOS) {
        return 2;
      }
    } else {
      return 0;
    }
    return 0;
  }
  static const giftsJson = "giftsJson"; //
  static const testModeStyle = "testModeStyle"; //
  static const blackList = "blackList"; //
  static const hadShowDragTip = "hadShowDragTip"; //
  static const bowlingDrag = 'bowlingDrag';
  static const systemId = "9999"; //
  // 为了ios审核，加上这个聊天对象，方便做UGC
  static const serviceId = "10000"; //
  // 游客登录记录
  static const keyVisitorAccount = 'keyVisitorAccount';
  static const visitorAccountSplit = '%#%';
}
