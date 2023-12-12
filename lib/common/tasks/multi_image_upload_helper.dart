import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/http_log_interceptor.dart';
import 'package:flutter_app/common/net2/http_resp_interceptor.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/task_manager/task_state.dart';
import 'package:flutter_app/model/multi_image_model.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:flutter_base/utils/log.dart';

/// 多重图片上传工具类
/// 和cacheManager一样，类似的webHelper
/// 网路业务和管理业务分开，各个不同的业务比如音色/vpn/短视频，只需要实现自己的上传Helper就行
mixin MultiImageUploadHelper on TaskState {
  // factory UploadHelper._() => null;
  final String tag = "MultiImageUploadHelper";
  final maxRetryCount = 3;
  Dio _dio = createDio();
  Future<MultiImageModel> uploadFile(List<String> localPaths) async {
    _dio.interceptors.add(HttpLogInterceptor());
    if (ArrayUtil.isEmpty(localPaths)) {
      onError("uploadFile localpath is empty");
      // onDone(null); use this??
      return null;
    }
    // 开始给一个0.01 的假进度
    onUpdate(0.01);
    MultiImageModel model = await _uploadOnceAndRetry(localPaths);
    if (null == model) {
      onUpdate(0.0);
      onError("error to upload");
      // onDone(null); or this???
    } else {
      onUpdate(1.0);
    }
    return model;
  }

  /// 发送分片重试3次
  Future<MultiImageModel> _uploadOnceAndRetry(List<String> localPaths) async {
    var retryCount = 0;
    while (retryCount <= maxRetryCount && !isTaskCanceled()) {
      var model = await _uploadOnce(localPaths);
      if (null != model) return model;
        retryCount++;
      if (retryCount >= maxRetryCount) {
        l.e(tag,
            '_uploadPatchAndRetry()..fileId:${localPaths?.length}...result:$model retryCount:$retryCount');
        return model;
      }
    }
    return null;
  }

  /// 单次上传一个分片数据
  Future<MultiImageModel> _uploadOnce(List<String> localPaths) async {
    List<MultipartFile> _formDateList = [];
    for (var index = 0; index < localPaths.length; index++) {
      var extent = FileUtil.getNameSuffix(localPaths[index]) ?? "";

      var formData = await MultipartFile.fromFile(
        localPaths[index],
        filename: '${DateTime.now().toIso8601String()}x${Random().nextInt(1024)}.$extent',
      );
      _formDateList.add(formData);
    }

    var mapFormData = FormData.fromMap({'upload': _formDateList});

    var options = Options(
        method: "POST",
        sendTimeout: 15000,
        receiveTimeout: 15000,
        contentType: "*/*", // 暂时让服务器全部接受
        headers: {
          'user-agent': await netManager.userAgent(),
          "Authorization": await netManager.getToken(),
        }
    );
    MultiImageModel model;
    try {
      Response resp = await _dio.post(
          Address.baseApiPath + "/vid/uploadStatic/batch",
          options: options,
          data: mapFormData);
      Map map = await HttpRespInterceptor.handleResponse(resp);
      model = MultiImageModel.fromJson(map);
    } catch (e) {
      l.e(tag, "_uploadOnce()...error:$e");
    }
    print(model?.toJson());
    return model;
  }
}
