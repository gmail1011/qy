import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/event/video_recorder_event.dart';
import 'package:flutter_app/page/video/video_publish/effect.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
// import 'package:image_pickers/image_pickers.dart';
import 'package:path_provider/path_provider.dart';

import 'action.dart';
import 'state.dart';

Effect<VideoRecordingState> buildEffect() {
  return combineEffects(<Object, Effect<VideoRecordingState>>{
    Lifecycle.initState: _onInitData,
    Lifecycle.dispose: _dispose,
    VideoRecordingAction.onStarVideoRecorder: _onStarVideoRecorder,
    VideoRecordingAction.onStopVideoRecorder: _closeVideoRecode,
    VideoRecordingAction.onUploadVideo: _onUploadVideo,
    VideoRecordingAction.onLocalVideo: _onLocalVideo,
    VideoRecordingAction.onSwitchCamera: _onSwitchCamera,
    VideoRecordingAction.onReLoadVideo: _onReLoadVideo
  });
}

Future _onStarVideoRecorder(
    Action action, Context<VideoRecordingState> ctx) async {
  final Directory extDir = await getApplicationDocumentsDirectory();
  final String dirPath = '${extDir.path}/Movies/flutter_test';
  await Directory(dirPath).create(recursive: true);
  final String filePath = '$dirPath/${timestamp()}.mp4';
  ctx.state.filePath = filePath;
  if (ctx.state.cameras.length != 0 && ctx.state.videoRecordStatus != 1) {
    ctx.dispatch(VideoRecordingActionCreator.onStarVideoRecording(1));
    ctx.state.controller.startVideoRecording(filePath).then((filePath) {
      GlobalVariable.eventBus.fire(VideoRecorderEvent(0, ctx.state.timeTag));
      showToast(msg: Lang.BEGIN_RECORDER);
    }).catchError((e) {
      ctx.dispatch(VideoRecordingActionCreator.onStarVideoRecording(0));
    });
  }
}

Future _onInitData(Action action, Context<VideoRecordingState> ctx) async {
  ///设置常亮
//  Wakelock.enable();
  List<CameraDescription> cameras = await availableCameras();
  if (cameras.length == 0) {
    ///这里代表没有获取到可用相机
    return;
  }
  CameraController controller =
      CameraController(cameras[0], ResolutionPreset.medium);
  Map<String, dynamic> map = Map();
  map['c'] = cameras;
  map['co'] = controller;
  controller.initialize().then((value) {
    ctx.dispatch(VideoRecordingActionCreator.onAction1(map));
  });
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
         // sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

_closeVideoRecode(Action action, Context<VideoRecordingState> ctx) async {
  if (ctx.state.controller.value == null) return;
  if (ctx.state.controller.value.isRecordingVideo) {
    showToast(msg: Lang.STOP_RECODE);
    try {
      await ctx.state.controller.stopVideoRecording();
      GlobalVariable.eventBus.fire(VideoRecorderEvent(1, ctx.state.timeTag));
      //录制完成
      ctx.dispatch(VideoRecordingActionCreator.onStarVideoRecording(2));
    } catch (e) {
      GlobalVariable.eventBus.fire(VideoRecorderEvent(1, ctx.state.timeTag));
      //录制完成
      ctx.dispatch(VideoRecordingActionCreator.onStarVideoRecording(2));
    }
  }
}

_dispose(Action action, Context<VideoRecordingState> ctx) async {
//  Wakelock.disable();
  if (ctx.state?.controller?.value == null) return;
  if (ctx.state.controller.value.isRecordingVideo) {
    showToast(msg: Lang.STOP_RECODE);
    try {
      await ctx.state.controller.stopVideoRecording();
      GlobalVariable.eventBus.fire(VideoRecorderEvent(1, ctx.state.timeTag));
      //录制完成
      ctx.dispatch(VideoRecordingActionCreator.onStarVideoRecording(2));
    } catch (e) {
      GlobalVariable.eventBus.fire(VideoRecorderEvent(1, ctx.state.timeTag));
      //录制完成
      ctx.dispatch(VideoRecordingActionCreator.onStarVideoRecording(2));
    }
  }
}

///重新录制
_onReLoadVideo(Action action, Context<VideoRecordingState> ctx) {
  ctx.dispatch(VideoRecordingActionCreator.onStarVideoRecording(0));
  GlobalVariable.eventBus.fire(VideoRecorderEvent(2, ctx.state.timeTag));
}

///上传视频
_onUploadVideo(Action action, Context<VideoRecordingState> ctx) {
  safePopPage({"videoPath": action.payload});
}

/// 读取本地视频列表
_onLocalVideo(Action action, Context<VideoRecordingState> ctx) async {
  // String path = await FilePicker.getFilePath(type: FileType.VIDEO);
  // var _path = await ImagePickers.pickerPaths(
  //     galleryMode: GalleryMode.video, selectCount: 1);
  // var path = _path[0].path;
  // if (path == null || path.isEmpty) {
  //   return;
  // }
  //
  // if (path.toLowerCase().contains('weixin') ||
  //     path.toLowerCase().contains('qq')) {
  //   showToast(msg: Lang.REQUIRE_NOT_WEI_XIN_QQ);
  //   return;
  // }
  //
  // var isCheck = await checkVideoRule(path);
  // if (!isCheck) {
  //   return;
  // }
  // if (ctx.context != null) {
  //   safePopPage({
  //     "videoPath": path,
  //   });
  // }
}

///切换摄像头
_onSwitchCamera(Action action, Context<VideoRecordingState> ctx) async {
  int isDirect = 0;

  ///0：后置 ，1：前置
  for (int i = 0; i < ctx.state.cameras.length; i++) {
    if (ctx.state.controller.description != ctx.state.cameras[i]) {
      isDirect = i;
    }
  }
  if (ctx.state.controller != null) {
    await ctx.state.controller.dispose();
  }
  try {
    CameraController controller =
        CameraController(ctx.state.cameras[isDirect], ResolutionPreset.medium);
    Map<String, dynamic> map = Map();
    map['c'] = ctx.state.cameras;
    map['co'] = controller;
    controller.initialize().then((value) {
      ctx.dispatch(VideoRecordingActionCreator.onAction1(map));
    });
  } catch (_) {}
}

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
double getResolutionToInt(String resolution) {
  List<String> list = resolution.split("*");
  return double.parse(list[0]) * double.parse(list[1]);
}
