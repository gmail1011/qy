import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/http_resp_interceptor.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/location_bean.dart';
import 'package:flutter_app/model/upload/image_upload_result_model.dart';
import 'package:flutter_app/model/upload/video_upload_result_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_app/utils/video_utils.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileUpLoadTool {
  int get maxImageSize => 200 * 1024;
  int compressCount = 0;

  int get compressMaxCount => 5;

  Future<List<ImageUploadResultModel>> uploadImageList(List<String> pathArr, {Function(int, int, int, int) proCallback}) async {
    List<ImageUploadResultModel> imageUrlArr = [];
    for (int i = 0; i < pathArr.length; i++) {
      String path = pathArr[i];
      var model = await uploadImage(
        path,
        callback: (pro, total) {
          if (proCallback != null) {
            proCallback(i, pathArr.length, pro, total);
          }
        },
      );
      if (model?.coverImg?.isNotEmpty == true) {
        imageUrlArr.add(model);
      } else {
        return null;
      }
    }
    return imageUrlArr;
  }

  Future<ImageUploadResultModel> uploadImage(String path, {Function(int, int) callback}) async {
    var extent = FileUtil.getNameSuffix(path);
    var name = '${DateTime.now().toIso8601String()}_${Random().nextInt(1024)}.$extent';
    debugLog("开始上传----", name);
    Uint8List fileData = File(path).readAsBytesSync();
    Uint8List compressFileData = await compressImageList(fileData, maxSize: maxImageSize, count: 2);
    FormData formData = FormData.fromMap({
      'upload': MultipartFile.fromBytes(compressFileData, filename: name),
    });
    var options = Options(
        method: "POST",
        sendTimeout:  30000,
        receiveTimeout:  60000,
        contentType: "*/*",
        // 暂时让服务器全部接受
        headers: {
          'user-agent': await netManager.userAgent(),
          "Authorization": await netManager.getToken(),
        });
    ImageUploadResultModel model;
    try {
      Dio dio = createDio();
      Response resp = await dio.post(
        "${Address.baseApiPath}/vid/uploadStatic",
        options: options,
        data: formData,
        onSendProgress: (count, total) {
          if (callback != null) {
            callback(count, total);
          }
        },
      );
      if (resp.statusCode == 200) {
        await HttpRespInterceptor.handleResponse(resp);
        model = ImageUploadResultModel.fromMap(resp.data);
      } else {
        model = ImageUploadResultModel()..errorDesc = resp.statusMessage;
      }
    } catch (e) {
      debugLog("_uploadPatchOnce()...error:$e");
    }
    return model;
  }

  Future<VideoUploadResultModel> uploadFile(String localPath, {Function(int, int, int, int) proCallback}) async {
    if (!FileUtil.isFileExist(localPath)) {
      return VideoUploadResultModel()..errorDesc = "文件找不到";
    }
    VideoUploadResultModel retModel;
    try {
      File videoFile = File(localPath);
      int fileLen = FileUtil.getFileSize(localPath);
      Uint8List fileData = await videoFile.readAsBytes();
      List<int> bytes = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
      String fileId = md5.convert(bytes).toString();
      // 1-n次，第n次可能不足一个分片
      int patchSize = FileUtil.getPatchSize(fileLen);
      int patchCount = FileUtil.getPatchCount(fileLen);
      debugLog("分段大小:$patchSize 视频被分成:$patchCount 个片段");

      for (int index = 0; index < patchCount; index++) {
        // 处理最后一个分片的长度
        int shouldReadLen = index < patchCount ? patchSize : min((fileLen) % patchSize, patchSize);
        Uint8List data = await FileUtil.getFileBlock(index * patchSize, shouldReadLen, videoFile);

        var options = Options(
          method: "POST",
          sendTimeout:  30000,
          receiveTimeout:  60000,
          contentType: "application/json",
          responseType: ResponseType.json,
          headers: {
            "Authorization": await netManager.getToken(),
            "User-Agent": await netManager.userAgent(),
            'Content-Type': 'application/json'
          },
        );

        var postData = {
          'data': base64.encode(data),
          'pos': index + 1,
          'totalPos': patchCount,
          'id': fileId,
        };
        Response resp = await createDio().post(
          Address.baseApiPath + Address.UPLOAD_VIDEO,
          options: options,
          data: postData,
          onSendProgress: (count, total) {
            if (proCallback != null) {
              proCallback(index, patchCount, count, total);
            }
          },
        );
        await HttpRespInterceptor.handleResponse(resp);
        retModel = VideoUploadResultModel.fromMap(resp.data);
      }
      retModel?.md5 = fileId;
      return retModel;
    } catch (e) {
      retModel = VideoUploadResultModel()..errorDesc = e.toString();
    }
    return retModel;
  }

  Future<Uint8List> compressImageList(Uint8List list, {int maxSize = 200 * 1024, int count = 1}) async {
    if(count == 0){
      return list;
    }
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 100,
      format: CompressFormat.jpeg,
    );
    debugLog("图片压缩原大小${list.length / 1024}, ${result.length / 1024}");
    compressCount++;
    if (result.length > maxSize && compressCount < compressMaxCount) {
      return compressImageList(result, maxSize: maxSize, count: count - 1);
    }
    return result;
  }

}
