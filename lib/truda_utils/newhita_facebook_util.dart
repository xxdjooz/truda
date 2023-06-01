import 'package:flutter/services.dart';

const String newhita_method_channel = "newhita_method_channel";
const platform = MethodChannel(newhita_method_channel);

Future<void> getFacebookKey() async {
  try {
    final String result = await platform.invokeMethod('getFacebookKey');
    print(result);
  } on PlatformException catch (e) {
    print("Failed to get getFacebookKey");
  }
}

Future<void> askNotification() async {
  try {
    final String result = await platform.invokeMethod('askNotification');
    print(result);
  } on PlatformException catch (e) {
    print("Failed to get askNotification");
  }
}

Future<void> testUpload(String url, String path) async {
  try {
    final String result =
        await platform.invokeMethod('testUpload', {"url": url, "path": path});
    print(result);
  } on PlatformException catch (e) {
    print("Failed to get testUpload");
  }
}

Future<void> gotoGooglePlay(String package) async {
  try {
    final String result = await platform
        .invokeMethod('method_goto_google_play', {"key_package_name": package});
    print(result);
  } on PlatformException catch (e) {
    print("Failed to get gotoGooglePlay");
  }
}

///关闭其他 activity
Future<void> finishExceptActivity() async {
  try {
    final String result = await platform.invokeMethod('key_clear_except');
    print(result);
  } on PlatformException catch (e) {
    print("Failed to get key_clear_except");
  }
}
