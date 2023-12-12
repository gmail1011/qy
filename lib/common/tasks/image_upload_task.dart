import 'package:flutter_app/model/upload/image_upload_result_model.dart';
import 'package:flutter_base/task_manager/base_task.dart';
import 'package:flutter_base/utils/log.dart';

import 'image_upload_helper.dart';

/// 单图片上传任务
/// 其实也可以通过 组合的方式将不同的helper注入到BaseTask中
class ImageUploadTask extends BaseTask<ImageUploadResultModel>
    with ImageUploadHelper {
  final String tag = "ImageUploadTask";
  final String localPath;

  ImageUploadTask(this.localPath, {ProgressChanged updateListener})
      : super(updateListener: updateListener);
  @override
  void sonDoExecute() async {
    l.d(tag, 'begin Upload doInBackgroud');
    running = true;
    var model = await uploadImage(localPath);
    if (null != model) onDone(model);
    running = false;
    l.d(tag, 'end Upload doInBackgroud');
  }
}
