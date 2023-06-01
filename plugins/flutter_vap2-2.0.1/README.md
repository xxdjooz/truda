[中文文档](./README_CH.md)

### Backdrop
Transparent video animation is currently one of the more popular implementations of animation. Major manufacturers have also open sourced their own frameworks. In the end, we chose [Tencent vap](https://github.com/Tencent/vap), which supports Android, IOS, and Web, and provides natural convenience for us to encapsulate flutter_vap. Provides a tool to generate a video with an alpha channel from a frame picture, which is simply awesome.



VAP（Video Animation Player）is developed by Penguin E-sports and is used to play cool animations.
- Compared with Webp and Apng animation solutions, it has the advantages of high compression rate (smaller material) and hardware decoding (faster decoding)
- Compared with Lottie, it can achieve more complex animation effects (such as particle effects)

### Preview
![image](http://file.jinxianyun.com/flutter_vap.gif)

[video for youtube](https://youtu.be/OCLkFhcYqwA)

[video for qiniu](http://file.jinxianyun.com/flutter_vap.mp4)

[apk download](http://file.jinxianyun.com/flutter_vap.apk)

### Setup
```
flutter_vap2: ${last_version}
```

### How to use
```dart
import 'package:flutter_vap2/flutter_vap.dart';

VapViewController vapViewController;

IgnorePointer(
  // VapView can set the width and height through the outer package Container() to limit the width and height of the pop-up video
  child: VapView(
    onVapViewCreated: (controller) {
        vapViewController = controller;
    }
  ),
),
```

1. Play local video
```dart
  import 'package:flutter_vap2/flutter_vap.dart';

  /// return: play error:       {"status": "failure", "errorMsg": ""}
  ///         play complete:    {"status": "complete"}
  Future<Map<dynamic, dynamic>> _playFile(String path) async {
    if (path == null) {
      return null;
    }
    var res = await vapViewController.playPath(path);
    if (res["status"] == "failure") {
      showToast(res["errorMsg"]);
    }
    return res;
  }
```

2. Play asset video
```dart
  Future<Map<dynamic, dynamic>> _playAsset(String asset) async {
    if (asset == null) {
      return null;
    }
    var res = await vapViewController.playAsset(asset);
    if (res["status"] == "failure") {
      showToast(res["errorMsg"]);
    }
    return res;
  }
```

3. Stop play
```dart
  VapController.stop()
```

4. Queue play
```dart
  _queuePlay() async {。
    // Simultaneously call playback in multiple places, making the queue perform playback.
    QueueUtil.get("vapQueue").addTask(() => vapViewController.playPath(downloadPathList[0]));
    QueueUtil.get("vapQueue").addTask(() => vapViewController.playPath(downloadPathList[1]));
  }
```

5. Cancel queue playback
```dart
  QueueUtil.get("vapQueue").cancelTask();
```

Example

[github](https://gitee.com/fine1021/flutter_vap/blob/main/example/lib/main.dart)


