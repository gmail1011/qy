import 'dart:async';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base/assets/svg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/player/v_player_progress.dart';
import 'package:flutter_base/player/video_player_ui.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'double_like/tiktok_video_gesture.dart';
import 'video_progress_colors.dart';

///脱离业务的全屏播放器-竖直播放器
class VPlayer extends StatefulWidget {
  /// 外部限制视频宽高，不传为全屏宽高
  /// see [configVideoSize]
  final double containerWidth, containerHeight;

  final IjkBaseVideoController controller;
  // 视频分辨率
  final double resolutionWidth;
  // 视频分辨率
  final double resolutionHeight;
  // // 封面
  // final String cover;
  final ValueChanged<IjkBaseVideoController> onTap;
  final ValueChanged<IjkBaseVideoController> onDoubleTap;
  final bool showProgress;

  /// 视频时长 单位秒
  final int dutationInSec;
  //进度条Padding
  final EdgeInsets progressPadding;
  final VideoProgressColors progressColors;

  VPlayer({
    Key key,
    @required this.controller,
    this.containerWidth,
    this.containerHeight,
    // this.cover,
    this.onTap,
    this.onDoubleTap,
    this.showProgress = true,
    this.dutationInSec = 0,
    @required this.resolutionWidth,
    @required this.resolutionHeight,
    this.progressPadding,
    this.progressColors,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VPlayerState();
  }
}

class VPlayerState extends State<VPlayer> {
  /// 外部限制视频宽高，不传为全屏宽高
  /// see [configVideoSize]
  double containerWidth, containerHeight;
  // 真正的视频使用宽高
  VideoResolution vr;

  /// 显示是否旋转开关
  bool showRotatedBox = false;

  /// 播放的视频是否是竖屏状态
  bool playerIsVertical = true;
  bool isShowBuffingUI = false;
  // 缓冲状态订阅
  StreamSubscription<bool> bufStateSc;
  _updateListener() {
    // playerPrint("test code 1");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    showRotatedBox =
        isHorizontalVideo(widget.resolutionWidth, widget.resolutionHeight);

    configContainerWH(playerIsVertical);
    vr = configVideoSize(containerWidth, containerHeight,
        widget.resolutionWidth, widget.resolutionHeight, true);

    playerPrint("init FullPlayer");
    widget.controller.addListener(_updateListener);
    bufStateSc = widget.controller.onBufferStateUpdate.listen((b) {
      playerPrint("onBuffing:$b   status:${widget.controller.getStatus()}");
      if (isShowBuffingUI != b && mounted) {
        setState(() {
          isShowBuffingUI = b;
        });
      }
    });
  }

  /// 配置容器的宽和高
  configContainerWH(bool isVertical) {
    // 视频分辨率配置
    if (isVertical) {
      containerWidth = widget.containerWidth ?? screen.screenWidth;
      containerHeight = widget.containerHeight ?? screen.screenHeight;
    } else {
      // 交换宽和高
      containerWidth = widget.containerHeight ?? screen.screenHeight;
      containerHeight = widget.containerWidth ?? screen.screenWidth;
    }
  }

  @override
  void didUpdateWidget(covariant VPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    playerPrint(
        "full_player didUpdateWidget()...oldState:${oldWidget.controller?.state} newState:${widget.controller?.state}");
  }

  @override
  void dispose() {
    playerPrint("full_player dispose()...${widget.controller?.isDisposed}");
    if (!(widget.controller?.isDisposed ?? false)) {
      widget.controller?.removeListener(_updateListener);
    }
    bufStateSc?.cancel();
    bufStateSc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (null == widget.controller || !widget.controller.isInitialed) {
      return Container(
        color: Colors.transparent,
        width: containerWidth,
        height: containerHeight,
        child: buildVideoLoading(),
      );
    } else if (widget.controller.isDisposed) {
      return Container(color: Colors.transparent);
    } else if (widget.controller.isPlayable()) {
      return Stack(
        children: <Widget>[
          // 渐变封面
          // AnimatedOpacity(
          //   opacity: widget.controller.value.initialized ? 0.0 : 1.0,
          //   duration: Duration(milliseconds: 500),
          //   child:
          // getFullPlayerCoverWidget(widget.cover, videoWidth, videoHeight),
          // ),

          // 视频播放器
          _getVideoPlayer(),
          // 左边旋转按钮,如果是水平视频
          _getRotateButton(),
          // 显示速度
          Visibility(
            visible: isShowBuffingUI,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  margin: EdgeInsets.only(bottom: Dimens.pt120),
                  child: buildVideoLoading()),
            ),
          ),
          // 播放器挂件,暂停播放按钮
          _getVideoUI(),
          // 播放进度条
          widget.showProgress ? _getVideoProcessBar() : Container(),
        ],
      );
    } else {
      return Container(color: Colors.transparent);
    }
  }

  /// 左边旋转按钮,如果是水平视频
  Widget _getRotateButton() {
    return Visibility(
      visible: (showRotatedBox &&
          null != widget.controller &&
          widget.controller.isPlayable() &&
          !widget.controller.isDisposed),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(left: Dimens.pt10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                playerIsVertical = !playerIsVertical;
                configContainerWH(playerIsVertical);
                vr = configVideoSize(containerWidth, containerHeight,
                    widget.resolutionWidth, widget.resolutionHeight, true);
                // l.i(tag,
                //     "setRotate()...videoWidth:$videoWidth  videoHeight:$videoHeight isVertical:$isVertical");
              });
            },
            child: SvgPicture.asset(
              playerIsVertical
                  ? AssetsSvg.VIDEO_IC_ROTATE_V
                  : AssetsSvg.VIDEO_IC_ROTATE_H,
              width: Dimens.pt28,
              height: Dimens.pt28,
              package: FlutterBase.basePkgName,
              // placeholderBuilder: (context) =>
              //     SpinKitFadingCircle(size: width, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getVideoProcessBar() {
    if (null == widget.controller || widget.controller.isDisposed) {
      playerPrint(
          "_getVideoProcessBar()...player:${widget.controller?.dataSource}  isDisposed");
      return Container(color: Colors.transparent);
    } else {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin:
              widget.progressPadding ?? EdgeInsets.only(bottom: Dimens.pt10),
          child: VPlayerProgress(
            widget.controller,
            colors:
                widget.progressColors ?? VideoProgressColors.defaultColors(),
            durationInSec: widget.dutationInSec,
          ),
        ),
      );
    }
  }

  /// ��取视频播��挂件
  Widget _getVideoUI() {
    if (null == widget.controller || widget.controller.isDisposed) {
      playerPrint(
          "full_player _getVideoUI()...player:${widget.controller?.sourceUrl}  isDisposed");
      return Container(
        color: Colors.transparent,
      );
    } else if (widget.controller.isPlayable()) {
      // playerPrint(
      //     "full_player _getVideoUI()...player:${widget.controller.dataSource}  isInitialized");
      return VideoPlayerUI(
          controller: widget.controller,
          imgLocation: ImgLocation.center,
          pausePress: onSingleClick,
          playPress: onSingleClick);
    } else {
      playerPrint(
          "full_player _getVideoUI()...player:${widget.controller.sourceUrl} unknow status");
      return Container(
        color: Colors.transparent,
      );
    }
  }

  /// 单���判断检查
  void onSingleClick() {
    if (null == widget.controller ||
        !widget.controller.isPlayable() ||
        widget.controller.isDisposed) {
      l.e(player_tag, "onSingleClick()...error");
      return;
    }
    widget.onTap?.call(widget.controller);
  }

  /// ���击判断检查
  void onDoubleClick() {
    if (null == widget.controller ||
        !widget.controller.isPlayable() ||
        widget.controller.isDisposed) {
      l.e(player_tag, "onDoubleClick()...error");
    }
    widget.onDoubleTap?.call(widget.controller);
  }

  ///视频播放器
  Widget _getVideoPlayer() {
    playerPrint(
        "_getVideoPlayer()...player:${widget.controller?.sourceUrl}  status:${widget.controller?.getStatus()}");
    if (null == widget.controller || widget.controller.isDisposed) {
      return Container(
        color: Colors.transparent,
      );
    } else if (widget.controller.isPlayable()) {
      return TikTokVideoGesture(
        onDoubleClick: onDoubleClick,
        onSingleTap: onSingleClick,
        child: Container(
          // 背景
          width: screen.screenWidth,
          height: screen.screenHeight,
          color: Colors.transparent,
          child: Center(
            child: RotatedBox(
              quarterTurns: playerIsVertical ? 0 : 1,
              child: Container(
                width: vr.videoWidth,
                height: vr.videoHeight,
                color: Colors.transparent,
                child: FijkView(
                  color: Colors.black,
                  width: vr.videoWidth,
                  height: vr.videoHeight,
                  player: widget.controller,
                  fit: FijkFit.contain,
                  panelBuilder: null,
                ),
                //   CustomPlayerView(
                // controller: widget.controller,
                // width: vr.videoWidth,
                // height: vr.videoHeight,
                // fit: PlayerFit.cover,
                // ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.transparent,
      );
    }
  }
}
