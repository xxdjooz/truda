import 'dart:io';
import 'dart:isolate';

class TrudaUploadIsolate {
  Future<int> loadData(String url, String localPath, String contentType) async {
    // 通过spawn新建一个isolate，并绑定静态方法
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // 获取新isolate的监听port
    SendPort sendPort = await receivePort.first;
    // 调用sendReceive自定义方法
    int dataList = await sendReceive(sendPort, url, localPath, contentType);
    print('dataList $dataList');
    return dataList;
  }

// isolate的绑定方法
  static dataLoader(SendPort sendPort) async {
    // 创建监听port，并将sendPort传给外界用来调用
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    // 监听外界调用
    await for (var msg in receivePort) {
      SendPort callbackPort = msg[0];
      String requestURL = msg[1];
      String localPath = msg[2];
      String contentType = msg[3];

      // 初始化一个Http客户端，并加入自定义Header
      var req = await HttpClient().putUrl(Uri.parse(requestURL));
      // headers.forEach((key, value) {
      //   req.headers.add(key, value);
      // });
      req.headers.add('Content-Type', contentType);
      req.headers.add('Accept', '*/*');
      req.headers.add('Connection', 'keep-alive');
      // 读文件
      req.bufferOutput = true;
      var file = File(localPath);
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
      // return response.statusCode;
      // 回调返回值给调用者
      callbackPort.send(response.statusCode);
    }
  }

// 创建自己的监听port，并且向新isolate发送消息
  Future sendReceive(
      SendPort sendPort, String url, String localPath, String contentType) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send([receivePort.sendPort, url, localPath, contentType]);
    // 接收到返回值，返回给调用者
    return receivePort.first;
  }
}
