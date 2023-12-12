import 'package:common_utils/common_utils.dart';
import 'package:flutter_base/task_manager/task_state.dart';
import 'package:flutter_base/local_server/m3u_preload.dart';

/// 视频下载工具类
/// 和cacheManager一样，类似的webHelper
/// 网路业务和管理业务分开，各个不同的业务比如音色/vpn/短视频，只需要实现自己的上传Helper就行
mixin VideoDownloadHelper on TaskState {
  // factory UploadHelper._() => null;
  final String tag = "VideoDownloadHelper";
  Future<bool> downloadVideo(String remotePath) async {
    if (TextUtil.isEmpty(remotePath)) {
      onError("downloadVideo file:$remotePath is not exist");
      // onDone(null); use this??
      return false;
    }
    // 开始给一个0.01 的假进度
    onUpdate(0.01);
    await M3uPreload().doTask(await M3uPreload().getTask(remotePath, -1), false,
        (index, total) {
      onUpdate(index / total, msg: index);
    });
    onUpdate(1.0);
    return true;
  }
}
