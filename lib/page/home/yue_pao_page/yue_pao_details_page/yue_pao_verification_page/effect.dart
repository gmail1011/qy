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

bool _isClick = false;
Effect<YuePaoVerificationState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoVerificationState>>{
    YuePaoVerificationAction.onSubmit: _onSubmit,
    YuePaoVerificationAction.onSelectPic: _onSelectPic,
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<YuePaoVerificationState> ctx) {
  _isClick = false;
}

/// 提交
void _onSubmit(Action action, Context<YuePaoVerificationState> ctx) async {
  var localPicList = ctx.state.localPicList;
  if (localPicList.length < 4) {
    showToast(msg: Lang.CONDITION);
    return;
  }
  if (_isClick) return;
  _isClick = true;
  var picList = <String>[];

  /// 上传图片
  if ((ctx.state.localPicList?.length ?? 0) > 0) {
    await loadingDialog.show(ctx.context,
        message: "开始上传图片", showTip: true, isDismissible: true);
    var multiImageModel = await taskManager
        .addTaskToQueue(MultiImageUploadTask(ctx.state.localPicList), (progress,
            {msg, isSuccess}) {
      loadingDialog.update(progress, message: (msg?.toString()) ?? '上传中');
    });
    safePopPage();
    picList = multiImageModel?.filePath ?? [];
  }
  String content = ctx.state.editingController.text;
  if (TextUtil.isEmpty(content) && picList.isEmpty) {
    showToast(msg: "提交内容不能为空");
    _isClick = false;
    return;
  }
  try {
    String productID = ctx.state.productID;
    await netManager.client.verifyReport(productID, content, picList, []);

    showToast(msg: Lang.SUB_SUCCESS);
    safePopPage();
  } catch (e) {
    l.e('verifyReport》》》', e.toString());
  } finally {
    _isClick = false;
  }
}

/// 选择图片
void _onSelectPic(Action action, Context<YuePaoVerificationState> ctx) async {
  var list = await _pickImg(ctx, action, 9 - (ctx.state.localPicList.length??0));
  // if (list.length + ctx.state.localPicList.length > 9) {
  //   showToast(msg: Lang.PLEASE_THREE_UP_PHOT1);
  //   return;
  // }
  ctx.dispatch(YuePaoVerificationActionCreator.onUpdatePic(list));
}

///选择图片
Future<List<String>> _pickImg(
    Context<YuePaoVerificationState> ctx, Action action, int needCount) async {
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
