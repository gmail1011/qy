import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:image_pickers/image_pickers.dart';

import 'action.dart';
import 'state.dart';

Effect<WishPublishState> buildEffect() {
  return combineEffects(<Object, Effect<WishPublishState>>{
    WishPublishAction.publish: _publish,
    WishPublishAction.selectImage: _selectImage,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

///初始化获取钱包余额
void _initState(Action action, Context<WishPublishState> ctx) async {
  GlobalStore.refreshWallet(true);
}

///发布问题图文
void _publish(Action action, Context<WishPublishState> ctx) async {
  try {
    String questionContent = ctx.state.editingController?.text?.trim();
    if (questionContent.isEmpty || questionContent.length < 3) {
      showToast(msg: "问题内容至少3个字");
      return;
    }
    //执行上传图片
    List<String> picList = [];
    if (ctx.state.localImagePathList?.isNotEmpty ?? false) {
      WBLoadingDialog.show(ctx.context);

      var multiImageModel = await taskManager
          .addTaskToQueue(MultiImageUploadTask(ctx.state.localImagePathList),
              (progress, {msg, isSuccess}) {
        l.e("progress", "$progress");
      });

      showToast(msg: "上传成功～");
      WBLoadingDialog.dismiss(ctx.context);
      picList = multiImageModel?.filePath ?? [];
    }

    int amountValue = 0;
    try {
      amountValue = int.parse(ctx.state.setAmountValue ?? "0") ?? 0;
    } catch (e) {
      l.e("int.parse-e", "$e");
    }
    var result = await netManager.client
        .submitDesire(amountValue, picList, questionContent);
    l.e("发布问题", "$result");

    showToast(msg: "发布成功～");
    safePopPage();

    GlobalStore.refreshWallet(true);
  } catch (e) {
    l.e("submitDesire", "$e");
    WBLoadingDialog.dismiss(ctx.context);
    showToast(msg: "发布失败～");
  }
}

///选择图片
void _selectImage(Action action, Context<WishPublishState> ctx) async {
  List<Media> mediaList = await ImagePickers.pickerPaths(
    uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
    selectCount: 9,
    showCamera: false,
  );

  l.e("_selectImage-mediaList", "$mediaList");
  List<String> imagePaths = [];
  for (Media media in mediaList) {
    imagePaths.add(media.path);
  }
  ctx.state.localImagePathList?.addAll(imagePaths);
  ctx.dispatch(WishPublishActionCreator.updateUI());
}

void _dispose(Action action, Context<WishPublishState> ctx) {
  WBLoadingDialog.dismiss(ctx.context);
  ctx.state.editingController?.dispose();
  ctx.state.printEditingController?.dispose();
  ctx.state.localImagePathList?.clear();
}
