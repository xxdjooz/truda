import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../truda_common/truda_colors.dart';
import '../truda_http/truda_http_util.dart';
import 'newhita_loading.dart';
import 'newhita_log.dart';

class NewHitaSimpleS3Upload extends StatefulWidget {
  const NewHitaSimpleS3Upload({Key? key}) : super(key: key);

  @override
  NewHitaSimpleS3UploadState createState() => NewHitaSimpleS3UploadState();
}

class NewHitaSimpleS3UploadState extends State<NewHitaSimpleS3Upload> {
  File? selectedFile;

  String? selectFileString;

  // SimpleS3 _simpleS3 = SimpleS3();
  bool isLoading = false;
  bool uploaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: StreamBuilder<dynamic>(
        //     stream: _simpleS3.getUploadPercentage,
        //     builder: (context, snapshot) {
        //       return new Text(
        //         snapshot.data == null ? "Simple S3 Test" : "Uploaded: ${snapshot.data}",
        //       );
        //     }),
      ),
      body: Center(
        child: selectedFile != null
            ? isLoading
                ? CircularProgressIndicator()
                : Image.file(selectedFile!)
            : GestureDetector(
                onTap: () async {
                  XFile? _pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {
                    selectedFile = File(_pickedFile?.path ?? "");
                    selectFileString = _pickedFile?.path ?? "";
                    print(selectFileString);
                    // print("文件类型=${TypeMedia.getMediaType(_pickedFile?.path ?? "")}");
                  });
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
      ),
      floatingActionButton: !isLoading
          ? FloatingActionButton(
              backgroundColor: uploaded ? Colors.green : Colors.blue,
              child: Icon(
                uploaded ? Icons.delete : Icons.arrow_upward,
                color: TrudaColors.white,
              ),
              onPressed: () async {
                if (uploaded) {
                  // print(await SimpleS3.delete(
                  //     "test/${selectedFile!.path.split("/").last}", "Credentials.s3_bucketName", "Credentials.s3_poolD", AWSRegions.apSouth1,
                  //     debugLog: true));
                  // setState(() {
                  //   selectedFile = null;
                  //   uploaded = false;
                  // });
                }
                if (selectedFile != null) _upload();
              },
            )
          : null,
    );
  }

  //, required Function progressCallback
  Future<Response> dioUpload(String url, String filePath,
      {Map<String, String> headers = const {},
      Map<String, String> body = const {}}) async {
    print('dioUpload-> url = ' + url);
    var par = url.split('?');
    var par1 = par[0];
    var pard = par1.split('/');
    var name = pard.last;
    print('dioUpload-> name = ' + name);
    var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(filePath, filename: name)});
    Dio dio = new Dio();
    CancelToken cancelToken = CancelToken();
    Response resp = await dio
        .put(url, data: formData, options: Options(headers: headers),
            onSendProgress: (int count, int data) {
      print(count);
      print(data);
      print(cancelToken);
      // progressCallback(count, data, cancelToken);
    });
    print("文件上传状态${resp.statusCode}");
    if (resp.statusCode == 200) {
      print("文件上传成功");
      return resp;
    } else {
      throw new Exception("网络访问错误");
    }
  }

  //, required Function progressCallback
  Future<Response> dioUpload2(String url, String filePath,
      {Map<String, String> headers = const {},
      Map<String, String> body = const {}}) async {
    print('dioUpload-> url = ' + url);
    // var par = url.split('?');
    // var par1 = par[0];
    // var pard = par1.split('/');
    // var name = pard.last;
    // print('dioUpload-> name = ' + name);
    var file = File(filePath);
    // var listInt = file.openRead();
    // var formData = Stream.fromIterable(listInt);
    Dio dio = Dio();
    CancelToken cancelToken = CancelToken();
    Response resp = await dio.put(url,
        data: file.openRead(),
        // data: formData,
        options: Options(headers: {
          // 'Content-Type': "binary/octet-stream",
          'Content-Type': "image/JPEG",
          'Accept': "*/*",
          'Content-Length': File(filePath).lengthSync().toString(),
          'Connection': 'keep-alive',
        }), onSendProgress: (int count, int data) {
      print(count);
      print(data);
      print(cancelToken);
      // progressCallback(count, data, cancelToken);
    });
    print("文件上传状态${resp.statusCode}");
    if (resp.statusCode == 200) {
      print("文件上传成功");
      return resp;
    } else {
      throw new Exception("网络访问错误");
    }
  }

  Future<String?> _upload() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        TrudaHttpUtil().post<String>('/user/s3/storage/upload/pre-signed',
            data: {'endType': '.jpg'}, errCallback: (err) {
          NewHitaLog.debug(err);
          NewHitaLoading.toast(err.message);
        }).then((value) {
          NewHitaLog.debug(value);
          // dioUpload2(value, selectedFile?.path ?? "");
          //
          uploadFile(File(selectedFile?.path ?? ""), value);
          // testUpload(value, selectedFile?.path ?? "");
        });

        // HiHttpManager.postRequest<AwsgetstoragedataEntity>(HiHttpUrls.awsUploadSigned, (awsConfigEntity) async {
        //   if (awsConfigEntity is AwsgetstoragedataEntity && awsConfigEntity.code == 0) {
        //     print("请求地址=${awsConfigEntity.data ?? ""}");
        //
        //     dioUpload(awsConfigEntity.data ?? "", selectedFile?.path ?? "");//, progressCallback: (){}
        //   } else {
        //     LogTool.debug("aws上传凭证获取失败");
        //   }
        // }, (e) {
        //   LogTool.debug("aws上传凭证获取失败");
        // }, {"endType": TypeMedia.getMediaType(selectFileString ?? "")});

        setState(() {
          uploaded = true;
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  // void upload(File file, String uri) async {
  //   ReceivePort port = ReceivePort();
  //
  //   Isolate iso = await Isolate.spawn(uploadFile(file, uri), port.sendPort);
  //   port.listen((message) {
  //     print(message);
  //     port.close();
  //     iso.kill();
  //   });
  //
  //   await compute(uploadFile(file, uri), null);
  // }

  static Future uploadFile(File file, String uri) async {
    // 初始化一个Http客户端，并加入自定义Header
    var req = await HttpClient().putUrl(Uri.parse(uri));
    // headers.forEach((key, value) {
    //   req.headers.add(key, value);
    // });
    req.headers.add('Content-Type', 'image/JPEG');
    req.headers.add('Accept', '*/*');
    req.headers.add('Connection', 'keep-alive');
    // 读文件
    req.bufferOutput = true;
    var s = await file.open();
    var x = 0;
    var size = file.lengthSync();
    req.headers.add('Content-Length', size.toString());
    var chunkSize = 65536;
    while (x < size) {
      var _len = size - x >= chunkSize ? chunkSize : size - x;
      var val = s.readSync(_len).toList();
      x = x + _len;
      // 处理数据块
      // val = proc(val);
      // 加入http发送缓冲区
      req.add(val);
      // 立即发送并清空缓冲区
      // await req.flush();
      // req.write(val);
      await req.flush();
    }
    await s.close();

    // 文件发送完成
    await req.close();
    // 获取返回数据
    final response = await req.done;
    // 其它处理逻辑
    print("response statusCode: ${response.statusCode}");
  }
}
