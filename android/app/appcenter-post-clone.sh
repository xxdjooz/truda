
#!/usr/bin/env bash
#Place this script in project/android/app/
#cd /root/workspace/Sumi_XAcW/Sumi/android
cd ..

# fail if any command fails
set -e
# debug log
set -x

cd ..
#git 上获取对应版本的Flutter 版本 3.3.2 可以根据需要去该地址查找：https://github.com/flutter/flutter
#git clone -b 3.3.8 https://github.com/flutter/flutter.git
git clone -b stable https://github.com/flutter/flutter.git

export PATH=`pwd`/flutter/bin:$PATH


#flutter downgrade 2.10.5
#flutter channel stable
flutter doctor



echo "Installed flutter to `pwd`/flutter"

#git update-index --chmod=+x gradlew

# build APK
# if you get "Execution failed for task ':app:lintVitalRelease'." error, uncomment next two lines
# flutter build apk --debug
# flutter build apk --profile
#为什么要 build apk 是因为不build 会报错倒是 aab 成功build 的包也不能获取到
flutter build apk --release

# if you need build bundle (AAB) in addition to your APK, uncomment line below and last line of this script.
#flutter build appbundle --release --build-number $APPCENTER_BUILD_ID
flutter build appbundle --release  --obfuscate --split-debug-info=build/app/outputs/bundle/release/obfuse

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_

# copy the AAB where AppCenter will find it
mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/release/app-release.aab $_
