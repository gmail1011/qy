import 'dart:async';
import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/new_page/mine/mine_publish_post_page.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/home/post/action.dart';
import 'package:flutter_app/page/publish/makeVideo/make_video_page.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/video_utils.dart';
import 'package:flutter_app/widget/UpLoadDialog.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/dialog/loading_dialog.dart';
import 'package:flutter_app/widget/dialog/newdialog/post_success_dialog.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';

import 'action.dart';
import 'state.dart';
import 'package:dio/dio.dart' as Dio;
Effect<VideoAndPicturePublishState> buildEffect() {
  return combineEffects(<Object, Effect<VideoAndPicturePublishState>>{
    VideoPublisherAction.onUploadVideo: _uploadVideoAction,
    VideoPublisherAction.onUploadPicture: _onUploadPicture,
    VideoPublisherAction.onUploadPictureAndText: _onUploadPictureAndText,
    VideoPublisherAction.onPickPicAndVideo: _onSelectPicAndVideo,
    VideoPublisherAction.onPop: _onPop,
    VideoPublisherAction.onSelectCity: _onSelectCity,
    VideoPublisherAction.onShowSetPriceDialog: _onShowSetPriceDialog,
    VideoPublisherAction.onDeleteItem: _onDeleteItem,
    VideoPublisherAction.onDeleteVideoPic: _onDeleteVideoPic,
    VideoPublisherAction.onSelectCover: _onSelectCover,
    VideoPublisherAction.loadMoreTag: _loadMoreTag,
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
  });
}

///初始化数据
void _init(Action action, Context<VideoAndPicturePublishState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    _getTagInfo(ctx);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });

  bus.on(EventBusUtils.clearUploadData, (arg) {
    ctx.dispatch(VideoPublishActionCreator.clearUi());
  });
}

void _dispose(Action action, Context<VideoAndPicturePublishState> ctx) {
  bus.off(EventBusUtils.clearUploadData);
  ctx.state.focusNode?.dispose();
  ctx.state.textEditingController?.dispose();
  ctx.state.textController?.dispose();
  ctx.state.scrollController?.dispose();
}

/// 开始选择城市
void _onSelectCity(
    Action action, Context<VideoAndPicturePublishState> ctx) async {
  final res = await JRouter().go(PAGE_CITY_SELECT);
  String cityAndProvince = res as String;
  if (TextUtil.isEmpty(cityAndProvince)) return;

  List<String> str = cityAndProvince.split("_");
  var newCity = str[0].replaceAll("市", "");

  if (TextUtil.isNotEmpty(newCity)) {
    ctx.state.uploadModel.city = newCity;
    ctx.dispatch(VideoPublishActionCreator.refreshUI());
  }
}

///删除视频或图片数据
void _onDeleteItem(
    Action action, Context<VideoAndPicturePublishState> ctx) async {
  if (ctx.state.uploadType == UploadType.UPLOAD_VIDEO) {
    ctx.state.uploadModel.videoLocalPath = null;
  } else if (ctx.state.uploadType == UploadType.UPLOAD_IMG) {
    if (ctx.state.uploadModel.localPicList.isEmpty) return;
    ctx.state.uploadModel.localPicList.removeAt(action.payload);
  }
  ctx.dispatch(VideoPublishActionCreator.refreshUI());
}

void _onDeleteVideoPic(Action action, Context<VideoAndPicturePublishState> ctx) async {
  if (ctx.state.uploadModel.localPicList.isEmpty) return;
  ctx.state.uploadModel.localPicList.removeAt(action.payload);
  ctx.dispatch(VideoPublishActionCreator.refreshUI());
}


///获取标签信息，隐藏时进行刷新
void _getTagInfo(Context<VideoAndPicturePublishState> ctx) async {
  // 获取本地tag
  try {
    var model = await netManager.client.getPublishTags(1, 20);
    ctx.dispatch(
        VideoPublishActionCreator.getTagListOkay(model.publishTags ?? []));
  } catch (e) {
    l.e("video_publish", "_getTagList()...error:$e");
  }
}

///点击获取更多标签
void _loadMoreTag(
    Action action, Context<VideoAndPicturePublishState> ctx) async {
  // 获取本地tag
  try {
    var model = await netManager.client.getPublishTags(1, 1000);
    ctx.dispatch(VideoPublishActionCreator.setMoreTag(model.publishTags ?? []));
  } catch (e) {
    l.e("video_publish", "_getTagList()...error:$e");
  }
}

///选择视频封面
_onSelectCover(Action action, Context<VideoAndPicturePublishState> ctx) async {
  var list = await _pickImg(ctx, action, 1);
  if (ArrayUtil.isEmpty(list)) return;
  ctx.state.videoCover = list[0];
  ctx.state.uploadModel.localPicList?.addAll(list);
  ctx.dispatch(VideoPublishActionCreator.isSelectedCover(true));
  ctx.dispatch(VideoPublishActionCreator.refreshUI());
}

/// 显示设置价格和免费时长的对话框
void _onShowSetPriceDialog(
    Action action, Context<VideoAndPicturePublishState> ctx) async {
  if ((ctx.state.uploadModel?.freeTime ?? 3) < 3) {
    ctx.state.uploadModel.freeTime = 3;
  }
  var result = await showConfigPriceAndTimeDialog(
    ctx.context,
    ctx.state.uploadModel.freeTime,
    ctx.state.uploadModel.maxVideoTime,
    ctx.state.uploadModel.coins?.toDouble() ?? 0,
  );
  if (result != null) {
    var coin = result['coin'];
    var second = result['second'];
    ctx.state.uploadModel.coins = coin;
    ctx.state.uploadModel.freeTime = second ?? 3;
    ctx.dispatch(VideoPublishActionCreator.refreshUI());
  }
}

_onUploadPictureAndText(
    Action action, Context<VideoAndPicturePublishState> ctx) async {
  String taskID = action.payload as String ?? "";


  var title = ctx.state.textTitleController?.text ?? '';
  var content = ctx.state.textController?.text ?? '';
  if (TextUtil.isEmpty(title)) {
    showToast(msg: "请输入标题");
    return;
  }

  if (TextUtil.isEmpty(content)) {
    showToast(msg: "请输入内容");
    return;
  }
  if (ArrayUtil.isEmpty(ctx.state.uploadModel.localPicList)) {
    showToast(msg: Lang.PLEASE_SELECT_UPLOAD_FILE);
    return;
  }


  if (ctx.state.postModuleModel == null) {
    showToast(msg: "没有选择话题");
    return;
  }
  var selectTagIds = [ctx.state.postModuleModel.id];

  if(ctx.state.uploadModel.localPicList.length>9){
    showToast(msg: "最多上传9张图片");
    return;
  }
  await loadingDialog.show(ctx.context,
      message: "开始上传图片", showTip: true, isDismissible: true);
  var multiImageModel = await taskManager
      .addTaskToQueue(MultiImageUploadTask(ctx.state.uploadModel.localPicList),
          (progress, {msg, isSuccess}) {
        loadingDialog.update(progress, message: (msg?.toString()) ?? '上传中');
      });
  if (ArrayUtil.isEmpty(multiImageModel?.filePath)) {
    await loadingDialog.dismiss();
    showToast(msg: Lang.sprint(Lang.UPLOAD_PICS_SUC_STR, args: [0]));
    return;
  }
  await loadingDialog.update(0, message: "正在更新信息");

  var seriesCover = multiImageModel.filePath;
  String ret;
  try {
    ret = await netManager.client.publishPost(title, content,NEWSTYPE_IMG,
        tags: selectTagIds,
        //location: location.toJson(),
        location: {"city": ctx.state.locationCity},
        coins: ctx.state.coin ?? 0,
        seriesCover: seriesCover,
        taskID: taskID);
  } catch (e) {
    l.e("video_publish", "_publishPicsPost()...error:$e");
    if(e is Dio.DioError && e.error is ApiException){
      ApiException exception = e.error;
      if(exception.code == 7016){
        loadingDialog.dismiss();
        VipRankAlert.show(ctx.context, type: VipAlertType.post);
        return;
      }
    }
  }
  loadingDialog.dismiss();
  if (null == ret) {
    showToast(msg: Lang.POST_PICS_FAILED);
    return;
  }
  showToast(msg: "上传成功");
  //ctx.broadcast(HomeActionCreator.changeTab(3));
  //safePopPage();

  //MakeVideoPage().buildPage({})

  ctx.dispatch(VideoPublishActionCreator.clearUi());
  if(ctx.state.isFromCenter == true) {
    int coin = ctx.state.coin ?? 0;
    safePopPage(coin);
  }else {
    // Navigator.of(ctx.context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return MinePublishPostPage();
    //     },
    //   ),
    // ).then((value) {});
    String val = await showDialog(
        context: ctx.context,
        builder: (BuildContext context) {
          return PostSuccessDialogHjllView();
        }
    );
    if(val == "sure"){
      safePopPage();
    }
  }
}

/// 上传图片帖子
_onUploadPicture(
    Action action, Context<VideoAndPicturePublishState> ctx) async {
  String taskID = action.payload as String ?? "";


  var title = ctx.state.textTitleController?.text ?? '';
  if (TextUtil.isEmpty(title)) {
    showToast(msg: "请输入标题");
    return;
  }
  if (ArrayUtil.isEmpty(ctx.state.uploadModel.localPicList)) {
    showToast(msg: Lang.PLEASE_SELECT_UPLOAD_FILE);
    return;
  }


  if (ctx.state.postModuleModel == null) {
    showToast(msg: "没有选择话题");
    return;
  }
  var selectTagIds = [ctx.state.postModuleModel.id];

  if(ctx.state.uploadModel.localPicList.length>9){
    showToast(msg: "最多上传9张图片");
    return;
  }
  await loadingDialog.show(ctx.context,
      message: "开始上传图片", showTip: true, isDismissible: true);
  var multiImageModel = await taskManager
      .addTaskToQueue(MultiImageUploadTask(ctx.state.uploadModel.localPicList),
          (progress, {msg, isSuccess}) {
    loadingDialog.update(progress, message: (msg?.toString()) ?? '上传中');
  });
  if (ArrayUtil.isEmpty(multiImageModel?.filePath)) {
    await loadingDialog.dismiss();
    showToast(msg: Lang.sprint(Lang.UPLOAD_PICS_SUC_STR, args: [0]));
    return;
  }
  await loadingDialog.update(0, message: "正在更新信息");

  var seriesCover = multiImageModel.filePath;
  String ret;
  try {
    ret = await netManager.client.publishPost(title, "",NEWSTYPE_IMG,
        tags: selectTagIds,
        //location: location.toJson(),
        location: {"city": ctx.state.locationCity},
        coins: ctx.state.coin ?? 0,
        seriesCover: seriesCover,
        taskID: taskID);
  } catch (e) {
    l.e("video_publish", "_publishPicsPost()...error:$e");
    if(e is Dio.DioError && e.error is ApiException){
      ApiException exception = e.error;
      if(exception.code == 7016){
        loadingDialog.dismiss();
        VipRankAlert.show(ctx.context, type: VipAlertType.post);
        return;
      }
    }
  }
  loadingDialog.dismiss();
  if (null == ret) {
    showToast(msg: Lang.POST_PICS_FAILED);
    return;
  }
  showToast(msg: "上传成功");
  //ctx.broadcast(HomeActionCreator.changeTab(3));
  //safePopPage();

  //MakeVideoPage().buildPage({})

  ctx.dispatch(VideoPublishActionCreator.clearUi());
  if(ctx.state.isFromCenter == true) {
    int coin = ctx.state.coin ?? 0;
    safePopPage(coin);
  }else {
    // Navigator.of(ctx.context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return MinePublishPostPage();
    //     },
    //   ),
    // ).then((value) {});
    String val = await showDialog(
          context: ctx.context,
          builder: (BuildContext context) {
            return PostSuccessDialogHjllView();
          }
        );
    if(val == "sure"){
      safePopPage();
    }
  }
}

///上传视频到资源服
_uploadVideoAction(
    Action action, Context<VideoAndPicturePublishState> ctx) async {

  var title = ctx.state.textTitleController?.text ?? '';
  var content = ctx.state.textController?.text ?? '';

  var coin = ctx.state.textMoneyController?.text??0;
  if (TextUtil.isEmpty(title)) {
    showToast(msg: "请输入标题");
    return;
  }
  if (TextUtil.isEmpty(content)) {
    showToast(msg: "请输入内容");
    return;
  }

  if (ctx.state.postModuleModel == null ) {
    showToast(msg: "没有选择话题");
    return;
  }

  ctx.state.uploadModel.title = title;
  ctx.state.uploadModel.content = content;
  var selectTagIds = [ctx.state.postModuleModel.id];
  ctx.state.uploadModel.selectedTagIdList = selectTagIds;

  if (TextUtil.isEmpty(ctx.state.uploadModel.videoLocalPath)) {
    showToast(msg: "请选择上传文件");
    return;
  }

  if (ctx.state.videoCover == null) {
    showToast(msg: "请选择视频封面！");
    return;
  }

  if(ctx.state.uploadModel.localPicList.length>9){
    showToast(msg: "最多上传9张图片");
    return;
  }

  ctx.state.uploadModel.city = ctx.state.locationCity;
  ctx.state.uploadModel.coins = int.parse(coin);

  String taskID = action.payload as String ?? "";
  ctx.state.uploadModel.taskID = taskID;

  if (ctx.state.postModuleModel!=null) {
    ctx.state.uploadModel.selectedTagIdList.add(ctx.state.postModuleModel.id);
  }

  String taskId = DateTime.now().toIso8601String();
  UploadVideoModel uploadModel = UploadVideoModel();

  uploadModel = ctx.state.uploadModel;
  // uploadModel.localPicList?.clear();
  // uploadModel.localPicList?.add(ctx.state.videoCover);

 showDialog(
      barrierDismissible: false,
      context: ctx.context,
      barrierColor: Colors.transparent,
      builder: (ctx) => Dialog(
            backgroundColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              height: 220.w,
              width: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black.withOpacity(0.3),
              ),
              child: UpLoadDialog(
                taskId,
                uploadModel,
              ),
            ),
          )).then((value) async {
    ctx.broadcast(PostActionCreator.onGetTaskId(taskId));
    if (value != null) {
      //showToast(msg: "上传成功");
      if (value is Dio.DioError && value.error is ApiException) {
        ApiException exception = value.error;
        if (exception.code == 7016) {
          VipRankAlert.show(ctx.context, type: VipAlertType.post);
          return;
        }
      }
      if (ctx.state.isFromCenter == true) {
        int coin = ctx.state.coin ?? 0;
        safePopPage(coin);
      } else {
        String val =  await showDialog(
            context: ctx.context,
            builder: (BuildContext context) {
              return PostSuccessDialogHjllView();
            });
        if(val == "sure"){
          safePopPage();
        }
      }
    }
  });
}

///选择图片 视频
_onSelectPicAndVideo(
    Action action, Context<VideoAndPicturePublishState> ctx) async {
  if (ctx.state.uploadType == UploadType.UPLOAD_IMG) {
    var list = await _pickImg(ctx, action, 600);
    if (ArrayUtil.isEmpty(list) || list.length < 1) {
      showToast(msg: "请至少选择1张图片", gravity: ToastGravity.CENTER);
      return;
    }
    ctx.state.uploadModel.localPicList?.addAll(list);
    ctx.dispatch(VideoPublishActionCreator.refreshUI());
  } else {
    var path = await _pickVideo(ctx, action);
    if (TextUtil.isEmpty(path)) return;
    String _coverPath = await VideoUtils.getVideoCoverPath(path);
    ctx.state.uploadModel.videoLocalPath = path;
    ctx.state.videoCover = _coverPath;
    // ctx.state.uploadModel.localPicList?.clear();
   // ctx.state.uploadModel.localPicList?.insert(0,_coverPath);
    ctx.state.uploadModel.maxVideoTime =
        await VideoUtils.getVideoDuration(path);
    ctx.dispatch(VideoPublishActionCreator.refreshUI());
  }
}


///选择视频
Future<String> _pickVideo(
    Context<VideoAndPicturePublishState> ctx, Action action) async {
  var pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
  if (pickedFile == null) return null;

  if (!File(pickedFile.path).existsSync()) {
    showToast(msg: "用户视频文件损坏或格式错误", gravity: ToastGravity.CENTER);
    return null;
  }
  var path = pickedFile.path;
  if (path.toLowerCase().contains('weixin') ||
      path.toLowerCase().contains('qq')) {
    showToast(msg: Lang.REQUIRE_NOT_WEI_XIN_QQ);
    return null;
  }
  var isCheck = await checkVideoRule(path);
  if (!isCheck) return null;
  return path;
}

///选择图片
Future<List<String>> _pickImg(Context<VideoAndPicturePublishState> ctx,
    Action action, int needCount) async {
  try {
    List<Media> mediaList = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      selectCount: needCount,
      showCamera: false,
      cropConfig: CropConfig(enableCrop: false),
    );

    List<String> imagePaths = [];
    for (Media assetEntity in mediaList) {
      imagePaths.add(assetEntity.path);
    }

    return imagePaths ?? [];
  } catch (e) {
    l.e("pickImages-e", "$e");
  }
  return [];
}

_onPop(Action action, Context<VideoAndPicturePublishState> ctx) async {

  safePopPage();

  // var ret = await showConfirm(ctx.context,
  //     content: "离开当前页面将清除上传信息，是否确认离开?", showCancelBtn: true);
  // if (ret != null && ret) {
  //   safePopPage();
  // }
}

///检测视频法性
Future<bool> checkVideoRule(String path) async {
  if (TextUtil.isEmpty(path)) {
    showToast(msg: "视频地址错误");
    return false;
  }

  MediaInfo videoInfo = await VideoUtils.getMediaInfo(path);
  if (videoInfo == null) {
    showToast(msg: Lang.VIDEO_GET_RESOURCE_FAIL, gravity: ToastGravity.CENTER);
    return false;
  }

  //时间
  if ((videoInfo.playTime) < 30 && (videoInfo.playTime) > 0) {
    showToast(msg: Lang.VIDEO_DURATION_LESS_4S, gravity: ToastGravity.CENTER);
    return false;
  }

  //大小
  int sizeM = (videoInfo.size ?? 0) ~/ (MB_SIZE);
  if (sizeM > 300 || sizeM == 0) {
    showToast(msg: Lang.VIDEO_SIZE_LESS_250M, gravity: ToastGravity.CENTER);
    return false;
  }

  //分辨率
  String resolution = videoInfo.resolution;
  if (TextUtil.isEmpty(resolution) || !resolution.contains("*")) {
    showToast(msg: Lang.VIDEO_GET_RESOURCE_FAIL, gravity: ToastGravity.CENTER);
    return false;
  }

  List<String> list = resolution.split("*");
  var curResolution = double.parse(list[0]) * double.parse(list[1]);
  if (curResolution < 360 * 360) {
    showToast(
        msg: Lang.VIDEO_RESOLUTION_THEN_360, gravity: ToastGravity.CENTER);
    return false;
  }

  return true;
}
