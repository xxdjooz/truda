import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as dio_response;
import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart' hide FormData;
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_services/truda_app_info_service.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../generated/json/base/json_convert_content.dart';
import '../truda_routes/truda_pages.dart';
import '../truda_rtm/truda_rtm_manager.dart';
import '../truda_services/truda_my_info_service.dart';
import '../truda_socket/truda_socket_manager.dart';
import '../truda_utils/newhita_loading.dart';
import 'truda_http_urls.dart';

/*
  * http 操作类
  *
  * 手册
  * https://github.com/flutterchina/dio/blob/master/README-ZH.md
  *
  * 从 3 升级到 4
  * https://github.com/flutterchina/dio/blob/master/migration_to_4.x.md
*/
typedef TrudaHttpErrCallback = void Function(TrudaErrorEntity err);
typedef TrudaHttpPageCallback = void Function(bool hasNext);
typedef TrudaHttpDoneCallback = void Function(bool success, String msg);

class TrudaHttpUtil {
  static final TrudaHttpUtil _instance = TrudaHttpUtil._internal();

  factory TrudaHttpUtil() => _instance;

  late Dio _dio;
  CancelToken cancelToken = CancelToken();
  static int timeDiff = 0;

  TrudaHttpUtil._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: "SERVER_API_URL",

      // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 20000,

      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 10000,

      // Http请求头.
      headers: {},

      /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
      /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
      /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
      /// 就会自动编码请求体.
      contentType: 'application/json; charset=utf-8',

      /// [responseType] 表示期望以那种格式(方式)接受响应数据。
      /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
      ///
      /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
      /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
      ///
      /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    // CERTIFICATE_VERIFY_FAILED: certificate has expired(handshake.cc:393)) 在有手机有这个错误
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };
    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        TrudaAppInfoService appInfo = TrudaAppInfoService.to;
        String userAgent =
            "${TrudaConstants.appNameLower},${appInfo.version},${appInfo.deviceModel},${appInfo.AppSystemVersionKey},${appInfo.channelName},${appInfo.buildNumber}";

        options.headers["User-Agent"] = _zipStr(userAgent);

        options.headers["Authorization"] =
            TrudaMyInfoService.to.authorization ?? "";
        options.headers["user-language"] =
            Get.deviceLocale?.languageCode ?? "en";
        options.headers["device-id"] = appInfo.deviceIdentifier;
        options.headers["time-difference"] = timeDiff.toString();
        // print(userAgent);
        // print(LocalStore.deviceId);
        // Do something before request is sent
        return handler.next(options); //continue
        // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      },
      onResponse: (response, handler) {
        if (response.statusCode == 200) {
          // 后台系统的时间
          int timestamp = int.parse(response.headers.value("timestamp") ?? "0");
          // 手机系统的时间
          int now = DateTime.now().millisecondsSinceEpoch;
          // 计算差值，用于下次请求计算
          timeDiff = timestamp == 0 ? 0 : timestamp - now;

          response.data = _unZipStr(response.data);
        }
        // Do something with response data
        return handler.next(response); // continue
        // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      },
      onError: (DioError e, handler) {
        // Do something with response error
        NewHitaLoading.dismiss();
        TrudaErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e); //continue
        // 如果你想完成请求并返回一些自定义数据，可以resolve 一个`Response`,如`handler.resolve(response)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
      },
    ));

    // 日志
    // _dio.interceptors.add(PrettyDioLogger(
    //     requestHeader: false,
    //     requestBody: true,
    //     responseHeader: false,
    //     responseBody: true));
  }

  /*
   * error统一处理
   */

  // 错误处理
  void onError(TrudaErrorEntity eInfo) {
    NewHitaLog.debug('error.code -> ' +
        eInfo.code.toString() +
        ', error.message -> ' +
        eInfo.message);
    // NewHitaLoading.toast("[${eInfo.code.toString()}]${eInfo.message}");
    switch (eInfo.code) {
      case 401:
        // UserStore.to.onLogout();
        // EasyLoading.showError(eInfo.message);
        break;
      default:
        // EasyLoading.showError('未知错误');
        break;
    }
  }

  // 错误信息
  TrudaErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return TrudaErrorEntity(code: -1, message: "DioErrorType.cancel");
      case DioErrorType.connectTimeout:
        return TrudaErrorEntity(
            code: -1, message: "DioErrorType.connectTimeout");
      case DioErrorType.sendTimeout:
        return TrudaErrorEntity(code: -1, message: "DioErrorType.sendTimeout");
      case DioErrorType.receiveTimeout:
        return TrudaErrorEntity(
            code: -1, message: "DioErrorType.receiveTimeout");
      case DioErrorType.response:
        {
          try {
            int errCode =
                error.response != null ? error.response!.statusCode! : -1;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
              case 401:
              case 403:
              case 404:
              case 405:
              case 500:
              case 502:
              case 503:
              case 505:
                return TrudaErrorEntity(code: errCode, message: "net err");
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  return TrudaErrorEntity(
                    code: errCode,
                    message: error.response != null
                        ? error.response!.statusMessage!
                        : "",
                  );
                }
            }
          } on Exception catch (_) {
            return TrudaErrorEntity(code: -1, message: "unknown err");
          }
        }
      default:
        {
          return TrudaErrorEntity(code: -1, message: error.message);
        }
    }
  }

  /// 压缩字符串
  String _zipStr(String str) {
    return base64Encode(zlib.encode(utf8.encode(str)));
  }

  /// 加密
  static dynamic _encryptAes(String content, {AESMode aesMode = AESMode.ecb}) {
    var key = TrudaMyInfoService.to.config?.publicKey ?? "";
    if (key.isEmpty) {
      return content;
    }
    NewHitaLog.debug("encryptAes start");
    var aesKey =
        '-----BEGIN PUBLIC KEY-----\n' + key + "\n-----END PUBLIC KEY-----";

    var aesPublicKey = RSAKeyParser().parse(aesKey) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: aesPublicKey));

    List<int> sourceBytes = utf8.encode(content);
    int inputLen = sourceBytes.length;
    int maxLen = 117;
    List<int> totalBytes = [];
    for (var i = 0; i < inputLen; i += maxLen) {
      int endLen = inputLen - i;
      List<int> item;
      if (endLen > maxLen) {
        item = sourceBytes.sublist(i, i + maxLen);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      totalBytes.addAll(encrypter.encryptBytes(item).bytes);
    }
    return base64.encode(totalBytes);
  }

  /// 解压字符串
  String _unZipStr(String str) {
    var decodeString = base64Decode(str);
    var zlibdecode = zlib.decode(decodeString);
    return utf8.decode(zlibdecode);
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// 读取本地配置
  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    // if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
    //   headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    // }
    return headers;
  }

  /// restful get 操作
  /// refresh 是否下拉刷新 默认 false
  /// noCache 是否不缓存 默认 true
  /// list 是否列表 默认 false
  /// cacheKey 缓存key
  /// cacheDisk 是否磁盘缓存
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = true,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post 操作
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    TrudaHttpErrCallback? errCallback,
    TrudaHttpPageCallback? pageCallback,
    TrudaHttpDoneCallback? doneCallback,
    bool showLoading = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    // NewHitaLog.debug('$path， begin');
    var paraFinal = {
      "method": path,
      "timestamp": DateTime.now().millisecondsSinceEpoch + timeDiff,
      "nonceStr": DateTime.now().microsecondsSinceEpoch,
    };
    if (data != null) {
      paraFinal["param"] = data;
    }
    // LogTool.debug("请求api:${path} \n请求的参数= ${paraFinal}");
    // 请求前压缩保留 加密去掉
    var json = const JsonEncoder().convert(paraFinal);

    var sendPara = _encryptAes(_zipStr(json));

    /// configApi接口和一般的接口不一样
    bool _isGetLanguage = path == TrudaHttpUrls.getTransationsApi;
    bool _isGetLanguageV2 = path == TrudaHttpUrls.getTransationsV2Api;
    bool _isGetConfig = path == TrudaHttpUrls.configApi;
    final _isSpecal = _isGetConfig || _isGetLanguage || _isGetLanguageV2;
    final root =
        _isSpecal ? TrudaHttpUrls.getConfigBaseUrl() : TrudaHttpUrls.getBaseUrl();
    _dio.options.baseUrl = root;
    NewHitaLog.debug('$root $path， Http post: $json');

    /// 一般接口path这里就直接不传值了，path放参数里面去了！！！！
    dio_response.Response<String> response;
    if (showLoading) NewHitaLoading.show();
    // NewHitaLog.debug('$path， begin post');
    try {
      response = await _dio.post(
        _isSpecal ? path : "",
        data: _isSpecal ? null : sendPara,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
      );
    } catch (e) {
      print(e);
      TrudaErrorEntity err;
      if (e is TrudaErrorEntity) {
        err = e;
      } else if (e is DioError) {
        err = TrudaErrorEntity(code: -4, message: e.message);
      } else {
        err = TrudaErrorEntity(code: -3, message: "try catch err");
      }
      if (errCallback == null) {
        NewHitaLoading.toast(err.message);
      } else {
        errCallback.call(err);
      }
      doneCallback?.call(false, err.message);
      return Future.error(e);
    } finally {
      if (showLoading) NewHitaLoading.dismiss();
      // NewHitaLog.debug('$path，post done');
    }
    NewHitaLog.longLog(response.data);
    // var baseEntity = response.data;
    var baseEntity = const JsonDecoder().convert(response.data ?? '{}');
    // try {
    //   baseEntity = _unZipStr(response.data);
    // } catch (e) {
    //   print(e);
    // }

    /// 返回的data是null,这个会发生吗？
    if (baseEntity == null) {
      if (errCallback == null) {
        NewHitaLoading.toast("baseEntity == null");
      } else {
        errCallback
            .call(TrudaErrorEntity(code: -3, message: "baseEntity == null"));
      }
      doneCallback?.call(false, "baseEntity == null");
      return Future.error("baseEntity err");
    }
    NewHitaLog.longLog(path + '->' + const JsonEncoder().convert(baseEntity));
    // int? code;
    // String? message
    // T? data;
    // dynamic page;
    /// 返回的data里面code不是0，需要处理
    var code = baseEntity["code"];
    if (code != 0) {
      if (errCallback == null) {
        if (code == 8) {
          NewHitaLoading.toast("${baseEntity["message"]}");
        } else if (code == 2) {
          TrudaMyInfoService.to.clear();
          Get.offAllNamed(TrudaAppPages.login);
          TrudaRtmManager.closeRtm();
          TrudaSocketManager.to.breakenSocket();
        } else {
          NewHitaLoading.toast("[${code}] ${baseEntity["message"]}");
        }
      } else {
        errCallback
            .call(TrudaErrorEntity(code: code, message: baseEntity["message"]));
      }
      doneCallback?.call(false, "[${code}] ${baseEntity["message"]}");
      return Future.error("baseEntity err");
    }

    /// 返回的分页数据
    if (baseEntity["page"] != null) {
      try {
        pageCallback?.call(baseEntity["page"]["hasNext"] == true);
      } catch (e) {
        print(e);
      }
    }
    doneCallback?.call(true, baseEntity["message"]);

    // 泛型用void,直接返回null
    if (T.toString() == 'void') {
      return null as T;
    }
    var serverData = baseEntity["data"];

    /// code=0而data=null的情况
    /// 为啥服务器有时code=0而data=[],有时code=0而data=null,真扯！？
    /// 这样的接口 .catchError((err) 判断err==0
    if (serverData == null) {
      return Future.error(0);
    }

    /// code=0而data is String的情况，泛型用String
    // if (serverData is String){
    //   return serverData as T;
    // }
    /// code=0而data不是map和list,不用fromJson
    if (serverData is! Map<String, dynamic> && serverData is! List<dynamic>) {
      NewHitaLog.debug('need not JsonConvert');
      return serverData as T;
    }

    return JsonConvert.fromJsonAsT<T>(serverData)!;
  }

  /// restful put 操作
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful patch 操作
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful delete 操作
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await _dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post Stream 流数据
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await _dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

// 异常处理
class TrudaErrorEntity implements Exception {
  int code = -1;
  String message = "";

  TrudaErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}
