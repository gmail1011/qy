import 'dart:io';

import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/file_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/pkt/pb.pb.dart';
import 'package:chat_online_customers/chat_widget/chat_page/utils/util.dart';
import 'package:dio/dio.dart';

class Network {
  // 单例公开访问点
  factory Network() => _share();

  // 静态私有成员，没有初始化
  static Network _instance;

  // 私有构造函数
  Network._() {
    // 具体初始化代码
    dio = Dio();
  }

  // 静态、同步、私有访问点
  static Network _share() {
    if (_instance == null) {
      _instance = Network._();
    }
    return _instance;
  }

  Dio dio;

  ///下载
  Future<void> download(String url, String fullPath,
      Function(dynamic data) onSuccess, Function(dynamic e) onError) async {
    var userId = await obtainValueByKey('id') ?? '';
    var appId = SocketManager().appId ?? '';
    var sessionId = await obtainValueByKey('sessionId') ?? '';
    dio.options.headers[HttpHeaders.contentTypeHeader] =
        "application/json, multipart/form-data";
    dio.options.headers["Authorization"] = "$userId&$appId&$sessionId";
    try {
      var response = await dio.download(url, fullPath);
      onSuccess(response);
    } catch (e) {
      onError(e.toString());
    }
  }

  ///判断本地是否存在当前音频数据
  Future<String> isExist(ChatFields chatFields) async {
    var path = await fileMgr.getRootPath();
    List list = await fileMgr.getAllFileFromDir(path);
    for (var item in list) {
      String it = item.path.split('/').last;
      if (it.contains('_')) {
        if (it.length > 0 &&
            chatFields.photo.first
                .contains(it.split('_')[1].split('.').first)) {
          return item.path;
        }
      } else {
        if (it.contains('.aac') &&
            chatFields.photo.first.contains(it.split('.').first)) {
          return item.path;
        }
      }
    }
    return '';
  }
}
