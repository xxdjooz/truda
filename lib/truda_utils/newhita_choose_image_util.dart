import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_colors.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:image_picker/image_picker.dart';

import '../truda_database/entity/truda_msg_entity.dart';
import '../truda_http/newhita_http_urls.dart';
import '../truda_http/newhita_http_util.dart';
import 'newhita_loading.dart';
import 'newhita_log.dart';
import 'newhita_upload_isolate.dart';

typedef NewHitaUpLoadCallBack = Function(NewHitaChooseImageUtil upLoader,
    NewHitaUploadType type, String? url, String? partPath);

enum NewHitaUploadType { cancel, begin, success, failed }

class NewHitaChooseImageUtil {
  final NewHitaUpLoadCallBack callBack;

  // type 0头像，1图片，2声音
  final int type;

  // 如果他是发消息，做暂时的存储
  TrudaMsgEntity? msg;

  NewHitaChooseImageUtil({required this.type, required this.callBack});

  void openChooseDialog() {
    Get.bottomSheet(
      Container(
          decoration: const BoxDecoration(
              color: TrudaColors.white,
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20), topEnd: Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  Get.back();
                  // cameraChoose?.call();
                  // imagePickerCallBack.call(image);
                  goChooseImage(true);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.only(top: 20, bottom: 10),
                  decoration: const BoxDecoration(
                      color: TrudaColors.white,
                      borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(20),
                          topEnd: Radius.circular(20))),
                  child: Text(
                    TrudaLanguageKey.newhita_base_take_picture.tr,
                    style: const TextStyle(
                        color: TrudaColors.textColor666, fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // albumChoose?.call();
                  Get.back();
                  // imagePickerCallBack.call(image);
                  goChooseImage(false);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: TrudaColors.white,
                  ),
                  child: Text(
                    TrudaLanguageKey.newhita_details_album.tr,
                    style: const TextStyle(
                        color: TrudaColors.textColor666, fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(top: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.only(top: 20, bottom: 20),
                  decoration: const BoxDecoration(
                    color: TrudaColors.white,
                  ),
                  child: Text(
                    TrudaLanguageKey.newhita_base_cancel.tr,
                    style: const TextStyle(
                        color: TrudaColors.textColor666, fontSize: 16),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void goChooseImage(bool camera) {
    // XFile? image
    ImagePicker()
        .pickImage(
            source: camera ? ImageSource.camera : ImageSource.gallery,
            maxWidth: 1080,
            maxHeight: 1080)
        .then((value) {
      if (value != null) {
        loadOssAndUpload(value.path);
        callBack.call(this, NewHitaUploadType.begin, null, value.path);
      } else {
        callBack.call(this, NewHitaUploadType.failed, null, null);
      }
    });
  }

  // type 0头像，1图片，2声音
  void loadOssAndUpload(String path) {
    // NewHitaHttpUtil().post<NewHitaOssConfig>(NewHitaHttpUrls.aliOssApi,
    //     data: {"private": false, "public": true}).then((value) {
    //   uploadWithFilePath(path, value);
    // }, onError: (e) {
    //   callBack.call(this, NewHitaUploadType.failed, null, null);
    // });
    NewHitaHttpUtil().post<String>(NewHitaHttpUrls.s3UploadUrl,
        data: {'endType': '.jpg'}, errCallback: (err) {
      NewHitaLog.debug(err);
      NewHitaLoading.toast(err.message);
      callBack.call(this, NewHitaUploadType.failed, null, null);
    }, showLoading: true).then((url) {
      uploadWithFilePath(path, url);
    });
  }

// type 0头像，1图片，2声音
  void uploadWithFilePath(String filePath, String url) async {
    // ShowLoading("");

    try {
      // File file = File(filePath);
      // String? endPoint = ossConfig.endpoint?.replaceFirst("http://", "");
      // endPoint = endPoint?.replaceFirst("https://", "");
      //
      // String path = (ossConfig.path ?? "") + (type == 0 ? "/media" : "/chat");
      //
      // OSSObject ossObject = type == 2
      //     ? OSSAudioObject.fromFile(file: file)
      //     : OSSImageObject.fromFile(file: file);
      // // 初始化OSSClient
      // OSSClient.init(
      //   endpoint: endPoint ?? "oss-cn-hongkong.aliyuncs.com",
      //   bucket: ossConfig.bucket ?? "yesme-public",
      //   credentials: () {
      //     return Future.value(Credentials(
      //         accessKeyId: ossConfig.key ?? "",
      //         accessKeySecret: ossConfig.secret ?? "",
      //         securityToken: ossConfig.token ?? "",
      //         expiration:
      //             DateTime.fromMillisecondsSinceEpoch(ossConfig.expire ?? 0)));
      //   },
      // );
      // OSSObject object = await OSSClient().putObject(
      //     object: ossObject,
      //     // endpoint: LocalStore.ossConfig?.endpoint ?? "",
      //     // bucket: LocalStore.ossConfig?.bucket ?? "",
      //     endpoint: endPoint ?? "oss-cn-hongkong.aliyuncs.com",
      //     bucket: ossConfig.bucket ?? "yesme-public",
      //     path: path);
      NewHitaUploadIsolate().loadData(url, filePath, 'image/jpeg').then((value) {
        if (value == 200) {
          var realUrl = url.split('?')[0];
          NewHitaLog.debug("图片上传成功 URL= ${realUrl}");
          callBack.call(this, NewHitaUploadType.success, realUrl, filePath);
        } else {
          callBack.call(this, NewHitaUploadType.failed, null, null);
        }
      }).catchError((e) {
        callBack.call(this, NewHitaUploadType.failed, null, null);
      });

      // if (object.url.isNotEmpty) {
      //   final String partPath = object.url.split(endPoint ?? "").last;
      //   callBack.call(this, NewHitaUploadType.success, object.url, partPath);
      // } else {
      //   callBack.call(this, NewHitaUploadType.failed, null, null);
      // }
    } catch (e) {
      NewHitaLog.debug(e);
      // showToast(LangMap.cbl_err_unknown.tr);
      callBack.call(this, NewHitaUploadType.failed, null, null);
    } finally {
      // CbldeLoding();
    }
  }
}
