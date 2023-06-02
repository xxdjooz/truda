import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TrudaAppInfoService extends GetxService {
  static TrudaAppInfoService get to => Get.find();
  late String deviceIdentifier;
  late String deviceModel;
  late String AppSystemVersionKey;
  late String version;
  late String buildNumber;
  String get channelName {
    if (GetPlatform.isIOS == true) {
      return "${TrudaConstants.appNameLower}200";
    }
    return "${TrudaConstants.appNameLower}100";
  }

  Future<TrudaAppInfoService> init() async {
    // 设备信息
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (GetPlatform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;

      AppSystemVersionKey = iosDeviceInfo.systemVersion ?? "unknow";
      deviceIdentifier = (iosDeviceInfo.identifierForVendor ?? "") +
          "-" +
          (iosDeviceInfo.utsname.machine ?? "");
      deviceModel = "ios " + (iosDeviceInfo.model ?? "iphone");
    } else if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;

      AppSystemVersionKey = androidDeviceInfo.version.release ?? "unknow";
      deviceIdentifier = (androidDeviceInfo.androidId ?? "") +
          "-" +
          (androidDeviceInfo.brand ?? "");
      deviceModel = "android " + (androidDeviceInfo.model ?? "android");
    }
    // 包信息
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
    return this;
  }
}
