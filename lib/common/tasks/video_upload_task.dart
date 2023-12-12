import 'package:flutter_app/model/multi_image_model.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_app/widget/dialog/loading_dialog.dart';
import 'package:flutter_base/task_manager/base_task.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';

import 'image_upload_helper.dart';
import 'multi_image_upload_task.dart';
import 'video_api_helper.dart';
import 'video_upload_helper.dart';

/// 视频分片上传任务
/// 其实也可以通过 组合的方式将不同的helper注入到BaseTask中
class VideoUploadTask extends BaseTask<bool>
    with VideoUploadHelper, ImageUploadHelper, VideoApiHelper {
  final String tag = "VideoUploadTask";
  final UploadVideoModel uploadVideoModel;

  VideoUploadTask(this.uploadVideoModel,
      {ProgressChanged updateListener, String taskId})
      : super(updateListener: updateListener, taskId: taskId);
  @override
  void sonDoExecute() async {
    l.d(tag, 'begin Upload doInBackgroud');
    running = true;
    onUpdate(0.00, msg: "上传视频");

    ///分片上传视频 0.6
    if (TextUtil.isEmpty(uploadVideoModel.videoFileId)) {
      var path = uploadVideoModel.videoLocalPath;
      var model = await uploadFile(path, rate: 0.8);
      if (model == null) {
        doFailed();
        return;
      }
      uploadVideoModel.videoFileId = model.id;
      uploadVideoModel.videoRemotePath = model.videoUri;
    }
    onUpdate(0.8, msg: "上传图片");

    ///上传单张图片 0.1 （封面图片）
    if (TextUtil.isEmpty(uploadVideoModel.coverRemotePath)) {
      var imgModel = await uploadImage(uploadVideoModel.localPicList[0], start: 0.8, rate: 0.15);
      uploadVideoModel.coverRemotePath = imgModel?.coverImg;
      if (TextUtil.isEmpty(uploadVideoModel.coverRemotePath)) {
        doFailed();
        return;
      }
    }
    ///上传多张图片
    MultiImageModel multiImageModel = await taskManager
        .addTaskToQueue(MultiImageUploadTask(uploadVideoModel.localPicList),
            (progress, {msg, isSuccess}) {
          loadingDialog.update(progress, message: (msg?.toString()) ?? '上传中');
        });
    uploadVideoModel.remotePIcList = multiImageModel.filePath;
    onUpdate(0.95, msg: "上传信息");
    var result = await uploadVideoApi(uploadVideoModel);
    if (result == true) {
      doSuc();
    } else {
      doFailed(msg: result);
    }
    l.d(tag, 'end Upload doInBackgroud');
    // return null != result && result;
  }

  void doFailed({msg}) {
    // 把-1 更新出去；
    onUpdate(-1.0, msg: msg ?? "上传失败");
    onError("上传失败");
    running = false;
  }

  void doSuc() {
    onUpdate(1.0, msg: "上传成功");
    onDone(true);
    running = false;
  }
}
