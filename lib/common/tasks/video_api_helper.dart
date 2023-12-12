import 'dart:io';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ResponseResult.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_base/task_manager/task_state.dart';
import 'package:flutter_app/model/location_bean.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_app/utils/video_utils.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:flutter_base/utils/log.dart';

///视频API调用
mixin VideoApiHelper on TaskState {
  Future<dynamic> uploadVideoApi(UploadVideoModel uploadVideoModel) async {
    String pubRet;
    var error;
    try {
      MediaInfo mediaInfo =
          await VideoUtils.getMediaInfo(uploadVideoModel.videoLocalPath);
      pubRet = await netManager.client.publishPost(
          uploadVideoModel.title, uploadVideoModel.content, NEWSTYPE_VIDEO,
          sourceID: uploadVideoModel.videoFileId,
          sourceURL: uploadVideoModel.videoRemotePath,
          tags: uploadVideoModel.selectedTagIdList,
          coins: uploadVideoModel.coins,
          playTime: mediaInfo.playTime == null ? 0 : mediaInfo.playTime,
          size: mediaInfo.size,
          resolution: mediaInfo.resolution,
          ratio: mediaInfo.ratio ?? 0.0,
          location: (LocationBean()..city = uploadVideoModel.city).toJson(),
          actor: uploadVideoModel.actor,
          filename: DateTime.now().toIso8601String() + ".mp4",
          freeTime: uploadVideoModel.freeTime,
          md5: await FileUtil.getFileMd5String(
              File(uploadVideoModel.videoLocalPath)),
          mimeType: "mp4",
          via: Platform.operatingSystem,
          cover: uploadVideoModel.coverRemotePath,
          coverThumb: uploadVideoModel.coverRemotePath,
          seriesCover:uploadVideoModel.remotePIcList,
          taskID: uploadVideoModel.taskID,
      );
    } catch (e) {
      error = e;
      l.e("VideoApiHelper", "uploadVideoApi()...error:$e");
    }

    
    if (null == pubRet) {
      onUpdate(0, msg: error ?? "上传接口异常");
      return error;
    } else {
      //ResponseResult result = responseResultFromJson(pubRet);
      onUpdate(1.0, msg: "上传成功");
      bus.emit(EventBusUtils.clearUploadData);
      return true;
    }
  }
}
