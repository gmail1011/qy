import 'package:camera/camera.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/video/video_record/action.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/page/video/video_record/progress_widget.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'state.dart';

Dispatch _dispatch;
var videoTime = -1;

Widget buildView(
    VideoRecordingState state, Dispatch dispatch, ViewService viewService) {
  _dispatch = dispatch;
  if (state.controller == null) {
    return Container();
  }
  if (!state.controller.value.isInitialized) {
    return Container();
  }

  return Scaffold(
    body: Stack(
      children: <Widget>[
        Container(
          height: screen.screenHeight,
          child: AspectRatio(
              aspectRatio: state.controller.value.aspectRatio,
              child: CameraPreview(state.controller)),
        ),
        state.videoRecordStatus != 0

            ///开始或者已完成
            ? state.videoRecordStatus == 2
                ? Positioned(
                    ///显示提交视频按钮
                    right: Dimens.pt30,
                    bottom: Dimens.pt88,
                    child: GestureDetector(
                      child: svgAssets(
                          videoTime < 3
                              ? AssetsSvg.RECORDER_PUBLISH
                              : AssetsSvg.RECORDER_PUBLISH_RED,
                          width: Dimens.pt35,
                          height: Dimens.pt35),
                      onTap: () {
                        //提交视频
                        //如果视频长度小于15s,不允许发布
                        if (videoTime < 15) {
                          showToast(msg: Lang.LESS_THAN_THREE_S);
                          return;
                        }
                        // viewService
                        //     .broadcast(VideoIndexActionCreator.onJumpTo(0));
                        
                        // viewService.broadcast(
                        //     VideoPublishActionCreator.onRefreshRecord(
                        //         state.filePath));
                      },
                    ),
                  )
                : Container()
            : Container(),

        ///进度条
        ProgressWidget(RecorderComplete),

        ///返回按钮
        Positioned(
            left: Dimens.pt20,
            top: Dimens.pt25,
            child: GestureDetector(
              onTap: () {
                // viewService.broadcast(VideoIndexActionCreator.onJumpTo(0));
                safePopPage();
              },
              child: Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: Dimens.pt25),
            )),

        ///删除视频按钮
        Positioned(
            right: Dimens.pt90,
            bottom: Dimens.pt96,
            child: Offstage(
              offstage: state.videoRecordStatus == 2 ? false : true,
              child: GestureDetector(
                onTap: () async {
                  ///清除当前视频
                  ///弹出弹出框
                  bool isPop = await showDialog(
                      context: viewService.context,
                      builder: (BuildContext context) {
                        return BackVideoRecorderDialog(viewService, dispatch);
                      });

                  ///退出
                  if (isPop ?? false) {
                    safePopPage(true);
                  }
                },
                child: svgAssets(AssetsSvg.DEL_VIDEO),
              ),
            )),

        /// 切换摄像头
        Positioned(
            right: Dimens.pt20,
            top: Dimens.pt20,
            child: GestureDetector(
              onTap: () {
                ///切换前后摄像头
                dispatch(VideoRecordingActionCreator.onSwitchCamera());
              },
              child: svgAssets(
                AssetsSvg.SWITCH_CAMERA,
                width: Dimens.pt45,
                height: Dimens.pt45,
              ),
            )),

        Positioned(
            bottom: Dimens.pt50,
            child: Container(
              width: screen.screenWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Offstage(
                    ///只有选中的时候才显示
                    offstage: state.timeTag == 0 ? false : true,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.red),
                        width: Dimens.pt6,
                        height: Dimens.pt6,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: Dimens.pt48)),
                  Offstage(
                    ///只有选中的时候才显示
                    offstage: state.timeTag == 1 ? false : true,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.red),
                        width: Dimens.pt6,
                        height: Dimens.pt6,
                      ),
                    ),
                  ),
                ],
              ),
            )),

        ///下面的时间选择
        Positioned(
          bottom: Dimens.pt30,
          child: Container(
            width: screen.screenWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (state.videoRecordStatus == 1) {
                      showToast(msg: Lang.VIDEO_RECORDING);
                      return;
                    }
                    dispatch(VideoRecordingActionCreator.onSwitchTime(0));
                  },
                  child: Padding(
                      padding: EdgeInsets.only(top: Dimens.pt5),
                      child: Text("1分钟",
                          style: TextStyle(
                              color: state.timeTag == 0
                                  ? Colors.red
                                  : Colors.white))),
                ),
                Padding(padding: EdgeInsets.only(left: Dimens.pt20)),
                GestureDetector(
                    onTap: () {
                      if (state.videoRecordStatus == 1) {
                        showToast(msg: Lang.VIDEO_RECORDING);
                        return;
                      }
                      dispatch(VideoRecordingActionCreator.onSwitchTime(1));
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: Dimens.pt5),
                        child: Text("5分钟",
                            style: TextStyle(
                                color: state.timeTag == 1
                                    ? Colors.red
                                    : Colors.white)))),
              ],
            ),
          ),
        ),

        ///录制按钮
        Positioned(
          bottom: Dimens.pt70,
          child: Container(
            alignment: Alignment.center,
            width: screen.screenWidth,
            child: GestureDetector(
                onTap: () {
                  if (ClickUtil.isFastClick()) return;
                  //开始录制
                  if (state.videoRecordStatus == 1) {
                    // 停止录制
                    dispatch(VideoRecordingActionCreator.onStopVideoRecorder());
                  } else {
                    dispatch(VideoRecordingActionCreator.onStarVideoRecorder());
                  }
                },
                child: ClipOval(
                  child: Container(
                    width: Dimens.pt70,
                    height: Dimens.pt70,
                    color: Colors.red,
                    child: state.videoRecordStatus == 1
                        ? Icon(Icons.slow_motion_video)
                        : Icon(
                            Icons.videocam,
                            size: Dimens.pt40,
                            color: Colors.white,
                          ),
                  ),
                )),
          ),
        )
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget BackVideoRecorderDialog(ViewService viewService, Dispatch dispatch) {
  return Padding(
    padding: EdgeInsets.all(Dimens.pt40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.pt6),
              color: Colors.white),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt20),
                child: Text(Lang.DEL_VIDEO,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: Dimens.pt15,
                        decoration: TextDecoration.none)),
              ),
              Padding(
                  padding: EdgeInsets.only(top: Dimens.pt20),
                  child: Divider(
                      height: 1.0, indent: 0.0, color: Color(0xffeaeaea))),
              Padding(
                  padding:
                      EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(left: Dimens.pt20),
                            child: GestureDetector(
                                child: Text(Lang.RE_CAMERA,
                                    style: TextStyle(
                                        color: Color(0xff666666),
                                        fontSize: Dimens.pt15,
                                        decoration: TextDecoration.none)),
                                onTap: () {
                                  safePopPage(false);

                                  ///重新拍摄
                                  dispatch(VideoRecordingActionCreator
                                      .onReLoadVideo());
                                })),
                        flex: 1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              safePopPage(false);
                            },
                            child: Text(Lang.cancel,
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: Dimens.pt15,
                                    decoration: TextDecoration.none)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: Dimens.pt20, right: Dimens.pt20),
                            child: GestureDetector(
                              onTap: () {
                                safePopPage(true);
                              },
                              child: Text(Lang.EXIT,
                                  style: TextStyle(
                                      color: Color(0xff666666),
                                      fontSize: Dimens.pt15,
                                      decoration: TextDecoration.none)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        )
      ],
    ),
  );
}

///录制完成的回调
// ignore: non_constant_identifier_names
RecorderComplete(int time) {
  videoTime = time;
  _dispatch(VideoRecordingActionCreator.onStopVideoRecorder());
}
