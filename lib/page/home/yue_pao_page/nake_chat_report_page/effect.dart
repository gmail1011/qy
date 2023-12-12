import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/widget/dialog/loading_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:image_pickers/UIConfig.dart';
// import 'package:image_pickers/image_pickers.dart';
import 'action.dart';
import 'state.dart';

// 是否点击举报
bool _isClickReport = false;
Effect<NakeChatReportState> buildEffect() {
  return combineEffects(<Object, Effect<NakeChatReportState>>{
    YuePaoReportAction.selectPic: _onSelectPic,
    YuePaoReportAction.onReport: _onReport,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<NakeChatReportState> ctx) {
  _isClickReport = false;
}

// 举报
void _onReport(Action action, Context<NakeChatReportState> ctx) async {
  if (_isClickReport) return;
  _isClickReport = true;
  var picList = <String>[];
  if ((ctx.state.localPicList?.length ?? 0) == 0) {
    showToast(msg: '请添加图片');
    _isClickReport = false;
    return;
  }
  await loadingDialog.show(ctx.context,
      message: "开始上传图片", showTip: true, isDismissible: true);
  var multiImageModel = await taskManager
      .addTaskToQueue(MultiImageUploadTask(ctx.state.localPicList), (progress,
          {msg, isSuccess}) {
    loadingDialog.update(progress, message: (msg?.toString()) ?? '上传中');
  });
  safePopPage();
  picList = multiImageModel?.filePath ?? [];

  try {
    String content = ctx.state.editingController.text;
    await netManager.client
        .postNakeChatFeedBack(ctx.state.id, ctx.state.type, picList, content);
    showToast(msg: Lang.REPORT_SUCCESS);
    safePopPage();
  } catch (e) {
    l.e('postFeedBack', e.toString());
  } finally {
    _isClickReport = false;
  }
}

void _onSelectPic(Action action, Context<NakeChatReportState> ctx) async {
  var list =
      await _pickImg(ctx, action, 9 - (ctx.state.localPicList.length ?? 0));
  // if (list.length + ctx.state.localPicList.length > 9) {
  //   showToast(msg: Lang.PLEASE_THREE_UP_PHOT1);
  //   return;
  // }
  ctx.dispatch(YuePaoReportActionCreator.onUpdatePic(list));
}

///选择图片
Future<List<String>> _pickImg(
    Context<NakeChatReportState> ctx, Action action, int needCount) async {
  List<String> ret = [];
  // var listMedia = await ImagePickers.pickerPaths(
  //   uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
  //   galleryMode: GalleryMode.image,
  //   selectCount: needCount,
  //   showCamera: true,
  // );
  // if (ArrayUtil.isEmpty(listMedia)) return ret;
  //
  // if (Platform.isAndroid) {
  //   for (var index = 0; index < listMedia.length; index++) {
  //     var path = listMedia[index].path;
  //     if (path != null) {
  //       ret.add(path);
  //     }
  //   }
  // } else {
  //   for (var index = 0; index < listMedia.length; index++) {
  //     var path = listMedia[index].path;
  //     var file = File(path);
  //     var size = await file.readAsBytes();
  //     //大于300kb的图需要压缩
  //     if ((size.length / 1024) > 300) {
  //       var compressFile = await FlutterNativeImage.compressImage(path,
  //           percentage: 40, quality: 50);
  //       path = compressFile.path;
  //     }
  //     if (path != null) {
  //       ret.add(path);
  //     } else {
  //       showToast(msg: "添加图片失败");
  //     }
  //   }
  // }
  return ret;
}
