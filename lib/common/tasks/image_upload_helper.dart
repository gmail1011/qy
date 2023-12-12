import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/http_resp_interceptor.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/upload/image_upload_result_model.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/task_manager/task_state.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:flutter_base/utils/log.dart';

/// 图片上传工具类
/// 和cacheManager一样，类似的webHelper
/// 网路业务和管理业务分开，各个不同的业务比如音色/vpn/短视频，只需要实现自己的上传Helper就行
mixin ImageUploadHelper on TaskState {
  // factory UploadHelper._() => null;
  final String tag = "ImageUploadHelper";
  final maxRetryCount = 3;
  Dio _dio = createDio();
  Future<ImageUploadResultModel> uploadImage(String localPath, {double start = 0.00,double rate = 1}) async {
    if (!FileUtil.isFileExist(localPath)) {
      onError("uploadFile file:$localPath is not exist");
      // onDone(null); use this??
      return null;
    }
    // 开始给一个0.01 的假进度
    onUpdate(start);
    ImageUploadResultModel model = await _uploadPatchAndRetry(localPath, start: start, rate: rate);
    if (null == model) {
      onUpdate(start);
      onError("error to upload");
      // onDone(null); or this???
    } else {
      onUpdate(start + rate);
    }
    return model;
  }

  /// 发送分片重试3次
  Future<ImageUploadResultModel> _uploadPatchAndRetry(String localPath, {double start = 0.00,double rate = 1}) async {
    var retryCount = 0;
    while (retryCount <= maxRetryCount && !isTaskCanceled()) {
      var model = await _uploadPatchOnce(localPath, start: start, rate: rate);
      if (null != model) return model;
      retryCount++;
      if (retryCount >= maxRetryCount) {
        l.e(tag,
            '_uploadPatchAndRetry()..fileId:$localPath...result:$model retryCount:$retryCount');
        return model;
      }
    }
    return null;
  }

  /// 单次上传一个分片数据
  Future<ImageUploadResultModel> _uploadPatchOnce(String localPath, {double start = 0.00,double rate = 1}) async {
    FormData formData = FormData.fromMap({
      "upload": await MultipartFile.fromFile(localPath,
          filename: DateTime.now().toIso8601String() + '.jpg'),
    });
    var options = Options(
        method: "POST",
        sendTimeout: 15000,
        receiveTimeout: 15000,
        contentType: "*/*", // 暂时让服务器全部接受
        headers: {
          'user-agent': await netManager.userAgent(),
          "Authorization": await netManager.getToken(),
        });

    ImageUploadResultModel model;
    try {
      Response resp = await _dio.post(Address.baseApiPath + "/vid/uploadStatic",
          options: options, data: formData, onSendProgress: (count, total) {
        double progress = count / total;
        progress = start + progress * rate;
        onUpdate(progress, msg: "正在上传图片");
      });
      Map map = await HttpRespInterceptor.handleResponse(resp);
      model = ImageUploadResultModel.fromMap(map);
    } catch (e) {
      l.e(tag, "_uploadPatchOnce()...error:$e");
    }
    return model;
  }
}
