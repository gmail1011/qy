import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/adapter.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/http_resp_interceptor.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/task_manager/task_state.dart';
import 'package:flutter_app/model/upload/video_upload_result_model.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:flutter_base/utils/log.dart';

/// 视频分片上传工具类
/// 和cacheManager一样，类似的webHelper
/// 网路业务和管理业务分开，各个不同的业务比如音色/vpn/短视频，只需要实现自己的上传Helper就行
mixin VideoUploadHelper on TaskState {
  final String tag = "VideoUploadHelper";
  final maxRetryCount = 3;
  Dio _dio = createDio();
  Future<VideoUploadResultModel> uploadFile(String localPath, {double start = 0.00, double rate = 1}) async {
    if (Config.PROXY) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return "PROXY 192.168.2.137:8888";
        };
      };
    }
    if (!FileUtil.isFileExist(localPath)) {
      onError("uploadFile file:$localPath is not exist");
      return null;
    }

    onUpdate(start);
    var file = File(localPath);
    int fileLen = FileUtil.getFileSize(localPath);
    String fileId = await FileUtil.getFileMd5String(file);
    // 1-n次，第n次可能不足一个分片
    int patchSize = FileUtil.getPatchSize(fileLen);
    int patchCount = FileUtil.getPatchCount(fileLen);
    l.i(tag, "分段大小:$patchSize 视频被分成:$patchCount 个片段");
    VideoUploadResultModel model;
    for (int pos = 0; pos < patchCount; pos++) {
      if (isTaskCanceled()) {
        onUpdate(start);
        onError(
            "uploadFile user canceled in send pic:${pos + 1} totalPos:$patchCount");
        return null;
      }
      // 处理最后一个分片的长度
      int shouldReadLen =
          pos < patchCount ? patchSize : min((fileLen) % patchSize, patchSize);
      Uint8List data =
          await FileUtil.getFileBlock(pos * patchSize, shouldReadLen, file);

      model = await _uploadPatchAndRetry(fileId, pos, patchCount, data, start: start + rate*pos/patchCount, rate: rate/patchCount);
      if (null == model) {
        onError("uploadFile error in send index/total:$pos/$patchCount");
        return null;
      } else {
      //  double progress = FileUtil.formatNum((pos +1 ) / patchCount, 2);
      //  progress = start + progress*rate;
      //  onUpdate(progress, msg: "正在上传${pos + 1}/$patchCount 个分片");
      }
    }

    if (null == model) {
      onError("error");
    } else {
      onUpdate(start + rate);
    }
    return model;
  }

  /// 发送分片重试3次
  /// [pos] index 下标 从0开始
  /// [totalPos] length
  Future<VideoUploadResultModel> _uploadPatchAndRetry(
      String fileId, int pos, int totalPos, Uint8List data,{double start = 0.00, double rate = 1}) async {
    var retryCount = 0;
    while (retryCount <= maxRetryCount && !isTaskCanceled()) {
      var model = await _uploadPatchOnce(fileId, pos, totalPos, data, start: start, rate: rate);
      if (null != model) return model;
      retryCount++;
      l.i(tag, "_uploadPatchAndRetry()...retry index/total=$pos/$totalPos retryCount:$retryCount");
      if (retryCount >= maxRetryCount) {
        l.e(tag,
            '_uploadPatchAndRetry()..retry count out!!! fileId:$fileId result:$model retryCount:$retryCount');
        return model;
      }
    }
    return null;
  }

  /// 单次上传一个分片数据
  /// [pos] index from 0
  Future<VideoUploadResultModel> _uploadPatchOnce(
      String fileId, int pos, int totalPos, Uint8List data, {double start = 0.00, double rate = 1}) async {
    // test fial code
    // if (pos == 1) return null;
    var options = Options(
      method: "POST",
      //连接服务器超时时间，单位是毫秒.
      sendTimeout: 15000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 15000,
      //Http请求头.
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: "application/json",
      // contentType: ContentType.json.toString(),
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
      headers: {
        "Authorization": await netManager.getToken(),
        "User-Agent": await netManager.userAgent(),
        'Content-Type': 'application/json'
      },
    );

    var postData = {
      'data': base64.encode(data),
      'pos': pos + 1,
      'totalPos': totalPos,
      'id': fileId
    };
    VideoUploadResultModel model;
    try {
//      String uploadPath = path.join(Address.baseApiPath,Address.UPLOAD_VIDEO);
      // l.i(tag, "_uploadPatchOnce()...begin index/total=$pos/$totalPos");
      Response resp = await _dio.post(
          Address.baseApiPath + Address.UPLOAD_VIDEO,
          options: options,
          data: postData, onSendProgress: (count, total) {
        double prog = count/total;
        var percent = pos/totalPos + (prog / totalPos);
        // l.i(tag, "_uploadPatchOnce()...progress:$percent");
        if(rate != 1) {
          percent = start + rate * prog;
        }
        onUpdate(percent, msg: "正在上传 index/total=$pos/$totalPos 个分片");
      });
      // l.i(tag, "_uploadPatchOnce()...end index/total=$pos/$totalPos");
      Map map = await HttpRespInterceptor.handleResponse(resp);
      model = VideoUploadResultModel.fromMap(map);
    } catch (e) {
      l.e(tag, "_uploadPatchOnce()... ${pos - 1}/$totalPos fialed error:$e");
    }
    return model;
  }
}
