import 'package:flutter_base/task_manager/base_task.dart';
import 'package:flutter_base/utils/log.dart';

import 'video_download_helper.dart';

/// 多图片上传任务
/// 其实也可以通过 组合的方式将不同的helper注入到BaseTask中
class VideoDownloadTask extends BaseTask<bool> with VideoDownloadHelper {
  final String tag = "VideoDownloadTask";
  final String remotePath;

  VideoDownloadTask(this.remotePath,
      {String taskId, ProgressChanged updateListener})
      : super(taskId: taskId, updateListener: updateListener);
  @override
  void sonDoExecute() async {
    l.d(tag, 'begin Download doInBackgroud');
    running = true;
    var model = await downloadVideo(remotePath);
    if (null != model) onDone(model);
    running = false;
    l.d(tag, 'end Download doInBackgroud');
    // return model;
  }
}
