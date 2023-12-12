import 'package:flutter_app/model/multi_image_model.dart';
import 'package:flutter_base/task_manager/base_task.dart';
import 'package:flutter_base/utils/log.dart';

import 'multi_image_upload_helper.dart';

/// 多图片上传任务
/// 其实也可以通过 组合的方式将不同的helper注入到BaseTask中
class MultiImageUploadTask extends BaseTask<MultiImageModel>
    with MultiImageUploadHelper {
  final String tag = "MultiImageUploadTask";
  final List<String> localPaths;

  MultiImageUploadTask(this.localPaths, {ProgressChanged updateListener})
      : super(updateListener: updateListener);
  @override
  void sonDoExecute() async {
    l.d(tag, 'begin Upload doInBackgroud');
    running = true;
    var model = await uploadFile(localPaths);
    if (null != model) onDone(model);
    running = false;
    l.d(tag, 'end Upload doInBackgroud');
    // return model;
  }
}
